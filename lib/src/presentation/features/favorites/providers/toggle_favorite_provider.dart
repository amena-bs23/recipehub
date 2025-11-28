import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipehub/src/core/di/dependency_injection.dart';

import '../../../../domain/use_cases/favorite_use_case.dart';

final toggleFavoriteNotifierProvider =
    AsyncNotifierProvider<ToggleFavoriteNotifier, Set<String>>(() {
      return ToggleFavoriteNotifier();
    });

class ToggleFavoriteNotifier extends AsyncNotifier<Set<String>> {
  late GetFavoriteIdsUseCase _getFavoriteIdsUseCase;
  @override
  FutureOr<Set<String>> build() async {
    _getFavoriteIdsUseCase = ref.read(getFavoriteIdsUseCaseProvider);
    return await _getFavoriteIdsUseCase.call();
  }

  bool isFavorite(String id) {
    return state.value?.contains(id) ?? false;
  }

  Future<void> addFavorite(String id) async {
    // state = const AsyncLoading();

    final favoriteIds = state.valueOrNull ?? <String>{};
    favoriteIds.add(id);
    state = AsyncData(favoriteIds);
    await _persist();
  }

  Future<void> removeFavorite(String id) async {
    final current = state.valueOrNull;
    if (current == null) return;
    // Copy
    final updated = {...current};
    // Remove
    updated.remove(id);
    // Update state
    state = AsyncData(updated);
    await _persist();
  }

  Future<void> _persist() async {
    // I will an use case to store the data through repository
  }

  /// Toggle helper: returns newValue
  Future<bool> toggle(String id) async {
    final favoriteIds = state.valueOrNull ?? <String>{};
    final newVal = !favoriteIds.contains(id);

    // optimistic update
    if (newVal) {
      addFavorite(id);
    } else {
      removeFavorite(id);
    }
    return newVal;
  }
}
