part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
AuthenticationRepository authenticationRepository(Ref ref) {
  return AuthenticationRepositoryImpl(
    remote: ref.read(restClientServiceProvider),
    local: ref.read(cacheServiceProvider),
  );
}

// @Riverpod(keepAlive: true)
// RecipeRepository recipeRepository(Ref ref) {
//   return RecipeRepositoryImpl(ref.read(recipeServiceProvider));
// }
