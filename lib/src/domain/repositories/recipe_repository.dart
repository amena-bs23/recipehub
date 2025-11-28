import 'dart:async';

import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/recipe_entity.dart';

abstract base class RecipeRepository extends Repository {
  Future<Result<List<RecipeListResponseEntity>, Failure>> getRecipes({
    int skip = 0,
    int limit = 30,
    String? query,
    String? difficulty,
  });

  Future<Result<Recipe, Failure>> getRecipeById(String id);

  // Future<Result<List<Recipe>, Failure>> searchRecipes(String query);

  Future<Result<void, Failure>> toggleFavorite(String recipeId);

  FutureOr<Set<String>> getFavoriteIds();
}
