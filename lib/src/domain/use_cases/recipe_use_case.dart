import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/recipe_entity.dart';
import '../repositories/recipe_repository.dart';

final class GetRecipesUseCase {
  GetRecipesUseCase(this.repository);

  final RecipeRepository repository;

  Future<Result<List<RecipeListResponseEntity>, String>> call({
    int skip = 0,
    int limit = 30,
    String? query,
    String? difficulty,
  }) async {
    final result = await repository.getRecipes(
      skip: skip,
      limit: limit,
      query: query,
      difficulty: difficulty,
    );

    return switch (result) {
      Success(:final data) => Success(data),
      Error(:final error) => Error(error.message),
      _ => const Error('Something went wrong'),
    };
  }
}

final class GetRecipeByIdUseCase {
  GetRecipeByIdUseCase(this.repository);

  final RecipeRepository repository;

  Future<Result<Recipe, Failure>> call(String id) async {
    return throw UnimplementedError();
    // return repository.getRecipeById(id);
  }
}

final class GetRecipeDetailsUseCase {
  GetRecipeDetailsUseCase(this.repository);

  final RecipeRepository repository;

  Future<Result<RecipeDetailsResponseEntity, Failure>> call(String id) async {
    return repository.getRecipeById(id);
  }
}
