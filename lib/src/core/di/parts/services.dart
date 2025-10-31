part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
Future<CacheService> cacheService(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return SharedPreferencesService(prefs);
}

@riverpod
RestClient restClientService(Ref ref) {
  return RestClient(
    ref.read(dioProvider),
    baseUrl: Endpoints.base, // Add baseUrl parameter
  );
}
