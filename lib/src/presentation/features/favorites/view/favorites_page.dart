import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/search_provider.dart';
import '../../shared/widgets/app_drawer.dart';
import '../../shared/widgets/search_bar.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Independent search state for favorites
    final searchState = ref.watch(searchProvider(SearchType.favorites));

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      drawer: const AppDrawer(), // Same drawer
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: refresh favorites
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
                  searchType: SearchType.favorites, // Different search type
                ),
              ),
              SizedBox(height: 16),
              // Filter and display favorites based on searchState
              // TODO: Implement filtered favorites list
              if (searchState.isEmpty)
                const Center(child: Text('No favorites yet'))
              else
                Text('Searching: ${searchState.query}'),
            ],
          ),
        ),
      ),
    );
  }
}
