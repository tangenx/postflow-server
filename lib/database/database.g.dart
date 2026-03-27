// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> updatedAt =
      GeneratedColumn<PgDateTime>(
        'updated_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    email,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final UuidValue id;
  final String username;
  final String? email;
  final bool isActive;
  final PgDateTime createdAt;
  final PgDateTime updatedAt;
  const User({
    required this.id,
    required this.username,
    this.email,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    map['updated_at'] = Variable<PgDateTime>(
      updatedAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<UuidValue>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String?>(json['email']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<PgDateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String?>(email),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
      'updatedAt': serializer.toJson<PgDateTime>(updatedAt),
    };
  }

  User copyWith({
    UuidValue? id,
    String? username,
    Value<String?> email = const Value.absent(),
    bool? isActive,
    PgDateTime? createdAt,
    PgDateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    email: email.present ? email.value : this.email,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, username, email, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.email == this.email &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<UuidValue> id;
  final Value<String> username;
  final Value<String?> email;
  final Value<bool> isActive;
  final Value<PgDateTime> createdAt;
  final Value<PgDateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    this.email = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : username = Value(username);
  static Insertable<User> custom({
    Expression<UuidValue>? id,
    Expression<String>? username,
    Expression<String>? email,
    Expression<bool>? isActive,
    Expression<PgDateTime>? createdAt,
    Expression<PgDateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<UuidValue>? id,
    Value<String>? username,
    Value<String?>? email,
    Value<bool>? isActive,
    Value<PgDateTime>? createdAt,
    Value<PgDateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserIdentitiesTable extends UserIdentities
    with TableInfo<$UserIdentitiesTable, UserIdentity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserIdentitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<UuidValue> userId = GeneratedColumn<UuidValue>(
    'user_id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<IdentityProvider, String>
  provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<IdentityProvider>($UserIdentitiesTable.$converterprovider);
  static const VerificationMeta _providerSubjectMeta = const VerificationMeta(
    'providerSubject',
  );
  @override
  late final GeneratedColumn<String> providerSubject = GeneratedColumn<String>(
    'provider_subject',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    provider,
    providerSubject,
    passwordHash,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_identities';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserIdentity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('provider_subject')) {
      context.handle(
        _providerSubjectMeta,
        providerSubject.isAcceptableOrUnknown(
          data['provider_subject']!,
          _providerSubjectMeta,
        ),
      );
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {provider, providerSubject},
    {userId, provider},
  ];
  @override
  UserIdentity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserIdentity(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}user_id'],
      )!,
      provider: $UserIdentitiesTable.$converterprovider.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}provider'],
        )!,
      ),
      providerSubject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_subject'],
      ),
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserIdentitiesTable createAlias(String alias) {
    return $UserIdentitiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<IdentityProvider, String, String>
  $converterprovider = const EnumNameConverter<IdentityProvider>(
    IdentityProvider.values,
  );
}

class UserIdentity extends DataClass implements Insertable<UserIdentity> {
  final UuidValue id;
  final UuidValue userId;
  final IdentityProvider provider;
  final String? providerSubject;
  final String? passwordHash;
  final PgDateTime createdAt;
  const UserIdentity({
    required this.id,
    required this.userId,
    required this.provider,
    this.providerSubject,
    this.passwordHash,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['user_id'] = Variable<UuidValue>(userId, PgTypes.uuid);
    {
      map['provider'] = Variable<String>(
        $UserIdentitiesTable.$converterprovider.toSql(provider),
      );
    }
    if (!nullToAbsent || providerSubject != null) {
      map['provider_subject'] = Variable<String>(providerSubject);
    }
    if (!nullToAbsent || passwordHash != null) {
      map['password_hash'] = Variable<String>(passwordHash);
    }
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  UserIdentitiesCompanion toCompanion(bool nullToAbsent) {
    return UserIdentitiesCompanion(
      id: Value(id),
      userId: Value(userId),
      provider: Value(provider),
      providerSubject: providerSubject == null && nullToAbsent
          ? const Value.absent()
          : Value(providerSubject),
      passwordHash: passwordHash == null && nullToAbsent
          ? const Value.absent()
          : Value(passwordHash),
      createdAt: Value(createdAt),
    );
  }

  factory UserIdentity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserIdentity(
      id: serializer.fromJson<UuidValue>(json['id']),
      userId: serializer.fromJson<UuidValue>(json['userId']),
      provider: $UserIdentitiesTable.$converterprovider.fromJson(
        serializer.fromJson<String>(json['provider']),
      ),
      providerSubject: serializer.fromJson<String?>(json['providerSubject']),
      passwordHash: serializer.fromJson<String?>(json['passwordHash']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'userId': serializer.toJson<UuidValue>(userId),
      'provider': serializer.toJson<String>(
        $UserIdentitiesTable.$converterprovider.toJson(provider),
      ),
      'providerSubject': serializer.toJson<String?>(providerSubject),
      'passwordHash': serializer.toJson<String?>(passwordHash),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
    };
  }

  UserIdentity copyWith({
    UuidValue? id,
    UuidValue? userId,
    IdentityProvider? provider,
    Value<String?> providerSubject = const Value.absent(),
    Value<String?> passwordHash = const Value.absent(),
    PgDateTime? createdAt,
  }) => UserIdentity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    provider: provider ?? this.provider,
    providerSubject: providerSubject.present
        ? providerSubject.value
        : this.providerSubject,
    passwordHash: passwordHash.present ? passwordHash.value : this.passwordHash,
    createdAt: createdAt ?? this.createdAt,
  );
  UserIdentity copyWithCompanion(UserIdentitiesCompanion data) {
    return UserIdentity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      provider: data.provider.present ? data.provider.value : this.provider,
      providerSubject: data.providerSubject.present
          ? data.providerSubject.value
          : this.providerSubject,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserIdentity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('provider: $provider, ')
          ..write('providerSubject: $providerSubject, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    provider,
    providerSubject,
    passwordHash,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserIdentity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.provider == this.provider &&
          other.providerSubject == this.providerSubject &&
          other.passwordHash == this.passwordHash &&
          other.createdAt == this.createdAt);
}

class UserIdentitiesCompanion extends UpdateCompanion<UserIdentity> {
  final Value<UuidValue> id;
  final Value<UuidValue> userId;
  final Value<IdentityProvider> provider;
  final Value<String?> providerSubject;
  final Value<String?> passwordHash;
  final Value<PgDateTime> createdAt;
  final Value<int> rowid;
  const UserIdentitiesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.provider = const Value.absent(),
    this.providerSubject = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserIdentitiesCompanion.insert({
    this.id = const Value.absent(),
    required UuidValue userId,
    required IdentityProvider provider,
    this.providerSubject = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       provider = Value(provider);
  static Insertable<UserIdentity> custom({
    Expression<UuidValue>? id,
    Expression<UuidValue>? userId,
    Expression<String>? provider,
    Expression<String>? providerSubject,
    Expression<String>? passwordHash,
    Expression<PgDateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (provider != null) 'provider': provider,
      if (providerSubject != null) 'provider_subject': providerSubject,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserIdentitiesCompanion copyWith({
    Value<UuidValue>? id,
    Value<UuidValue>? userId,
    Value<IdentityProvider>? provider,
    Value<String?>? providerSubject,
    Value<String?>? passwordHash,
    Value<PgDateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UserIdentitiesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      provider: provider ?? this.provider,
      providerSubject: providerSubject ?? this.providerSubject,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (userId.present) {
      map['user_id'] = Variable<UuidValue>(userId.value, PgTypes.uuid);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(
        $UserIdentitiesTable.$converterprovider.toSql(provider.value),
      );
    }
    if (providerSubject.present) {
      map['provider_subject'] = Variable<String>(providerSubject.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserIdentitiesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('provider: $provider, ')
          ..write('providerSubject: $providerSubject, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RefreshTokensTable extends RefreshTokens
    with TableInfo<$RefreshTokensTable, RefreshToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RefreshTokensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<UuidValue> userId = GeneratedColumn<UuidValue>(
    'user_id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _tokenHashMeta = const VerificationMeta(
    'tokenHash',
  );
  @override
  late final GeneratedColumn<String> tokenHash = GeneratedColumn<String>(
    'token_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> expiresAt =
      GeneratedColumn<PgDateTime>(
        'expires_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _revokedAtMeta = const VerificationMeta(
    'revokedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> revokedAt =
      GeneratedColumn<PgDateTime>(
        'revoked_at',
        aliasedName,
        true,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    tokenHash,
    expiresAt,
    revokedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'refresh_tokens';
  @override
  VerificationContext validateIntegrity(
    Insertable<RefreshToken> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('token_hash')) {
      context.handle(
        _tokenHashMeta,
        tokenHash.isAcceptableOrUnknown(data['token_hash']!, _tokenHashMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenHashMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('revoked_at')) {
      context.handle(
        _revokedAtMeta,
        revokedAt.isAcceptableOrUnknown(data['revoked_at']!, _revokedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RefreshToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RefreshToken(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}user_id'],
      )!,
      tokenHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_hash'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}expires_at'],
      )!,
      revokedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}revoked_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RefreshTokensTable createAlias(String alias) {
    return $RefreshTokensTable(attachedDatabase, alias);
  }
}

class RefreshToken extends DataClass implements Insertable<RefreshToken> {
  final UuidValue id;
  final UuidValue userId;
  final String tokenHash;
  final PgDateTime expiresAt;
  final PgDateTime? revokedAt;
  final PgDateTime createdAt;
  const RefreshToken({
    required this.id,
    required this.userId,
    required this.tokenHash,
    required this.expiresAt,
    this.revokedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['user_id'] = Variable<UuidValue>(userId, PgTypes.uuid);
    map['token_hash'] = Variable<String>(tokenHash);
    map['expires_at'] = Variable<PgDateTime>(
      expiresAt,
      PgTypes.timestampWithTimezone,
    );
    if (!nullToAbsent || revokedAt != null) {
      map['revoked_at'] = Variable<PgDateTime>(
        revokedAt,
        PgTypes.timestampWithTimezone,
      );
    }
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  RefreshTokensCompanion toCompanion(bool nullToAbsent) {
    return RefreshTokensCompanion(
      id: Value(id),
      userId: Value(userId),
      tokenHash: Value(tokenHash),
      expiresAt: Value(expiresAt),
      revokedAt: revokedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(revokedAt),
      createdAt: Value(createdAt),
    );
  }

  factory RefreshToken.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RefreshToken(
      id: serializer.fromJson<UuidValue>(json['id']),
      userId: serializer.fromJson<UuidValue>(json['userId']),
      tokenHash: serializer.fromJson<String>(json['tokenHash']),
      expiresAt: serializer.fromJson<PgDateTime>(json['expiresAt']),
      revokedAt: serializer.fromJson<PgDateTime?>(json['revokedAt']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'userId': serializer.toJson<UuidValue>(userId),
      'tokenHash': serializer.toJson<String>(tokenHash),
      'expiresAt': serializer.toJson<PgDateTime>(expiresAt),
      'revokedAt': serializer.toJson<PgDateTime?>(revokedAt),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
    };
  }

  RefreshToken copyWith({
    UuidValue? id,
    UuidValue? userId,
    String? tokenHash,
    PgDateTime? expiresAt,
    Value<PgDateTime?> revokedAt = const Value.absent(),
    PgDateTime? createdAt,
  }) => RefreshToken(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    tokenHash: tokenHash ?? this.tokenHash,
    expiresAt: expiresAt ?? this.expiresAt,
    revokedAt: revokedAt.present ? revokedAt.value : this.revokedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  RefreshToken copyWithCompanion(RefreshTokensCompanion data) {
    return RefreshToken(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      tokenHash: data.tokenHash.present ? data.tokenHash.value : this.tokenHash,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      revokedAt: data.revokedAt.present ? data.revokedAt.value : this.revokedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RefreshToken(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('revokedAt: $revokedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, tokenHash, expiresAt, revokedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RefreshToken &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.tokenHash == this.tokenHash &&
          other.expiresAt == this.expiresAt &&
          other.revokedAt == this.revokedAt &&
          other.createdAt == this.createdAt);
}

class RefreshTokensCompanion extends UpdateCompanion<RefreshToken> {
  final Value<UuidValue> id;
  final Value<UuidValue> userId;
  final Value<String> tokenHash;
  final Value<PgDateTime> expiresAt;
  final Value<PgDateTime?> revokedAt;
  final Value<PgDateTime> createdAt;
  final Value<int> rowid;
  const RefreshTokensCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.tokenHash = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.revokedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RefreshTokensCompanion.insert({
    this.id = const Value.absent(),
    required UuidValue userId,
    required String tokenHash,
    required PgDateTime expiresAt,
    this.revokedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       tokenHash = Value(tokenHash),
       expiresAt = Value(expiresAt);
  static Insertable<RefreshToken> custom({
    Expression<UuidValue>? id,
    Expression<UuidValue>? userId,
    Expression<String>? tokenHash,
    Expression<PgDateTime>? expiresAt,
    Expression<PgDateTime>? revokedAt,
    Expression<PgDateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (tokenHash != null) 'token_hash': tokenHash,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (revokedAt != null) 'revoked_at': revokedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RefreshTokensCompanion copyWith({
    Value<UuidValue>? id,
    Value<UuidValue>? userId,
    Value<String>? tokenHash,
    Value<PgDateTime>? expiresAt,
    Value<PgDateTime?>? revokedAt,
    Value<PgDateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RefreshTokensCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tokenHash: tokenHash ?? this.tokenHash,
      expiresAt: expiresAt ?? this.expiresAt,
      revokedAt: revokedAt ?? this.revokedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (userId.present) {
      map['user_id'] = Variable<UuidValue>(userId.value, PgTypes.uuid);
    }
    if (tokenHash.present) {
      map['token_hash'] = Variable<String>(tokenHash.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<PgDateTime>(
        expiresAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (revokedAt.present) {
      map['revoked_at'] = Variable<PgDateTime>(
        revokedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RefreshTokensCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('revokedAt: $revokedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SocialNetworksTable extends SocialNetworks
    with TableInfo<$SocialNetworksTable, SocialNetwork> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SocialNetworksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<Object> data = GeneratedColumn<Object>(
    'data',
    aliasedName,
    false,
    type: PgTypes.jsonb,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}', PgTypes.jsonb),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, slug, displayName, data, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'social_networks';
  @override
  VerificationContext validateIntegrity(
    Insertable<SocialNetwork> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SocialNetwork map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SocialNetwork(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      data: attachedDatabase.typeMapping.read(
        PgTypes.jsonb,
        data['${effectivePrefix}data'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $SocialNetworksTable createAlias(String alias) {
    return $SocialNetworksTable(attachedDatabase, alias);
  }
}

class SocialNetwork extends DataClass implements Insertable<SocialNetwork> {
  final UuidValue id;
  final String slug;
  final String displayName;
  final Object data;
  final bool isActive;
  const SocialNetwork({
    required this.id,
    required this.slug,
    required this.displayName,
    required this.data,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['slug'] = Variable<String>(slug);
    map['display_name'] = Variable<String>(displayName);
    map['data'] = Variable<Object>(data, PgTypes.jsonb);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SocialNetworksCompanion toCompanion(bool nullToAbsent) {
    return SocialNetworksCompanion(
      id: Value(id),
      slug: Value(slug),
      displayName: Value(displayName),
      data: Value(data),
      isActive: Value(isActive),
    );
  }

  factory SocialNetwork.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SocialNetwork(
      id: serializer.fromJson<UuidValue>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      displayName: serializer.fromJson<String>(json['displayName']),
      data: serializer.fromJson<Object>(json['data']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'slug': serializer.toJson<String>(slug),
      'displayName': serializer.toJson<String>(displayName),
      'data': serializer.toJson<Object>(data),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  SocialNetwork copyWith({
    UuidValue? id,
    String? slug,
    String? displayName,
    Object? data,
    bool? isActive,
  }) => SocialNetwork(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    displayName: displayName ?? this.displayName,
    data: data ?? this.data,
    isActive: isActive ?? this.isActive,
  );
  SocialNetwork copyWithCompanion(SocialNetworksCompanion data) {
    return SocialNetwork(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      data: data.data.present ? data.data.value : this.data,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SocialNetwork(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('displayName: $displayName, ')
          ..write('data: $data, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, slug, displayName, data, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SocialNetwork &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.displayName == this.displayName &&
          other.data == this.data &&
          other.isActive == this.isActive);
}

class SocialNetworksCompanion extends UpdateCompanion<SocialNetwork> {
  final Value<UuidValue> id;
  final Value<String> slug;
  final Value<String> displayName;
  final Value<Object> data;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SocialNetworksCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.displayName = const Value.absent(),
    this.data = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SocialNetworksCompanion.insert({
    this.id = const Value.absent(),
    required String slug,
    required String displayName,
    this.data = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : slug = Value(slug),
       displayName = Value(displayName);
  static Insertable<SocialNetwork> custom({
    Expression<UuidValue>? id,
    Expression<String>? slug,
    Expression<String>? displayName,
    Expression<Object>? data,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (displayName != null) 'display_name': displayName,
      if (data != null) 'data': data,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SocialNetworksCompanion copyWith({
    Value<UuidValue>? id,
    Value<String>? slug,
    Value<String>? displayName,
    Value<Object>? data,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return SocialNetworksCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      displayName: displayName ?? this.displayName,
      data: data ?? this.data,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (data.present) {
      map['data'] = Variable<Object>(data.value, PgTypes.jsonb);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SocialNetworksCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('displayName: $displayName, ')
          ..write('data: $data, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSocialAccountsTable extends UserSocialAccounts
    with TableInfo<$UserSocialAccountsTable, UserSocialAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSocialAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<UuidValue> userId = GeneratedColumn<UuidValue>(
    'user_id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _socialNetworkIdMeta = const VerificationMeta(
    'socialNetworkId',
  );
  @override
  late final GeneratedColumn<UuidValue> socialNetworkId =
      GeneratedColumn<UuidValue>(
        'social_network_id',
        aliasedName,
        false,
        type: PgTypes.uuid,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES social_networks (id)',
        ),
      );
  static const VerificationMeta _externalAccountIdMeta = const VerificationMeta(
    'externalAccountId',
  );
  @override
  late final GeneratedColumn<String> externalAccountId =
      GeneratedColumn<String>(
        'external_account_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _screenNameMeta = const VerificationMeta(
    'screenName',
  );
  @override
  late final GeneratedColumn<String> screenName = GeneratedColumn<String>(
    'screen_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'refresh_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tokenExpiresAtMeta = const VerificationMeta(
    'tokenExpiresAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> tokenExpiresAt =
      GeneratedColumn<PgDateTime>(
        'token_expires_at',
        aliasedName,
        true,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    socialNetworkId,
    externalAccountId,
    screenName,
    accessToken,
    refreshToken,
    tokenExpiresAt,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_social_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSocialAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('social_network_id')) {
      context.handle(
        _socialNetworkIdMeta,
        socialNetworkId.isAcceptableOrUnknown(
          data['social_network_id']!,
          _socialNetworkIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_socialNetworkIdMeta);
    }
    if (data.containsKey('external_account_id')) {
      context.handle(
        _externalAccountIdMeta,
        externalAccountId.isAcceptableOrUnknown(
          data['external_account_id']!,
          _externalAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_externalAccountIdMeta);
    }
    if (data.containsKey('screen_name')) {
      context.handle(
        _screenNameMeta,
        screenName.isAcceptableOrUnknown(data['screen_name']!, _screenNameMeta),
      );
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(
          data['refresh_token']!,
          _refreshTokenMeta,
        ),
      );
    }
    if (data.containsKey('token_expires_at')) {
      context.handle(
        _tokenExpiresAtMeta,
        tokenExpiresAt.isAcceptableOrUnknown(
          data['token_expires_at']!,
          _tokenExpiresAtMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {socialNetworkId, externalAccountId},
  ];
  @override
  UserSocialAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSocialAccount(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}user_id'],
      )!,
      socialNetworkId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}social_network_id'],
      )!,
      externalAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_account_id'],
      )!,
      screenName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}screen_name'],
      ),
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      ),
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token'],
      ),
      tokenExpiresAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}token_expires_at'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserSocialAccountsTable createAlias(String alias) {
    return $UserSocialAccountsTable(attachedDatabase, alias);
  }
}

class UserSocialAccount extends DataClass
    implements Insertable<UserSocialAccount> {
  final UuidValue id;
  final UuidValue userId;
  final UuidValue socialNetworkId;
  final String externalAccountId;
  final String? screenName;
  final String? accessToken;
  final String? refreshToken;
  final PgDateTime? tokenExpiresAt;
  final bool isActive;
  final PgDateTime createdAt;
  const UserSocialAccount({
    required this.id,
    required this.userId,
    required this.socialNetworkId,
    required this.externalAccountId,
    this.screenName,
    this.accessToken,
    this.refreshToken,
    this.tokenExpiresAt,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['user_id'] = Variable<UuidValue>(userId, PgTypes.uuid);
    map['social_network_id'] = Variable<UuidValue>(
      socialNetworkId,
      PgTypes.uuid,
    );
    map['external_account_id'] = Variable<String>(externalAccountId);
    if (!nullToAbsent || screenName != null) {
      map['screen_name'] = Variable<String>(screenName);
    }
    if (!nullToAbsent || accessToken != null) {
      map['access_token'] = Variable<String>(accessToken);
    }
    if (!nullToAbsent || refreshToken != null) {
      map['refresh_token'] = Variable<String>(refreshToken);
    }
    if (!nullToAbsent || tokenExpiresAt != null) {
      map['token_expires_at'] = Variable<PgDateTime>(
        tokenExpiresAt,
        PgTypes.timestampWithTimezone,
      );
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  UserSocialAccountsCompanion toCompanion(bool nullToAbsent) {
    return UserSocialAccountsCompanion(
      id: Value(id),
      userId: Value(userId),
      socialNetworkId: Value(socialNetworkId),
      externalAccountId: Value(externalAccountId),
      screenName: screenName == null && nullToAbsent
          ? const Value.absent()
          : Value(screenName),
      accessToken: accessToken == null && nullToAbsent
          ? const Value.absent()
          : Value(accessToken),
      refreshToken: refreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshToken),
      tokenExpiresAt: tokenExpiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(tokenExpiresAt),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory UserSocialAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSocialAccount(
      id: serializer.fromJson<UuidValue>(json['id']),
      userId: serializer.fromJson<UuidValue>(json['userId']),
      socialNetworkId: serializer.fromJson<UuidValue>(json['socialNetworkId']),
      externalAccountId: serializer.fromJson<String>(json['externalAccountId']),
      screenName: serializer.fromJson<String?>(json['screenName']),
      accessToken: serializer.fromJson<String?>(json['accessToken']),
      refreshToken: serializer.fromJson<String?>(json['refreshToken']),
      tokenExpiresAt: serializer.fromJson<PgDateTime?>(json['tokenExpiresAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'userId': serializer.toJson<UuidValue>(userId),
      'socialNetworkId': serializer.toJson<UuidValue>(socialNetworkId),
      'externalAccountId': serializer.toJson<String>(externalAccountId),
      'screenName': serializer.toJson<String?>(screenName),
      'accessToken': serializer.toJson<String?>(accessToken),
      'refreshToken': serializer.toJson<String?>(refreshToken),
      'tokenExpiresAt': serializer.toJson<PgDateTime?>(tokenExpiresAt),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
    };
  }

  UserSocialAccount copyWith({
    UuidValue? id,
    UuidValue? userId,
    UuidValue? socialNetworkId,
    String? externalAccountId,
    Value<String?> screenName = const Value.absent(),
    Value<String?> accessToken = const Value.absent(),
    Value<String?> refreshToken = const Value.absent(),
    Value<PgDateTime?> tokenExpiresAt = const Value.absent(),
    bool? isActive,
    PgDateTime? createdAt,
  }) => UserSocialAccount(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    socialNetworkId: socialNetworkId ?? this.socialNetworkId,
    externalAccountId: externalAccountId ?? this.externalAccountId,
    screenName: screenName.present ? screenName.value : this.screenName,
    accessToken: accessToken.present ? accessToken.value : this.accessToken,
    refreshToken: refreshToken.present ? refreshToken.value : this.refreshToken,
    tokenExpiresAt: tokenExpiresAt.present
        ? tokenExpiresAt.value
        : this.tokenExpiresAt,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  UserSocialAccount copyWithCompanion(UserSocialAccountsCompanion data) {
    return UserSocialAccount(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      socialNetworkId: data.socialNetworkId.present
          ? data.socialNetworkId.value
          : this.socialNetworkId,
      externalAccountId: data.externalAccountId.present
          ? data.externalAccountId.value
          : this.externalAccountId,
      screenName: data.screenName.present
          ? data.screenName.value
          : this.screenName,
      accessToken: data.accessToken.present
          ? data.accessToken.value
          : this.accessToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      tokenExpiresAt: data.tokenExpiresAt.present
          ? data.tokenExpiresAt.value
          : this.tokenExpiresAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSocialAccount(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('socialNetworkId: $socialNetworkId, ')
          ..write('externalAccountId: $externalAccountId, ')
          ..write('screenName: $screenName, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('tokenExpiresAt: $tokenExpiresAt, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    socialNetworkId,
    externalAccountId,
    screenName,
    accessToken,
    refreshToken,
    tokenExpiresAt,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSocialAccount &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.socialNetworkId == this.socialNetworkId &&
          other.externalAccountId == this.externalAccountId &&
          other.screenName == this.screenName &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken &&
          other.tokenExpiresAt == this.tokenExpiresAt &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class UserSocialAccountsCompanion extends UpdateCompanion<UserSocialAccount> {
  final Value<UuidValue> id;
  final Value<UuidValue> userId;
  final Value<UuidValue> socialNetworkId;
  final Value<String> externalAccountId;
  final Value<String?> screenName;
  final Value<String?> accessToken;
  final Value<String?> refreshToken;
  final Value<PgDateTime?> tokenExpiresAt;
  final Value<bool> isActive;
  final Value<PgDateTime> createdAt;
  final Value<int> rowid;
  const UserSocialAccountsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.socialNetworkId = const Value.absent(),
    this.externalAccountId = const Value.absent(),
    this.screenName = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.tokenExpiresAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSocialAccountsCompanion.insert({
    this.id = const Value.absent(),
    required UuidValue userId,
    required UuidValue socialNetworkId,
    required String externalAccountId,
    this.screenName = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.tokenExpiresAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       socialNetworkId = Value(socialNetworkId),
       externalAccountId = Value(externalAccountId);
  static Insertable<UserSocialAccount> custom({
    Expression<UuidValue>? id,
    Expression<UuidValue>? userId,
    Expression<UuidValue>? socialNetworkId,
    Expression<String>? externalAccountId,
    Expression<String>? screenName,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<PgDateTime>? tokenExpiresAt,
    Expression<bool>? isActive,
    Expression<PgDateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (socialNetworkId != null) 'social_network_id': socialNetworkId,
      if (externalAccountId != null) 'external_account_id': externalAccountId,
      if (screenName != null) 'screen_name': screenName,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (tokenExpiresAt != null) 'token_expires_at': tokenExpiresAt,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSocialAccountsCompanion copyWith({
    Value<UuidValue>? id,
    Value<UuidValue>? userId,
    Value<UuidValue>? socialNetworkId,
    Value<String>? externalAccountId,
    Value<String?>? screenName,
    Value<String?>? accessToken,
    Value<String?>? refreshToken,
    Value<PgDateTime?>? tokenExpiresAt,
    Value<bool>? isActive,
    Value<PgDateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UserSocialAccountsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      socialNetworkId: socialNetworkId ?? this.socialNetworkId,
      externalAccountId: externalAccountId ?? this.externalAccountId,
      screenName: screenName ?? this.screenName,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (userId.present) {
      map['user_id'] = Variable<UuidValue>(userId.value, PgTypes.uuid);
    }
    if (socialNetworkId.present) {
      map['social_network_id'] = Variable<UuidValue>(
        socialNetworkId.value,
        PgTypes.uuid,
      );
    }
    if (externalAccountId.present) {
      map['external_account_id'] = Variable<String>(externalAccountId.value);
    }
    if (screenName.present) {
      map['screen_name'] = Variable<String>(screenName.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (tokenExpiresAt.present) {
      map['token_expires_at'] = Variable<PgDateTime>(
        tokenExpiresAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSocialAccountsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('socialNetworkId: $socialNetworkId, ')
          ..write('externalAccountId: $externalAccountId, ')
          ..write('screenName: $screenName, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('tokenExpiresAt: $tokenExpiresAt, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SocialAccountTargetsTable extends SocialAccountTargets
    with TableInfo<$SocialAccountTargetsTable, SocialAccountTarget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SocialAccountTargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _userSocialAccountIdMeta =
      const VerificationMeta('userSocialAccountId');
  @override
  late final GeneratedColumn<UuidValue> userSocialAccountId =
      GeneratedColumn<UuidValue>(
        'user_social_account_id',
        aliasedName,
        false,
        type: PgTypes.uuid,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES user_social_accounts (id)',
        ),
      );
  static const VerificationMeta _targetTypeMeta = const VerificationMeta(
    'targetType',
  );
  @override
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetLabelMeta = const VerificationMeta(
    'targetLabel',
  );
  @override
  late final GeneratedColumn<String> targetLabel = GeneratedColumn<String>(
    'target_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userSocialAccountId,
    targetType,
    targetId,
    targetLabel,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'social_account_targets';
  @override
  VerificationContext validateIntegrity(
    Insertable<SocialAccountTarget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_social_account_id')) {
      context.handle(
        _userSocialAccountIdMeta,
        userSocialAccountId.isAcceptableOrUnknown(
          data['user_social_account_id']!,
          _userSocialAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userSocialAccountIdMeta);
    }
    if (data.containsKey('target_type')) {
      context.handle(
        _targetTypeMeta,
        targetType.isAcceptableOrUnknown(data['target_type']!, _targetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTypeMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('target_label')) {
      context.handle(
        _targetLabelMeta,
        targetLabel.isAcceptableOrUnknown(
          data['target_label']!,
          _targetLabelMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userSocialAccountId, targetId},
  ];
  @override
  SocialAccountTarget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SocialAccountTarget(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      userSocialAccountId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}user_social_account_id'],
      )!,
      targetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_type'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      )!,
      targetLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_label'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $SocialAccountTargetsTable createAlias(String alias) {
    return $SocialAccountTargetsTable(attachedDatabase, alias);
  }
}

class SocialAccountTarget extends DataClass
    implements Insertable<SocialAccountTarget> {
  final UuidValue id;
  final UuidValue userSocialAccountId;
  final String targetType;
  final String targetId;
  final String? targetLabel;
  final bool isActive;
  const SocialAccountTarget({
    required this.id,
    required this.userSocialAccountId,
    required this.targetType,
    required this.targetId,
    this.targetLabel,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['user_social_account_id'] = Variable<UuidValue>(
      userSocialAccountId,
      PgTypes.uuid,
    );
    map['target_type'] = Variable<String>(targetType);
    map['target_id'] = Variable<String>(targetId);
    if (!nullToAbsent || targetLabel != null) {
      map['target_label'] = Variable<String>(targetLabel);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SocialAccountTargetsCompanion toCompanion(bool nullToAbsent) {
    return SocialAccountTargetsCompanion(
      id: Value(id),
      userSocialAccountId: Value(userSocialAccountId),
      targetType: Value(targetType),
      targetId: Value(targetId),
      targetLabel: targetLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(targetLabel),
      isActive: Value(isActive),
    );
  }

  factory SocialAccountTarget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SocialAccountTarget(
      id: serializer.fromJson<UuidValue>(json['id']),
      userSocialAccountId: serializer.fromJson<UuidValue>(
        json['userSocialAccountId'],
      ),
      targetType: serializer.fromJson<String>(json['targetType']),
      targetId: serializer.fromJson<String>(json['targetId']),
      targetLabel: serializer.fromJson<String?>(json['targetLabel']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'userSocialAccountId': serializer.toJson<UuidValue>(userSocialAccountId),
      'targetType': serializer.toJson<String>(targetType),
      'targetId': serializer.toJson<String>(targetId),
      'targetLabel': serializer.toJson<String?>(targetLabel),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  SocialAccountTarget copyWith({
    UuidValue? id,
    UuidValue? userSocialAccountId,
    String? targetType,
    String? targetId,
    Value<String?> targetLabel = const Value.absent(),
    bool? isActive,
  }) => SocialAccountTarget(
    id: id ?? this.id,
    userSocialAccountId: userSocialAccountId ?? this.userSocialAccountId,
    targetType: targetType ?? this.targetType,
    targetId: targetId ?? this.targetId,
    targetLabel: targetLabel.present ? targetLabel.value : this.targetLabel,
    isActive: isActive ?? this.isActive,
  );
  SocialAccountTarget copyWithCompanion(SocialAccountTargetsCompanion data) {
    return SocialAccountTarget(
      id: data.id.present ? data.id.value : this.id,
      userSocialAccountId: data.userSocialAccountId.present
          ? data.userSocialAccountId.value
          : this.userSocialAccountId,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      targetLabel: data.targetLabel.present
          ? data.targetLabel.value
          : this.targetLabel,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SocialAccountTarget(')
          ..write('id: $id, ')
          ..write('userSocialAccountId: $userSocialAccountId, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId, ')
          ..write('targetLabel: $targetLabel, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userSocialAccountId,
    targetType,
    targetId,
    targetLabel,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SocialAccountTarget &&
          other.id == this.id &&
          other.userSocialAccountId == this.userSocialAccountId &&
          other.targetType == this.targetType &&
          other.targetId == this.targetId &&
          other.targetLabel == this.targetLabel &&
          other.isActive == this.isActive);
}

class SocialAccountTargetsCompanion
    extends UpdateCompanion<SocialAccountTarget> {
  final Value<UuidValue> id;
  final Value<UuidValue> userSocialAccountId;
  final Value<String> targetType;
  final Value<String> targetId;
  final Value<String?> targetLabel;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SocialAccountTargetsCompanion({
    this.id = const Value.absent(),
    this.userSocialAccountId = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetId = const Value.absent(),
    this.targetLabel = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SocialAccountTargetsCompanion.insert({
    this.id = const Value.absent(),
    required UuidValue userSocialAccountId,
    required String targetType,
    required String targetId,
    this.targetLabel = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userSocialAccountId = Value(userSocialAccountId),
       targetType = Value(targetType),
       targetId = Value(targetId);
  static Insertable<SocialAccountTarget> custom({
    Expression<UuidValue>? id,
    Expression<UuidValue>? userSocialAccountId,
    Expression<String>? targetType,
    Expression<String>? targetId,
    Expression<String>? targetLabel,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userSocialAccountId != null)
        'user_social_account_id': userSocialAccountId,
      if (targetType != null) 'target_type': targetType,
      if (targetId != null) 'target_id': targetId,
      if (targetLabel != null) 'target_label': targetLabel,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SocialAccountTargetsCompanion copyWith({
    Value<UuidValue>? id,
    Value<UuidValue>? userSocialAccountId,
    Value<String>? targetType,
    Value<String>? targetId,
    Value<String?>? targetLabel,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return SocialAccountTargetsCompanion(
      id: id ?? this.id,
      userSocialAccountId: userSocialAccountId ?? this.userSocialAccountId,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      targetLabel: targetLabel ?? this.targetLabel,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (userSocialAccountId.present) {
      map['user_social_account_id'] = Variable<UuidValue>(
        userSocialAccountId.value,
        PgTypes.uuid,
      );
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (targetLabel.present) {
      map['target_label'] = Variable<String>(targetLabel.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SocialAccountTargetsCompanion(')
          ..write('id: $id, ')
          ..write('userSocialAccountId: $userSocialAccountId, ')
          ..write('targetType: $targetType, ')
          ..write('targetId: $targetId, ')
          ..write('targetLabel: $targetLabel, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArtistsTable extends Artists with TableInfo<$ArtistsTable, Artist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  @override
  List<GeneratedColumn> get $columns => [id, name, sourceUrl, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Artist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Artist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Artist(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ArtistsTable createAlias(String alias) {
    return $ArtistsTable(attachedDatabase, alias);
  }
}

class Artist extends DataClass implements Insertable<Artist> {
  final UuidValue id;
  final String name;
  final String? sourceUrl;
  final String? notes;
  final PgDateTime createdAt;
  const Artist({
    required this.id,
    required this.name,
    this.sourceUrl,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  ArtistsCompanion toCompanion(bool nullToAbsent) {
    return ArtistsCompanion(
      id: Value(id),
      name: Value(name),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Artist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Artist(
      id: serializer.fromJson<UuidValue>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'name': serializer.toJson<String>(name),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
    };
  }

  Artist copyWith({
    UuidValue? id,
    String? name,
    Value<String?> sourceUrl = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    PgDateTime? createdAt,
  }) => Artist(
    id: id ?? this.id,
    name: name ?? this.name,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  Artist copyWithCompanion(ArtistsCompanion data) {
    return Artist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Artist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sourceUrl, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Artist &&
          other.id == this.id &&
          other.name == this.name &&
          other.sourceUrl == this.sourceUrl &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class ArtistsCompanion extends UpdateCompanion<Artist> {
  final Value<UuidValue> id;
  final Value<String> name;
  final Value<String?> sourceUrl;
  final Value<String?> notes;
  final Value<PgDateTime> createdAt;
  final Value<int> rowid;
  const ArtistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sourceUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Artist> custom({
    Expression<UuidValue>? id,
    Expression<String>? name,
    Expression<String>? sourceUrl,
    Expression<String>? notes,
    Expression<PgDateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtistsCompanion copyWith({
    Value<UuidValue>? id,
    Value<String>? name,
    Value<String?>? sourceUrl,
    Value<String?>? notes,
    Value<PgDateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ArtistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FranchisesTable extends Franchises
    with TableInfo<$FranchisesTable, Franchise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FranchisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'franchises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Franchise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Franchise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Franchise(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FranchisesTable createAlias(String alias) {
    return $FranchisesTable(attachedDatabase, alias);
  }
}

class Franchise extends DataClass implements Insertable<Franchise> {
  final UuidValue id;
  final String name;
  final String? description;
  final PgDateTime createdAt;
  const Franchise({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  FranchisesCompanion toCompanion(bool nullToAbsent) {
    return FranchisesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory Franchise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Franchise(
      id: serializer.fromJson<UuidValue>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
    };
  }

  Franchise copyWith({
    UuidValue? id,
    String? name,
    Value<String?> description = const Value.absent(),
    PgDateTime? createdAt,
  }) => Franchise(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  Franchise copyWithCompanion(FranchisesCompanion data) {
    return Franchise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Franchise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Franchise &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class FranchisesCompanion extends UpdateCompanion<Franchise> {
  final Value<UuidValue> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<PgDateTime> createdAt;
  final Value<int> rowid;
  const FranchisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FranchisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Franchise> custom({
    Expression<UuidValue>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<PgDateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FranchisesCompanion copyWith({
    Value<UuidValue>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<PgDateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FranchisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FranchisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharactersTable extends Characters
    with TableInfo<$CharactersTable, Character> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _franchiseIdMeta = const VerificationMeta(
    'franchiseId',
  );
  @override
  late final GeneratedColumn<UuidValue> franchiseId =
      GeneratedColumn<UuidValue>(
        'franchise_id',
        aliasedName,
        false,
        type: PgTypes.uuid,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES franchises (id)',
        ),
      );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    franchiseId,
    name,
    description,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Character> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('franchise_id')) {
      context.handle(
        _franchiseIdMeta,
        franchiseId.isAcceptableOrUnknown(
          data['franchise_id']!,
          _franchiseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_franchiseIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Character map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Character(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      franchiseId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}franchise_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CharactersTable createAlias(String alias) {
    return $CharactersTable(attachedDatabase, alias);
  }
}

class Character extends DataClass implements Insertable<Character> {
  final UuidValue id;
  final UuidValue franchiseId;
  final String name;
  final String? description;
  final PgDateTime createdAt;
  const Character({
    required this.id,
    required this.franchiseId,
    required this.name,
    this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['franchise_id'] = Variable<UuidValue>(franchiseId, PgTypes.uuid);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  CharactersCompanion toCompanion(bool nullToAbsent) {
    return CharactersCompanion(
      id: Value(id),
      franchiseId: Value(franchiseId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory Character.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Character(
      id: serializer.fromJson<UuidValue>(json['id']),
      franchiseId: serializer.fromJson<UuidValue>(json['franchiseId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'franchiseId': serializer.toJson<UuidValue>(franchiseId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
    };
  }

  Character copyWith({
    UuidValue? id,
    UuidValue? franchiseId,
    String? name,
    Value<String?> description = const Value.absent(),
    PgDateTime? createdAt,
  }) => Character(
    id: id ?? this.id,
    franchiseId: franchiseId ?? this.franchiseId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  Character copyWithCompanion(CharactersCompanion data) {
    return Character(
      id: data.id.present ? data.id.value : this.id,
      franchiseId: data.franchiseId.present
          ? data.franchiseId.value
          : this.franchiseId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Character(')
          ..write('id: $id, ')
          ..write('franchiseId: $franchiseId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, franchiseId, name, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Character &&
          other.id == this.id &&
          other.franchiseId == this.franchiseId &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class CharactersCompanion extends UpdateCompanion<Character> {
  final Value<UuidValue> id;
  final Value<UuidValue> franchiseId;
  final Value<String> name;
  final Value<String?> description;
  final Value<PgDateTime> createdAt;
  final Value<int> rowid;
  const CharactersCompanion({
    this.id = const Value.absent(),
    this.franchiseId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharactersCompanion.insert({
    this.id = const Value.absent(),
    required UuidValue franchiseId,
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : franchiseId = Value(franchiseId),
       name = Value(name);
  static Insertable<Character> custom({
    Expression<UuidValue>? id,
    Expression<UuidValue>? franchiseId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<PgDateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (franchiseId != null) 'franchise_id': franchiseId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharactersCompanion copyWith({
    Value<UuidValue>? id,
    Value<UuidValue>? franchiseId,
    Value<String>? name,
    Value<String?>? description,
    Value<PgDateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CharactersCompanion(
      id: id ?? this.id,
      franchiseId: franchiseId ?? this.franchiseId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (franchiseId.present) {
      map['franchise_id'] = Variable<UuidValue>(
        franchiseId.value,
        PgTypes.uuid,
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersCompanion(')
          ..write('id: $id, ')
          ..write('franchiseId: $franchiseId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaTypesTable extends MediaTypes
    with TableInfo<$MediaTypesTable, MediaType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allowedExtensionsMeta = const VerificationMeta(
    'allowedExtensions',
  );
  @override
  late final GeneratedColumn<List<String>> allowedExtensions =
      GeneratedColumn<List<String>>(
        'allowed_extensions',
        aliasedName,
        false,
        type: PgTypes.textArray,
        requiredDuringInsert: false,
        defaultValue: Constant([], PgTypes.textArray),
      );
  static const VerificationMeta _maxSizeMbMeta = const VerificationMeta(
    'maxSizeMb',
  );
  @override
  late final GeneratedColumn<int> maxSizeMb = GeneratedColumn<int>(
    'max_size_mb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slug,
    displayName,
    allowedExtensions,
    maxSizeMb,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaType> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('allowed_extensions')) {
      context.handle(
        _allowedExtensionsMeta,
        allowedExtensions.isAcceptableOrUnknown(
          data['allowed_extensions']!,
          _allowedExtensionsMeta,
        ),
      );
    }
    if (data.containsKey('max_size_mb')) {
      context.handle(
        _maxSizeMbMeta,
        maxSizeMb.isAcceptableOrUnknown(data['max_size_mb']!, _maxSizeMbMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaType(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      allowedExtensions: attachedDatabase.typeMapping.read(
        PgTypes.textArray,
        data['${effectivePrefix}allowed_extensions'],
      )!,
      maxSizeMb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_size_mb'],
      )!,
    );
  }

  @override
  $MediaTypesTable createAlias(String alias) {
    return $MediaTypesTable(attachedDatabase, alias);
  }
}

class MediaType extends DataClass implements Insertable<MediaType> {
  final UuidValue id;
  final String slug;
  final String displayName;
  final List<String> allowedExtensions;
  final int maxSizeMb;
  const MediaType({
    required this.id,
    required this.slug,
    required this.displayName,
    required this.allowedExtensions,
    required this.maxSizeMb,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['slug'] = Variable<String>(slug);
    map['display_name'] = Variable<String>(displayName);
    map['allowed_extensions'] = Variable<List<String>>(
      allowedExtensions,
      PgTypes.textArray,
    );
    map['max_size_mb'] = Variable<int>(maxSizeMb);
    return map;
  }

  MediaTypesCompanion toCompanion(bool nullToAbsent) {
    return MediaTypesCompanion(
      id: Value(id),
      slug: Value(slug),
      displayName: Value(displayName),
      allowedExtensions: Value(allowedExtensions),
      maxSizeMb: Value(maxSizeMb),
    );
  }

  factory MediaType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaType(
      id: serializer.fromJson<UuidValue>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      displayName: serializer.fromJson<String>(json['displayName']),
      allowedExtensions: serializer.fromJson<List<String>>(
        json['allowedExtensions'],
      ),
      maxSizeMb: serializer.fromJson<int>(json['maxSizeMb']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'slug': serializer.toJson<String>(slug),
      'displayName': serializer.toJson<String>(displayName),
      'allowedExtensions': serializer.toJson<List<String>>(allowedExtensions),
      'maxSizeMb': serializer.toJson<int>(maxSizeMb),
    };
  }

  MediaType copyWith({
    UuidValue? id,
    String? slug,
    String? displayName,
    List<String>? allowedExtensions,
    int? maxSizeMb,
  }) => MediaType(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    displayName: displayName ?? this.displayName,
    allowedExtensions: allowedExtensions ?? this.allowedExtensions,
    maxSizeMb: maxSizeMb ?? this.maxSizeMb,
  );
  MediaType copyWithCompanion(MediaTypesCompanion data) {
    return MediaType(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      allowedExtensions: data.allowedExtensions.present
          ? data.allowedExtensions.value
          : this.allowedExtensions,
      maxSizeMb: data.maxSizeMb.present ? data.maxSizeMb.value : this.maxSizeMb,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaType(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('displayName: $displayName, ')
          ..write('allowedExtensions: $allowedExtensions, ')
          ..write('maxSizeMb: $maxSizeMb')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, slug, displayName, allowedExtensions, maxSizeMb);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaType &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.displayName == this.displayName &&
          other.allowedExtensions == this.allowedExtensions &&
          other.maxSizeMb == this.maxSizeMb);
}

class MediaTypesCompanion extends UpdateCompanion<MediaType> {
  final Value<UuidValue> id;
  final Value<String> slug;
  final Value<String> displayName;
  final Value<List<String>> allowedExtensions;
  final Value<int> maxSizeMb;
  final Value<int> rowid;
  const MediaTypesCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.displayName = const Value.absent(),
    this.allowedExtensions = const Value.absent(),
    this.maxSizeMb = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaTypesCompanion.insert({
    this.id = const Value.absent(),
    required String slug,
    required String displayName,
    this.allowedExtensions = const Value.absent(),
    this.maxSizeMb = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : slug = Value(slug),
       displayName = Value(displayName);
  static Insertable<MediaType> custom({
    Expression<UuidValue>? id,
    Expression<String>? slug,
    Expression<String>? displayName,
    Expression<List<String>>? allowedExtensions,
    Expression<int>? maxSizeMb,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (displayName != null) 'display_name': displayName,
      if (allowedExtensions != null) 'allowed_extensions': allowedExtensions,
      if (maxSizeMb != null) 'max_size_mb': maxSizeMb,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaTypesCompanion copyWith({
    Value<UuidValue>? id,
    Value<String>? slug,
    Value<String>? displayName,
    Value<List<String>>? allowedExtensions,
    Value<int>? maxSizeMb,
    Value<int>? rowid,
  }) {
    return MediaTypesCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      displayName: displayName ?? this.displayName,
      allowedExtensions: allowedExtensions ?? this.allowedExtensions,
      maxSizeMb: maxSizeMb ?? this.maxSizeMb,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (allowedExtensions.present) {
      map['allowed_extensions'] = Variable<List<String>>(
        allowedExtensions.value,
        PgTypes.textArray,
      );
    }
    if (maxSizeMb.present) {
      map['max_size_mb'] = Variable<int>(maxSizeMb.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaTypesCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('displayName: $displayName, ')
          ..write('allowedExtensions: $allowedExtensions, ')
          ..write('maxSizeMb: $maxSizeMb, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaFilesTable extends MediaFiles
    with TableInfo<$MediaFilesTable, MediaFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _uploadedByMeta = const VerificationMeta(
    'uploadedBy',
  );
  @override
  late final GeneratedColumn<UuidValue> uploadedBy = GeneratedColumn<UuidValue>(
    'uploaded_by',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _mediaTypeIdMeta = const VerificationMeta(
    'mediaTypeId',
  );
  @override
  late final GeneratedColumn<UuidValue> mediaTypeId =
      GeneratedColumn<UuidValue>(
        'media_type_id',
        aliasedName,
        false,
        type: PgTypes.uuid,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES media_types (id)',
        ),
      );
  @override
  late final GeneratedColumnWithTypeConverter<StorageType, String> storageType =
      GeneratedColumn<String>(
        'storage_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(StorageType.local.name),
      ).withConverter<StorageType>($MediaFilesTable.$converterstorageType);
  static const VerificationMeta _storagePathMeta = const VerificationMeta(
    'storagePath',
  );
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
    'storage_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalFilenameMeta = const VerificationMeta(
    'originalFilename',
  );
  @override
  late final GeneratedColumn<String> originalFilename = GeneratedColumn<String>(
    'original_filename',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<BigInt> fileSizeBytes = GeneratedColumn<BigInt>(
    'file_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<Object> metadata = GeneratedColumn<Object>(
    'metadata',
    aliasedName,
    false,
    type: PgTypes.jsonb,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}', PgTypes.jsonb),
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> uploadedAt =
      GeneratedColumn<PgDateTime>(
        'uploaded_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uploadedBy,
    mediaTypeId,
    storageType,
    storagePath,
    sourceUrl,
    originalFilename,
    fileSizeBytes,
    metadata,
    uploadedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uploaded_by')) {
      context.handle(
        _uploadedByMeta,
        uploadedBy.isAcceptableOrUnknown(data['uploaded_by']!, _uploadedByMeta),
      );
    } else if (isInserting) {
      context.missing(_uploadedByMeta);
    }
    if (data.containsKey('media_type_id')) {
      context.handle(
        _mediaTypeIdMeta,
        mediaTypeId.isAcceptableOrUnknown(
          data['media_type_id']!,
          _mediaTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeIdMeta);
    }
    if (data.containsKey('storage_path')) {
      context.handle(
        _storagePathMeta,
        storagePath.isAcceptableOrUnknown(
          data['storage_path']!,
          _storagePathMeta,
        ),
      );
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('original_filename')) {
      context.handle(
        _originalFilenameMeta,
        originalFilename.isAcceptableOrUnknown(
          data['original_filename']!,
          _originalFilenameMeta,
        ),
      );
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaFile(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      uploadedBy: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}uploaded_by'],
      )!,
      mediaTypeId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}media_type_id'],
      )!,
      storageType: $MediaFilesTable.$converterstorageType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}storage_type'],
        )!,
      ),
      storagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_path'],
      ),
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      originalFilename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_filename'],
      ),
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}file_size_bytes'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        PgTypes.jsonb,
        data['${effectivePrefix}metadata'],
      )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}uploaded_at'],
      )!,
    );
  }

  @override
  $MediaFilesTable createAlias(String alias) {
    return $MediaFilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StorageType, String, String> $converterstorageType =
      const EnumNameConverter<StorageType>(StorageType.values);
}

class MediaFile extends DataClass implements Insertable<MediaFile> {
  final UuidValue id;
  final UuidValue uploadedBy;
  final UuidValue mediaTypeId;
  final StorageType storageType;
  final String? storagePath;
  final String? sourceUrl;
  final String? originalFilename;
  final BigInt? fileSizeBytes;
  final Object metadata;
  final PgDateTime uploadedAt;
  const MediaFile({
    required this.id,
    required this.uploadedBy,
    required this.mediaTypeId,
    required this.storageType,
    this.storagePath,
    this.sourceUrl,
    this.originalFilename,
    this.fileSizeBytes,
    required this.metadata,
    required this.uploadedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['uploaded_by'] = Variable<UuidValue>(uploadedBy, PgTypes.uuid);
    map['media_type_id'] = Variable<UuidValue>(mediaTypeId, PgTypes.uuid);
    {
      map['storage_type'] = Variable<String>(
        $MediaFilesTable.$converterstorageType.toSql(storageType),
      );
    }
    if (!nullToAbsent || storagePath != null) {
      map['storage_path'] = Variable<String>(storagePath);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    if (!nullToAbsent || originalFilename != null) {
      map['original_filename'] = Variable<String>(originalFilename);
    }
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<BigInt>(fileSizeBytes);
    }
    map['metadata'] = Variable<Object>(metadata, PgTypes.jsonb);
    map['uploaded_at'] = Variable<PgDateTime>(
      uploadedAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  MediaFilesCompanion toCompanion(bool nullToAbsent) {
    return MediaFilesCompanion(
      id: Value(id),
      uploadedBy: Value(uploadedBy),
      mediaTypeId: Value(mediaTypeId),
      storageType: Value(storageType),
      storagePath: storagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(storagePath),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      originalFilename: originalFilename == null && nullToAbsent
          ? const Value.absent()
          : Value(originalFilename),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSizeBytes),
      metadata: Value(metadata),
      uploadedAt: Value(uploadedAt),
    );
  }

  factory MediaFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaFile(
      id: serializer.fromJson<UuidValue>(json['id']),
      uploadedBy: serializer.fromJson<UuidValue>(json['uploadedBy']),
      mediaTypeId: serializer.fromJson<UuidValue>(json['mediaTypeId']),
      storageType: $MediaFilesTable.$converterstorageType.fromJson(
        serializer.fromJson<String>(json['storageType']),
      ),
      storagePath: serializer.fromJson<String?>(json['storagePath']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      originalFilename: serializer.fromJson<String?>(json['originalFilename']),
      fileSizeBytes: serializer.fromJson<BigInt?>(json['fileSizeBytes']),
      metadata: serializer.fromJson<Object>(json['metadata']),
      uploadedAt: serializer.fromJson<PgDateTime>(json['uploadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'uploadedBy': serializer.toJson<UuidValue>(uploadedBy),
      'mediaTypeId': serializer.toJson<UuidValue>(mediaTypeId),
      'storageType': serializer.toJson<String>(
        $MediaFilesTable.$converterstorageType.toJson(storageType),
      ),
      'storagePath': serializer.toJson<String?>(storagePath),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'originalFilename': serializer.toJson<String?>(originalFilename),
      'fileSizeBytes': serializer.toJson<BigInt?>(fileSizeBytes),
      'metadata': serializer.toJson<Object>(metadata),
      'uploadedAt': serializer.toJson<PgDateTime>(uploadedAt),
    };
  }

  MediaFile copyWith({
    UuidValue? id,
    UuidValue? uploadedBy,
    UuidValue? mediaTypeId,
    StorageType? storageType,
    Value<String?> storagePath = const Value.absent(),
    Value<String?> sourceUrl = const Value.absent(),
    Value<String?> originalFilename = const Value.absent(),
    Value<BigInt?> fileSizeBytes = const Value.absent(),
    Object? metadata,
    PgDateTime? uploadedAt,
  }) => MediaFile(
    id: id ?? this.id,
    uploadedBy: uploadedBy ?? this.uploadedBy,
    mediaTypeId: mediaTypeId ?? this.mediaTypeId,
    storageType: storageType ?? this.storageType,
    storagePath: storagePath.present ? storagePath.value : this.storagePath,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    originalFilename: originalFilename.present
        ? originalFilename.value
        : this.originalFilename,
    fileSizeBytes: fileSizeBytes.present
        ? fileSizeBytes.value
        : this.fileSizeBytes,
    metadata: metadata ?? this.metadata,
    uploadedAt: uploadedAt ?? this.uploadedAt,
  );
  MediaFile copyWithCompanion(MediaFilesCompanion data) {
    return MediaFile(
      id: data.id.present ? data.id.value : this.id,
      uploadedBy: data.uploadedBy.present
          ? data.uploadedBy.value
          : this.uploadedBy,
      mediaTypeId: data.mediaTypeId.present
          ? data.mediaTypeId.value
          : this.mediaTypeId,
      storageType: data.storageType.present
          ? data.storageType.value
          : this.storageType,
      storagePath: data.storagePath.present
          ? data.storagePath.value
          : this.storagePath,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      originalFilename: data.originalFilename.present
          ? data.originalFilename.value
          : this.originalFilename,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      uploadedAt: data.uploadedAt.present
          ? data.uploadedAt.value
          : this.uploadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaFile(')
          ..write('id: $id, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('mediaTypeId: $mediaTypeId, ')
          ..write('storageType: $storageType, ')
          ..write('storagePath: $storagePath, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('originalFilename: $originalFilename, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('metadata: $metadata, ')
          ..write('uploadedAt: $uploadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uploadedBy,
    mediaTypeId,
    storageType,
    storagePath,
    sourceUrl,
    originalFilename,
    fileSizeBytes,
    metadata,
    uploadedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaFile &&
          other.id == this.id &&
          other.uploadedBy == this.uploadedBy &&
          other.mediaTypeId == this.mediaTypeId &&
          other.storageType == this.storageType &&
          other.storagePath == this.storagePath &&
          other.sourceUrl == this.sourceUrl &&
          other.originalFilename == this.originalFilename &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.metadata == this.metadata &&
          other.uploadedAt == this.uploadedAt);
}

class MediaFilesCompanion extends UpdateCompanion<MediaFile> {
  final Value<UuidValue> id;
  final Value<UuidValue> uploadedBy;
  final Value<UuidValue> mediaTypeId;
  final Value<StorageType> storageType;
  final Value<String?> storagePath;
  final Value<String?> sourceUrl;
  final Value<String?> originalFilename;
  final Value<BigInt?> fileSizeBytes;
  final Value<Object> metadata;
  final Value<PgDateTime> uploadedAt;
  final Value<int> rowid;
  const MediaFilesCompanion({
    this.id = const Value.absent(),
    this.uploadedBy = const Value.absent(),
    this.mediaTypeId = const Value.absent(),
    this.storageType = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.originalFilename = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.metadata = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaFilesCompanion.insert({
    this.id = const Value.absent(),
    required UuidValue uploadedBy,
    required UuidValue mediaTypeId,
    this.storageType = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.originalFilename = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.metadata = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uploadedBy = Value(uploadedBy),
       mediaTypeId = Value(mediaTypeId);
  static Insertable<MediaFile> custom({
    Expression<UuidValue>? id,
    Expression<UuidValue>? uploadedBy,
    Expression<UuidValue>? mediaTypeId,
    Expression<String>? storageType,
    Expression<String>? storagePath,
    Expression<String>? sourceUrl,
    Expression<String>? originalFilename,
    Expression<BigInt>? fileSizeBytes,
    Expression<Object>? metadata,
    Expression<PgDateTime>? uploadedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uploadedBy != null) 'uploaded_by': uploadedBy,
      if (mediaTypeId != null) 'media_type_id': mediaTypeId,
      if (storageType != null) 'storage_type': storageType,
      if (storagePath != null) 'storage_path': storagePath,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (originalFilename != null) 'original_filename': originalFilename,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (metadata != null) 'metadata': metadata,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaFilesCompanion copyWith({
    Value<UuidValue>? id,
    Value<UuidValue>? uploadedBy,
    Value<UuidValue>? mediaTypeId,
    Value<StorageType>? storageType,
    Value<String?>? storagePath,
    Value<String?>? sourceUrl,
    Value<String?>? originalFilename,
    Value<BigInt?>? fileSizeBytes,
    Value<Object>? metadata,
    Value<PgDateTime>? uploadedAt,
    Value<int>? rowid,
  }) {
    return MediaFilesCompanion(
      id: id ?? this.id,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      mediaTypeId: mediaTypeId ?? this.mediaTypeId,
      storageType: storageType ?? this.storageType,
      storagePath: storagePath ?? this.storagePath,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      originalFilename: originalFilename ?? this.originalFilename,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      metadata: metadata ?? this.metadata,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (uploadedBy.present) {
      map['uploaded_by'] = Variable<UuidValue>(uploadedBy.value, PgTypes.uuid);
    }
    if (mediaTypeId.present) {
      map['media_type_id'] = Variable<UuidValue>(
        mediaTypeId.value,
        PgTypes.uuid,
      );
    }
    if (storageType.present) {
      map['storage_type'] = Variable<String>(
        $MediaFilesTable.$converterstorageType.toSql(storageType.value),
      );
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (originalFilename.present) {
      map['original_filename'] = Variable<String>(originalFilename.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<BigInt>(fileSizeBytes.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<Object>(metadata.value, PgTypes.jsonb);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<PgDateTime>(
        uploadedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaFilesCompanion(')
          ..write('id: $id, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('mediaTypeId: $mediaTypeId, ')
          ..write('storageType: $storageType, ')
          ..write('storagePath: $storagePath, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('originalFilename: $originalFilename, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('metadata: $metadata, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CaptionTemplatesTable extends CaptionTemplates
    with TableInfo<$CaptionTemplatesTable, CaptionTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaptionTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<UuidValue> ownerId = GeneratedColumn<UuidValue>(
    'owner_id',
    aliasedName,
    true,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _variablesMeta = const VerificationMeta(
    'variables',
  );
  @override
  late final GeneratedColumn<Object> variables = GeneratedColumn<Object>(
    'variables',
    aliasedName,
    false,
    type: PgTypes.jsonb,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]', PgTypes.jsonb),
  );
  static const VerificationMeta _isGlobalMeta = const VerificationMeta(
    'isGlobal',
  );
  @override
  late final GeneratedColumn<bool> isGlobal = GeneratedColumn<bool>(
    'is_global',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> updatedAt =
      GeneratedColumn<PgDateTime>(
        'updated_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    name,
    body,
    variables,
    isGlobal,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'caption_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<CaptionTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('variables')) {
      context.handle(
        _variablesMeta,
        variables.isAcceptableOrUnknown(data['variables']!, _variablesMeta),
      );
    }
    if (data.containsKey('is_global')) {
      context.handle(
        _isGlobalMeta,
        isGlobal.isAcceptableOrUnknown(data['is_global']!, _isGlobalMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaptionTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaptionTemplate(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}owner_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      variables: attachedDatabase.typeMapping.read(
        PgTypes.jsonb,
        data['${effectivePrefix}variables'],
      )!,
      isGlobal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_global'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CaptionTemplatesTable createAlias(String alias) {
    return $CaptionTemplatesTable(attachedDatabase, alias);
  }
}

class CaptionTemplate extends DataClass implements Insertable<CaptionTemplate> {
  final UuidValue id;
  final UuidValue? ownerId;
  final String name;
  final String body;
  final Object variables;
  final bool isGlobal;
  final PgDateTime createdAt;
  final PgDateTime updatedAt;
  const CaptionTemplate({
    required this.id,
    this.ownerId,
    required this.name,
    required this.body,
    required this.variables,
    required this.isGlobal,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<UuidValue>(ownerId, PgTypes.uuid);
    }
    map['name'] = Variable<String>(name);
    map['body'] = Variable<String>(body);
    map['variables'] = Variable<Object>(variables, PgTypes.jsonb);
    map['is_global'] = Variable<bool>(isGlobal);
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    map['updated_at'] = Variable<PgDateTime>(
      updatedAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  CaptionTemplatesCompanion toCompanion(bool nullToAbsent) {
    return CaptionTemplatesCompanion(
      id: Value(id),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      name: Value(name),
      body: Value(body),
      variables: Value(variables),
      isGlobal: Value(isGlobal),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CaptionTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaptionTemplate(
      id: serializer.fromJson<UuidValue>(json['id']),
      ownerId: serializer.fromJson<UuidValue?>(json['ownerId']),
      name: serializer.fromJson<String>(json['name']),
      body: serializer.fromJson<String>(json['body']),
      variables: serializer.fromJson<Object>(json['variables']),
      isGlobal: serializer.fromJson<bool>(json['isGlobal']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<PgDateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'ownerId': serializer.toJson<UuidValue?>(ownerId),
      'name': serializer.toJson<String>(name),
      'body': serializer.toJson<String>(body),
      'variables': serializer.toJson<Object>(variables),
      'isGlobal': serializer.toJson<bool>(isGlobal),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
      'updatedAt': serializer.toJson<PgDateTime>(updatedAt),
    };
  }

  CaptionTemplate copyWith({
    UuidValue? id,
    Value<UuidValue?> ownerId = const Value.absent(),
    String? name,
    String? body,
    Object? variables,
    bool? isGlobal,
    PgDateTime? createdAt,
    PgDateTime? updatedAt,
  }) => CaptionTemplate(
    id: id ?? this.id,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    name: name ?? this.name,
    body: body ?? this.body,
    variables: variables ?? this.variables,
    isGlobal: isGlobal ?? this.isGlobal,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CaptionTemplate copyWithCompanion(CaptionTemplatesCompanion data) {
    return CaptionTemplate(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      name: data.name.present ? data.name.value : this.name,
      body: data.body.present ? data.body.value : this.body,
      variables: data.variables.present ? data.variables.value : this.variables,
      isGlobal: data.isGlobal.present ? data.isGlobal.value : this.isGlobal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaptionTemplate(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('body: $body, ')
          ..write('variables: $variables, ')
          ..write('isGlobal: $isGlobal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    name,
    body,
    variables,
    isGlobal,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaptionTemplate &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.name == this.name &&
          other.body == this.body &&
          other.variables == this.variables &&
          other.isGlobal == this.isGlobal &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CaptionTemplatesCompanion extends UpdateCompanion<CaptionTemplate> {
  final Value<UuidValue> id;
  final Value<UuidValue?> ownerId;
  final Value<String> name;
  final Value<String> body;
  final Value<Object> variables;
  final Value<bool> isGlobal;
  final Value<PgDateTime> createdAt;
  final Value<PgDateTime> updatedAt;
  final Value<int> rowid;
  const CaptionTemplatesCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.name = const Value.absent(),
    this.body = const Value.absent(),
    this.variables = const Value.absent(),
    this.isGlobal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CaptionTemplatesCompanion.insert({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    required String name,
    required String body,
    this.variables = const Value.absent(),
    this.isGlobal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       body = Value(body);
  static Insertable<CaptionTemplate> custom({
    Expression<UuidValue>? id,
    Expression<UuidValue>? ownerId,
    Expression<String>? name,
    Expression<String>? body,
    Expression<Object>? variables,
    Expression<bool>? isGlobal,
    Expression<PgDateTime>? createdAt,
    Expression<PgDateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (body != null) 'body': body,
      if (variables != null) 'variables': variables,
      if (isGlobal != null) 'is_global': isGlobal,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CaptionTemplatesCompanion copyWith({
    Value<UuidValue>? id,
    Value<UuidValue?>? ownerId,
    Value<String>? name,
    Value<String>? body,
    Value<Object>? variables,
    Value<bool>? isGlobal,
    Value<PgDateTime>? createdAt,
    Value<PgDateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CaptionTemplatesCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      body: body ?? this.body,
      variables: variables ?? this.variables,
      isGlobal: isGlobal ?? this.isGlobal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<UuidValue>(ownerId.value, PgTypes.uuid);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (variables.present) {
      map['variables'] = Variable<Object>(variables.value, PgTypes.jsonb);
    }
    if (isGlobal.present) {
      map['is_global'] = Variable<bool>(isGlobal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaptionTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('body: $body, ')
          ..write('variables: $variables, ')
          ..write('isGlobal: $isGlobal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostsTable extends Posts with TableInfo<$PostsTable, Post> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<UuidValue> createdBy = GeneratedColumn<UuidValue>(
    'created_by',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _internalNoteMeta = const VerificationMeta(
    'internalNote',
  );
  @override
  late final GeneratedColumn<String> internalNote = GeneratedColumn<String>(
    'internal_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PostStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(PostStatus.draft.name),
      ).withConverter<PostStatus>($PostsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> updatedAt =
      GeneratedColumn<PgDateTime>(
        'updated_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdBy,
    internalNote,
    description,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'posts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Post> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('internal_note')) {
      context.handle(
        _internalNoteMeta,
        internalNote.isAcceptableOrUnknown(
          data['internal_note']!,
          _internalNoteMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Post map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Post(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}created_by'],
      )!,
      internalNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}internal_note'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: $PostsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PostsTable createAlias(String alias) {
    return $PostsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PostStatus, String, String> $converterstatus =
      const EnumNameConverter<PostStatus>(PostStatus.values);
}

class Post extends DataClass implements Insertable<Post> {
  final UuidValue id;
  final UuidValue createdBy;
  final String? internalNote;
  final String? description;
  final PostStatus status;
  final PgDateTime createdAt;
  final PgDateTime updatedAt;
  const Post({
    required this.id,
    required this.createdBy,
    this.internalNote,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['created_by'] = Variable<UuidValue>(createdBy, PgTypes.uuid);
    if (!nullToAbsent || internalNote != null) {
      map['internal_note'] = Variable<String>(internalNote);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['status'] = Variable<String>(
        $PostsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    map['updated_at'] = Variable<PgDateTime>(
      updatedAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  PostsCompanion toCompanion(bool nullToAbsent) {
    return PostsCompanion(
      id: Value(id),
      createdBy: Value(createdBy),
      internalNote: internalNote == null && nullToAbsent
          ? const Value.absent()
          : Value(internalNote),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Post.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Post(
      id: serializer.fromJson<UuidValue>(json['id']),
      createdBy: serializer.fromJson<UuidValue>(json['createdBy']),
      internalNote: serializer.fromJson<String?>(json['internalNote']),
      description: serializer.fromJson<String?>(json['description']),
      status: $PostsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<PgDateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'createdBy': serializer.toJson<UuidValue>(createdBy),
      'internalNote': serializer.toJson<String?>(internalNote),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(
        $PostsTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
      'updatedAt': serializer.toJson<PgDateTime>(updatedAt),
    };
  }

  Post copyWith({
    UuidValue? id,
    UuidValue? createdBy,
    Value<String?> internalNote = const Value.absent(),
    Value<String?> description = const Value.absent(),
    PostStatus? status,
    PgDateTime? createdAt,
    PgDateTime? updatedAt,
  }) => Post(
    id: id ?? this.id,
    createdBy: createdBy ?? this.createdBy,
    internalNote: internalNote.present ? internalNote.value : this.internalNote,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Post copyWithCompanion(PostsCompanion data) {
    return Post(
      id: data.id.present ? data.id.value : this.id,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      internalNote: data.internalNote.present
          ? data.internalNote.value
          : this.internalNote,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Post(')
          ..write('id: $id, ')
          ..write('createdBy: $createdBy, ')
          ..write('internalNote: $internalNote, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdBy,
    internalNote,
    description,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Post &&
          other.id == this.id &&
          other.createdBy == this.createdBy &&
          other.internalNote == this.internalNote &&
          other.description == this.description &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PostsCompanion extends UpdateCompanion<Post> {
  final Value<UuidValue> id;
  final Value<UuidValue> createdBy;
  final Value<String?> internalNote;
  final Value<String?> description;
  final Value<PostStatus> status;
  final Value<PgDateTime> createdAt;
  final Value<PgDateTime> updatedAt;
  final Value<int> rowid;
  const PostsCompanion({
    this.id = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.internalNote = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostsCompanion.insert({
    this.id = const Value.absent(),
    required UuidValue createdBy,
    this.internalNote = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdBy = Value(createdBy);
  static Insertable<Post> custom({
    Expression<UuidValue>? id,
    Expression<UuidValue>? createdBy,
    Expression<String>? internalNote,
    Expression<String>? description,
    Expression<String>? status,
    Expression<PgDateTime>? createdAt,
    Expression<PgDateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdBy != null) 'created_by': createdBy,
      if (internalNote != null) 'internal_note': internalNote,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostsCompanion copyWith({
    Value<UuidValue>? id,
    Value<UuidValue>? createdBy,
    Value<String?>? internalNote,
    Value<String?>? description,
    Value<PostStatus>? status,
    Value<PgDateTime>? createdAt,
    Value<PgDateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PostsCompanion(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      internalNote: internalNote ?? this.internalNote,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<UuidValue>(createdBy.value, PgTypes.uuid);
    }
    if (internalNote.present) {
      map['internal_note'] = Variable<String>(internalNote.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $PostsTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostsCompanion(')
          ..write('id: $id, ')
          ..write('createdBy: $createdBy, ')
          ..write('internalNote: $internalNote, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostMediaTable extends PostMedia
    with TableInfo<$PostMediaTable, PostMediaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostMediaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<UuidValue> postId = GeneratedColumn<UuidValue>(
    'post_id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES posts (id)',
    ),
  );
  static const VerificationMeta _mediaFileIdMeta = const VerificationMeta(
    'mediaFileId',
  );
  @override
  late final GeneratedColumn<UuidValue> mediaFileId =
      GeneratedColumn<UuidValue>(
        'media_file_id',
        aliasedName,
        false,
        type: PgTypes.uuid,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES media_files (id)',
        ),
      );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, postId, mediaFileId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'post_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostMediaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('media_file_id')) {
      context.handle(
        _mediaFileIdMeta,
        mediaFileId.isAcceptableOrUnknown(
          data['media_file_id']!,
          _mediaFileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mediaFileIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {postId, mediaFileId},
  ];
  @override
  PostMediaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostMediaData(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      postId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}post_id'],
      )!,
      mediaFileId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}media_file_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $PostMediaTable createAlias(String alias) {
    return $PostMediaTable(attachedDatabase, alias);
  }
}

class PostMediaData extends DataClass implements Insertable<PostMediaData> {
  final UuidValue id;
  final UuidValue postId;
  final UuidValue mediaFileId;
  final int sortOrder;
  const PostMediaData({
    required this.id,
    required this.postId,
    required this.mediaFileId,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['post_id'] = Variable<UuidValue>(postId, PgTypes.uuid);
    map['media_file_id'] = Variable<UuidValue>(mediaFileId, PgTypes.uuid);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  PostMediaCompanion toCompanion(bool nullToAbsent) {
    return PostMediaCompanion(
      id: Value(id),
      postId: Value(postId),
      mediaFileId: Value(mediaFileId),
      sortOrder: Value(sortOrder),
    );
  }

  factory PostMediaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostMediaData(
      id: serializer.fromJson<UuidValue>(json['id']),
      postId: serializer.fromJson<UuidValue>(json['postId']),
      mediaFileId: serializer.fromJson<UuidValue>(json['mediaFileId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'postId': serializer.toJson<UuidValue>(postId),
      'mediaFileId': serializer.toJson<UuidValue>(mediaFileId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  PostMediaData copyWith({
    UuidValue? id,
    UuidValue? postId,
    UuidValue? mediaFileId,
    int? sortOrder,
  }) => PostMediaData(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    mediaFileId: mediaFileId ?? this.mediaFileId,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  PostMediaData copyWithCompanion(PostMediaCompanion data) {
    return PostMediaData(
      id: data.id.present ? data.id.value : this.id,
      postId: data.postId.present ? data.postId.value : this.postId,
      mediaFileId: data.mediaFileId.present
          ? data.mediaFileId.value
          : this.mediaFileId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostMediaData(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('mediaFileId: $mediaFileId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, postId, mediaFileId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostMediaData &&
          other.id == this.id &&
          other.postId == this.postId &&
          other.mediaFileId == this.mediaFileId &&
          other.sortOrder == this.sortOrder);
}

class PostMediaCompanion extends UpdateCompanion<PostMediaData> {
  final Value<UuidValue> id;
  final Value<UuidValue> postId;
  final Value<UuidValue> mediaFileId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const PostMediaCompanion({
    this.id = const Value.absent(),
    this.postId = const Value.absent(),
    this.mediaFileId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostMediaCompanion.insert({
    this.id = const Value.absent(),
    required UuidValue postId,
    required UuidValue mediaFileId,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : postId = Value(postId),
       mediaFileId = Value(mediaFileId);
  static Insertable<PostMediaData> custom({
    Expression<UuidValue>? id,
    Expression<UuidValue>? postId,
    Expression<UuidValue>? mediaFileId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postId != null) 'post_id': postId,
      if (mediaFileId != null) 'media_file_id': mediaFileId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostMediaCompanion copyWith({
    Value<UuidValue>? id,
    Value<UuidValue>? postId,
    Value<UuidValue>? mediaFileId,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return PostMediaCompanion(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      mediaFileId: mediaFileId ?? this.mediaFileId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (postId.present) {
      map['post_id'] = Variable<UuidValue>(postId.value, PgTypes.uuid);
    }
    if (mediaFileId.present) {
      map['media_file_id'] = Variable<UuidValue>(
        mediaFileId.value,
        PgTypes.uuid,
      );
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostMediaCompanion(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('mediaFileId: $mediaFileId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostArtistsTable extends PostArtists
    with TableInfo<$PostArtistsTable, PostArtist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<UuidValue> postId = GeneratedColumn<UuidValue>(
    'post_id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES posts (id)',
    ),
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<UuidValue> artistId = GeneratedColumn<UuidValue>(
    'artist_id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES artists (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [postId, artistId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'post_artists';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostArtist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {postId, artistId};
  @override
  PostArtist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostArtist(
      postId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}post_id'],
      )!,
      artistId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}artist_id'],
      )!,
    );
  }

  @override
  $PostArtistsTable createAlias(String alias) {
    return $PostArtistsTable(attachedDatabase, alias);
  }
}

class PostArtist extends DataClass implements Insertable<PostArtist> {
  final UuidValue postId;
  final UuidValue artistId;
  const PostArtist({required this.postId, required this.artistId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['post_id'] = Variable<UuidValue>(postId, PgTypes.uuid);
    map['artist_id'] = Variable<UuidValue>(artistId, PgTypes.uuid);
    return map;
  }

  PostArtistsCompanion toCompanion(bool nullToAbsent) {
    return PostArtistsCompanion(
      postId: Value(postId),
      artistId: Value(artistId),
    );
  }

  factory PostArtist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostArtist(
      postId: serializer.fromJson<UuidValue>(json['postId']),
      artistId: serializer.fromJson<UuidValue>(json['artistId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'postId': serializer.toJson<UuidValue>(postId),
      'artistId': serializer.toJson<UuidValue>(artistId),
    };
  }

  PostArtist copyWith({UuidValue? postId, UuidValue? artistId}) => PostArtist(
    postId: postId ?? this.postId,
    artistId: artistId ?? this.artistId,
  );
  PostArtist copyWithCompanion(PostArtistsCompanion data) {
    return PostArtist(
      postId: data.postId.present ? data.postId.value : this.postId,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostArtist(')
          ..write('postId: $postId, ')
          ..write('artistId: $artistId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(postId, artistId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostArtist &&
          other.postId == this.postId &&
          other.artistId == this.artistId);
}

class PostArtistsCompanion extends UpdateCompanion<PostArtist> {
  final Value<UuidValue> postId;
  final Value<UuidValue> artistId;
  final Value<int> rowid;
  const PostArtistsCompanion({
    this.postId = const Value.absent(),
    this.artistId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostArtistsCompanion.insert({
    required UuidValue postId,
    required UuidValue artistId,
    this.rowid = const Value.absent(),
  }) : postId = Value(postId),
       artistId = Value(artistId);
  static Insertable<PostArtist> custom({
    Expression<UuidValue>? postId,
    Expression<UuidValue>? artistId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (postId != null) 'post_id': postId,
      if (artistId != null) 'artist_id': artistId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostArtistsCompanion copyWith({
    Value<UuidValue>? postId,
    Value<UuidValue>? artistId,
    Value<int>? rowid,
  }) {
    return PostArtistsCompanion(
      postId: postId ?? this.postId,
      artistId: artistId ?? this.artistId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (postId.present) {
      map['post_id'] = Variable<UuidValue>(postId.value, PgTypes.uuid);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<UuidValue>(artistId.value, PgTypes.uuid);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostArtistsCompanion(')
          ..write('postId: $postId, ')
          ..write('artistId: $artistId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostCharactersTable extends PostCharacters
    with TableInfo<$PostCharactersTable, PostCharacter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostCharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<UuidValue> postId = GeneratedColumn<UuidValue>(
    'post_id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES posts (id)',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<UuidValue> characterId =
      GeneratedColumn<UuidValue>(
        'character_id',
        aliasedName,
        false,
        type: PgTypes.uuid,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES characters (id)',
        ),
      );
  static const VerificationMeta _contextFranchiseIdMeta =
      const VerificationMeta('contextFranchiseId');
  @override
  late final GeneratedColumn<UuidValue> contextFranchiseId =
      GeneratedColumn<UuidValue>(
        'context_franchise_id',
        aliasedName,
        true,
        type: PgTypes.uuid,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES franchises (id)',
        ),
      );
  @override
  List<GeneratedColumn> get $columns => [
    postId,
    characterId,
    contextFranchiseId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'post_characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostCharacter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('context_franchise_id')) {
      context.handle(
        _contextFranchiseIdMeta,
        contextFranchiseId.isAcceptableOrUnknown(
          data['context_franchise_id']!,
          _contextFranchiseIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {postId, characterId};
  @override
  PostCharacter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostCharacter(
      postId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}post_id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}character_id'],
      )!,
      contextFranchiseId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}context_franchise_id'],
      ),
    );
  }

  @override
  $PostCharactersTable createAlias(String alias) {
    return $PostCharactersTable(attachedDatabase, alias);
  }
}

class PostCharacter extends DataClass implements Insertable<PostCharacter> {
  final UuidValue postId;
  final UuidValue characterId;
  final UuidValue? contextFranchiseId;
  const PostCharacter({
    required this.postId,
    required this.characterId,
    this.contextFranchiseId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['post_id'] = Variable<UuidValue>(postId, PgTypes.uuid);
    map['character_id'] = Variable<UuidValue>(characterId, PgTypes.uuid);
    if (!nullToAbsent || contextFranchiseId != null) {
      map['context_franchise_id'] = Variable<UuidValue>(
        contextFranchiseId,
        PgTypes.uuid,
      );
    }
    return map;
  }

  PostCharactersCompanion toCompanion(bool nullToAbsent) {
    return PostCharactersCompanion(
      postId: Value(postId),
      characterId: Value(characterId),
      contextFranchiseId: contextFranchiseId == null && nullToAbsent
          ? const Value.absent()
          : Value(contextFranchiseId),
    );
  }

  factory PostCharacter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostCharacter(
      postId: serializer.fromJson<UuidValue>(json['postId']),
      characterId: serializer.fromJson<UuidValue>(json['characterId']),
      contextFranchiseId: serializer.fromJson<UuidValue?>(
        json['contextFranchiseId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'postId': serializer.toJson<UuidValue>(postId),
      'characterId': serializer.toJson<UuidValue>(characterId),
      'contextFranchiseId': serializer.toJson<UuidValue?>(contextFranchiseId),
    };
  }

  PostCharacter copyWith({
    UuidValue? postId,
    UuidValue? characterId,
    Value<UuidValue?> contextFranchiseId = const Value.absent(),
  }) => PostCharacter(
    postId: postId ?? this.postId,
    characterId: characterId ?? this.characterId,
    contextFranchiseId: contextFranchiseId.present
        ? contextFranchiseId.value
        : this.contextFranchiseId,
  );
  PostCharacter copyWithCompanion(PostCharactersCompanion data) {
    return PostCharacter(
      postId: data.postId.present ? data.postId.value : this.postId,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      contextFranchiseId: data.contextFranchiseId.present
          ? data.contextFranchiseId.value
          : this.contextFranchiseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostCharacter(')
          ..write('postId: $postId, ')
          ..write('characterId: $characterId, ')
          ..write('contextFranchiseId: $contextFranchiseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(postId, characterId, contextFranchiseId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostCharacter &&
          other.postId == this.postId &&
          other.characterId == this.characterId &&
          other.contextFranchiseId == this.contextFranchiseId);
}

class PostCharactersCompanion extends UpdateCompanion<PostCharacter> {
  final Value<UuidValue> postId;
  final Value<UuidValue> characterId;
  final Value<UuidValue?> contextFranchiseId;
  final Value<int> rowid;
  const PostCharactersCompanion({
    this.postId = const Value.absent(),
    this.characterId = const Value.absent(),
    this.contextFranchiseId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostCharactersCompanion.insert({
    required UuidValue postId,
    required UuidValue characterId,
    this.contextFranchiseId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : postId = Value(postId),
       characterId = Value(characterId);
  static Insertable<PostCharacter> custom({
    Expression<UuidValue>? postId,
    Expression<UuidValue>? characterId,
    Expression<UuidValue>? contextFranchiseId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (postId != null) 'post_id': postId,
      if (characterId != null) 'character_id': characterId,
      if (contextFranchiseId != null)
        'context_franchise_id': contextFranchiseId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostCharactersCompanion copyWith({
    Value<UuidValue>? postId,
    Value<UuidValue>? characterId,
    Value<UuidValue?>? contextFranchiseId,
    Value<int>? rowid,
  }) {
    return PostCharactersCompanion(
      postId: postId ?? this.postId,
      characterId: characterId ?? this.characterId,
      contextFranchiseId: contextFranchiseId ?? this.contextFranchiseId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (postId.present) {
      map['post_id'] = Variable<UuidValue>(postId.value, PgTypes.uuid);
    }
    if (characterId.present) {
      map['character_id'] = Variable<UuidValue>(
        characterId.value,
        PgTypes.uuid,
      );
    }
    if (contextFranchiseId.present) {
      map['context_franchise_id'] = Variable<UuidValue>(
        contextFranchiseId.value,
        PgTypes.uuid,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostCharactersCompanion(')
          ..write('postId: $postId, ')
          ..write('characterId: $characterId, ')
          ..write('contextFranchiseId: $contextFranchiseId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostSchedulesTable extends PostSchedules
    with TableInfo<$PostSchedulesTable, PostSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<UuidValue> postId = GeneratedColumn<UuidValue>(
    'post_id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES posts (id)',
    ),
  );
  static const VerificationMeta _socialAccountTargetIdMeta =
      const VerificationMeta('socialAccountTargetId');
  @override
  late final GeneratedColumn<UuidValue> socialAccountTargetId =
      GeneratedColumn<UuidValue>(
        'social_account_target_id',
        aliasedName,
        false,
        type: PgTypes.uuid,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES social_account_targets (id)',
        ),
      );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> scheduledAt =
      GeneratedColumn<PgDateTime>(
        'scheduled_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<ScheduleStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(ScheduleStatus.pending.name),
      ).withConverter<ScheduleStatus>($PostSchedulesTable.$converterstatus);
  static const VerificationMeta _externalPostIdMeta = const VerificationMeta(
    'externalPostId',
  );
  @override
  late final GeneratedColumn<String> externalPostId = GeneratedColumn<String>(
    'external_post_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> publishedAt =
      GeneratedColumn<PgDateTime>(
        'published_at',
        aliasedName,
        true,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>(
        'created_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<PgDateTime> updatedAt =
      GeneratedColumn<PgDateTime>(
        'updated_at',
        aliasedName,
        false,
        type: PgTypes.timestampWithTimezone,
        requiredDuringInsert: false,
        defaultValue: now(),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    postId,
    socialAccountTargetId,
    scheduledAt,
    status,
    externalPostId,
    publishedAt,
    errorMessage,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'post_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostSchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('post_id')) {
      context.handle(
        _postIdMeta,
        postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta),
      );
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('social_account_target_id')) {
      context.handle(
        _socialAccountTargetIdMeta,
        socialAccountTargetId.isAcceptableOrUnknown(
          data['social_account_target_id']!,
          _socialAccountTargetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_socialAccountTargetIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('external_post_id')) {
      context.handle(
        _externalPostIdMeta,
        externalPostId.isAcceptableOrUnknown(
          data['external_post_id']!,
          _externalPostIdMeta,
        ),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostSchedule(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      postId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}post_id'],
      )!,
      socialAccountTargetId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}social_account_target_id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}scheduled_at'],
      )!,
      status: $PostSchedulesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      externalPostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_post_id'],
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}published_at'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        PgTypes.timestampWithTimezone,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PostSchedulesTable createAlias(String alias) {
    return $PostSchedulesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ScheduleStatus, String, String> $converterstatus =
      const EnumNameConverter<ScheduleStatus>(ScheduleStatus.values);
}

class PostSchedule extends DataClass implements Insertable<PostSchedule> {
  final UuidValue id;
  final UuidValue postId;
  final UuidValue socialAccountTargetId;
  final PgDateTime scheduledAt;
  final ScheduleStatus status;
  final String? externalPostId;
  final PgDateTime? publishedAt;
  final String? errorMessage;
  final PgDateTime createdAt;
  final PgDateTime updatedAt;
  const PostSchedule({
    required this.id,
    required this.postId,
    required this.socialAccountTargetId,
    required this.scheduledAt,
    required this.status,
    this.externalPostId,
    this.publishedAt,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['post_id'] = Variable<UuidValue>(postId, PgTypes.uuid);
    map['social_account_target_id'] = Variable<UuidValue>(
      socialAccountTargetId,
      PgTypes.uuid,
    );
    map['scheduled_at'] = Variable<PgDateTime>(
      scheduledAt,
      PgTypes.timestampWithTimezone,
    );
    {
      map['status'] = Variable<String>(
        $PostSchedulesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || externalPostId != null) {
      map['external_post_id'] = Variable<String>(externalPostId);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<PgDateTime>(
        publishedAt,
        PgTypes.timestampWithTimezone,
      );
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<PgDateTime>(
      createdAt,
      PgTypes.timestampWithTimezone,
    );
    map['updated_at'] = Variable<PgDateTime>(
      updatedAt,
      PgTypes.timestampWithTimezone,
    );
    return map;
  }

  PostSchedulesCompanion toCompanion(bool nullToAbsent) {
    return PostSchedulesCompanion(
      id: Value(id),
      postId: Value(postId),
      socialAccountTargetId: Value(socialAccountTargetId),
      scheduledAt: Value(scheduledAt),
      status: Value(status),
      externalPostId: externalPostId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalPostId),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PostSchedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostSchedule(
      id: serializer.fromJson<UuidValue>(json['id']),
      postId: serializer.fromJson<UuidValue>(json['postId']),
      socialAccountTargetId: serializer.fromJson<UuidValue>(
        json['socialAccountTargetId'],
      ),
      scheduledAt: serializer.fromJson<PgDateTime>(json['scheduledAt']),
      status: $PostSchedulesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      externalPostId: serializer.fromJson<String?>(json['externalPostId']),
      publishedAt: serializer.fromJson<PgDateTime?>(json['publishedAt']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<PgDateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'postId': serializer.toJson<UuidValue>(postId),
      'socialAccountTargetId': serializer.toJson<UuidValue>(
        socialAccountTargetId,
      ),
      'scheduledAt': serializer.toJson<PgDateTime>(scheduledAt),
      'status': serializer.toJson<String>(
        $PostSchedulesTable.$converterstatus.toJson(status),
      ),
      'externalPostId': serializer.toJson<String?>(externalPostId),
      'publishedAt': serializer.toJson<PgDateTime?>(publishedAt),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
      'updatedAt': serializer.toJson<PgDateTime>(updatedAt),
    };
  }

  PostSchedule copyWith({
    UuidValue? id,
    UuidValue? postId,
    UuidValue? socialAccountTargetId,
    PgDateTime? scheduledAt,
    ScheduleStatus? status,
    Value<String?> externalPostId = const Value.absent(),
    Value<PgDateTime?> publishedAt = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    PgDateTime? createdAt,
    PgDateTime? updatedAt,
  }) => PostSchedule(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    socialAccountTargetId: socialAccountTargetId ?? this.socialAccountTargetId,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    status: status ?? this.status,
    externalPostId: externalPostId.present
        ? externalPostId.value
        : this.externalPostId,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PostSchedule copyWithCompanion(PostSchedulesCompanion data) {
    return PostSchedule(
      id: data.id.present ? data.id.value : this.id,
      postId: data.postId.present ? data.postId.value : this.postId,
      socialAccountTargetId: data.socialAccountTargetId.present
          ? data.socialAccountTargetId.value
          : this.socialAccountTargetId,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      status: data.status.present ? data.status.value : this.status,
      externalPostId: data.externalPostId.present
          ? data.externalPostId.value
          : this.externalPostId,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostSchedule(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('socialAccountTargetId: $socialAccountTargetId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('externalPostId: $externalPostId, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    postId,
    socialAccountTargetId,
    scheduledAt,
    status,
    externalPostId,
    publishedAt,
    errorMessage,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostSchedule &&
          other.id == this.id &&
          other.postId == this.postId &&
          other.socialAccountTargetId == this.socialAccountTargetId &&
          other.scheduledAt == this.scheduledAt &&
          other.status == this.status &&
          other.externalPostId == this.externalPostId &&
          other.publishedAt == this.publishedAt &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PostSchedulesCompanion extends UpdateCompanion<PostSchedule> {
  final Value<UuidValue> id;
  final Value<UuidValue> postId;
  final Value<UuidValue> socialAccountTargetId;
  final Value<PgDateTime> scheduledAt;
  final Value<ScheduleStatus> status;
  final Value<String?> externalPostId;
  final Value<PgDateTime?> publishedAt;
  final Value<String?> errorMessage;
  final Value<PgDateTime> createdAt;
  final Value<PgDateTime> updatedAt;
  final Value<int> rowid;
  const PostSchedulesCompanion({
    this.id = const Value.absent(),
    this.postId = const Value.absent(),
    this.socialAccountTargetId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.status = const Value.absent(),
    this.externalPostId = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostSchedulesCompanion.insert({
    this.id = const Value.absent(),
    required UuidValue postId,
    required UuidValue socialAccountTargetId,
    required PgDateTime scheduledAt,
    this.status = const Value.absent(),
    this.externalPostId = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : postId = Value(postId),
       socialAccountTargetId = Value(socialAccountTargetId),
       scheduledAt = Value(scheduledAt);
  static Insertable<PostSchedule> custom({
    Expression<UuidValue>? id,
    Expression<UuidValue>? postId,
    Expression<UuidValue>? socialAccountTargetId,
    Expression<PgDateTime>? scheduledAt,
    Expression<String>? status,
    Expression<String>? externalPostId,
    Expression<PgDateTime>? publishedAt,
    Expression<String>? errorMessage,
    Expression<PgDateTime>? createdAt,
    Expression<PgDateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postId != null) 'post_id': postId,
      if (socialAccountTargetId != null)
        'social_account_target_id': socialAccountTargetId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (status != null) 'status': status,
      if (externalPostId != null) 'external_post_id': externalPostId,
      if (publishedAt != null) 'published_at': publishedAt,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostSchedulesCompanion copyWith({
    Value<UuidValue>? id,
    Value<UuidValue>? postId,
    Value<UuidValue>? socialAccountTargetId,
    Value<PgDateTime>? scheduledAt,
    Value<ScheduleStatus>? status,
    Value<String?>? externalPostId,
    Value<PgDateTime?>? publishedAt,
    Value<String?>? errorMessage,
    Value<PgDateTime>? createdAt,
    Value<PgDateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PostSchedulesCompanion(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      socialAccountTargetId:
          socialAccountTargetId ?? this.socialAccountTargetId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      externalPostId: externalPostId ?? this.externalPostId,
      publishedAt: publishedAt ?? this.publishedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (postId.present) {
      map['post_id'] = Variable<UuidValue>(postId.value, PgTypes.uuid);
    }
    if (socialAccountTargetId.present) {
      map['social_account_target_id'] = Variable<UuidValue>(
        socialAccountTargetId.value,
        PgTypes.uuid,
      );
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<PgDateTime>(
        scheduledAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $PostSchedulesTable.$converterstatus.toSql(status.value),
      );
    }
    if (externalPostId.present) {
      map['external_post_id'] = Variable<String>(externalPostId.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<PgDateTime>(
        publishedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<PgDateTime>(
        createdAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<PgDateTime>(
        updatedAt.value,
        PgTypes.timestampWithTimezone,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('socialAccountTargetId: $socialAccountTargetId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('externalPostId: $externalPostId, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostCaptionsTable extends PostCaptions
    with TableInfo<$PostCaptionsTable, PostCaption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostCaptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<UuidValue> id = GeneratedColumn<UuidValue>(
    'id',
    aliasedName,
    false,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultValue: genRandomUuid(),
  );
  static const VerificationMeta _postScheduleIdMeta = const VerificationMeta(
    'postScheduleId',
  );
  @override
  late final GeneratedColumn<UuidValue> postScheduleId =
      GeneratedColumn<UuidValue>(
        'post_schedule_id',
        aliasedName,
        false,
        type: PgTypes.uuid,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES post_schedules (id)',
        ),
      );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<UuidValue> templateId = GeneratedColumn<UuidValue>(
    'template_id',
    aliasedName,
    true,
    type: PgTypes.uuid,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES caption_templates (id)',
    ),
  );
  static const VerificationMeta _renderedBodyMeta = const VerificationMeta(
    'renderedBody',
  );
  @override
  late final GeneratedColumn<String> renderedBody = GeneratedColumn<String>(
    'rendered_body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _variableOverridesMeta = const VerificationMeta(
    'variableOverrides',
  );
  @override
  late final GeneratedColumn<Object> variableOverrides =
      GeneratedColumn<Object>(
        'variable_overrides',
        aliasedName,
        false,
        type: PgTypes.jsonb,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}', PgTypes.jsonb),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    postScheduleId,
    templateId,
    renderedBody,
    variableOverrides,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'post_captions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostCaption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('post_schedule_id')) {
      context.handle(
        _postScheduleIdMeta,
        postScheduleId.isAcceptableOrUnknown(
          data['post_schedule_id']!,
          _postScheduleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_postScheduleIdMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('rendered_body')) {
      context.handle(
        _renderedBodyMeta,
        renderedBody.isAcceptableOrUnknown(
          data['rendered_body']!,
          _renderedBodyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_renderedBodyMeta);
    }
    if (data.containsKey('variable_overrides')) {
      context.handle(
        _variableOverridesMeta,
        variableOverrides.isAcceptableOrUnknown(
          data['variable_overrides']!,
          _variableOverridesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {postScheduleId},
  ];
  @override
  PostCaption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostCaption(
      id: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}id'],
      )!,
      postScheduleId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}post_schedule_id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        PgTypes.uuid,
        data['${effectivePrefix}template_id'],
      ),
      renderedBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rendered_body'],
      )!,
      variableOverrides: attachedDatabase.typeMapping.read(
        PgTypes.jsonb,
        data['${effectivePrefix}variable_overrides'],
      )!,
    );
  }

  @override
  $PostCaptionsTable createAlias(String alias) {
    return $PostCaptionsTable(attachedDatabase, alias);
  }
}

class PostCaption extends DataClass implements Insertable<PostCaption> {
  final UuidValue id;
  final UuidValue postScheduleId;
  final UuidValue? templateId;
  final String renderedBody;
  final Object variableOverrides;
  const PostCaption({
    required this.id,
    required this.postScheduleId,
    this.templateId,
    required this.renderedBody,
    required this.variableOverrides,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<UuidValue>(id, PgTypes.uuid);
    map['post_schedule_id'] = Variable<UuidValue>(postScheduleId, PgTypes.uuid);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<UuidValue>(templateId, PgTypes.uuid);
    }
    map['rendered_body'] = Variable<String>(renderedBody);
    map['variable_overrides'] = Variable<Object>(
      variableOverrides,
      PgTypes.jsonb,
    );
    return map;
  }

  PostCaptionsCompanion toCompanion(bool nullToAbsent) {
    return PostCaptionsCompanion(
      id: Value(id),
      postScheduleId: Value(postScheduleId),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      renderedBody: Value(renderedBody),
      variableOverrides: Value(variableOverrides),
    );
  }

  factory PostCaption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostCaption(
      id: serializer.fromJson<UuidValue>(json['id']),
      postScheduleId: serializer.fromJson<UuidValue>(json['postScheduleId']),
      templateId: serializer.fromJson<UuidValue?>(json['templateId']),
      renderedBody: serializer.fromJson<String>(json['renderedBody']),
      variableOverrides: serializer.fromJson<Object>(json['variableOverrides']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<UuidValue>(id),
      'postScheduleId': serializer.toJson<UuidValue>(postScheduleId),
      'templateId': serializer.toJson<UuidValue?>(templateId),
      'renderedBody': serializer.toJson<String>(renderedBody),
      'variableOverrides': serializer.toJson<Object>(variableOverrides),
    };
  }

  PostCaption copyWith({
    UuidValue? id,
    UuidValue? postScheduleId,
    Value<UuidValue?> templateId = const Value.absent(),
    String? renderedBody,
    Object? variableOverrides,
  }) => PostCaption(
    id: id ?? this.id,
    postScheduleId: postScheduleId ?? this.postScheduleId,
    templateId: templateId.present ? templateId.value : this.templateId,
    renderedBody: renderedBody ?? this.renderedBody,
    variableOverrides: variableOverrides ?? this.variableOverrides,
  );
  PostCaption copyWithCompanion(PostCaptionsCompanion data) {
    return PostCaption(
      id: data.id.present ? data.id.value : this.id,
      postScheduleId: data.postScheduleId.present
          ? data.postScheduleId.value
          : this.postScheduleId,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      renderedBody: data.renderedBody.present
          ? data.renderedBody.value
          : this.renderedBody,
      variableOverrides: data.variableOverrides.present
          ? data.variableOverrides.value
          : this.variableOverrides,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostCaption(')
          ..write('id: $id, ')
          ..write('postScheduleId: $postScheduleId, ')
          ..write('templateId: $templateId, ')
          ..write('renderedBody: $renderedBody, ')
          ..write('variableOverrides: $variableOverrides')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    postScheduleId,
    templateId,
    renderedBody,
    variableOverrides,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostCaption &&
          other.id == this.id &&
          other.postScheduleId == this.postScheduleId &&
          other.templateId == this.templateId &&
          other.renderedBody == this.renderedBody &&
          other.variableOverrides == this.variableOverrides);
}

class PostCaptionsCompanion extends UpdateCompanion<PostCaption> {
  final Value<UuidValue> id;
  final Value<UuidValue> postScheduleId;
  final Value<UuidValue?> templateId;
  final Value<String> renderedBody;
  final Value<Object> variableOverrides;
  final Value<int> rowid;
  const PostCaptionsCompanion({
    this.id = const Value.absent(),
    this.postScheduleId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.renderedBody = const Value.absent(),
    this.variableOverrides = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostCaptionsCompanion.insert({
    this.id = const Value.absent(),
    required UuidValue postScheduleId,
    this.templateId = const Value.absent(),
    required String renderedBody,
    this.variableOverrides = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : postScheduleId = Value(postScheduleId),
       renderedBody = Value(renderedBody);
  static Insertable<PostCaption> custom({
    Expression<UuidValue>? id,
    Expression<UuidValue>? postScheduleId,
    Expression<UuidValue>? templateId,
    Expression<String>? renderedBody,
    Expression<Object>? variableOverrides,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postScheduleId != null) 'post_schedule_id': postScheduleId,
      if (templateId != null) 'template_id': templateId,
      if (renderedBody != null) 'rendered_body': renderedBody,
      if (variableOverrides != null) 'variable_overrides': variableOverrides,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostCaptionsCompanion copyWith({
    Value<UuidValue>? id,
    Value<UuidValue>? postScheduleId,
    Value<UuidValue?>? templateId,
    Value<String>? renderedBody,
    Value<Object>? variableOverrides,
    Value<int>? rowid,
  }) {
    return PostCaptionsCompanion(
      id: id ?? this.id,
      postScheduleId: postScheduleId ?? this.postScheduleId,
      templateId: templateId ?? this.templateId,
      renderedBody: renderedBody ?? this.renderedBody,
      variableOverrides: variableOverrides ?? this.variableOverrides,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<UuidValue>(id.value, PgTypes.uuid);
    }
    if (postScheduleId.present) {
      map['post_schedule_id'] = Variable<UuidValue>(
        postScheduleId.value,
        PgTypes.uuid,
      );
    }
    if (templateId.present) {
      map['template_id'] = Variable<UuidValue>(templateId.value, PgTypes.uuid);
    }
    if (renderedBody.present) {
      map['rendered_body'] = Variable<String>(renderedBody.value);
    }
    if (variableOverrides.present) {
      map['variable_overrides'] = Variable<Object>(
        variableOverrides.value,
        PgTypes.jsonb,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostCaptionsCompanion(')
          ..write('id: $id, ')
          ..write('postScheduleId: $postScheduleId, ')
          ..write('templateId: $templateId, ')
          ..write('renderedBody: $renderedBody, ')
          ..write('variableOverrides: $variableOverrides, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$PostflowDatabase extends GeneratedDatabase {
  _$PostflowDatabase(QueryExecutor e) : super(e);
  $PostflowDatabaseManager get managers => $PostflowDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $UserIdentitiesTable userIdentities = $UserIdentitiesTable(this);
  late final $RefreshTokensTable refreshTokens = $RefreshTokensTable(this);
  late final $SocialNetworksTable socialNetworks = $SocialNetworksTable(this);
  late final $UserSocialAccountsTable userSocialAccounts =
      $UserSocialAccountsTable(this);
  late final $SocialAccountTargetsTable socialAccountTargets =
      $SocialAccountTargetsTable(this);
  late final $ArtistsTable artists = $ArtistsTable(this);
  late final $FranchisesTable franchises = $FranchisesTable(this);
  late final $CharactersTable characters = $CharactersTable(this);
  late final $MediaTypesTable mediaTypes = $MediaTypesTable(this);
  late final $MediaFilesTable mediaFiles = $MediaFilesTable(this);
  late final $CaptionTemplatesTable captionTemplates = $CaptionTemplatesTable(
    this,
  );
  late final $PostsTable posts = $PostsTable(this);
  late final $PostMediaTable postMedia = $PostMediaTable(this);
  late final $PostArtistsTable postArtists = $PostArtistsTable(this);
  late final $PostCharactersTable postCharacters = $PostCharactersTable(this);
  late final $PostSchedulesTable postSchedules = $PostSchedulesTable(this);
  late final $PostCaptionsTable postCaptions = $PostCaptionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    userIdentities,
    refreshTokens,
    socialNetworks,
    userSocialAccounts,
    socialAccountTargets,
    artists,
    franchises,
    characters,
    mediaTypes,
    mediaFiles,
    captionTemplates,
    posts,
    postMedia,
    postArtists,
    postCharacters,
    postSchedules,
    postCaptions,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<UuidValue> id,
      required String username,
      Value<String?> email,
      Value<bool> isActive,
      Value<PgDateTime> createdAt,
      Value<PgDateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<UuidValue> id,
      Value<String> username,
      Value<String?> email,
      Value<bool> isActive,
      Value<PgDateTime> createdAt,
      Value<PgDateTime> updatedAt,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$PostflowDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserIdentitiesTable, List<UserIdentity>>
  _userIdentitiesRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.userIdentities,
        aliasName: $_aliasNameGenerator(db.users.id, db.userIdentities.userId),
      );

  $$UserIdentitiesTableProcessedTableManager get userIdentitiesRefs {
    final manager = $$UserIdentitiesTableTableManager(
      $_db,
      $_db.userIdentities,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_userIdentitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RefreshTokensTable, List<RefreshToken>>
  _refreshTokensRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.refreshTokens,
        aliasName: $_aliasNameGenerator(db.users.id, db.refreshTokens.userId),
      );

  $$RefreshTokensTableProcessedTableManager get refreshTokensRefs {
    final manager = $$RefreshTokensTableTableManager(
      $_db,
      $_db.refreshTokens,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_refreshTokensRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserSocialAccountsTable, List<UserSocialAccount>>
  _userSocialAccountsRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.userSocialAccounts,
        aliasName: $_aliasNameGenerator(
          db.users.id,
          db.userSocialAccounts.userId,
        ),
      );

  $$UserSocialAccountsTableProcessedTableManager get userSocialAccountsRefs {
    final manager = $$UserSocialAccountsTableTableManager(
      $_db,
      $_db.userSocialAccounts,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userSocialAccountsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MediaFilesTable, List<MediaFile>>
  _mediaFilesRefsTable(_$PostflowDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaFiles,
    aliasName: $_aliasNameGenerator(db.users.id, db.mediaFiles.uploadedBy),
  );

  $$MediaFilesTableProcessedTableManager get mediaFilesRefs {
    final manager = $$MediaFilesTableTableManager(
      $_db,
      $_db.mediaFiles,
    ).filter((f) => f.uploadedBy.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CaptionTemplatesTable, List<CaptionTemplate>>
  _captionTemplatesRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.captionTemplates,
        aliasName: $_aliasNameGenerator(
          db.users.id,
          db.captionTemplates.ownerId,
        ),
      );

  $$CaptionTemplatesTableProcessedTableManager get captionTemplatesRefs {
    final manager = $$CaptionTemplatesTableTableManager(
      $_db,
      $_db.captionTemplates,
    ).filter((f) => f.ownerId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _captionTemplatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PostsTable, List<Post>> _postsRefsTable(
    _$PostflowDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.posts,
    aliasName: $_aliasNameGenerator(db.users.id, db.posts.createdBy),
  );

  $$PostsTableProcessedTableManager get postsRefs {
    final manager = $$PostsTableTableManager(
      $_db,
      $_db.posts,
    ).filter((f) => f.createdBy.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_postsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer
    extends Composer<_$PostflowDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userIdentitiesRefs(
    Expression<bool> Function($$UserIdentitiesTableFilterComposer f) f,
  ) {
    final $$UserIdentitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userIdentities,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserIdentitiesTableFilterComposer(
            $db: $db,
            $table: $db.userIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> refreshTokensRefs(
    Expression<bool> Function($$RefreshTokensTableFilterComposer f) f,
  ) {
    final $$RefreshTokensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.refreshTokens,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefreshTokensTableFilterComposer(
            $db: $db,
            $table: $db.refreshTokens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> userSocialAccountsRefs(
    Expression<bool> Function($$UserSocialAccountsTableFilterComposer f) f,
  ) {
    final $$UserSocialAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userSocialAccounts,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserSocialAccountsTableFilterComposer(
            $db: $db,
            $table: $db.userSocialAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mediaFilesRefs(
    Expression<bool> Function($$MediaFilesTableFilterComposer f) f,
  ) {
    final $$MediaFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.uploadedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableFilterComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> captionTemplatesRefs(
    Expression<bool> Function($$CaptionTemplatesTableFilterComposer f) f,
  ) {
    final $$CaptionTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.captionTemplates,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaptionTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.captionTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> postsRefs(
    Expression<bool> Function($$PostsTableFilterComposer f) f,
  ) {
    final $$PostsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.createdBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableFilterComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$PostflowDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<PgDateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> userIdentitiesRefs<T extends Object>(
    Expression<T> Function($$UserIdentitiesTableAnnotationComposer a) f,
  ) {
    final $$UserIdentitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userIdentities,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserIdentitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.userIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> refreshTokensRefs<T extends Object>(
    Expression<T> Function($$RefreshTokensTableAnnotationComposer a) f,
  ) {
    final $$RefreshTokensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.refreshTokens,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefreshTokensTableAnnotationComposer(
            $db: $db,
            $table: $db.refreshTokens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> userSocialAccountsRefs<T extends Object>(
    Expression<T> Function($$UserSocialAccountsTableAnnotationComposer a) f,
  ) {
    final $$UserSocialAccountsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.userSocialAccounts,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserSocialAccountsTableAnnotationComposer(
                $db: $db,
                $table: $db.userSocialAccounts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> mediaFilesRefs<T extends Object>(
    Expression<T> Function($$MediaFilesTableAnnotationComposer a) f,
  ) {
    final $$MediaFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.uploadedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> captionTemplatesRefs<T extends Object>(
    Expression<T> Function($$CaptionTemplatesTableAnnotationComposer a) f,
  ) {
    final $$CaptionTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.captionTemplates,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaptionTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.captionTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> postsRefs<T extends Object>(
    Expression<T> Function($$PostsTableAnnotationComposer a) f,
  ) {
    final $$PostsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.createdBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableAnnotationComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({
            bool userIdentitiesRefs,
            bool refreshTokensRefs,
            bool userSocialAccountsRefs,
            bool mediaFilesRefs,
            bool captionTemplatesRefs,
            bool postsRefs,
          })
        > {
  $$UsersTableTableManager(_$PostflowDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                email: email,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required String username,
                Value<String?> email = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                email: email,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userIdentitiesRefs = false,
                refreshTokensRefs = false,
                userSocialAccountsRefs = false,
                mediaFilesRefs = false,
                captionTemplatesRefs = false,
                postsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (userIdentitiesRefs) db.userIdentities,
                    if (refreshTokensRefs) db.refreshTokens,
                    if (userSocialAccountsRefs) db.userSocialAccounts,
                    if (mediaFilesRefs) db.mediaFiles,
                    if (captionTemplatesRefs) db.captionTemplates,
                    if (postsRefs) db.posts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (userIdentitiesRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          UserIdentity
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._userIdentitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).userIdentitiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (refreshTokensRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          RefreshToken
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._refreshTokensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).refreshTokensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (userSocialAccountsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          UserSocialAccount
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._userSocialAccountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).userSocialAccountsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mediaFilesRefs)
                        await $_getPrefetchedData<User, $UsersTable, MediaFile>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._mediaFilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).mediaFilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.uploadedBy == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (captionTemplatesRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          CaptionTemplate
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._captionTemplatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).captionTemplatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ownerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (postsRefs)
                        await $_getPrefetchedData<User, $UsersTable, Post>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._postsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(db, table, p0).postsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.createdBy == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({
        bool userIdentitiesRefs,
        bool refreshTokensRefs,
        bool userSocialAccountsRefs,
        bool mediaFilesRefs,
        bool captionTemplatesRefs,
        bool postsRefs,
      })
    >;
typedef $$UserIdentitiesTableCreateCompanionBuilder =
    UserIdentitiesCompanion Function({
      Value<UuidValue> id,
      required UuidValue userId,
      required IdentityProvider provider,
      Value<String?> providerSubject,
      Value<String?> passwordHash,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });
typedef $$UserIdentitiesTableUpdateCompanionBuilder =
    UserIdentitiesCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue> userId,
      Value<IdentityProvider> provider,
      Value<String?> providerSubject,
      Value<String?> passwordHash,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });

final class $$UserIdentitiesTableReferences
    extends
        BaseReferences<_$PostflowDatabase, $UserIdentitiesTable, UserIdentity> {
  $$UserIdentitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$PostflowDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.userIdentities.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<UuidValue>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserIdentitiesTableFilterComposer
    extends Composer<_$PostflowDatabase, $UserIdentitiesTable> {
  $$UserIdentitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IdentityProvider, IdentityProvider, String>
  get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get providerSubject => $composableBuilder(
    column: $table.providerSubject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserIdentitiesTableOrderingComposer
    extends Composer<_$PostflowDatabase, $UserIdentitiesTable> {
  $$UserIdentitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerSubject => $composableBuilder(
    column: $table.providerSubject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserIdentitiesTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $UserIdentitiesTable> {
  $$UserIdentitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IdentityProvider, String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get providerSubject => $composableBuilder(
    column: $table.providerSubject,
    builder: (column) => column,
  );

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserIdentitiesTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $UserIdentitiesTable,
          UserIdentity,
          $$UserIdentitiesTableFilterComposer,
          $$UserIdentitiesTableOrderingComposer,
          $$UserIdentitiesTableAnnotationComposer,
          $$UserIdentitiesTableCreateCompanionBuilder,
          $$UserIdentitiesTableUpdateCompanionBuilder,
          (UserIdentity, $$UserIdentitiesTableReferences),
          UserIdentity,
          PrefetchHooks Function({bool userId})
        > {
  $$UserIdentitiesTableTableManager(
    _$PostflowDatabase db,
    $UserIdentitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserIdentitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserIdentitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserIdentitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue> userId = const Value.absent(),
                Value<IdentityProvider> provider = const Value.absent(),
                Value<String?> providerSubject = const Value.absent(),
                Value<String?> passwordHash = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserIdentitiesCompanion(
                id: id,
                userId: userId,
                provider: provider,
                providerSubject: providerSubject,
                passwordHash: passwordHash,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required UuidValue userId,
                required IdentityProvider provider,
                Value<String?> providerSubject = const Value.absent(),
                Value<String?> passwordHash = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserIdentitiesCompanion.insert(
                id: id,
                userId: userId,
                provider: provider,
                providerSubject: providerSubject,
                passwordHash: passwordHash,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserIdentitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$UserIdentitiesTableReferences
                                    ._userIdTable(db),
                                referencedColumn:
                                    $$UserIdentitiesTableReferences
                                        ._userIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserIdentitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $UserIdentitiesTable,
      UserIdentity,
      $$UserIdentitiesTableFilterComposer,
      $$UserIdentitiesTableOrderingComposer,
      $$UserIdentitiesTableAnnotationComposer,
      $$UserIdentitiesTableCreateCompanionBuilder,
      $$UserIdentitiesTableUpdateCompanionBuilder,
      (UserIdentity, $$UserIdentitiesTableReferences),
      UserIdentity,
      PrefetchHooks Function({bool userId})
    >;
typedef $$RefreshTokensTableCreateCompanionBuilder =
    RefreshTokensCompanion Function({
      Value<UuidValue> id,
      required UuidValue userId,
      required String tokenHash,
      required PgDateTime expiresAt,
      Value<PgDateTime?> revokedAt,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });
typedef $$RefreshTokensTableUpdateCompanionBuilder =
    RefreshTokensCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue> userId,
      Value<String> tokenHash,
      Value<PgDateTime> expiresAt,
      Value<PgDateTime?> revokedAt,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });

final class $$RefreshTokensTableReferences
    extends
        BaseReferences<_$PostflowDatabase, $RefreshTokensTable, RefreshToken> {
  $$RefreshTokensTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$PostflowDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.refreshTokens.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<UuidValue>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RefreshTokensTableFilterComposer
    extends Composer<_$PostflowDatabase, $RefreshTokensTable> {
  $$RefreshTokensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefreshTokensTableOrderingComposer
    extends Composer<_$PostflowDatabase, $RefreshTokensTable> {
  $$RefreshTokensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefreshTokensTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $RefreshTokensTable> {
  $$RefreshTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokenHash =>
      $composableBuilder(column: $table.tokenHash, builder: (column) => column);

  GeneratedColumn<PgDateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<PgDateTime> get revokedAt =>
      $composableBuilder(column: $table.revokedAt, builder: (column) => column);

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefreshTokensTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $RefreshTokensTable,
          RefreshToken,
          $$RefreshTokensTableFilterComposer,
          $$RefreshTokensTableOrderingComposer,
          $$RefreshTokensTableAnnotationComposer,
          $$RefreshTokensTableCreateCompanionBuilder,
          $$RefreshTokensTableUpdateCompanionBuilder,
          (RefreshToken, $$RefreshTokensTableReferences),
          RefreshToken,
          PrefetchHooks Function({bool userId})
        > {
  $$RefreshTokensTableTableManager(
    _$PostflowDatabase db,
    $RefreshTokensTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RefreshTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RefreshTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RefreshTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue> userId = const Value.absent(),
                Value<String> tokenHash = const Value.absent(),
                Value<PgDateTime> expiresAt = const Value.absent(),
                Value<PgDateTime?> revokedAt = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RefreshTokensCompanion(
                id: id,
                userId: userId,
                tokenHash: tokenHash,
                expiresAt: expiresAt,
                revokedAt: revokedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required UuidValue userId,
                required String tokenHash,
                required PgDateTime expiresAt,
                Value<PgDateTime?> revokedAt = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RefreshTokensCompanion.insert(
                id: id,
                userId: userId,
                tokenHash: tokenHash,
                expiresAt: expiresAt,
                revokedAt: revokedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RefreshTokensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$RefreshTokensTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$RefreshTokensTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RefreshTokensTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $RefreshTokensTable,
      RefreshToken,
      $$RefreshTokensTableFilterComposer,
      $$RefreshTokensTableOrderingComposer,
      $$RefreshTokensTableAnnotationComposer,
      $$RefreshTokensTableCreateCompanionBuilder,
      $$RefreshTokensTableUpdateCompanionBuilder,
      (RefreshToken, $$RefreshTokensTableReferences),
      RefreshToken,
      PrefetchHooks Function({bool userId})
    >;
typedef $$SocialNetworksTableCreateCompanionBuilder =
    SocialNetworksCompanion Function({
      Value<UuidValue> id,
      required String slug,
      required String displayName,
      Value<Object> data,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$SocialNetworksTableUpdateCompanionBuilder =
    SocialNetworksCompanion Function({
      Value<UuidValue> id,
      Value<String> slug,
      Value<String> displayName,
      Value<Object> data,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$SocialNetworksTableReferences
    extends
        BaseReferences<
          _$PostflowDatabase,
          $SocialNetworksTable,
          SocialNetwork
        > {
  $$SocialNetworksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$UserSocialAccountsTable, List<UserSocialAccount>>
  _userSocialAccountsRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.userSocialAccounts,
        aliasName: $_aliasNameGenerator(
          db.socialNetworks.id,
          db.userSocialAccounts.socialNetworkId,
        ),
      );

  $$UserSocialAccountsTableProcessedTableManager get userSocialAccountsRefs {
    final manager =
        $$UserSocialAccountsTableTableManager(
          $_db,
          $_db.userSocialAccounts,
        ).filter(
          (f) => f.socialNetworkId.id.sqlEquals($_itemColumn<UuidValue>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _userSocialAccountsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SocialNetworksTableFilterComposer
    extends Composer<_$PostflowDatabase, $SocialNetworksTable> {
  $$SocialNetworksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Object> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userSocialAccountsRefs(
    Expression<bool> Function($$UserSocialAccountsTableFilterComposer f) f,
  ) {
    final $$UserSocialAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userSocialAccounts,
      getReferencedColumn: (t) => t.socialNetworkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserSocialAccountsTableFilterComposer(
            $db: $db,
            $table: $db.userSocialAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SocialNetworksTableOrderingComposer
    extends Composer<_$PostflowDatabase, $SocialNetworksTable> {
  $$SocialNetworksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Object> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SocialNetworksTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $SocialNetworksTable> {
  $$SocialNetworksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<Object> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> userSocialAccountsRefs<T extends Object>(
    Expression<T> Function($$UserSocialAccountsTableAnnotationComposer a) f,
  ) {
    final $$UserSocialAccountsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.userSocialAccounts,
          getReferencedColumn: (t) => t.socialNetworkId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserSocialAccountsTableAnnotationComposer(
                $db: $db,
                $table: $db.userSocialAccounts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SocialNetworksTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $SocialNetworksTable,
          SocialNetwork,
          $$SocialNetworksTableFilterComposer,
          $$SocialNetworksTableOrderingComposer,
          $$SocialNetworksTableAnnotationComposer,
          $$SocialNetworksTableCreateCompanionBuilder,
          $$SocialNetworksTableUpdateCompanionBuilder,
          (SocialNetwork, $$SocialNetworksTableReferences),
          SocialNetwork,
          PrefetchHooks Function({bool userSocialAccountsRefs})
        > {
  $$SocialNetworksTableTableManager(
    _$PostflowDatabase db,
    $SocialNetworksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SocialNetworksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SocialNetworksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SocialNetworksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<Object> data = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SocialNetworksCompanion(
                id: id,
                slug: slug,
                displayName: displayName,
                data: data,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required String slug,
                required String displayName,
                Value<Object> data = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SocialNetworksCompanion.insert(
                id: id,
                slug: slug,
                displayName: displayName,
                data: data,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SocialNetworksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userSocialAccountsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (userSocialAccountsRefs) db.userSocialAccounts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userSocialAccountsRefs)
                    await $_getPrefetchedData<
                      SocialNetwork,
                      $SocialNetworksTable,
                      UserSocialAccount
                    >(
                      currentTable: table,
                      referencedTable: $$SocialNetworksTableReferences
                          ._userSocialAccountsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SocialNetworksTableReferences(
                            db,
                            table,
                            p0,
                          ).userSocialAccountsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.socialNetworkId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SocialNetworksTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $SocialNetworksTable,
      SocialNetwork,
      $$SocialNetworksTableFilterComposer,
      $$SocialNetworksTableOrderingComposer,
      $$SocialNetworksTableAnnotationComposer,
      $$SocialNetworksTableCreateCompanionBuilder,
      $$SocialNetworksTableUpdateCompanionBuilder,
      (SocialNetwork, $$SocialNetworksTableReferences),
      SocialNetwork,
      PrefetchHooks Function({bool userSocialAccountsRefs})
    >;
typedef $$UserSocialAccountsTableCreateCompanionBuilder =
    UserSocialAccountsCompanion Function({
      Value<UuidValue> id,
      required UuidValue userId,
      required UuidValue socialNetworkId,
      required String externalAccountId,
      Value<String?> screenName,
      Value<String?> accessToken,
      Value<String?> refreshToken,
      Value<PgDateTime?> tokenExpiresAt,
      Value<bool> isActive,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });
typedef $$UserSocialAccountsTableUpdateCompanionBuilder =
    UserSocialAccountsCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue> userId,
      Value<UuidValue> socialNetworkId,
      Value<String> externalAccountId,
      Value<String?> screenName,
      Value<String?> accessToken,
      Value<String?> refreshToken,
      Value<PgDateTime?> tokenExpiresAt,
      Value<bool> isActive,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });

final class $$UserSocialAccountsTableReferences
    extends
        BaseReferences<
          _$PostflowDatabase,
          $UserSocialAccountsTable,
          UserSocialAccount
        > {
  $$UserSocialAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$PostflowDatabase db) =>
      db.users.createAlias(
        $_aliasNameGenerator(db.userSocialAccounts.userId, db.users.id),
      );

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<UuidValue>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SocialNetworksTable _socialNetworkIdTable(_$PostflowDatabase db) =>
      db.socialNetworks.createAlias(
        $_aliasNameGenerator(
          db.userSocialAccounts.socialNetworkId,
          db.socialNetworks.id,
        ),
      );

  $$SocialNetworksTableProcessedTableManager get socialNetworkId {
    final $_column = $_itemColumn<UuidValue>('social_network_id')!;

    final manager = $$SocialNetworksTableTableManager(
      $_db,
      $_db.socialNetworks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_socialNetworkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $SocialAccountTargetsTable,
    List<SocialAccountTarget>
  >
  _socialAccountTargetsRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.socialAccountTargets,
        aliasName: $_aliasNameGenerator(
          db.userSocialAccounts.id,
          db.socialAccountTargets.userSocialAccountId,
        ),
      );

  $$SocialAccountTargetsTableProcessedTableManager
  get socialAccountTargetsRefs {
    final manager =
        $$SocialAccountTargetsTableTableManager(
          $_db,
          $_db.socialAccountTargets,
        ).filter(
          (f) => f.userSocialAccountId.id.sqlEquals(
            $_itemColumn<UuidValue>('id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _socialAccountTargetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserSocialAccountsTableFilterComposer
    extends Composer<_$PostflowDatabase, $UserSocialAccountsTable> {
  $$UserSocialAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalAccountId => $composableBuilder(
    column: $table.externalAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get screenName => $composableBuilder(
    column: $table.screenName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get tokenExpiresAt => $composableBuilder(
    column: $table.tokenExpiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SocialNetworksTableFilterComposer get socialNetworkId {
    final $$SocialNetworksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.socialNetworkId,
      referencedTable: $db.socialNetworks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SocialNetworksTableFilterComposer(
            $db: $db,
            $table: $db.socialNetworks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> socialAccountTargetsRefs(
    Expression<bool> Function($$SocialAccountTargetsTableFilterComposer f) f,
  ) {
    final $$SocialAccountTargetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.socialAccountTargets,
      getReferencedColumn: (t) => t.userSocialAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SocialAccountTargetsTableFilterComposer(
            $db: $db,
            $table: $db.socialAccountTargets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserSocialAccountsTableOrderingComposer
    extends Composer<_$PostflowDatabase, $UserSocialAccountsTable> {
  $$UserSocialAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalAccountId => $composableBuilder(
    column: $table.externalAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get screenName => $composableBuilder(
    column: $table.screenName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get tokenExpiresAt => $composableBuilder(
    column: $table.tokenExpiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SocialNetworksTableOrderingComposer get socialNetworkId {
    final $$SocialNetworksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.socialNetworkId,
      referencedTable: $db.socialNetworks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SocialNetworksTableOrderingComposer(
            $db: $db,
            $table: $db.socialNetworks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserSocialAccountsTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $UserSocialAccountsTable> {
  $$UserSocialAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get externalAccountId => $composableBuilder(
    column: $table.externalAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get screenName => $composableBuilder(
    column: $table.screenName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<PgDateTime> get tokenExpiresAt => $composableBuilder(
    column: $table.tokenExpiresAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SocialNetworksTableAnnotationComposer get socialNetworkId {
    final $$SocialNetworksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.socialNetworkId,
      referencedTable: $db.socialNetworks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SocialNetworksTableAnnotationComposer(
            $db: $db,
            $table: $db.socialNetworks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> socialAccountTargetsRefs<T extends Object>(
    Expression<T> Function($$SocialAccountTargetsTableAnnotationComposer a) f,
  ) {
    final $$SocialAccountTargetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.socialAccountTargets,
          getReferencedColumn: (t) => t.userSocialAccountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SocialAccountTargetsTableAnnotationComposer(
                $db: $db,
                $table: $db.socialAccountTargets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$UserSocialAccountsTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $UserSocialAccountsTable,
          UserSocialAccount,
          $$UserSocialAccountsTableFilterComposer,
          $$UserSocialAccountsTableOrderingComposer,
          $$UserSocialAccountsTableAnnotationComposer,
          $$UserSocialAccountsTableCreateCompanionBuilder,
          $$UserSocialAccountsTableUpdateCompanionBuilder,
          (UserSocialAccount, $$UserSocialAccountsTableReferences),
          UserSocialAccount,
          PrefetchHooks Function({
            bool userId,
            bool socialNetworkId,
            bool socialAccountTargetsRefs,
          })
        > {
  $$UserSocialAccountsTableTableManager(
    _$PostflowDatabase db,
    $UserSocialAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSocialAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSocialAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSocialAccountsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue> userId = const Value.absent(),
                Value<UuidValue> socialNetworkId = const Value.absent(),
                Value<String> externalAccountId = const Value.absent(),
                Value<String?> screenName = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                Value<PgDateTime?> tokenExpiresAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSocialAccountsCompanion(
                id: id,
                userId: userId,
                socialNetworkId: socialNetworkId,
                externalAccountId: externalAccountId,
                screenName: screenName,
                accessToken: accessToken,
                refreshToken: refreshToken,
                tokenExpiresAt: tokenExpiresAt,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required UuidValue userId,
                required UuidValue socialNetworkId,
                required String externalAccountId,
                Value<String?> screenName = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                Value<PgDateTime?> tokenExpiresAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSocialAccountsCompanion.insert(
                id: id,
                userId: userId,
                socialNetworkId: socialNetworkId,
                externalAccountId: externalAccountId,
                screenName: screenName,
                accessToken: accessToken,
                refreshToken: refreshToken,
                tokenExpiresAt: tokenExpiresAt,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserSocialAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userId = false,
                socialNetworkId = false,
                socialAccountTargetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (socialAccountTargetsRefs) db.socialAccountTargets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.userId,
                                    referencedTable:
                                        $$UserSocialAccountsTableReferences
                                            ._userIdTable(db),
                                    referencedColumn:
                                        $$UserSocialAccountsTableReferences
                                            ._userIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (socialNetworkId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.socialNetworkId,
                                    referencedTable:
                                        $$UserSocialAccountsTableReferences
                                            ._socialNetworkIdTable(db),
                                    referencedColumn:
                                        $$UserSocialAccountsTableReferences
                                            ._socialNetworkIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (socialAccountTargetsRefs)
                        await $_getPrefetchedData<
                          UserSocialAccount,
                          $UserSocialAccountsTable,
                          SocialAccountTarget
                        >(
                          currentTable: table,
                          referencedTable: $$UserSocialAccountsTableReferences
                              ._socialAccountTargetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserSocialAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).socialAccountTargetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userSocialAccountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UserSocialAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $UserSocialAccountsTable,
      UserSocialAccount,
      $$UserSocialAccountsTableFilterComposer,
      $$UserSocialAccountsTableOrderingComposer,
      $$UserSocialAccountsTableAnnotationComposer,
      $$UserSocialAccountsTableCreateCompanionBuilder,
      $$UserSocialAccountsTableUpdateCompanionBuilder,
      (UserSocialAccount, $$UserSocialAccountsTableReferences),
      UserSocialAccount,
      PrefetchHooks Function({
        bool userId,
        bool socialNetworkId,
        bool socialAccountTargetsRefs,
      })
    >;
typedef $$SocialAccountTargetsTableCreateCompanionBuilder =
    SocialAccountTargetsCompanion Function({
      Value<UuidValue> id,
      required UuidValue userSocialAccountId,
      required String targetType,
      required String targetId,
      Value<String?> targetLabel,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$SocialAccountTargetsTableUpdateCompanionBuilder =
    SocialAccountTargetsCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue> userSocialAccountId,
      Value<String> targetType,
      Value<String> targetId,
      Value<String?> targetLabel,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$SocialAccountTargetsTableReferences
    extends
        BaseReferences<
          _$PostflowDatabase,
          $SocialAccountTargetsTable,
          SocialAccountTarget
        > {
  $$SocialAccountTargetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserSocialAccountsTable _userSocialAccountIdTable(
    _$PostflowDatabase db,
  ) => db.userSocialAccounts.createAlias(
    $_aliasNameGenerator(
      db.socialAccountTargets.userSocialAccountId,
      db.userSocialAccounts.id,
    ),
  );

  $$UserSocialAccountsTableProcessedTableManager get userSocialAccountId {
    final $_column = $_itemColumn<UuidValue>('user_social_account_id')!;

    final manager = $$UserSocialAccountsTableTableManager(
      $_db,
      $_db.userSocialAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userSocialAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PostSchedulesTable, List<PostSchedule>>
  _postSchedulesRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.postSchedules,
        aliasName: $_aliasNameGenerator(
          db.socialAccountTargets.id,
          db.postSchedules.socialAccountTargetId,
        ),
      );

  $$PostSchedulesTableProcessedTableManager get postSchedulesRefs {
    final manager = $$PostSchedulesTableTableManager($_db, $_db.postSchedules)
        .filter(
          (f) => f.socialAccountTargetId.id.sqlEquals(
            $_itemColumn<UuidValue>('id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_postSchedulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SocialAccountTargetsTableFilterComposer
    extends Composer<_$PostflowDatabase, $SocialAccountTargetsTable> {
  $$SocialAccountTargetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetLabel => $composableBuilder(
    column: $table.targetLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$UserSocialAccountsTableFilterComposer get userSocialAccountId {
    final $$UserSocialAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userSocialAccountId,
      referencedTable: $db.userSocialAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserSocialAccountsTableFilterComposer(
            $db: $db,
            $table: $db.userSocialAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> postSchedulesRefs(
    Expression<bool> Function($$PostSchedulesTableFilterComposer f) f,
  ) {
    final $$PostSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postSchedules,
      getReferencedColumn: (t) => t.socialAccountTargetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.postSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SocialAccountTargetsTableOrderingComposer
    extends Composer<_$PostflowDatabase, $SocialAccountTargetsTable> {
  $$SocialAccountTargetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetLabel => $composableBuilder(
    column: $table.targetLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserSocialAccountsTableOrderingComposer get userSocialAccountId {
    final $$UserSocialAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userSocialAccountId,
      referencedTable: $db.userSocialAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserSocialAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.userSocialAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SocialAccountTargetsTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $SocialAccountTargetsTable> {
  $$SocialAccountTargetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<String> get targetLabel => $composableBuilder(
    column: $table.targetLabel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$UserSocialAccountsTableAnnotationComposer get userSocialAccountId {
    final $$UserSocialAccountsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.userSocialAccountId,
          referencedTable: $db.userSocialAccounts,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$UserSocialAccountsTableAnnotationComposer(
                $db: $db,
                $table: $db.userSocialAccounts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> postSchedulesRefs<T extends Object>(
    Expression<T> Function($$PostSchedulesTableAnnotationComposer a) f,
  ) {
    final $$PostSchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postSchedules,
      getReferencedColumn: (t) => t.socialAccountTargetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostSchedulesTableAnnotationComposer(
            $db: $db,
            $table: $db.postSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SocialAccountTargetsTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $SocialAccountTargetsTable,
          SocialAccountTarget,
          $$SocialAccountTargetsTableFilterComposer,
          $$SocialAccountTargetsTableOrderingComposer,
          $$SocialAccountTargetsTableAnnotationComposer,
          $$SocialAccountTargetsTableCreateCompanionBuilder,
          $$SocialAccountTargetsTableUpdateCompanionBuilder,
          (SocialAccountTarget, $$SocialAccountTargetsTableReferences),
          SocialAccountTarget,
          PrefetchHooks Function({
            bool userSocialAccountId,
            bool postSchedulesRefs,
          })
        > {
  $$SocialAccountTargetsTableTableManager(
    _$PostflowDatabase db,
    $SocialAccountTargetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SocialAccountTargetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SocialAccountTargetsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SocialAccountTargetsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue> userSocialAccountId = const Value.absent(),
                Value<String> targetType = const Value.absent(),
                Value<String> targetId = const Value.absent(),
                Value<String?> targetLabel = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SocialAccountTargetsCompanion(
                id: id,
                userSocialAccountId: userSocialAccountId,
                targetType: targetType,
                targetId: targetId,
                targetLabel: targetLabel,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required UuidValue userSocialAccountId,
                required String targetType,
                required String targetId,
                Value<String?> targetLabel = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SocialAccountTargetsCompanion.insert(
                id: id,
                userSocialAccountId: userSocialAccountId,
                targetType: targetType,
                targetId: targetId,
                targetLabel: targetLabel,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SocialAccountTargetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({userSocialAccountId = false, postSchedulesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (postSchedulesRefs) db.postSchedules,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userSocialAccountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.userSocialAccountId,
                                    referencedTable:
                                        $$SocialAccountTargetsTableReferences
                                            ._userSocialAccountIdTable(db),
                                    referencedColumn:
                                        $$SocialAccountTargetsTableReferences
                                            ._userSocialAccountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (postSchedulesRefs)
                        await $_getPrefetchedData<
                          SocialAccountTarget,
                          $SocialAccountTargetsTable,
                          PostSchedule
                        >(
                          currentTable: table,
                          referencedTable: $$SocialAccountTargetsTableReferences
                              ._postSchedulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SocialAccountTargetsTableReferences(
                                db,
                                table,
                                p0,
                              ).postSchedulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.socialAccountTargetId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SocialAccountTargetsTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $SocialAccountTargetsTable,
      SocialAccountTarget,
      $$SocialAccountTargetsTableFilterComposer,
      $$SocialAccountTargetsTableOrderingComposer,
      $$SocialAccountTargetsTableAnnotationComposer,
      $$SocialAccountTargetsTableCreateCompanionBuilder,
      $$SocialAccountTargetsTableUpdateCompanionBuilder,
      (SocialAccountTarget, $$SocialAccountTargetsTableReferences),
      SocialAccountTarget,
      PrefetchHooks Function({bool userSocialAccountId, bool postSchedulesRefs})
    >;
typedef $$ArtistsTableCreateCompanionBuilder =
    ArtistsCompanion Function({
      Value<UuidValue> id,
      required String name,
      Value<String?> sourceUrl,
      Value<String?> notes,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ArtistsTableUpdateCompanionBuilder =
    ArtistsCompanion Function({
      Value<UuidValue> id,
      Value<String> name,
      Value<String?> sourceUrl,
      Value<String?> notes,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });

final class $$ArtistsTableReferences
    extends BaseReferences<_$PostflowDatabase, $ArtistsTable, Artist> {
  $$ArtistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PostArtistsTable, List<PostArtist>>
  _postArtistsRefsTable(_$PostflowDatabase db) => MultiTypedResultKey.fromTable(
    db.postArtists,
    aliasName: $_aliasNameGenerator(db.artists.id, db.postArtists.artistId),
  );

  $$PostArtistsTableProcessedTableManager get postArtistsRefs {
    final manager = $$PostArtistsTableTableManager(
      $_db,
      $_db.postArtists,
    ).filter((f) => f.artistId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_postArtistsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ArtistsTableFilterComposer
    extends Composer<_$PostflowDatabase, $ArtistsTable> {
  $$ArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> postArtistsRefs(
    Expression<bool> Function($$PostArtistsTableFilterComposer f) f,
  ) {
    final $$PostArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postArtists,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostArtistsTableFilterComposer(
            $db: $db,
            $table: $db.postArtists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtistsTableOrderingComposer
    extends Composer<_$PostflowDatabase, $ArtistsTable> {
  $$ArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArtistsTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $ArtistsTable> {
  $$ArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> postArtistsRefs<T extends Object>(
    Expression<T> Function($$PostArtistsTableAnnotationComposer a) f,
  ) {
    final $$PostArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postArtists,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.postArtists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtistsTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $ArtistsTable,
          Artist,
          $$ArtistsTableFilterComposer,
          $$ArtistsTableOrderingComposer,
          $$ArtistsTableAnnotationComposer,
          $$ArtistsTableCreateCompanionBuilder,
          $$ArtistsTableUpdateCompanionBuilder,
          (Artist, $$ArtistsTableReferences),
          Artist,
          PrefetchHooks Function({bool postArtistsRefs})
        > {
  $$ArtistsTableTableManager(_$PostflowDatabase db, $ArtistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtistsCompanion(
                id: id,
                name: name,
                sourceUrl: sourceUrl,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required String name,
                Value<String?> sourceUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtistsCompanion.insert(
                id: id,
                name: name,
                sourceUrl: sourceUrl,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ArtistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({postArtistsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (postArtistsRefs) db.postArtists],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (postArtistsRefs)
                    await $_getPrefetchedData<
                      Artist,
                      $ArtistsTable,
                      PostArtist
                    >(
                      currentTable: table,
                      referencedTable: $$ArtistsTableReferences
                          ._postArtistsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ArtistsTableReferences(
                        db,
                        table,
                        p0,
                      ).postArtistsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.artistId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ArtistsTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $ArtistsTable,
      Artist,
      $$ArtistsTableFilterComposer,
      $$ArtistsTableOrderingComposer,
      $$ArtistsTableAnnotationComposer,
      $$ArtistsTableCreateCompanionBuilder,
      $$ArtistsTableUpdateCompanionBuilder,
      (Artist, $$ArtistsTableReferences),
      Artist,
      PrefetchHooks Function({bool postArtistsRefs})
    >;
typedef $$FranchisesTableCreateCompanionBuilder =
    FranchisesCompanion Function({
      Value<UuidValue> id,
      required String name,
      Value<String?> description,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });
typedef $$FranchisesTableUpdateCompanionBuilder =
    FranchisesCompanion Function({
      Value<UuidValue> id,
      Value<String> name,
      Value<String?> description,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });

final class $$FranchisesTableReferences
    extends BaseReferences<_$PostflowDatabase, $FranchisesTable, Franchise> {
  $$FranchisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CharactersTable, List<Character>>
  _charactersRefsTable(_$PostflowDatabase db) => MultiTypedResultKey.fromTable(
    db.characters,
    aliasName: $_aliasNameGenerator(
      db.franchises.id,
      db.characters.franchiseId,
    ),
  );

  $$CharactersTableProcessedTableManager get charactersRefs {
    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.franchiseId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_charactersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PostCharactersTable, List<PostCharacter>>
  _postCharactersRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.postCharacters,
        aliasName: $_aliasNameGenerator(
          db.franchises.id,
          db.postCharacters.contextFranchiseId,
        ),
      );

  $$PostCharactersTableProcessedTableManager get postCharactersRefs {
    final manager = $$PostCharactersTableTableManager($_db, $_db.postCharacters)
        .filter(
          (f) =>
              f.contextFranchiseId.id.sqlEquals($_itemColumn<UuidValue>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_postCharactersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FranchisesTableFilterComposer
    extends Composer<_$PostflowDatabase, $FranchisesTable> {
  $$FranchisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> charactersRefs(
    Expression<bool> Function($$CharactersTableFilterComposer f) f,
  ) {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.franchiseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> postCharactersRefs(
    Expression<bool> Function($$PostCharactersTableFilterComposer f) f,
  ) {
    final $$PostCharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCharacters,
      getReferencedColumn: (t) => t.contextFranchiseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostCharactersTableFilterComposer(
            $db: $db,
            $table: $db.postCharacters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FranchisesTableOrderingComposer
    extends Composer<_$PostflowDatabase, $FranchisesTable> {
  $$FranchisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FranchisesTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $FranchisesTable> {
  $$FranchisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> charactersRefs<T extends Object>(
    Expression<T> Function($$CharactersTableAnnotationComposer a) f,
  ) {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.franchiseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> postCharactersRefs<T extends Object>(
    Expression<T> Function($$PostCharactersTableAnnotationComposer a) f,
  ) {
    final $$PostCharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCharacters,
      getReferencedColumn: (t) => t.contextFranchiseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostCharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.postCharacters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FranchisesTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $FranchisesTable,
          Franchise,
          $$FranchisesTableFilterComposer,
          $$FranchisesTableOrderingComposer,
          $$FranchisesTableAnnotationComposer,
          $$FranchisesTableCreateCompanionBuilder,
          $$FranchisesTableUpdateCompanionBuilder,
          (Franchise, $$FranchisesTableReferences),
          Franchise,
          PrefetchHooks Function({bool charactersRefs, bool postCharactersRefs})
        > {
  $$FranchisesTableTableManager(_$PostflowDatabase db, $FranchisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FranchisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FranchisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FranchisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FranchisesCompanion(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FranchisesCompanion.insert(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FranchisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({charactersRefs = false, postCharactersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (charactersRefs) db.characters,
                    if (postCharactersRefs) db.postCharacters,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (charactersRefs)
                        await $_getPrefetchedData<
                          Franchise,
                          $FranchisesTable,
                          Character
                        >(
                          currentTable: table,
                          referencedTable: $$FranchisesTableReferences
                              ._charactersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FranchisesTableReferences(
                                db,
                                table,
                                p0,
                              ).charactersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.franchiseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (postCharactersRefs)
                        await $_getPrefetchedData<
                          Franchise,
                          $FranchisesTable,
                          PostCharacter
                        >(
                          currentTable: table,
                          referencedTable: $$FranchisesTableReferences
                              ._postCharactersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FranchisesTableReferences(
                                db,
                                table,
                                p0,
                              ).postCharactersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.contextFranchiseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FranchisesTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $FranchisesTable,
      Franchise,
      $$FranchisesTableFilterComposer,
      $$FranchisesTableOrderingComposer,
      $$FranchisesTableAnnotationComposer,
      $$FranchisesTableCreateCompanionBuilder,
      $$FranchisesTableUpdateCompanionBuilder,
      (Franchise, $$FranchisesTableReferences),
      Franchise,
      PrefetchHooks Function({bool charactersRefs, bool postCharactersRefs})
    >;
typedef $$CharactersTableCreateCompanionBuilder =
    CharactersCompanion Function({
      Value<UuidValue> id,
      required UuidValue franchiseId,
      required String name,
      Value<String?> description,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });
typedef $$CharactersTableUpdateCompanionBuilder =
    CharactersCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue> franchiseId,
      Value<String> name,
      Value<String?> description,
      Value<PgDateTime> createdAt,
      Value<int> rowid,
    });

final class $$CharactersTableReferences
    extends BaseReferences<_$PostflowDatabase, $CharactersTable, Character> {
  $$CharactersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FranchisesTable _franchiseIdTable(_$PostflowDatabase db) =>
      db.franchises.createAlias(
        $_aliasNameGenerator(db.characters.franchiseId, db.franchises.id),
      );

  $$FranchisesTableProcessedTableManager get franchiseId {
    final $_column = $_itemColumn<UuidValue>('franchise_id')!;

    final manager = $$FranchisesTableTableManager(
      $_db,
      $_db.franchises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_franchiseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PostCharactersTable, List<PostCharacter>>
  _postCharactersRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.postCharacters,
        aliasName: $_aliasNameGenerator(
          db.characters.id,
          db.postCharacters.characterId,
        ),
      );

  $$PostCharactersTableProcessedTableManager get postCharactersRefs {
    final manager = $$PostCharactersTableTableManager(
      $_db,
      $_db.postCharacters,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_postCharactersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CharactersTableFilterComposer
    extends Composer<_$PostflowDatabase, $CharactersTable> {
  $$CharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FranchisesTableFilterComposer get franchiseId {
    final $$FranchisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.franchiseId,
      referencedTable: $db.franchises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FranchisesTableFilterComposer(
            $db: $db,
            $table: $db.franchises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> postCharactersRefs(
    Expression<bool> Function($$PostCharactersTableFilterComposer f) f,
  ) {
    final $$PostCharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCharacters,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostCharactersTableFilterComposer(
            $db: $db,
            $table: $db.postCharacters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CharactersTableOrderingComposer
    extends Composer<_$PostflowDatabase, $CharactersTable> {
  $$CharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FranchisesTableOrderingComposer get franchiseId {
    final $$FranchisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.franchiseId,
      referencedTable: $db.franchises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FranchisesTableOrderingComposer(
            $db: $db,
            $table: $db.franchises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharactersTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $CharactersTable> {
  $$CharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$FranchisesTableAnnotationComposer get franchiseId {
    final $$FranchisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.franchiseId,
      referencedTable: $db.franchises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FranchisesTableAnnotationComposer(
            $db: $db,
            $table: $db.franchises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> postCharactersRefs<T extends Object>(
    Expression<T> Function($$PostCharactersTableAnnotationComposer a) f,
  ) {
    final $$PostCharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCharacters,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostCharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.postCharacters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CharactersTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $CharactersTable,
          Character,
          $$CharactersTableFilterComposer,
          $$CharactersTableOrderingComposer,
          $$CharactersTableAnnotationComposer,
          $$CharactersTableCreateCompanionBuilder,
          $$CharactersTableUpdateCompanionBuilder,
          (Character, $$CharactersTableReferences),
          Character,
          PrefetchHooks Function({bool franchiseId, bool postCharactersRefs})
        > {
  $$CharactersTableTableManager(_$PostflowDatabase db, $CharactersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue> franchiseId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion(
                id: id,
                franchiseId: franchiseId,
                name: name,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required UuidValue franchiseId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion.insert(
                id: id,
                franchiseId: franchiseId,
                name: name,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharactersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({franchiseId = false, postCharactersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (postCharactersRefs) db.postCharacters,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (franchiseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.franchiseId,
                                    referencedTable: $$CharactersTableReferences
                                        ._franchiseIdTable(db),
                                    referencedColumn:
                                        $$CharactersTableReferences
                                            ._franchiseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (postCharactersRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          PostCharacter
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._postCharactersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).postCharactersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $CharactersTable,
      Character,
      $$CharactersTableFilterComposer,
      $$CharactersTableOrderingComposer,
      $$CharactersTableAnnotationComposer,
      $$CharactersTableCreateCompanionBuilder,
      $$CharactersTableUpdateCompanionBuilder,
      (Character, $$CharactersTableReferences),
      Character,
      PrefetchHooks Function({bool franchiseId, bool postCharactersRefs})
    >;
typedef $$MediaTypesTableCreateCompanionBuilder =
    MediaTypesCompanion Function({
      Value<UuidValue> id,
      required String slug,
      required String displayName,
      Value<List<String>> allowedExtensions,
      Value<int> maxSizeMb,
      Value<int> rowid,
    });
typedef $$MediaTypesTableUpdateCompanionBuilder =
    MediaTypesCompanion Function({
      Value<UuidValue> id,
      Value<String> slug,
      Value<String> displayName,
      Value<List<String>> allowedExtensions,
      Value<int> maxSizeMb,
      Value<int> rowid,
    });

final class $$MediaTypesTableReferences
    extends BaseReferences<_$PostflowDatabase, $MediaTypesTable, MediaType> {
  $$MediaTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MediaFilesTable, List<MediaFile>>
  _mediaFilesRefsTable(_$PostflowDatabase db) => MultiTypedResultKey.fromTable(
    db.mediaFiles,
    aliasName: $_aliasNameGenerator(
      db.mediaTypes.id,
      db.mediaFiles.mediaTypeId,
    ),
  );

  $$MediaFilesTableProcessedTableManager get mediaFilesRefs {
    final manager = $$MediaFilesTableTableManager(
      $_db,
      $_db.mediaFiles,
    ).filter((f) => f.mediaTypeId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MediaTypesTableFilterComposer
    extends Composer<_$PostflowDatabase, $MediaTypesTable> {
  $$MediaTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<List<String>> get allowedExtensions => $composableBuilder(
    column: $table.allowedExtensions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxSizeMb => $composableBuilder(
    column: $table.maxSizeMb,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mediaFilesRefs(
    Expression<bool> Function($$MediaFilesTableFilterComposer f) f,
  ) {
    final $$MediaFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.mediaTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableFilterComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaTypesTableOrderingComposer
    extends Composer<_$PostflowDatabase, $MediaTypesTable> {
  $$MediaTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<List<String>> get allowedExtensions => $composableBuilder(
    column: $table.allowedExtensions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxSizeMb => $composableBuilder(
    column: $table.maxSizeMb,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaTypesTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $MediaTypesTable> {
  $$MediaTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<List<String>> get allowedExtensions => $composableBuilder(
    column: $table.allowedExtensions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxSizeMb =>
      $composableBuilder(column: $table.maxSizeMb, builder: (column) => column);

  Expression<T> mediaFilesRefs<T extends Object>(
    Expression<T> Function($$MediaFilesTableAnnotationComposer a) f,
  ) {
    final $$MediaFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.mediaTypeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaTypesTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $MediaTypesTable,
          MediaType,
          $$MediaTypesTableFilterComposer,
          $$MediaTypesTableOrderingComposer,
          $$MediaTypesTableAnnotationComposer,
          $$MediaTypesTableCreateCompanionBuilder,
          $$MediaTypesTableUpdateCompanionBuilder,
          (MediaType, $$MediaTypesTableReferences),
          MediaType,
          PrefetchHooks Function({bool mediaFilesRefs})
        > {
  $$MediaTypesTableTableManager(_$PostflowDatabase db, $MediaTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<List<String>> allowedExtensions = const Value.absent(),
                Value<int> maxSizeMb = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaTypesCompanion(
                id: id,
                slug: slug,
                displayName: displayName,
                allowedExtensions: allowedExtensions,
                maxSizeMb: maxSizeMb,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required String slug,
                required String displayName,
                Value<List<String>> allowedExtensions = const Value.absent(),
                Value<int> maxSizeMb = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaTypesCompanion.insert(
                id: id,
                slug: slug,
                displayName: displayName,
                allowedExtensions: allowedExtensions,
                maxSizeMb: maxSizeMb,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaTypesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mediaFilesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mediaFilesRefs) db.mediaFiles],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mediaFilesRefs)
                    await $_getPrefetchedData<
                      MediaType,
                      $MediaTypesTable,
                      MediaFile
                    >(
                      currentTable: table,
                      referencedTable: $$MediaTypesTableReferences
                          ._mediaFilesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MediaTypesTableReferences(
                            db,
                            table,
                            p0,
                          ).mediaFilesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.mediaTypeId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MediaTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $MediaTypesTable,
      MediaType,
      $$MediaTypesTableFilterComposer,
      $$MediaTypesTableOrderingComposer,
      $$MediaTypesTableAnnotationComposer,
      $$MediaTypesTableCreateCompanionBuilder,
      $$MediaTypesTableUpdateCompanionBuilder,
      (MediaType, $$MediaTypesTableReferences),
      MediaType,
      PrefetchHooks Function({bool mediaFilesRefs})
    >;
typedef $$MediaFilesTableCreateCompanionBuilder =
    MediaFilesCompanion Function({
      Value<UuidValue> id,
      required UuidValue uploadedBy,
      required UuidValue mediaTypeId,
      Value<StorageType> storageType,
      Value<String?> storagePath,
      Value<String?> sourceUrl,
      Value<String?> originalFilename,
      Value<BigInt?> fileSizeBytes,
      Value<Object> metadata,
      Value<PgDateTime> uploadedAt,
      Value<int> rowid,
    });
typedef $$MediaFilesTableUpdateCompanionBuilder =
    MediaFilesCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue> uploadedBy,
      Value<UuidValue> mediaTypeId,
      Value<StorageType> storageType,
      Value<String?> storagePath,
      Value<String?> sourceUrl,
      Value<String?> originalFilename,
      Value<BigInt?> fileSizeBytes,
      Value<Object> metadata,
      Value<PgDateTime> uploadedAt,
      Value<int> rowid,
    });

final class $$MediaFilesTableReferences
    extends BaseReferences<_$PostflowDatabase, $MediaFilesTable, MediaFile> {
  $$MediaFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _uploadedByTable(_$PostflowDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.mediaFiles.uploadedBy, db.users.id));

  $$UsersTableProcessedTableManager get uploadedBy {
    final $_column = $_itemColumn<UuidValue>('uploaded_by')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_uploadedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MediaTypesTable _mediaTypeIdTable(_$PostflowDatabase db) =>
      db.mediaTypes.createAlias(
        $_aliasNameGenerator(db.mediaFiles.mediaTypeId, db.mediaTypes.id),
      );

  $$MediaTypesTableProcessedTableManager get mediaTypeId {
    final $_column = $_itemColumn<UuidValue>('media_type_id')!;

    final manager = $$MediaTypesTableTableManager(
      $_db,
      $_db.mediaTypes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PostMediaTable, List<PostMediaData>>
  _postMediaRefsTable(_$PostflowDatabase db) => MultiTypedResultKey.fromTable(
    db.postMedia,
    aliasName: $_aliasNameGenerator(db.mediaFiles.id, db.postMedia.mediaFileId),
  );

  $$PostMediaTableProcessedTableManager get postMediaRefs {
    final manager = $$PostMediaTableTableManager(
      $_db,
      $_db.postMedia,
    ).filter((f) => f.mediaFileId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_postMediaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MediaFilesTableFilterComposer
    extends Composer<_$PostflowDatabase, $MediaFilesTable> {
  $$MediaFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StorageType, StorageType, String>
  get storageType => $composableBuilder(
    column: $table.storageType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<BigInt> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Object> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get uploadedBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploadedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaTypesTableFilterComposer get mediaTypeId {
    final $$MediaTypesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaTypeId,
      referencedTable: $db.mediaTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTypesTableFilterComposer(
            $db: $db,
            $table: $db.mediaTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> postMediaRefs(
    Expression<bool> Function($$PostMediaTableFilterComposer f) f,
  ) {
    final $$PostMediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postMedia,
      getReferencedColumn: (t) => t.mediaFileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostMediaTableFilterComposer(
            $db: $db,
            $table: $db.postMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaFilesTableOrderingComposer
    extends Composer<_$PostflowDatabase, $MediaFilesTable> {
  $$MediaFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storageType => $composableBuilder(
    column: $table.storageType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<BigInt> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Object> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get uploadedBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploadedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaTypesTableOrderingComposer get mediaTypeId {
    final $$MediaTypesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaTypeId,
      referencedTable: $db.mediaTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTypesTableOrderingComposer(
            $db: $db,
            $table: $db.mediaTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaFilesTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $MediaFilesTable> {
  $$MediaFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StorageType, String> get storageType =>
      $composableBuilder(
        column: $table.storageType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get originalFilename => $composableBuilder(
    column: $table.originalFilename,
    builder: (column) => column,
  );

  GeneratedColumn<BigInt> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<Object> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<PgDateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get uploadedBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploadedBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaTypesTableAnnotationComposer get mediaTypeId {
    final $$MediaTypesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaTypeId,
      referencedTable: $db.mediaTypes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaTypesTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaTypes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> postMediaRefs<T extends Object>(
    Expression<T> Function($$PostMediaTableAnnotationComposer a) f,
  ) {
    final $$PostMediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postMedia,
      getReferencedColumn: (t) => t.mediaFileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostMediaTableAnnotationComposer(
            $db: $db,
            $table: $db.postMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MediaFilesTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $MediaFilesTable,
          MediaFile,
          $$MediaFilesTableFilterComposer,
          $$MediaFilesTableOrderingComposer,
          $$MediaFilesTableAnnotationComposer,
          $$MediaFilesTableCreateCompanionBuilder,
          $$MediaFilesTableUpdateCompanionBuilder,
          (MediaFile, $$MediaFilesTableReferences),
          MediaFile,
          PrefetchHooks Function({
            bool uploadedBy,
            bool mediaTypeId,
            bool postMediaRefs,
          })
        > {
  $$MediaFilesTableTableManager(_$PostflowDatabase db, $MediaFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue> uploadedBy = const Value.absent(),
                Value<UuidValue> mediaTypeId = const Value.absent(),
                Value<StorageType> storageType = const Value.absent(),
                Value<String?> storagePath = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<String?> originalFilename = const Value.absent(),
                Value<BigInt?> fileSizeBytes = const Value.absent(),
                Value<Object> metadata = const Value.absent(),
                Value<PgDateTime> uploadedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaFilesCompanion(
                id: id,
                uploadedBy: uploadedBy,
                mediaTypeId: mediaTypeId,
                storageType: storageType,
                storagePath: storagePath,
                sourceUrl: sourceUrl,
                originalFilename: originalFilename,
                fileSizeBytes: fileSizeBytes,
                metadata: metadata,
                uploadedAt: uploadedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required UuidValue uploadedBy,
                required UuidValue mediaTypeId,
                Value<StorageType> storageType = const Value.absent(),
                Value<String?> storagePath = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<String?> originalFilename = const Value.absent(),
                Value<BigInt?> fileSizeBytes = const Value.absent(),
                Value<Object> metadata = const Value.absent(),
                Value<PgDateTime> uploadedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaFilesCompanion.insert(
                id: id,
                uploadedBy: uploadedBy,
                mediaTypeId: mediaTypeId,
                storageType: storageType,
                storagePath: storagePath,
                sourceUrl: sourceUrl,
                originalFilename: originalFilename,
                fileSizeBytes: fileSizeBytes,
                metadata: metadata,
                uploadedAt: uploadedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MediaFilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                uploadedBy = false,
                mediaTypeId = false,
                postMediaRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (postMediaRefs) db.postMedia],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (uploadedBy) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.uploadedBy,
                                    referencedTable: $$MediaFilesTableReferences
                                        ._uploadedByTable(db),
                                    referencedColumn:
                                        $$MediaFilesTableReferences
                                            ._uploadedByTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (mediaTypeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.mediaTypeId,
                                    referencedTable: $$MediaFilesTableReferences
                                        ._mediaTypeIdTable(db),
                                    referencedColumn:
                                        $$MediaFilesTableReferences
                                            ._mediaTypeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (postMediaRefs)
                        await $_getPrefetchedData<
                          MediaFile,
                          $MediaFilesTable,
                          PostMediaData
                        >(
                          currentTable: table,
                          referencedTable: $$MediaFilesTableReferences
                              ._postMediaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MediaFilesTableReferences(
                                db,
                                table,
                                p0,
                              ).postMediaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mediaFileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MediaFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $MediaFilesTable,
      MediaFile,
      $$MediaFilesTableFilterComposer,
      $$MediaFilesTableOrderingComposer,
      $$MediaFilesTableAnnotationComposer,
      $$MediaFilesTableCreateCompanionBuilder,
      $$MediaFilesTableUpdateCompanionBuilder,
      (MediaFile, $$MediaFilesTableReferences),
      MediaFile,
      PrefetchHooks Function({
        bool uploadedBy,
        bool mediaTypeId,
        bool postMediaRefs,
      })
    >;
typedef $$CaptionTemplatesTableCreateCompanionBuilder =
    CaptionTemplatesCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue?> ownerId,
      required String name,
      required String body,
      Value<Object> variables,
      Value<bool> isGlobal,
      Value<PgDateTime> createdAt,
      Value<PgDateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CaptionTemplatesTableUpdateCompanionBuilder =
    CaptionTemplatesCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue?> ownerId,
      Value<String> name,
      Value<String> body,
      Value<Object> variables,
      Value<bool> isGlobal,
      Value<PgDateTime> createdAt,
      Value<PgDateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CaptionTemplatesTableReferences
    extends
        BaseReferences<
          _$PostflowDatabase,
          $CaptionTemplatesTable,
          CaptionTemplate
        > {
  $$CaptionTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _ownerIdTable(_$PostflowDatabase db) =>
      db.users.createAlias(
        $_aliasNameGenerator(db.captionTemplates.ownerId, db.users.id),
      );

  $$UsersTableProcessedTableManager? get ownerId {
    final $_column = $_itemColumn<UuidValue>('owner_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PostCaptionsTable, List<PostCaption>>
  _postCaptionsRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.postCaptions,
        aliasName: $_aliasNameGenerator(
          db.captionTemplates.id,
          db.postCaptions.templateId,
        ),
      );

  $$PostCaptionsTableProcessedTableManager get postCaptionsRefs {
    final manager = $$PostCaptionsTableTableManager(
      $_db,
      $_db.postCaptions,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_postCaptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CaptionTemplatesTableFilterComposer
    extends Composer<_$PostflowDatabase, $CaptionTemplatesTable> {
  $$CaptionTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Object> get variables => $composableBuilder(
    column: $table.variables,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGlobal => $composableBuilder(
    column: $table.isGlobal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get ownerId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> postCaptionsRefs(
    Expression<bool> Function($$PostCaptionsTableFilterComposer f) f,
  ) {
    final $$PostCaptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCaptions,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostCaptionsTableFilterComposer(
            $db: $db,
            $table: $db.postCaptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CaptionTemplatesTableOrderingComposer
    extends Composer<_$PostflowDatabase, $CaptionTemplatesTable> {
  $$CaptionTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Object> get variables => $composableBuilder(
    column: $table.variables,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGlobal => $composableBuilder(
    column: $table.isGlobal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get ownerId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CaptionTemplatesTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $CaptionTemplatesTable> {
  $$CaptionTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<Object> get variables =>
      $composableBuilder(column: $table.variables, builder: (column) => column);

  GeneratedColumn<bool> get isGlobal =>
      $composableBuilder(column: $table.isGlobal, builder: (column) => column);

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<PgDateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get ownerId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> postCaptionsRefs<T extends Object>(
    Expression<T> Function($$PostCaptionsTableAnnotationComposer a) f,
  ) {
    final $$PostCaptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCaptions,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostCaptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.postCaptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CaptionTemplatesTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $CaptionTemplatesTable,
          CaptionTemplate,
          $$CaptionTemplatesTableFilterComposer,
          $$CaptionTemplatesTableOrderingComposer,
          $$CaptionTemplatesTableAnnotationComposer,
          $$CaptionTemplatesTableCreateCompanionBuilder,
          $$CaptionTemplatesTableUpdateCompanionBuilder,
          (CaptionTemplate, $$CaptionTemplatesTableReferences),
          CaptionTemplate,
          PrefetchHooks Function({bool ownerId, bool postCaptionsRefs})
        > {
  $$CaptionTemplatesTableTableManager(
    _$PostflowDatabase db,
    $CaptionTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaptionTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaptionTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaptionTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue?> ownerId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<Object> variables = const Value.absent(),
                Value<bool> isGlobal = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CaptionTemplatesCompanion(
                id: id,
                ownerId: ownerId,
                name: name,
                body: body,
                variables: variables,
                isGlobal: isGlobal,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue?> ownerId = const Value.absent(),
                required String name,
                required String body,
                Value<Object> variables = const Value.absent(),
                Value<bool> isGlobal = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CaptionTemplatesCompanion.insert(
                id: id,
                ownerId: ownerId,
                name: name,
                body: body,
                variables: variables,
                isGlobal: isGlobal,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CaptionTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ownerId = false, postCaptionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (postCaptionsRefs) db.postCaptions],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ownerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ownerId,
                                referencedTable:
                                    $$CaptionTemplatesTableReferences
                                        ._ownerIdTable(db),
                                referencedColumn:
                                    $$CaptionTemplatesTableReferences
                                        ._ownerIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (postCaptionsRefs)
                    await $_getPrefetchedData<
                      CaptionTemplate,
                      $CaptionTemplatesTable,
                      PostCaption
                    >(
                      currentTable: table,
                      referencedTable: $$CaptionTemplatesTableReferences
                          ._postCaptionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CaptionTemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).postCaptionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.templateId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CaptionTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $CaptionTemplatesTable,
      CaptionTemplate,
      $$CaptionTemplatesTableFilterComposer,
      $$CaptionTemplatesTableOrderingComposer,
      $$CaptionTemplatesTableAnnotationComposer,
      $$CaptionTemplatesTableCreateCompanionBuilder,
      $$CaptionTemplatesTableUpdateCompanionBuilder,
      (CaptionTemplate, $$CaptionTemplatesTableReferences),
      CaptionTemplate,
      PrefetchHooks Function({bool ownerId, bool postCaptionsRefs})
    >;
typedef $$PostsTableCreateCompanionBuilder =
    PostsCompanion Function({
      Value<UuidValue> id,
      required UuidValue createdBy,
      Value<String?> internalNote,
      Value<String?> description,
      Value<PostStatus> status,
      Value<PgDateTime> createdAt,
      Value<PgDateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PostsTableUpdateCompanionBuilder =
    PostsCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue> createdBy,
      Value<String?> internalNote,
      Value<String?> description,
      Value<PostStatus> status,
      Value<PgDateTime> createdAt,
      Value<PgDateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PostsTableReferences
    extends BaseReferences<_$PostflowDatabase, $PostsTable, Post> {
  $$PostsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _createdByTable(_$PostflowDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.posts.createdBy, db.users.id));

  $$UsersTableProcessedTableManager get createdBy {
    final $_column = $_itemColumn<UuidValue>('created_by')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_createdByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PostMediaTable, List<PostMediaData>>
  _postMediaRefsTable(_$PostflowDatabase db) => MultiTypedResultKey.fromTable(
    db.postMedia,
    aliasName: $_aliasNameGenerator(db.posts.id, db.postMedia.postId),
  );

  $$PostMediaTableProcessedTableManager get postMediaRefs {
    final manager = $$PostMediaTableTableManager(
      $_db,
      $_db.postMedia,
    ).filter((f) => f.postId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_postMediaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PostArtistsTable, List<PostArtist>>
  _postArtistsRefsTable(_$PostflowDatabase db) => MultiTypedResultKey.fromTable(
    db.postArtists,
    aliasName: $_aliasNameGenerator(db.posts.id, db.postArtists.postId),
  );

  $$PostArtistsTableProcessedTableManager get postArtistsRefs {
    final manager = $$PostArtistsTableTableManager(
      $_db,
      $_db.postArtists,
    ).filter((f) => f.postId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_postArtistsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PostCharactersTable, List<PostCharacter>>
  _postCharactersRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.postCharacters,
        aliasName: $_aliasNameGenerator(db.posts.id, db.postCharacters.postId),
      );

  $$PostCharactersTableProcessedTableManager get postCharactersRefs {
    final manager = $$PostCharactersTableTableManager(
      $_db,
      $_db.postCharacters,
    ).filter((f) => f.postId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_postCharactersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PostSchedulesTable, List<PostSchedule>>
  _postSchedulesRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.postSchedules,
        aliasName: $_aliasNameGenerator(db.posts.id, db.postSchedules.postId),
      );

  $$PostSchedulesTableProcessedTableManager get postSchedulesRefs {
    final manager = $$PostSchedulesTableTableManager(
      $_db,
      $_db.postSchedules,
    ).filter((f) => f.postId.id.sqlEquals($_itemColumn<UuidValue>('id')!));

    final cache = $_typedResult.readTableOrNull(_postSchedulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PostsTableFilterComposer
    extends Composer<_$PostflowDatabase, $PostsTable> {
  $$PostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get internalNote => $composableBuilder(
    column: $table.internalNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PostStatus, PostStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get createdBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> postMediaRefs(
    Expression<bool> Function($$PostMediaTableFilterComposer f) f,
  ) {
    final $$PostMediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postMedia,
      getReferencedColumn: (t) => t.postId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostMediaTableFilterComposer(
            $db: $db,
            $table: $db.postMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> postArtistsRefs(
    Expression<bool> Function($$PostArtistsTableFilterComposer f) f,
  ) {
    final $$PostArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postArtists,
      getReferencedColumn: (t) => t.postId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostArtistsTableFilterComposer(
            $db: $db,
            $table: $db.postArtists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> postCharactersRefs(
    Expression<bool> Function($$PostCharactersTableFilterComposer f) f,
  ) {
    final $$PostCharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCharacters,
      getReferencedColumn: (t) => t.postId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostCharactersTableFilterComposer(
            $db: $db,
            $table: $db.postCharacters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> postSchedulesRefs(
    Expression<bool> Function($$PostSchedulesTableFilterComposer f) f,
  ) {
    final $$PostSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postSchedules,
      getReferencedColumn: (t) => t.postId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.postSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PostsTableOrderingComposer
    extends Composer<_$PostflowDatabase, $PostsTable> {
  $$PostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get internalNote => $composableBuilder(
    column: $table.internalNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get createdBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostsTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $PostsTable> {
  $$PostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get internalNote => $composableBuilder(
    column: $table.internalNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PostStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<PgDateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get createdBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdBy,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> postMediaRefs<T extends Object>(
    Expression<T> Function($$PostMediaTableAnnotationComposer a) f,
  ) {
    final $$PostMediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postMedia,
      getReferencedColumn: (t) => t.postId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostMediaTableAnnotationComposer(
            $db: $db,
            $table: $db.postMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> postArtistsRefs<T extends Object>(
    Expression<T> Function($$PostArtistsTableAnnotationComposer a) f,
  ) {
    final $$PostArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postArtists,
      getReferencedColumn: (t) => t.postId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.postArtists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> postCharactersRefs<T extends Object>(
    Expression<T> Function($$PostCharactersTableAnnotationComposer a) f,
  ) {
    final $$PostCharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCharacters,
      getReferencedColumn: (t) => t.postId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostCharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.postCharacters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> postSchedulesRefs<T extends Object>(
    Expression<T> Function($$PostSchedulesTableAnnotationComposer a) f,
  ) {
    final $$PostSchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postSchedules,
      getReferencedColumn: (t) => t.postId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostSchedulesTableAnnotationComposer(
            $db: $db,
            $table: $db.postSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PostsTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $PostsTable,
          Post,
          $$PostsTableFilterComposer,
          $$PostsTableOrderingComposer,
          $$PostsTableAnnotationComposer,
          $$PostsTableCreateCompanionBuilder,
          $$PostsTableUpdateCompanionBuilder,
          (Post, $$PostsTableReferences),
          Post,
          PrefetchHooks Function({
            bool createdBy,
            bool postMediaRefs,
            bool postArtistsRefs,
            bool postCharactersRefs,
            bool postSchedulesRefs,
          })
        > {
  $$PostsTableTableManager(_$PostflowDatabase db, $PostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue> createdBy = const Value.absent(),
                Value<String?> internalNote = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<PostStatus> status = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostsCompanion(
                id: id,
                createdBy: createdBy,
                internalNote: internalNote,
                description: description,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required UuidValue createdBy,
                Value<String?> internalNote = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<PostStatus> status = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostsCompanion.insert(
                id: id,
                createdBy: createdBy,
                internalNote: internalNote,
                description: description,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PostsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                createdBy = false,
                postMediaRefs = false,
                postArtistsRefs = false,
                postCharactersRefs = false,
                postSchedulesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (postMediaRefs) db.postMedia,
                    if (postArtistsRefs) db.postArtists,
                    if (postCharactersRefs) db.postCharacters,
                    if (postSchedulesRefs) db.postSchedules,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (createdBy) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.createdBy,
                                    referencedTable: $$PostsTableReferences
                                        ._createdByTable(db),
                                    referencedColumn: $$PostsTableReferences
                                        ._createdByTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (postMediaRefs)
                        await $_getPrefetchedData<
                          Post,
                          $PostsTable,
                          PostMediaData
                        >(
                          currentTable: table,
                          referencedTable: $$PostsTableReferences
                              ._postMediaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PostsTableReferences(
                                db,
                                table,
                                p0,
                              ).postMediaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.postId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (postArtistsRefs)
                        await $_getPrefetchedData<
                          Post,
                          $PostsTable,
                          PostArtist
                        >(
                          currentTable: table,
                          referencedTable: $$PostsTableReferences
                              ._postArtistsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PostsTableReferences(
                                db,
                                table,
                                p0,
                              ).postArtistsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.postId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (postCharactersRefs)
                        await $_getPrefetchedData<
                          Post,
                          $PostsTable,
                          PostCharacter
                        >(
                          currentTable: table,
                          referencedTable: $$PostsTableReferences
                              ._postCharactersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PostsTableReferences(
                                db,
                                table,
                                p0,
                              ).postCharactersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.postId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (postSchedulesRefs)
                        await $_getPrefetchedData<
                          Post,
                          $PostsTable,
                          PostSchedule
                        >(
                          currentTable: table,
                          referencedTable: $$PostsTableReferences
                              ._postSchedulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PostsTableReferences(
                                db,
                                table,
                                p0,
                              ).postSchedulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.postId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PostsTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $PostsTable,
      Post,
      $$PostsTableFilterComposer,
      $$PostsTableOrderingComposer,
      $$PostsTableAnnotationComposer,
      $$PostsTableCreateCompanionBuilder,
      $$PostsTableUpdateCompanionBuilder,
      (Post, $$PostsTableReferences),
      Post,
      PrefetchHooks Function({
        bool createdBy,
        bool postMediaRefs,
        bool postArtistsRefs,
        bool postCharactersRefs,
        bool postSchedulesRefs,
      })
    >;
typedef $$PostMediaTableCreateCompanionBuilder =
    PostMediaCompanion Function({
      Value<UuidValue> id,
      required UuidValue postId,
      required UuidValue mediaFileId,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$PostMediaTableUpdateCompanionBuilder =
    PostMediaCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue> postId,
      Value<UuidValue> mediaFileId,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$PostMediaTableReferences
    extends BaseReferences<_$PostflowDatabase, $PostMediaTable, PostMediaData> {
  $$PostMediaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PostsTable _postIdTable(_$PostflowDatabase db) => db.posts
      .createAlias($_aliasNameGenerator(db.postMedia.postId, db.posts.id));

  $$PostsTableProcessedTableManager get postId {
    final $_column = $_itemColumn<UuidValue>('post_id')!;

    final manager = $$PostsTableTableManager(
      $_db,
      $_db.posts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_postIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MediaFilesTable _mediaFileIdTable(_$PostflowDatabase db) =>
      db.mediaFiles.createAlias(
        $_aliasNameGenerator(db.postMedia.mediaFileId, db.mediaFiles.id),
      );

  $$MediaFilesTableProcessedTableManager get mediaFileId {
    final $_column = $_itemColumn<UuidValue>('media_file_id')!;

    final manager = $$MediaFilesTableTableManager(
      $_db,
      $_db.mediaFiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mediaFileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PostMediaTableFilterComposer
    extends Composer<_$PostflowDatabase, $PostMediaTable> {
  $$PostMediaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$PostsTableFilterComposer get postId {
    final $$PostsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableFilterComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaFilesTableFilterComposer get mediaFileId {
    final $$MediaFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaFileId,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableFilterComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostMediaTableOrderingComposer
    extends Composer<_$PostflowDatabase, $PostMediaTable> {
  $$PostMediaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$PostsTableOrderingComposer get postId {
    final $$PostsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableOrderingComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaFilesTableOrderingComposer get mediaFileId {
    final $$MediaFilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaFileId,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableOrderingComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostMediaTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $PostMediaTable> {
  $$PostMediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$PostsTableAnnotationComposer get postId {
    final $$PostsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableAnnotationComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MediaFilesTableAnnotationComposer get mediaFileId {
    final $$MediaFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mediaFileId,
      referencedTable: $db.mediaFiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.mediaFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostMediaTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $PostMediaTable,
          PostMediaData,
          $$PostMediaTableFilterComposer,
          $$PostMediaTableOrderingComposer,
          $$PostMediaTableAnnotationComposer,
          $$PostMediaTableCreateCompanionBuilder,
          $$PostMediaTableUpdateCompanionBuilder,
          (PostMediaData, $$PostMediaTableReferences),
          PostMediaData,
          PrefetchHooks Function({bool postId, bool mediaFileId})
        > {
  $$PostMediaTableTableManager(_$PostflowDatabase db, $PostMediaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostMediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostMediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostMediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue> postId = const Value.absent(),
                Value<UuidValue> mediaFileId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostMediaCompanion(
                id: id,
                postId: postId,
                mediaFileId: mediaFileId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required UuidValue postId,
                required UuidValue mediaFileId,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostMediaCompanion.insert(
                id: id,
                postId: postId,
                mediaFileId: mediaFileId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PostMediaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({postId = false, mediaFileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (postId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.postId,
                                referencedTable: $$PostMediaTableReferences
                                    ._postIdTable(db),
                                referencedColumn: $$PostMediaTableReferences
                                    ._postIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (mediaFileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mediaFileId,
                                referencedTable: $$PostMediaTableReferences
                                    ._mediaFileIdTable(db),
                                referencedColumn: $$PostMediaTableReferences
                                    ._mediaFileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PostMediaTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $PostMediaTable,
      PostMediaData,
      $$PostMediaTableFilterComposer,
      $$PostMediaTableOrderingComposer,
      $$PostMediaTableAnnotationComposer,
      $$PostMediaTableCreateCompanionBuilder,
      $$PostMediaTableUpdateCompanionBuilder,
      (PostMediaData, $$PostMediaTableReferences),
      PostMediaData,
      PrefetchHooks Function({bool postId, bool mediaFileId})
    >;
typedef $$PostArtistsTableCreateCompanionBuilder =
    PostArtistsCompanion Function({
      required UuidValue postId,
      required UuidValue artistId,
      Value<int> rowid,
    });
typedef $$PostArtistsTableUpdateCompanionBuilder =
    PostArtistsCompanion Function({
      Value<UuidValue> postId,
      Value<UuidValue> artistId,
      Value<int> rowid,
    });

final class $$PostArtistsTableReferences
    extends BaseReferences<_$PostflowDatabase, $PostArtistsTable, PostArtist> {
  $$PostArtistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PostsTable _postIdTable(_$PostflowDatabase db) => db.posts
      .createAlias($_aliasNameGenerator(db.postArtists.postId, db.posts.id));

  $$PostsTableProcessedTableManager get postId {
    final $_column = $_itemColumn<UuidValue>('post_id')!;

    final manager = $$PostsTableTableManager(
      $_db,
      $_db.posts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_postIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ArtistsTable _artistIdTable(_$PostflowDatabase db) =>
      db.artists.createAlias(
        $_aliasNameGenerator(db.postArtists.artistId, db.artists.id),
      );

  $$ArtistsTableProcessedTableManager get artistId {
    final $_column = $_itemColumn<UuidValue>('artist_id')!;

    final manager = $$ArtistsTableTableManager(
      $_db,
      $_db.artists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_artistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PostArtistsTableFilterComposer
    extends Composer<_$PostflowDatabase, $PostArtistsTable> {
  $$PostArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PostsTableFilterComposer get postId {
    final $$PostsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableFilterComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableFilterComposer get artistId {
    final $$ArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableFilterComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostArtistsTableOrderingComposer
    extends Composer<_$PostflowDatabase, $PostArtistsTable> {
  $$PostArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PostsTableOrderingComposer get postId {
    final $$PostsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableOrderingComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableOrderingComposer get artistId {
    final $$ArtistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableOrderingComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostArtistsTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $PostArtistsTable> {
  $$PostArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PostsTableAnnotationComposer get postId {
    final $$PostsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableAnnotationComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableAnnotationComposer get artistId {
    final $$ArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostArtistsTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $PostArtistsTable,
          PostArtist,
          $$PostArtistsTableFilterComposer,
          $$PostArtistsTableOrderingComposer,
          $$PostArtistsTableAnnotationComposer,
          $$PostArtistsTableCreateCompanionBuilder,
          $$PostArtistsTableUpdateCompanionBuilder,
          (PostArtist, $$PostArtistsTableReferences),
          PostArtist,
          PrefetchHooks Function({bool postId, bool artistId})
        > {
  $$PostArtistsTableTableManager(_$PostflowDatabase db, $PostArtistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> postId = const Value.absent(),
                Value<UuidValue> artistId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostArtistsCompanion(
                postId: postId,
                artistId: artistId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required UuidValue postId,
                required UuidValue artistId,
                Value<int> rowid = const Value.absent(),
              }) => PostArtistsCompanion.insert(
                postId: postId,
                artistId: artistId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PostArtistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({postId = false, artistId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (postId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.postId,
                                referencedTable: $$PostArtistsTableReferences
                                    ._postIdTable(db),
                                referencedColumn: $$PostArtistsTableReferences
                                    ._postIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (artistId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.artistId,
                                referencedTable: $$PostArtistsTableReferences
                                    ._artistIdTable(db),
                                referencedColumn: $$PostArtistsTableReferences
                                    ._artistIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PostArtistsTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $PostArtistsTable,
      PostArtist,
      $$PostArtistsTableFilterComposer,
      $$PostArtistsTableOrderingComposer,
      $$PostArtistsTableAnnotationComposer,
      $$PostArtistsTableCreateCompanionBuilder,
      $$PostArtistsTableUpdateCompanionBuilder,
      (PostArtist, $$PostArtistsTableReferences),
      PostArtist,
      PrefetchHooks Function({bool postId, bool artistId})
    >;
typedef $$PostCharactersTableCreateCompanionBuilder =
    PostCharactersCompanion Function({
      required UuidValue postId,
      required UuidValue characterId,
      Value<UuidValue?> contextFranchiseId,
      Value<int> rowid,
    });
typedef $$PostCharactersTableUpdateCompanionBuilder =
    PostCharactersCompanion Function({
      Value<UuidValue> postId,
      Value<UuidValue> characterId,
      Value<UuidValue?> contextFranchiseId,
      Value<int> rowid,
    });

final class $$PostCharactersTableReferences
    extends
        BaseReferences<
          _$PostflowDatabase,
          $PostCharactersTable,
          PostCharacter
        > {
  $$PostCharactersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PostsTable _postIdTable(_$PostflowDatabase db) => db.posts
      .createAlias($_aliasNameGenerator(db.postCharacters.postId, db.posts.id));

  $$PostsTableProcessedTableManager get postId {
    final $_column = $_itemColumn<UuidValue>('post_id')!;

    final manager = $$PostsTableTableManager(
      $_db,
      $_db.posts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_postIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CharactersTable _characterIdTable(_$PostflowDatabase db) =>
      db.characters.createAlias(
        $_aliasNameGenerator(db.postCharacters.characterId, db.characters.id),
      );

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<UuidValue>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FranchisesTable _contextFranchiseIdTable(_$PostflowDatabase db) =>
      db.franchises.createAlias(
        $_aliasNameGenerator(
          db.postCharacters.contextFranchiseId,
          db.franchises.id,
        ),
      );

  $$FranchisesTableProcessedTableManager? get contextFranchiseId {
    final $_column = $_itemColumn<UuidValue>('context_franchise_id');
    if ($_column == null) return null;
    final manager = $$FranchisesTableTableManager(
      $_db,
      $_db.franchises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contextFranchiseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PostCharactersTableFilterComposer
    extends Composer<_$PostflowDatabase, $PostCharactersTable> {
  $$PostCharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PostsTableFilterComposer get postId {
    final $$PostsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableFilterComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FranchisesTableFilterComposer get contextFranchiseId {
    final $$FranchisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contextFranchiseId,
      referencedTable: $db.franchises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FranchisesTableFilterComposer(
            $db: $db,
            $table: $db.franchises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostCharactersTableOrderingComposer
    extends Composer<_$PostflowDatabase, $PostCharactersTable> {
  $$PostCharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PostsTableOrderingComposer get postId {
    final $$PostsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableOrderingComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FranchisesTableOrderingComposer get contextFranchiseId {
    final $$FranchisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contextFranchiseId,
      referencedTable: $db.franchises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FranchisesTableOrderingComposer(
            $db: $db,
            $table: $db.franchises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostCharactersTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $PostCharactersTable> {
  $$PostCharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PostsTableAnnotationComposer get postId {
    final $$PostsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableAnnotationComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FranchisesTableAnnotationComposer get contextFranchiseId {
    final $$FranchisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contextFranchiseId,
      referencedTable: $db.franchises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FranchisesTableAnnotationComposer(
            $db: $db,
            $table: $db.franchises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostCharactersTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $PostCharactersTable,
          PostCharacter,
          $$PostCharactersTableFilterComposer,
          $$PostCharactersTableOrderingComposer,
          $$PostCharactersTableAnnotationComposer,
          $$PostCharactersTableCreateCompanionBuilder,
          $$PostCharactersTableUpdateCompanionBuilder,
          (PostCharacter, $$PostCharactersTableReferences),
          PostCharacter,
          PrefetchHooks Function({
            bool postId,
            bool characterId,
            bool contextFranchiseId,
          })
        > {
  $$PostCharactersTableTableManager(
    _$PostflowDatabase db,
    $PostCharactersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostCharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostCharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostCharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> postId = const Value.absent(),
                Value<UuidValue> characterId = const Value.absent(),
                Value<UuidValue?> contextFranchiseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostCharactersCompanion(
                postId: postId,
                characterId: characterId,
                contextFranchiseId: contextFranchiseId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required UuidValue postId,
                required UuidValue characterId,
                Value<UuidValue?> contextFranchiseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostCharactersCompanion.insert(
                postId: postId,
                characterId: characterId,
                contextFranchiseId: contextFranchiseId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PostCharactersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                postId = false,
                characterId = false,
                contextFranchiseId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (postId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.postId,
                                    referencedTable:
                                        $$PostCharactersTableReferences
                                            ._postIdTable(db),
                                    referencedColumn:
                                        $$PostCharactersTableReferences
                                            ._postIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (characterId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.characterId,
                                    referencedTable:
                                        $$PostCharactersTableReferences
                                            ._characterIdTable(db),
                                    referencedColumn:
                                        $$PostCharactersTableReferences
                                            ._characterIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (contextFranchiseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.contextFranchiseId,
                                    referencedTable:
                                        $$PostCharactersTableReferences
                                            ._contextFranchiseIdTable(db),
                                    referencedColumn:
                                        $$PostCharactersTableReferences
                                            ._contextFranchiseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PostCharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $PostCharactersTable,
      PostCharacter,
      $$PostCharactersTableFilterComposer,
      $$PostCharactersTableOrderingComposer,
      $$PostCharactersTableAnnotationComposer,
      $$PostCharactersTableCreateCompanionBuilder,
      $$PostCharactersTableUpdateCompanionBuilder,
      (PostCharacter, $$PostCharactersTableReferences),
      PostCharacter,
      PrefetchHooks Function({
        bool postId,
        bool characterId,
        bool contextFranchiseId,
      })
    >;
typedef $$PostSchedulesTableCreateCompanionBuilder =
    PostSchedulesCompanion Function({
      Value<UuidValue> id,
      required UuidValue postId,
      required UuidValue socialAccountTargetId,
      required PgDateTime scheduledAt,
      Value<ScheduleStatus> status,
      Value<String?> externalPostId,
      Value<PgDateTime?> publishedAt,
      Value<String?> errorMessage,
      Value<PgDateTime> createdAt,
      Value<PgDateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PostSchedulesTableUpdateCompanionBuilder =
    PostSchedulesCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue> postId,
      Value<UuidValue> socialAccountTargetId,
      Value<PgDateTime> scheduledAt,
      Value<ScheduleStatus> status,
      Value<String?> externalPostId,
      Value<PgDateTime?> publishedAt,
      Value<String?> errorMessage,
      Value<PgDateTime> createdAt,
      Value<PgDateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PostSchedulesTableReferences
    extends
        BaseReferences<_$PostflowDatabase, $PostSchedulesTable, PostSchedule> {
  $$PostSchedulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PostsTable _postIdTable(_$PostflowDatabase db) => db.posts
      .createAlias($_aliasNameGenerator(db.postSchedules.postId, db.posts.id));

  $$PostsTableProcessedTableManager get postId {
    final $_column = $_itemColumn<UuidValue>('post_id')!;

    final manager = $$PostsTableTableManager(
      $_db,
      $_db.posts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_postIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SocialAccountTargetsTable _socialAccountTargetIdTable(
    _$PostflowDatabase db,
  ) => db.socialAccountTargets.createAlias(
    $_aliasNameGenerator(
      db.postSchedules.socialAccountTargetId,
      db.socialAccountTargets.id,
    ),
  );

  $$SocialAccountTargetsTableProcessedTableManager get socialAccountTargetId {
    final $_column = $_itemColumn<UuidValue>('social_account_target_id')!;

    final manager = $$SocialAccountTargetsTableTableManager(
      $_db,
      $_db.socialAccountTargets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _socialAccountTargetIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PostCaptionsTable, List<PostCaption>>
  _postCaptionsRefsTable(_$PostflowDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.postCaptions,
        aliasName: $_aliasNameGenerator(
          db.postSchedules.id,
          db.postCaptions.postScheduleId,
        ),
      );

  $$PostCaptionsTableProcessedTableManager get postCaptionsRefs {
    final manager = $$PostCaptionsTableTableManager($_db, $_db.postCaptions)
        .filter(
          (f) => f.postScheduleId.id.sqlEquals($_itemColumn<UuidValue>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_postCaptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PostSchedulesTableFilterComposer
    extends Composer<_$PostflowDatabase, $PostSchedulesTable> {
  $$PostSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ScheduleStatus, ScheduleStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get externalPostId => $composableBuilder(
    column: $table.externalPostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PostsTableFilterComposer get postId {
    final $$PostsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableFilterComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SocialAccountTargetsTableFilterComposer get socialAccountTargetId {
    final $$SocialAccountTargetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.socialAccountTargetId,
      referencedTable: $db.socialAccountTargets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SocialAccountTargetsTableFilterComposer(
            $db: $db,
            $table: $db.socialAccountTargets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> postCaptionsRefs(
    Expression<bool> Function($$PostCaptionsTableFilterComposer f) f,
  ) {
    final $$PostCaptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCaptions,
      getReferencedColumn: (t) => t.postScheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostCaptionsTableFilterComposer(
            $db: $db,
            $table: $db.postCaptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PostSchedulesTableOrderingComposer
    extends Composer<_$PostflowDatabase, $PostSchedulesTable> {
  $$PostSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalPostId => $composableBuilder(
    column: $table.externalPostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<PgDateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PostsTableOrderingComposer get postId {
    final $$PostsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableOrderingComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SocialAccountTargetsTableOrderingComposer get socialAccountTargetId {
    final $$SocialAccountTargetsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.socialAccountTargetId,
          referencedTable: $db.socialAccountTargets,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SocialAccountTargetsTableOrderingComposer(
                $db: $db,
                $table: $db.socialAccountTargets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PostSchedulesTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $PostSchedulesTable> {
  $$PostSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<PgDateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ScheduleStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get externalPostId => $composableBuilder(
    column: $table.externalPostId,
    builder: (column) => column,
  );

  GeneratedColumn<PgDateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<PgDateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<PgDateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PostsTableAnnotationComposer get postId {
    final $$PostsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostsTableAnnotationComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SocialAccountTargetsTableAnnotationComposer get socialAccountTargetId {
    final $$SocialAccountTargetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.socialAccountTargetId,
          referencedTable: $db.socialAccountTargets,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SocialAccountTargetsTableAnnotationComposer(
                $db: $db,
                $table: $db.socialAccountTargets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> postCaptionsRefs<T extends Object>(
    Expression<T> Function($$PostCaptionsTableAnnotationComposer a) f,
  ) {
    final $$PostCaptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCaptions,
      getReferencedColumn: (t) => t.postScheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostCaptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.postCaptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PostSchedulesTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $PostSchedulesTable,
          PostSchedule,
          $$PostSchedulesTableFilterComposer,
          $$PostSchedulesTableOrderingComposer,
          $$PostSchedulesTableAnnotationComposer,
          $$PostSchedulesTableCreateCompanionBuilder,
          $$PostSchedulesTableUpdateCompanionBuilder,
          (PostSchedule, $$PostSchedulesTableReferences),
          PostSchedule,
          PrefetchHooks Function({
            bool postId,
            bool socialAccountTargetId,
            bool postCaptionsRefs,
          })
        > {
  $$PostSchedulesTableTableManager(
    _$PostflowDatabase db,
    $PostSchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostSchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue> postId = const Value.absent(),
                Value<UuidValue> socialAccountTargetId = const Value.absent(),
                Value<PgDateTime> scheduledAt = const Value.absent(),
                Value<ScheduleStatus> status = const Value.absent(),
                Value<String?> externalPostId = const Value.absent(),
                Value<PgDateTime?> publishedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostSchedulesCompanion(
                id: id,
                postId: postId,
                socialAccountTargetId: socialAccountTargetId,
                scheduledAt: scheduledAt,
                status: status,
                externalPostId: externalPostId,
                publishedAt: publishedAt,
                errorMessage: errorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required UuidValue postId,
                required UuidValue socialAccountTargetId,
                required PgDateTime scheduledAt,
                Value<ScheduleStatus> status = const Value.absent(),
                Value<String?> externalPostId = const Value.absent(),
                Value<PgDateTime?> publishedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<PgDateTime> createdAt = const Value.absent(),
                Value<PgDateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostSchedulesCompanion.insert(
                id: id,
                postId: postId,
                socialAccountTargetId: socialAccountTargetId,
                scheduledAt: scheduledAt,
                status: status,
                externalPostId: externalPostId,
                publishedAt: publishedAt,
                errorMessage: errorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PostSchedulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                postId = false,
                socialAccountTargetId = false,
                postCaptionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (postCaptionsRefs) db.postCaptions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (postId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.postId,
                                    referencedTable:
                                        $$PostSchedulesTableReferences
                                            ._postIdTable(db),
                                    referencedColumn:
                                        $$PostSchedulesTableReferences
                                            ._postIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (socialAccountTargetId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.socialAccountTargetId,
                                    referencedTable:
                                        $$PostSchedulesTableReferences
                                            ._socialAccountTargetIdTable(db),
                                    referencedColumn:
                                        $$PostSchedulesTableReferences
                                            ._socialAccountTargetIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (postCaptionsRefs)
                        await $_getPrefetchedData<
                          PostSchedule,
                          $PostSchedulesTable,
                          PostCaption
                        >(
                          currentTable: table,
                          referencedTable: $$PostSchedulesTableReferences
                              ._postCaptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PostSchedulesTableReferences(
                                db,
                                table,
                                p0,
                              ).postCaptionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.postScheduleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PostSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $PostSchedulesTable,
      PostSchedule,
      $$PostSchedulesTableFilterComposer,
      $$PostSchedulesTableOrderingComposer,
      $$PostSchedulesTableAnnotationComposer,
      $$PostSchedulesTableCreateCompanionBuilder,
      $$PostSchedulesTableUpdateCompanionBuilder,
      (PostSchedule, $$PostSchedulesTableReferences),
      PostSchedule,
      PrefetchHooks Function({
        bool postId,
        bool socialAccountTargetId,
        bool postCaptionsRefs,
      })
    >;
typedef $$PostCaptionsTableCreateCompanionBuilder =
    PostCaptionsCompanion Function({
      Value<UuidValue> id,
      required UuidValue postScheduleId,
      Value<UuidValue?> templateId,
      required String renderedBody,
      Value<Object> variableOverrides,
      Value<int> rowid,
    });
typedef $$PostCaptionsTableUpdateCompanionBuilder =
    PostCaptionsCompanion Function({
      Value<UuidValue> id,
      Value<UuidValue> postScheduleId,
      Value<UuidValue?> templateId,
      Value<String> renderedBody,
      Value<Object> variableOverrides,
      Value<int> rowid,
    });

final class $$PostCaptionsTableReferences
    extends
        BaseReferences<_$PostflowDatabase, $PostCaptionsTable, PostCaption> {
  $$PostCaptionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PostSchedulesTable _postScheduleIdTable(_$PostflowDatabase db) =>
      db.postSchedules.createAlias(
        $_aliasNameGenerator(
          db.postCaptions.postScheduleId,
          db.postSchedules.id,
        ),
      );

  $$PostSchedulesTableProcessedTableManager get postScheduleId {
    final $_column = $_itemColumn<UuidValue>('post_schedule_id')!;

    final manager = $$PostSchedulesTableTableManager(
      $_db,
      $_db.postSchedules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_postScheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CaptionTemplatesTable _templateIdTable(_$PostflowDatabase db) =>
      db.captionTemplates.createAlias(
        $_aliasNameGenerator(
          db.postCaptions.templateId,
          db.captionTemplates.id,
        ),
      );

  $$CaptionTemplatesTableProcessedTableManager? get templateId {
    final $_column = $_itemColumn<UuidValue>('template_id');
    if ($_column == null) return null;
    final manager = $$CaptionTemplatesTableTableManager(
      $_db,
      $_db.captionTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PostCaptionsTableFilterComposer
    extends Composer<_$PostflowDatabase, $PostCaptionsTable> {
  $$PostCaptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get renderedBody => $composableBuilder(
    column: $table.renderedBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Object> get variableOverrides => $composableBuilder(
    column: $table.variableOverrides,
    builder: (column) => ColumnFilters(column),
  );

  $$PostSchedulesTableFilterComposer get postScheduleId {
    final $$PostSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postScheduleId,
      referencedTable: $db.postSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.postSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaptionTemplatesTableFilterComposer get templateId {
    final $$CaptionTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.captionTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaptionTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.captionTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostCaptionsTableOrderingComposer
    extends Composer<_$PostflowDatabase, $PostCaptionsTable> {
  $$PostCaptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<UuidValue> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get renderedBody => $composableBuilder(
    column: $table.renderedBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Object> get variableOverrides => $composableBuilder(
    column: $table.variableOverrides,
    builder: (column) => ColumnOrderings(column),
  );

  $$PostSchedulesTableOrderingComposer get postScheduleId {
    final $$PostSchedulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postScheduleId,
      referencedTable: $db.postSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostSchedulesTableOrderingComposer(
            $db: $db,
            $table: $db.postSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaptionTemplatesTableOrderingComposer get templateId {
    final $$CaptionTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.captionTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaptionTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.captionTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostCaptionsTableAnnotationComposer
    extends Composer<_$PostflowDatabase, $PostCaptionsTable> {
  $$PostCaptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<UuidValue> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get renderedBody => $composableBuilder(
    column: $table.renderedBody,
    builder: (column) => column,
  );

  GeneratedColumn<Object> get variableOverrides => $composableBuilder(
    column: $table.variableOverrides,
    builder: (column) => column,
  );

  $$PostSchedulesTableAnnotationComposer get postScheduleId {
    final $$PostSchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postScheduleId,
      referencedTable: $db.postSchedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PostSchedulesTableAnnotationComposer(
            $db: $db,
            $table: $db.postSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CaptionTemplatesTableAnnotationComposer get templateId {
    final $$CaptionTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.captionTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaptionTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.captionTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostCaptionsTableTableManager
    extends
        RootTableManager<
          _$PostflowDatabase,
          $PostCaptionsTable,
          PostCaption,
          $$PostCaptionsTableFilterComposer,
          $$PostCaptionsTableOrderingComposer,
          $$PostCaptionsTableAnnotationComposer,
          $$PostCaptionsTableCreateCompanionBuilder,
          $$PostCaptionsTableUpdateCompanionBuilder,
          (PostCaption, $$PostCaptionsTableReferences),
          PostCaption,
          PrefetchHooks Function({bool postScheduleId, bool templateId})
        > {
  $$PostCaptionsTableTableManager(
    _$PostflowDatabase db,
    $PostCaptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostCaptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostCaptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostCaptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                Value<UuidValue> postScheduleId = const Value.absent(),
                Value<UuidValue?> templateId = const Value.absent(),
                Value<String> renderedBody = const Value.absent(),
                Value<Object> variableOverrides = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostCaptionsCompanion(
                id: id,
                postScheduleId: postScheduleId,
                templateId: templateId,
                renderedBody: renderedBody,
                variableOverrides: variableOverrides,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<UuidValue> id = const Value.absent(),
                required UuidValue postScheduleId,
                Value<UuidValue?> templateId = const Value.absent(),
                required String renderedBody,
                Value<Object> variableOverrides = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostCaptionsCompanion.insert(
                id: id,
                postScheduleId: postScheduleId,
                templateId: templateId,
                renderedBody: renderedBody,
                variableOverrides: variableOverrides,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PostCaptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({postScheduleId = false, templateId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (postScheduleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.postScheduleId,
                                    referencedTable:
                                        $$PostCaptionsTableReferences
                                            ._postScheduleIdTable(db),
                                    referencedColumn:
                                        $$PostCaptionsTableReferences
                                            ._postScheduleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (templateId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.templateId,
                                    referencedTable:
                                        $$PostCaptionsTableReferences
                                            ._templateIdTable(db),
                                    referencedColumn:
                                        $$PostCaptionsTableReferences
                                            ._templateIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PostCaptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PostflowDatabase,
      $PostCaptionsTable,
      PostCaption,
      $$PostCaptionsTableFilterComposer,
      $$PostCaptionsTableOrderingComposer,
      $$PostCaptionsTableAnnotationComposer,
      $$PostCaptionsTableCreateCompanionBuilder,
      $$PostCaptionsTableUpdateCompanionBuilder,
      (PostCaption, $$PostCaptionsTableReferences),
      PostCaption,
      PrefetchHooks Function({bool postScheduleId, bool templateId})
    >;

class $PostflowDatabaseManager {
  final _$PostflowDatabase _db;
  $PostflowDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$UserIdentitiesTableTableManager get userIdentities =>
      $$UserIdentitiesTableTableManager(_db, _db.userIdentities);
  $$RefreshTokensTableTableManager get refreshTokens =>
      $$RefreshTokensTableTableManager(_db, _db.refreshTokens);
  $$SocialNetworksTableTableManager get socialNetworks =>
      $$SocialNetworksTableTableManager(_db, _db.socialNetworks);
  $$UserSocialAccountsTableTableManager get userSocialAccounts =>
      $$UserSocialAccountsTableTableManager(_db, _db.userSocialAccounts);
  $$SocialAccountTargetsTableTableManager get socialAccountTargets =>
      $$SocialAccountTargetsTableTableManager(_db, _db.socialAccountTargets);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db, _db.artists);
  $$FranchisesTableTableManager get franchises =>
      $$FranchisesTableTableManager(_db, _db.franchises);
  $$CharactersTableTableManager get characters =>
      $$CharactersTableTableManager(_db, _db.characters);
  $$MediaTypesTableTableManager get mediaTypes =>
      $$MediaTypesTableTableManager(_db, _db.mediaTypes);
  $$MediaFilesTableTableManager get mediaFiles =>
      $$MediaFilesTableTableManager(_db, _db.mediaFiles);
  $$CaptionTemplatesTableTableManager get captionTemplates =>
      $$CaptionTemplatesTableTableManager(_db, _db.captionTemplates);
  $$PostsTableTableManager get posts =>
      $$PostsTableTableManager(_db, _db.posts);
  $$PostMediaTableTableManager get postMedia =>
      $$PostMediaTableTableManager(_db, _db.postMedia);
  $$PostArtistsTableTableManager get postArtists =>
      $$PostArtistsTableTableManager(_db, _db.postArtists);
  $$PostCharactersTableTableManager get postCharacters =>
      $$PostCharactersTableTableManager(_db, _db.postCharacters);
  $$PostSchedulesTableTableManager get postSchedules =>
      $$PostSchedulesTableTableManager(_db, _db.postSchedules);
  $$PostCaptionsTableTableManager get postCaptions =>
      $$PostCaptionsTableTableManager(_db, _db.postCaptions);
}

mixin _$ArtistsDaoMixin on DatabaseAccessor<PostflowDatabase> {
  $ArtistsTable get artists => attachedDatabase.artists;
  ArtistsDaoManager get managers => ArtistsDaoManager(this);
}

class ArtistsDaoManager {
  final _$ArtistsDaoMixin _db;
  ArtistsDaoManager(this._db);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db.attachedDatabase, _db.artists);
}

mixin _$UsersDaoMixin on DatabaseAccessor<PostflowDatabase> {
  $UsersTable get users => attachedDatabase.users;
  UsersDaoManager get managers => UsersDaoManager(this);
}

class UsersDaoManager {
  final _$UsersDaoMixin _db;
  UsersDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}

mixin _$UserIdentitiesDaoMixin on DatabaseAccessor<PostflowDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $UserIdentitiesTable get userIdentities => attachedDatabase.userIdentities;
  UserIdentitiesDaoManager get managers => UserIdentitiesDaoManager(this);
}

class UserIdentitiesDaoManager {
  final _$UserIdentitiesDaoMixin _db;
  UserIdentitiesDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$UserIdentitiesTableTableManager get userIdentities =>
      $$UserIdentitiesTableTableManager(
        _db.attachedDatabase,
        _db.userIdentities,
      );
}

mixin _$RefreshTokensDaoMixin on DatabaseAccessor<PostflowDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $RefreshTokensTable get refreshTokens => attachedDatabase.refreshTokens;
  RefreshTokensDaoManager get managers => RefreshTokensDaoManager(this);
}

class RefreshTokensDaoManager {
  final _$RefreshTokensDaoMixin _db;
  RefreshTokensDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$RefreshTokensTableTableManager get refreshTokens =>
      $$RefreshTokensTableTableManager(_db.attachedDatabase, _db.refreshTokens);
}
