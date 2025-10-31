import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/providers/search_provider.dart';
import '../../shared/widgets/recipe_card.dart';
import '../riverpod/recipes_provider.dart';

class RecipeListSection extends ConsumerStatefulWidget {
  const RecipeListSection({super.key});

  @override
  ConsumerState<RecipeListSection> createState() => _RecipeListSectionState();
}

class _RecipeListSectionState extends ConsumerState<RecipeListSection> {
  final ScrollController _scrollController = ScrollController();
  String? _lastQuery;
  String? _lastDifficulty;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchState = ref.read(searchProvider(SearchType.recipes));
      _lastQuery = searchState.query.isEmpty ? null : searchState.query;
      _lastDifficulty = searchState.difficulty;
      
      ref.read(recipesNotifierProvider.notifier).loadRecipes(
            query: _lastQuery,
            difficulty: _lastDifficulty,
            refresh: false,
          );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final recipesState = ref.read(recipesNotifierProvider);
      final searchState = ref.read(searchProvider(SearchType.recipes));
      
      if (!recipesState.isLoading && recipesState.hasMore) {
        ref.read(recipesNotifierProvider.notifier).loadRecipes(
              query: searchState.query.isEmpty ? null : searchState.query,
              difficulty: searchState.difficulty,
            );
      }
    }
  }

  void _loadRecipesIfNeeded() {
    final searchState = ref.read(searchProvider(SearchType.recipes));
    final query = searchState.query.isEmpty ? null : searchState.query;
    final difficulty = searchState.difficulty;

    // Only reload if query or difficulty changed
    if (_lastQuery != query || _lastDifficulty != difficulty) {
      _lastQuery = query;
      _lastDifficulty = difficulty;
      
      ref.read(recipesNotifierProvider.notifier).loadRecipes(
            query: query,
            difficulty: difficulty,
            refresh: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch search state to trigger reloads when it changes
    final searchState = ref.watch(searchProvider(SearchType.recipes));
    final recipesState = ref.watch(recipesNotifierProvider);

    // Trigger load when search state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecipesIfNeeded();
    });

    if (recipesState.isLoading && recipesState.recipes.isEmpty) {
      return const _LoadingSkeleton();
    }

    if (recipesState.error != null && recipesState.recipes.isEmpty) {
      return _ErrorWidget(
        error: recipesState.error!,
        onRetry: () {
          ref.read(recipesNotifierProvider.notifier).loadRecipes(
                query: searchState.query.isEmpty ? null : searchState.query,
                difficulty: searchState.difficulty,
                refresh: true,
              );
        },
      );
    }

    if (recipesState.recipes.isEmpty && !recipesState.isLoading) {
      return const _EmptyWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'All Recipes (${recipesState.recipes.length})',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: recipesState.recipes.length + (recipesState.isLoading ? 2 : 0),
          itemBuilder: (context, index) {
            if (index >= recipesState.recipes.length) {
              return _RecipeCardSkeleton();
            }

            final recipe = recipesState.recipes[index];
            return RecipeCard(
              recipe: recipe,
              onTap: () {
                context.go('/recipe/${recipe.id}');
              },
              onFavoriteToggle: () {
                ref
                    .read(recipesNotifierProvider.notifier)
                    .toggleFavorite(recipe);
              },
            );
          },
        ),
        if (recipesState.isLoading && recipesState.recipes.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _RecipeCardSkeleton(),
    );
  }
}

class _RecipeCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container(color: Colors.white)),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 100, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading recipes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No recipes found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

