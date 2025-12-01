import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/recipe_entity.dart';
import '../../../../domain/use_cases/favorite_use_case.dart';
import '../../../../domain/use_cases/recipe_use_case.dart';

class FavoritesState {
  final List<Recipe> favorites;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  FavoritesState copyWith({
    List<Recipe>? favorites,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
    );
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier(
    this._getRecipesUseCase,
    this._toggleFavoriteUseCase,
    this._ref,
  ) : super(const FavoritesState()) {
    loadFavorites();
  }

  final GetRecipesUseCase _getRecipesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final Ref _ref;

  Future<void> loadFavorites({bool refresh = false}) async {
    state = state.copyWith(
      isLoading: !refresh,
      isRefreshing: refresh,
      error: null,
    );

    // Load all recipes and filter favorites
    final result = await _getRecipesUseCase.call(limit: 100);

    /*state = switch (result) {
      Success(:final data) => () {
        final favorites = data.where((r) => r.isFavorite).toList();
        return state.copyWith(
          favorites: favorites,
          isLoading: false,
          isRefreshing: false,
          error: null,
        );
      }(),
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
    };*/
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    final result = await _toggleFavoriteUseCase.call(recipe.id);

    state = switch (result) {
      Success() => () {
        final newState = recipe.isFavorite
            ? // Remove from favorites
              state.copyWith(
                favorites: state.favorites
                    .where((r) => r.id != recipe.id)
                    .toList(),
              )
            : // Add to favorites
              state.copyWith(
                favorites: [
                  ...state.favorites,
                  recipe.copyWith(isFavorite: true),
                ],
              );

        // Invalidate recipes provider to sync state
        // This will cause it to reload with fresh data when accessed
        /*_ref.invalidate(recipesNotifierProvider);*/

        return newState;
      }(),
      Error(:final error) => state.copyWith(error: error.message),
      _ => state.copyWith(error: 'Something went wrong'),
    };
  }

  List<Recipe> filterFavorites(String query, String? difficulty) {
    var filtered = state.favorites;

    if (query.isNotEmpty) {
      filtered = filtered
          .where(
            (r) =>
                r.title.toLowerCase().contains(query.toLowerCase()) ||
                r.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    if (difficulty != null && difficulty.isNotEmpty && difficulty != 'All') {
      filtered = filtered.where((r) {
        return r.difficulty.name.toLowerCase() == difficulty.toLowerCase();
      }).toList();
    }

    return filtered;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
      final getRecipesUseCase = ref.read(getRecipesUseCaseProvider);
      final toggleFavoriteUseCase = ref.read(toggleFavoriteUseCaseProvider);
      return FavoritesNotifier(getRecipesUseCase, toggleFavoriteUseCase, ref);
    });
