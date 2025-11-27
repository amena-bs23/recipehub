import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/providers/search_provider.dart';
import '../../shared/widgets/recipe_card.dart';
import '../riverpod/recipe_list_provider.dart';
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
        ref
            .read(recipesNotifierProvider.notifier)
            .loadRecipes(
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

      ref
          .read(recipesNotifierProvider.notifier)
          .loadRecipes(query: query, difficulty: difficulty, refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch search state to trigger reloads when it changes
    // final searchState = ref.watch(searchProvider(SearchType.recipes));
    final recipesAsync = ref.watch(recipeListNotifierProvider);

    return recipesAsync.when(
      data: (recipeList) {
        // return Text(recipeList.toString());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'All Recipes (${recipeList.length})',
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
              itemCount: recipeList.length + (recipesAsync.isLoading ? 2 : 0),
              itemBuilder: (context, index) {
                if (index >= recipeList.length) {
                  return _RecipeCardSkeleton();
                }

                final recipe = recipeList[index];
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
            if (recipesAsync.isRefreshing) const _Loader(),
          ],
        );
      },
      error: (error, stack) => Text(error.toString()),
      loading: () => const _Loader(),
    );
  }
}

/*
class _RecipeList extends StatelessWidget {
  const _RecipeList(this.recipeList);

  final List<RecipeListResponseEntity> recipeList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'All Recipes (${recipeList.length})',
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
          itemCount: recipeList.length + (recipesState.isLoading ? 2 : 0),
          itemBuilder: (context, index) {
            if (index >= recipeList.length) {
              return _RecipeCardSkeleton();
            }

            final recipe = recipeList[index];
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
        if (recipesState.isLoading && recipeList.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
*/

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

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
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
