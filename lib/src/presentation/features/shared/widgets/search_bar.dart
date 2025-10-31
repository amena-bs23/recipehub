import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_provider.dart';

class RecipeSearchBar extends ConsumerStatefulWidget {
  final SearchType searchType; // Add search type parameter

  const RecipeSearchBar({
    super.key,
    required this.searchType, // Make it required
  });

  @override
  ConsumerState<RecipeSearchBar> createState() => _RecipeSearchBarState();
}

class _RecipeSearchBarState extends ConsumerState<RecipeSearchBar> {
  final TextEditingController searchTextController = TextEditingController();
  late final searchNotifier = ref.read(
    searchProvider(widget.searchType).notifier,
  );

  @override
  void initState() {
    super.initState();
    // Sync controller with provider state on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(searchProvider(widget.searchType));
      searchTextController.text = currentState.query;
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch search state for difficulty changes
    final searchState = ref.watch(searchProvider(widget.searchType));

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: searchTextController,
            decoration: InputDecoration(
              hintText: 'Search recipes...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchState.query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchTextController.clear();
                        searchNotifier.updateQuery('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              // Real-time search update (or debounce if needed)
              searchNotifier.updateQuery(value);
            },
            onSubmitted: (value) {
              searchNotifier.updateSearch(value, searchState.difficulty);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<String>(
            value: searchState.difficulty,
            isDense: true,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'All', child: Text('All')),
              DropdownMenuItem(value: 'Easy', child: Text('Easy')),
              DropdownMenuItem(value: 'Medium', child: Text('Medium')),
              DropdownMenuItem(value: 'Hard', child: Text('Hard')),
            ],
            onChanged: (value) {
              searchNotifier.updateDifficulty(value);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
