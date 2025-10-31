import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/recipe_card.dart';
import '../riverpod/recipes_provider.dart';
import 'recipe_list_section_widgets.dart';

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
    // ref is available in ConsumerStatefulWidget's initState
    ref.read(recipesNotifierProvider.notifier).loadRecipes(
          query: widget.query.isEmpty ? null : widget.query,
          difficulty: widget.difficulty,
        );

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
      return const RecipeListLoadingSkeleton();
    }

    if (state.error != null && state.recipes.isEmpty) {
      return RecipeListErrorWidget(
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
      return const RecipeListEmptyWidget();
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
              return const RecipeCardSkeleton();
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
