part of '../dependency_injection.dart';

// Authentication Use Cases
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
CheckRememberMeUseCase checkRememberMeUseCase(Ref ref) {
  return CheckRememberMeUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
SaveRememberMeUseCase saveRememberMeUseCase(Ref ref) {
  return SaveRememberMeUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.read(authenticationRepositoryProvider));
}

// Recipe Use Cases
@riverpod
GetRecipesUseCase getRecipesUseCase(Ref ref) {
  return GetRecipesUseCase(ref.read(recipeRepositoryProvider));
}

@riverpod
GetRecipeByIdUseCase getRecipeByIdUseCase(Ref ref) {
  return GetRecipeByIdUseCase(ref.read(recipeRepositoryProvider));
}

/*@riverpod
SearchRecipesUseCase searchRecipesUseCase(Ref ref) {
  return SearchRecipesUseCase(ref.read(recipeRepositoryProvider));
}*/

@riverpod
ToggleFavoriteUseCase toggleFavoriteUseCase(Ref ref) {
  return ToggleFavoriteUseCase(ref.read(recipeRepositoryProvider));
}

@riverpod
GetFavoritesUseCase getFavoritesUseCase(Ref ref) {
  return GetFavoritesUseCase(ref.read(recipeRepositoryProvider));
}
