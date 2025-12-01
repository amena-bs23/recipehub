import 'package:recipehub/src/core/base/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/recipe_entity.dart';
import '../../../../domain/use_cases/recipe_use_case.dart';

part 'recipe_details_provider.g.dart';

@riverpod
class RecipeDetailsNotifier extends _$RecipeDetailsNotifier {
  late GetRecipeDetailsUseCase _getRecipeDetailsUseCase;

  @override
  Future<RecipeDetailsResponseEntity> build() async {
    _getRecipeDetailsUseCase = ref.read(getRecipeDetailsUseCaseProvider);
    return throw UnimplementedError();
    // return await _loadRecipes();
  }

  Future<RecipeDetailsResponseEntity> _getRecipeDetails() async {
    final result = await _getRecipeDetailsUseCase.call('1');

    return switch (result) {
      Success(:final data) => data,
      Error(:final error) => throw Exception(error),
      _ => throw Exception('Unknown error'),
    };
  }
}
