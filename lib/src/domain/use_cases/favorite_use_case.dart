import 'dart:async';

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/recipe_entity.dart';
import '../repositories/recipe_repository.dart';

final class ToggleFavoriteUseCase {
  ToggleFavoriteUseCase(this.repository);

  final RecipeRepository repository;

  Future<Result<void, Failure>> call(String recipeId) async {
    return repository.toggleFavorite(recipeId);
  }
}

final class GetFavoritesUseCase {
  GetFavoritesUseCase(this.repository);

  final RecipeRepository repository;

  Future<Result<List<RecipeListResponseEntity>, Failure>> call() async {
    return repository.getRecipes();
  }
}

final class GetFavoriteIdsUseCase {
  GetFavoriteIdsUseCase(this.repository);

  final RecipeRepository repository;

  FutureOr<Set<String>> call() async {
    return repository.getFavoriteIds();
  }
}
