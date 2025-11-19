import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/recipe_entity.dart';

class RecipesState {
  final AsyncValue<List<Recipe>> recipes;
  final bool hasMore;
  final int currentPage;
  final bool isRefreshing;

  const RecipesState({
    this.recipes = const AsyncValue.loading(),
    this.hasMore = true,
    this.currentPage = 0,
    this.isRefreshing = false,
  });

  RecipesState copyWith({
    AsyncValue<List<Recipe>>? recipes,
    bool? hasMore,
    int? currentPage,
    bool? isRefreshing,
  }) {
    return RecipesState(
      recipes: recipes ?? this.recipes,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  // Convenience getters
  // bool get isLoading => recipes.isLoading && !isRefreshing;
  // bool get hasError => recipes.hasError;
  String? get error => recipes.hasError ? recipes.error.toString() : null;
  List<Recipe> get recipeList => recipes.value ?? [];

  // === NEW ACCURATE GETTERS ===
  bool get isLoading =>
      recipes.maybeWhen(loading: () => true, orElse: () => false);

  bool get isInitialLoading =>
      recipes.maybeWhen(loading: () => recipeList.isEmpty, orElse: () => false);

  bool get isBackgroundLoading => recipes.maybeWhen(
    loading: () => recipeList.isNotEmpty,
    orElse: () => false,
  );

  bool get isHardError => recipes.maybeWhen(
    error: (_, __) => recipeList.isEmpty,
    orElse: () => false,
  );

  bool get isSoftError => recipes.maybeWhen(
    error: (_, __) => recipeList.isNotEmpty,
    orElse: () => false,
  );
}
