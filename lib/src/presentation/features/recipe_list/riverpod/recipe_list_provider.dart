import 'package:recipehub/src/core/base/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/recipe_entity.dart';
import '../../../../domain/use_cases/recipe_use_case.dart';

part 'recipe_list_provider.g.dart';

@riverpod
class RecipeListNotifier extends _$RecipeListNotifier {
  late GetRecipesUseCase _getRecipesUseCase;

  @override
  Future<List<RecipeListResponseEntity>> build() async {
    _getRecipesUseCase = ref.read(getRecipesUseCaseProvider);
    return await _loadRecipes();
  }

  Future<List<RecipeListResponseEntity>> _loadRecipes() async {
    final result = await _getRecipesUseCase.call();

    return switch (result) {
      Success(:final data) => data,
      Error(:final error) => throw Exception(error),
      _ => throw Exception('Unknown error'),
    };
  }
}
