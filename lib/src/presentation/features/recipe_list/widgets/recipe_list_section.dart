import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/widgets/recipe_card.dart';
import '../riverpod/recipes_provider.dart';

class RecipeListSection extends ConsumerStatefulWidget {
  const RecipeListSection({super.key, required this.query, this.difficulty});

  final String query;
  final String? difficulty;

  @override
  ConsumerState<RecipeListSection> createState() => _RecipeListSectionState();
}

class _RecipeListSectionState extends ConsumerState<RecipeListSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recipesNotifierProvider.notifier)
          .loadRecipes(
            query: widget.query.isEmpty ? null : widget.query,
            difficulty: widget.difficulty,
          );
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(RecipeListSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query ||
        oldWidget.difficulty != widget.difficulty) {
      ref
          .read(recipesNotifierProvider.notifier)
          .loadRecipes(
            query: widget.query.isEmpty ? null : widget.query,
            difficulty: widget.difficulty,
            refresh: true,
          );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = ref.read(recipesNotifierProvider);
      if (!state.isLoading && state.hasMore) {
        ref
            .read(recipesNotifierProvider.notifier)
            .loadRecipes(
              query: widget.query.isEmpty ? null : widget.query,
              difficulty: widget.difficulty,
            );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipesNotifierProvider);

    if (state.isLoading && state.recipes.isEmpty) {
      return const _LoadingSkeleton();
    }

    if (state.error != null && state.recipes.isEmpty) {
      return _ErrorWidget(
        error: state.error!,
        onRetry: () {
          ref
              .read(recipesNotifierProvider.notifier)
              .loadRecipes(
                query: widget.query.isEmpty ? null : widget.query,
                difficulty: widget.difficulty,
                refresh: true,
              );
        },
      );
    }

    if (state.recipes.isEmpty) {
      return const _EmptyWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'All Recipes (${state.recipes.length})',
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
          itemCount: state.recipes.length + (state.isLoading ? 2 : 0),
          itemBuilder: (context, index) {
            if (index >= state.recipes.length) {
              return _RecipeCardSkeleton();
            }

            final recipe = state.recipes[index];
            return RecipeCard(
              recipe: recipe,
              onTap: () {
                // Navigate to detail
                // context.go('/recipe/${recipe.id}');
              },
              onFavoriteToggle: () {
                ref
                    .read(recipesNotifierProvider.notifier)
                    .toggleFavorite(recipe);
              },
            );
          },
        ),
        if (state.isLoading && state.recipes.isNotEmpty)
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

