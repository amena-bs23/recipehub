import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_provider.dart';

class RecipeSearchBar extends ConsumerStatefulWidget {
  final SearchType searchType;

  const RecipeSearchBar({
    super.key,
    required this.searchType,
  });

  @override
  ConsumerState<RecipeSearchBar> createState() => _RecipeSearchBarState();
}

class _RecipeSearchBarState extends ConsumerState<RecipeSearchBar> {
  final TextEditingController searchTextController = TextEditingController();
  String? _lastSyncedPendingQuery;

  @override
  void initState() {
    super.initState();
    // Sync controller with provider state on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(searchProvider(widget.searchType));
      searchTextController.text = currentState.pendingQuery;
      _lastSyncedPendingQuery = currentState.pendingQuery;
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch search state for all UI updates
    final searchState = ref.watch(searchProvider(widget.searchType));
    final searchNotifier = ref.read(searchProvider(widget.searchType).notifier);

    // Sync controller text with provider state if it changed externally
    // (e.g., when search is cleared programmatically)
    if (_lastSyncedPendingQuery != null &&
        searchState.pendingQuery != _lastSyncedPendingQuery &&
        searchTextController.text != searchState.pendingQuery) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          searchTextController.text = searchState.pendingQuery;
          _lastSyncedPendingQuery = searchState.pendingQuery;
        }
      });
    } else if (_lastSyncedPendingQuery == null) {
      _lastSyncedPendingQuery = searchState.pendingQuery;
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: searchTextController,
            decoration: InputDecoration(
              hintText: 'Search recipes...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchState.hasPendingText
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _lastSyncedPendingQuery = '';
                        searchTextController.clear();
                        searchNotifier.clearSearch();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              // Track the value we're updating to avoid sync loops
              _lastSyncedPendingQuery = value;
              // Update pending query in provider (triggers debounce)
              searchNotifier.updatePendingQuery(value);
            },
            onSubmitted: (value) {
              // Commit immediately on submit
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
              // Update difficulty and commit current text field value
              searchNotifier.updateDifficulty(
                value,
                pendingQuery: searchTextController.text,
              );
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              isDense: true,
            ),
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ],
    );
  }
}
