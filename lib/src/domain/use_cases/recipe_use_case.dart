import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/recipe_entity.dart';
import '../repositories/recipe_repository.dart';

final class GetRecipesUseCase {
  GetRecipesUseCase(this.repository);

  final RecipeRepository repository;

  Future<Result<List<Recipe>, Failure>> call({
    int skip = 0,
    int limit = 30,
    String? query,
    String? difficulty,
  }) async {
    return repository.getRecipes(
      skip: skip,
      limit: limit,
      query: query,
      difficulty: difficulty,
    );
  }
}

final class GetRecipeByIdUseCase {
  GetRecipeByIdUseCase(this.repository);

  final RecipeRepository repository;

  Future<Result<Recipe, Failure>> call(String id) async {
    return repository.getRecipeById(id);
  }
}

final class SearchRecipesUseCase {
  SearchRecipesUseCase(this.repository);

  final RecipeRepository repository;

  Future<Result<List<Recipe>, Failure>> call(String query) async {
    return repository.searchRecipes(query);
  }
}

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

  Future<Result<List<Recipe>, Failure>> call() async {
    return repository.getRecipes();
  }
}
