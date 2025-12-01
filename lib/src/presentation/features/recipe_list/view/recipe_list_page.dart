import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/search_provider.dart';
import '../../shared/widgets/app_drawer.dart';
import '../../shared/widgets/search_bar.dart';
import '../riverpod/recipe_list_provider.dart';
import '../widgets/loader_widget.dart';
import '../widgets/recipe_list_section.dart';

class RecipeListPage extends ConsumerWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider(SearchType.recipes));
    final recipesAsync = ref.watch(recipeListNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('RecipeHub')),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(recipeListNotifierProvider.notifier).loadRecipes();
          /*await ref
              .read(recipeNotifierProvider.notifier)
              ._loadRecipes(
            query: searchState.query.isEmpty ? null : searchState.query,
            difficulty: searchState.difficulty,
            refresh: true,
          );*/
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RecipeSearchBar(searchType: SearchType.recipes),
              ),
              const SizedBox(height: 16),
              recipesAsync.when(
                data: (recipeList) {
                  return RecipeListSection(recipeList: recipeList);
                  // return const Text('Hello World!');
                },
                error: (error, stack) => Text(error.toString()),
                loading: () => const Loader(),
              ),
              if (recipesAsync.isRefreshing) const Loader(),
            ],
          ),
        ),
      ),
    );
  }
}
