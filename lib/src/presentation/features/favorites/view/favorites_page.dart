import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/search_provider.dart';
import '../../shared/widgets/app_drawer.dart';
import '../../shared/widgets/recipe_card.dart';
import '../../shared/widgets/search_bar.dart';
import '../providers/favorites_provider.dart';
import '../widgets/favorites_page_widgets.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider(SearchType.favorites));
    final favoritesState = ref.watch(favoritesNotifierProvider);

    final filteredFavorites = ref
        .read(favoritesNotifierProvider.notifier)
        .filterFavorites(searchState.query, searchState.difficulty);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(favoritesNotifierProvider.notifier)
              .loadFavorites(refresh: true);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RecipeSearchBar(searchType: SearchType.favorites),
              ),
              const SizedBox(height: 16),
              if (favoritesState.isLoading && favoritesState.favorites.isEmpty)
                const FavoritesLoadingGrid()
              else if (favoritesState.error != null &&
                  favoritesState.favorites.isEmpty)
                FavoritesErrorWidget(
                  error: favoritesState.error!,
                  onRetry: () {
                    ref
                        .read(favoritesNotifierProvider.notifier)
                        .loadFavorites(refresh: true);
                  },
                )
              else if (filteredFavorites.isEmpty)
                const FavoritesEmptyWidget()
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Favorites (${filteredFavorites.length})',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: filteredFavorites.length,
                        itemBuilder: (context, index) {
                          final recipe = filteredFavorites[index];
                          return RecipeCard(
                            recipe: recipe,
                            onTap: () {
                              // Navigate to detail
                              // context.go('/recipe/${recipe.id}');
                            },
                            onFavoriteToggle: () {
                              ref
                                  .read(favoritesNotifierProvider.notifier)
                                  .toggleFavorite(recipe);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
