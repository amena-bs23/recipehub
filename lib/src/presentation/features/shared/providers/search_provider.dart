import 'package:flutter_riverpod/flutter_riverpod.dart';

// Search type enum to distinguish between recipe list and favorites
enum SearchType { recipes, favorites }

// Search state
class SearchState {
  final String query;
  final String? difficulty;

  SearchState({required this.query, this.difficulty});

  bool get isEmpty =>
      query.isEmpty && (difficulty == null || difficulty == 'All');
}

// Search Notifier using Family for independent search states
class SearchNotifier extends FamilyNotifier<SearchState, SearchType> {
  @override
  SearchState build(SearchType searchType) {
    return SearchState(query: '', difficulty: 'All');
  }

  void updateQuery(String query) {
    state = SearchState(query: query, difficulty: state.difficulty);
  }

  void updateDifficulty(String? difficulty) {
    state = SearchState(query: state.query, difficulty: difficulty ?? 'All');
  }

  void updateSearch(String query, String? difficulty) {
    state = SearchState(query: query, difficulty: difficulty ?? 'All');
  }

  void clearSearch() {
    state = SearchState(query: '', difficulty: 'All');
  }
}

// Provider definition
final searchProvider =
    NotifierProvider.family<SearchNotifier, SearchState, SearchType>(
      SearchNotifier.new,
    );
