/*
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/recipe_entity.dart';
import '../../../../domain/use_cases/recipe_use_case.dart';
import 'recipes_state.dart';

class RecipesNotifier extends Notifier<RecipesState> {
  GetRecipesUseCase get _getRecipesUseCase =>
      ref.read(getRecipesUseCaseProvider);
  // FavoriteUseCase get _favoriteUseCase => ref.read(favoriteUseCaseProvider);

  static const int _pageSize = 30;

  @override
  RecipesState build() {
    return const RecipesState();
  }

  Future<void> loadRecipes({
    String? query,
    String? difficulty,
    bool refresh = false,
  }) async {
    // Get current recipes before loading
    final currentRecipes = state.recipeList;

    // Set loading state - preserve previous data if available (for pagination)
    if (refresh) {
      state = state.copyWith(
        isRefreshing: true,
        currentPage: 0,
        recipes: currentRecipes.isEmpty
            ? const AsyncValue.loading()
            : AsyncValue.data(
                currentRecipes,
              ), // Keep showing current data while refreshing
      );
    } else {
      // For pagination, keep showing current data
      if (currentRecipes.isNotEmpty) {
        // Don't change state, just keep current data visible
      } else {
        state = state.copyWith(recipes: const AsyncValue.loading());
      }
    }

    try {
      final result = await _getRecipesUseCase.call(
        skip: refresh ? 0 : currentRecipes.length,
        limit: _pageSize,
        query: query,
        difficulty: difficulty,
      );

      */
/*state = switch (result) {
        Success(:final data) => state.copyWith(
            recipes: AsyncValue.data(
              refresh ? data : [...currentRecipes, ...data],
            ),
            hasMore: data.length >= _pageSize,
            currentPage: refresh ? 0 : state.currentPage + 1,
            isRefreshing: false,
          ),
        Error(:final error) => state.copyWith(
            recipes: AsyncValue<List<Recipe>>.error(
              error,
              StackTrace.current,
            ),
            isRefreshing: false,
          ),
        _ => state.copyWith(
            recipes: AsyncValue<List<Recipe>>.error(
              'Something went wrong',
              StackTrace.current,
            ),
            isRefreshing: false,
          ),
      };*/ /*

    } catch (e, stackTrace) {
      state = state.copyWith(
        recipes: AsyncValue<List<Recipe>>.error(e, stackTrace),
        isRefreshing: false,
      );
    }
  }

  */
/*Future<void> toggleFavorite(RecipeListResponseEntity recipe) async {
    final result = await _toggleFavoriteUseCase.call(recipe.id);

    switch (result) {
      case Success():
        // Update local state
        final currentRecipes = state.recipeList;
        final updatedRecipes = currentRecipes.map((r) {
          if (r.id == recipe.id) {
            return recipe.copyWith(isFavorite: !recipe.isFavorite);
          }
          return r;
        }).toList();

        // state = state.copyWith(recipes: AsyncValue.data(updatedRecipes));

        // Invalidate favorites provider to sync state
        ref.invalidate(favoritesNotifierProvider);
      case Error(:final error):
        state = state.copyWith(
          recipes: AsyncValue<List<Recipe>>.error(error, StackTrace.current),
        );
      default:
        state = state.copyWith(
          recipes: AsyncValue<List<Recipe>>.error(
            'Something went wrong',
            StackTrace.current,
          ),
        );
    }
  }*/ /*

}

final recipesNotifierProvider = NotifierProvider<RecipesNotifier, RecipesState>(
  RecipesNotifier.new,
);
*/
