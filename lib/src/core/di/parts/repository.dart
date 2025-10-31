part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
Future<AuthenticationRepository> authenticationRepository(Ref ref) async {
  final cacheService = await ref.watch(cacheServiceProvider.future);
  return AuthenticationRepositoryImpl(
    remote: ref.read(restClientServiceProvider),
    local: cacheService,
  );
}

@Riverpod(keepAlive: true)
Future<RecipeRepository> recipeRepository(Ref ref) async {
  final cacheService = await ref.watch(cacheServiceProvider.future);
  return RecipeRepositoryImpl(
    remote: ref.read(restClientServiceProvider),
    local: cacheService,
  );
}
