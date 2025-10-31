import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Search type enum to distinguish between recipe list and favorites
enum SearchType { recipes, favorites }

// Search state
class SearchState {
  final String query; // The committed search query (used for filtering)
  final String pendingQuery; // The current text field value (for UI display)
  final String? difficulty;

  SearchState({
    required this.query,
    required this.pendingQuery,
    this.difficulty,
  });

  bool get isEmpty =>
      query.isEmpty && (difficulty == null || difficulty == 'All');

  bool get hasPendingText => pendingQuery.isNotEmpty;
}

// Search Notifier using Family for independent search states
class SearchNotifier extends FamilyNotifier<SearchState, SearchType> {
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 500);

  @override
  SearchState build(SearchType searchType) {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return SearchState(query: '', pendingQuery: '', difficulty: 'All');
  }

  /// Update the pending query immediately (for text field display)
  /// This will trigger debounced commit to actual query
  void updatePendingQuery(String pendingQuery) {
    state = SearchState(
      query: state.query,
      pendingQuery: pendingQuery,
      difficulty: state.difficulty,
    );

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Schedule debounced commit
    _debounceTimer = Timer(_debounceDelay, () {
      commitPendingQuery();
    });
  }

  /// Commit the pending query to the actual query (triggers search)
  void commitPendingQuery() {
    _debounceTimer?.cancel();
    state = SearchState(
      query: state.pendingQuery,
      pendingQuery: state.pendingQuery,
      difficulty: state.difficulty,
    );
  }

  /// Update difficulty immediately (no debounce)
  /// Commits any pending query first, then updates difficulty
  void updateDifficulty(String? difficulty, {String? pendingQuery}) {
    _debounceTimer?.cancel();
    // Commit any pending query before changing difficulty
    final queryToCommit = pendingQuery ?? state.pendingQuery;
    state = SearchState(
      query: queryToCommit,
      pendingQuery: queryToCommit,
      difficulty: difficulty ?? 'All',
    );
  }

  /// Update search query and difficulty immediately (no debounce)
  void updateSearch(String query, String? difficulty) {
    _debounceTimer?.cancel();
    state = SearchState(
      query: query,
      pendingQuery: query,
      difficulty: difficulty ?? 'All',
    );
  }

  /// Clear search immediately
  void clearSearch() {
    _debounceTimer?.cancel();
    state = SearchState(
      query: '',
      pendingQuery: '',
      difficulty: 'All',
    );
  }
}

// Provider definition
final searchProvider =
    NotifierProvider.family<SearchNotifier, SearchState, SearchType>(
      SearchNotifier.new,
    );
