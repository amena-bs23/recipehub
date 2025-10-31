import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/recipe_entity.dart';
import '../../../../domain/use_cases/recipe_use_case.dart';
import 'recipes_state.dart';

class RecipesNotifier extends StateNotifier<RecipesState> {
  RecipesNotifier(this._getRecipesUseCase, this._toggleFavoriteUseCase)
      : super(const RecipesState());

  final GetRecipesUseCase _getRecipesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  static const int _pageSize = 30;

  Future<void> loadRecipes({
    String? query,
    String? difficulty,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(
        isRefreshing: true,
        error: null,
        currentPage: 0,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    final result = await _getRecipesUseCase.call(
      skip: refresh ? 0 : state.recipes.length,
      limit: _pageSize,
      query: query,
      difficulty: difficulty,
    );

    state = switch (result) {
      Success(:final data) => state.copyWith(
          recipes: refresh ? data : [...state.recipes, ...data],
          isLoading: false,
          isRefreshing: false,
          hasMore: data.length >= _pageSize,
          currentPage: refresh ? 0 : state.currentPage + 1,
          error: null,
        ),
      Error(:final error) => state.copyWith(
          isLoading: false,
          isRefreshing: false,
          error: error.message,
        ),
      _ => state.copyWith(
          isLoading: false,
          isRefreshing: false,
          error: 'Something went wrong',
        ),
    };
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    final result = await _toggleFavoriteUseCase.call(recipe.id);

    state = switch (result) {
      Success() => () {
          // Update local state
          final updatedRecipes = state.recipes.map((r) {
            if (r.id == recipe.id) {
              return recipe.copyWith(isFavorite: !recipe.isFavorite);
            }
            return r;
          }).toList();
          return state.copyWith(recipes: updatedRecipes);
        }(),
      Error(:final error) => state.copyWith(error: error.message),
      _ => state.copyWith(error: 'Something went wrong'),
    };
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final recipesNotifierProvider =
    StateNotifierProvider<RecipesNotifier, RecipesState>((ref) {
  final getRecipesUseCase = ref.read(getRecipesUseCaseProvider);
  final toggleFavoriteUseCase = ref.read(toggleFavoriteUseCaseProvider);
  return RecipesNotifier(getRecipesUseCase, toggleFavoriteUseCase);
});
