import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipehub/src/presentation/core/router/routes.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../domain/entities/recipe_entity.dart';
import '../riverpod/recipe_detail_provider.dart';

class RecipeDetailPage extends ConsumerStatefulWidget {
  const RecipeDetailPage({super.key, required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends ConsumerState<RecipeDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recipeDetailNotifierProvider.notifier)
          .loadRecipe(widget.recipeId);
    });
  }

  void onFavoriteToggle() {
    ref.read(recipeDetailNotifierProvider.notifier).toggleFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipeDetailNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(Routes.home);
                  }
                },
              ),
            ),
            flexibleSpace: state.isLoading
                ? FlexibleSpaceBar(
                    background: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.grey[300]),
                    ),
                  )
                : FlexibleSpaceBar(
                    background: state.recipe != null
                        ? CachedNetworkImage(
                            imageUrl: state.recipe!.imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                          )
                        : null,
                  ),
            actions: [
              if (state.recipe != null)
                Semantics(
                  label: state.recipe!.isFavorite
                      ? 'favorite_${state.recipe!.id}'
                      : 'not_favorite_${state.recipe!.id}',
                  button: true,
                  onTap: onFavoriteToggle,
                  child: IconButton(
                    icon: Icon(
                      state.recipe!.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: state.recipe!.isFavorite
                          ? Colors.red
                          : Colors.white,
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: state.isLoading
                ? const _LoadingContent()
                : state.error != null
                ? _ErrorContent(
                    error: state.error!,
                    onRetry: () {
                      ref
                          .read(recipeDetailNotifierProvider.notifier)
                          .loadRecipe(widget.recipeId);
                    },
                  )
                : state.recipe != null
                ? _RecipeContent(recipe: state.recipe!)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _RecipeContent extends StatelessWidget {
  const _RecipeContent({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            recipe.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _InfoChip(
                icon: Icons.access_time,
                label: '${recipe.cookingTime} min',
              ),
              const SizedBox(width: 16),
              _InfoChip(
                icon: Icons.trending_up,
                label: recipe.difficulty.name.toUpperCase(),
                color: _getDifficultyColor(recipe.difficulty),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Ingredients',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...recipe.ingredients.map(
            (ingredient) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ingredient,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Instructions',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...recipe.steps.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color != null ? Colors.white : null),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color != null ? Colors.white : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 24, width: 200, color: Colors.white),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                Container(height: 20, width: 150, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            error.contains('404') ? 'Recipe not found' : 'Error loading recipe',
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
    );
  }
}
