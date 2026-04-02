--  Postflow — Database Init
--  For PostgreSQL 15+

-- Extensions
CREATE EXTENSION IF NOT EXISTS "pg_trgm";   -- trigram search on names

--  ENUMS

CREATE TYPE storage_type      AS ENUM ('local', 'remote', 's3');
CREATE TYPE post_status       AS ENUM ('draft', 'ready', 'partial', 'archived');
CREATE TYPE schedule_status   AS ENUM ('pending', 'publishing', 'published', 'failed', 'cancelled');
CREATE TYPE identity_provider AS ENUM ('local', 'vk', 'github', 'discord', 'telegram');

--  USERS

CREATE TABLE users (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    username    TEXT        NOT NULL UNIQUE,
    email       TEXT        UNIQUE,                    -- nullable: selectors may skip email
    is_active   BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- One user → many auth methods (password, oauth, magic-link, …)
CREATE TABLE user_identities (
    id               UUID             PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id          UUID             NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider         identity_provider NOT NULL,
    provider_subject TEXT,            -- oauth sub / magic-link token target
    password_hash    TEXT,            -- only for provider = 'local'
    created_at       TIMESTAMPTZ      NOT NULL DEFAULT NOW(),

    UNIQUE (provider, provider_subject),
    -- local identity is unique per user
    UNIQUE (user_id, provider)
);

-- JWT refresh tokens (one row per issued refresh token)
CREATE TABLE refresh_tokens (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash  TEXT        NOT NULL UNIQUE,  -- bcrypt/sha256 of the actual token
    expires_at  TIMESTAMPTZ NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    revoked_at  TIMESTAMPTZ              -- NULL = still valid
);
CREATE INDEX ON refresh_tokens (user_id) WHERE revoked_at IS NULL;

-- User settings (such as SauceNAO API key)
CREATE TABLE user_settings (
    user_id        UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    saucenao_api_key TEXT,
    -- other settings here
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

--  SOCIAL NETWORKS

CREATE TABLE social_networks (
    id           UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
	-- determinies the adapter to use for backend, icon for frontend and so on
    slug         TEXT    NOT NULL UNIQUE,   -- 'twitter', 'vk', 'telegram', …
    display_name TEXT    NOT NULL,
    -- e.g. {"max_images": 4, "supports_gif": true, "max_caption_len": 280}
    capabilities JSONB   NOT NULL DEFAULT '{}',
    is_active    BOOLEAN NOT NULL DEFAULT TRUE
);

-- Credentials for a bot / userbot on a social network (one row per token)
CREATE TABLE user_social_accounts (
    id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    social_network_id UUID        NOT NULL REFERENCES social_networks(id),
	external_account_id TEXT        NOT NULL,   -- immutable ID from the platform (bot ID, user ID, etc.)
    screen_name       TEXT,   -- @handle or bot name, for display only
    access_token      TEXT,
    refresh_token     TEXT,   -- probably not needed
    token_expires_at  TIMESTAMPTZ,   -- same as refresh_token
    is_active         BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

	UNIQUE (social_network_id, external_account_id)
);
 
-- Where a given account actually posts to (one account → many targets)
CREATE TABLE social_account_targets (
    id                    UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    user_social_account_id UUID   NOT NULL REFERENCES user_social_accounts(id) ON DELETE CASCADE,
    -- 'user', 'group', 'channel', 'chat'
    target_type           TEXT    NOT NULL,
    -- group id, channel @username, telegram chat_id, etc.
    target_id             TEXT    NOT NULL,
    -- human-readable label shown in UI, e.g. "My Art Channel"
    target_label          TEXT,
    is_active             BOOLEAN NOT NULL DEFAULT TRUE,
 
    UNIQUE (user_social_account_id, target_id)
);

--  ARTISTS / FRANCHISES / CHARACTERS

CREATE TABLE artists (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name       TEXT NOT NULL,
    source_url TEXT,          -- pixiv, twitter, etc.
    notes      TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX ON artists USING gin (name gin_trgm_ops);

CREATE TABLE franchises (
    id             UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
    name           TEXT           NOT NULL,
    description    TEXT,
    created_at     TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);
CREATE INDEX ON franchises USING gin (name gin_trgm_ops);

CREATE TABLE characters (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    franchise_id UUID REFERENCES franchises(id) ON DELETE SET NULL,
    name         TEXT NOT NULL,
    description  TEXT,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX ON characters USING gin (name gin_trgm_ops);

--  MEDIA

CREATE TABLE media_types (
    id                 UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    slug               TEXT    NOT NULL UNIQUE,  -- 'image', 'gif', 'video', …
    display_name       TEXT    NOT NULL,
    allowed_extensions TEXT[]  NOT NULL DEFAULT '{}',
    mime_types         TEXT[]  NOT NULL DEFAULT '{}',
    max_size_mb        INTEGER NOT NULL DEFAULT 20
);

CREATE TABLE media_files (
    id                UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    uploaded_by       UUID         NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    media_type_id     UUID         NOT NULL REFERENCES media_types(id),
    storage_type      storage_type NOT NULL DEFAULT 'local',
    storage_path      TEXT,        -- local / s3 key; NULL when storage_type = 'remote'
    source_url        TEXT,        -- original URL;  NULL when storage_type = 'local'/'s3'
    original_filename TEXT,
    file_size_bytes   BIGINT,
    -- e.g. {"width": 1920, "height": 1080, "duration_ms": 3400, "frame_count": 80}
    metadata          JSONB        NOT NULL DEFAULT '{}',
    uploaded_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_storage_path_or_url
        CHECK (storage_path IS NOT NULL OR source_url IS NOT NULL)
);

--  CAPTION TEMPLATES

CREATE TABLE caption_templates (
    id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id   UUID        REFERENCES users(id) ON DELETE CASCADE,  -- NULL = global/system
    name       TEXT        NOT NULL,
    -- raw template body, e.g.:
    --   #{character} from #{fandom} by #{artist}
    --   {link:source} — @{account.shortlink}
    body       TEXT        NOT NULL,
    -- metadata for UI + validation, e.g.:
    --   ["character", "fandom", "artist", "source_url", "account.shortlink"]
    variables  JSONB       NOT NULL DEFAULT '[]',
    is_global  BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

--  POSTS

CREATE TABLE posts (
    id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by    UUID        NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    internal_note TEXT,                      -- label for UI only, not posted anywhere
    description   TEXT,
    status      post_status NOT NULL DEFAULT 'draft',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Media attached to a post (ordered)
CREATE TABLE post_media (
    id            UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id       UUID    NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    media_file_id UUID    NOT NULL REFERENCES media_files(id) ON DELETE RESTRICT,
    sort_order    INTEGER NOT NULL DEFAULT 0,

    UNIQUE (post_id, media_file_id)
);

-- Many-to-many: post ↔ artist
CREATE TABLE post_artists (
    post_id   UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    artist_id UUID NOT NULL REFERENCES artists(id) ON DELETE RESTRICT,
    PRIMARY KEY (post_id, artist_id)
);

-- Many-to-many: post ↔ character
CREATE TABLE post_characters (
    post_id      UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    character_id UUID NOT NULL REFERENCES characters(id) ON DELETE RESTRICT,
    PRIMARY KEY (post_id, character_id)
);

-- Many-to-many: post ↔ franchise
CREATE TABLE post_franchises (
    post_id      UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    franchise_id UUID NOT NULL REFERENCES franchises(id) ON DELETE RESTRICT,
    PRIMARY KEY (post_id, franchise_id)
);

--  SCHEDULING

CREATE TABLE post_schedules (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id                 UUID            NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    social_account_target_id UUID           NOT NULL REFERENCES social_account_targets(id) ON DELETE RESTRICT,
    scheduled_at            TIMESTAMPTZ     NOT NULL,
    status                  schedule_status NOT NULL DEFAULT 'pending',
    external_post_id        TEXT,           -- ID returned by the social network after publishing
    published_at            TIMESTAMPTZ,
    error_message           TEXT,
    created_at              TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);
CREATE INDEX ON post_schedules (scheduled_at) WHERE status = 'pending';
 
-- Per-schedule caption (rendered from template or written manually)
CREATE TABLE post_captions (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_schedule_id   UUID NOT NULL REFERENCES post_schedules(id) ON DELETE CASCADE,
    template_id        UUID REFERENCES caption_templates(id) ON DELETE SET NULL,
    rendered_body      TEXT NOT NULL,
    -- per-schedule variable overrides, e.g. {"artist": "Override Name"}
    variable_overrides JSONB NOT NULL DEFAULT '{}',
 
    UNIQUE (post_schedule_id)   -- one caption per scheduled post
);

--  UTILITY: auto-update updated_at

CREATE OR REPLACE FUNCTION touch_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TRIGGER trg_posts_updated_at
    BEFORE UPDATE ON posts
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TRIGGER trg_post_schedules_updated_at
    BEFORE UPDATE ON post_schedules
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TRIGGER trg_caption_templates_updated_at
    BEFORE UPDATE ON caption_templates
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

CREATE TRIGGER trg_user_settings_updated_at
    BEFORE UPDATE ON user_settings
    FOR EACH ROW EXECUTE FUNCTION touch_updated_at();

--  SEED

-- system user for auth-disabled (selfhost) mode

INSERT INTO users (id, username, email) VALUES
    ('00000000-0000-0000-0000-000000000001', 'system', NULL);

INSERT INTO user_identities (user_id, provider) VALUES
    ('00000000-0000-0000-0000-000000000001', 'local');

-- common media types
INSERT INTO media_types (slug, display_name, allowed_extensions, mime_types, max_size_mb) VALUES
    ('image', 'Image', ARRAY['jpg','jpeg','png','webp'], ARRAY['image/jpeg','image/png','image/webp'], 20),
    ('gif',   'GIF',   ARRAY['gif'],                    ARRAY['image/gif'],                           50),
    ('video', 'Video', ARRAY['mp4','webm'],              ARRAY['video/mp4','video/webm'],             200);
