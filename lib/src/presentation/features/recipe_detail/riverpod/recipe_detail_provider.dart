import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipehub/src/presentation/features/favorites/providers/favorites_provider.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/recipe_entity.dart';
import '../../../../domain/use_cases/favorite_use_case.dart';
import '../../../../domain/use_cases/recipe_use_case.dart';

class RecipeDetailState {
  final Recipe? recipe;
  final bool isLoading;
  final String? error;

  const RecipeDetailState({this.recipe, this.isLoading = false, this.error});

  RecipeDetailState copyWith({Recipe? recipe, bool? isLoading, String? error}) {
    return RecipeDetailState(
      recipe: recipe ?? this.recipe,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class RecipeDetailNotifier extends StateNotifier<RecipeDetailState> {
  RecipeDetailNotifier(
    this._getRecipeByIdUseCase,
    this._toggleFavoriteUseCase,
    this._ref,
  ) : super(const RecipeDetailState());

  final GetRecipeByIdUseCase _getRecipeByIdUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final Ref _ref;

  Future<void> loadRecipe(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getRecipeByIdUseCase.call(id);

    state = switch (result) {
      Success(:final data) => state.copyWith(
        recipe: data,
        isLoading: false,
        error: null,
      ),
      Error(:final error) => state.copyWith(
        isLoading: false,
        error: error.message,
      ),
      _ => state.copyWith(isLoading: false, error: 'Something went wrong'),
    };
  }

  Future<void> toggleFavorite() async {
    if (state.recipe == null) return;

    final result = await _toggleFavoriteUseCase.call(state.recipe!.id);

    state = switch (result) {
      Success() => () {
        // Invalidate recipes and favorites providers to sync state
        /*_ref.invalidate(recipesNotifierProvider);*/
        _ref.invalidate(favoritesNotifierProvider);

        return state.copyWith(
          recipe: state.recipe!.copyWith(isFavorite: !state.recipe!.isFavorite),
        );
      }(),
      Error(:final error) => state.copyWith(error: error.message),
      _ => state.copyWith(error: 'Something went wrong'),
    };
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final recipeDetailNotifierProvider =
    StateNotifierProvider<RecipeDetailNotifier, RecipeDetailState>((ref) {
      final getRecipeByIdUseCase = ref.read(getRecipeByIdUseCaseProvider);
      final toggleFavoriteUseCase = ref.read(toggleFavoriteUseCaseProvider);
      return RecipeDetailNotifier(
        getRecipeByIdUseCase,
        toggleFavoriteUseCase,
        ref,
      );
    });
