import '../../../../domain/entities/recipe_entity.dart';

class RecipesState {
  final List<Recipe> recipes;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const RecipesState({
    this.recipes = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 0,
  });

  RecipesState copyWith({
    List<Recipe>? recipes,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return RecipesState(
      recipes: recipes ?? this.recipes,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

