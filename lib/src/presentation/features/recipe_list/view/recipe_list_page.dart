import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/search_provider.dart';
import '../../shared/widgets/app_drawer.dart';
import '../../shared/widgets/search_bar.dart';
import '../widgets/recipe_list_section.dart';

class RecipeListPage extends ConsumerWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch search state for filtering recipes
    final searchState = ref.watch(searchProvider(SearchType.recipes));

    return Scaffold(
      appBar: AppBar(title: const Text('RecipeHub')),
      drawer: const AppDrawer(), // Add drawer
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: trigger provider refresh
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RecipeSearchBar(
                  searchType: SearchType.recipes, // Pass search type
                ),
              ),
              SizedBox(height: 16),
              RecipeListSection(
                // Pass search filters to section
                query: searchState.query,
                difficulty: searchState.difficulty,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
