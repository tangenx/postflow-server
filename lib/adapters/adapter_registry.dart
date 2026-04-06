import 'social_adapter.dart';

class AdapterRegistry {
  final Map<String, SocialAdapter> _adapters = {};

  void register(SocialAdapter adapter) {
    _adapters[adapter.slug] = adapter;
  }

  SocialAdapter? get(String slug) {
    final adapter = _adapters[slug];
    if (adapter == null) {
      throw UnsupportedError('No adapter found for slug $slug');
    }
    return adapter;
  }
}
