import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipehub/src/domain/entities/recipe_entity.dart';
import 'package:recipehub/src/presentation/features/recipe_list/widgets/recipe_card_skeleton_widget.dart';

import '../../shared/widgets/recipe_card.dart';

class RecipeListSection extends ConsumerStatefulWidget {
  const RecipeListSection({super.key, required this.recipeList});

  final List<RecipeListResponseEntity> recipeList;

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
    // _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /*void _onScroll() {
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
  }*/

  /*void _loadRecipesIfNeeded() {
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
  }*/

  @override
  Widget build(BuildContext context) {
    // Watch search state to trigger reloads when it changes
    // final searchState = ref.watch(searchProvider(SearchType.recipes));
    // final recipesAsync = ref.watch(recipeListNotifierProvider);

    // return Text(widget.recipeList.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'All Recipes (${widget.recipeList.length})',
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
          itemCount: widget.recipeList.length,
          itemBuilder: (context, index) {
            if (index >= widget.recipeList.length) {
              return const RecipeCardSkeleton();
            }

            final recipe = widget.recipeList[index];
            return RecipeCard(
              recipe: recipe,
              onTap: () {
                context.go('/recipe/${recipe.id}');
              },
              onFavoriteToggle: () {
                /*ref
                        .read(recipesNotifierProvider.notifier)
                        .toggleFavorite(recipe);*/
              },
            );
          },
        ),
      ],
    );

    /*return recipesAsync.when(
      data: (recipeList) {
        // return Text(recipeList.toString());

      },
      error: (error, stack) => Text(error.toString()),
      loading: () => const Loader(),
    );*/
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
