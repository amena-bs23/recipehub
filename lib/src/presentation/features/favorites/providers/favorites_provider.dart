import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteNotifier extends Notifier<Set<Recipe>> {
  @override
  Set<Recipe> build() {
    return {};
  }

  void addFavorite(Recipe recipe) {
    if (!state.contains(recipe)) {
      state = {...state, recipe};
    }
  }

  void removeFavorite(Recipe recipe) {
    if (state.contains(recipe)) {
      state = state.where((p) => p.id != recipe.id).toSet();
      // state = {...state}..remove(recipe); // IF a entire recipe object is passing to this method instead of sending recipe.id
    }
  }

  void clearFavorites() {
    state = {};
  }
}

// final favoriteNotifierProvider =
//     NotifierProvider<FavoriteNotifier, Set<Recipe>>(() {
//       return FavoriteNotifier();
//     });

final favoriteNotifierProvider =
    NotifierProvider<FavoriteNotifier, Set<Recipe>>(() => FavoriteNotifier());

// NotifierProvider is how you register your Notifier with Riverpod’s dependency system.
// It’s what makes your FavoriteNotifier available throughout your app.

// Its generic syntax is:
//
// NotifierProvider<NotifierType, StateType>(
// () => NotifierInstance,
// );

class Recipe {
  Recipe({this.id, this.name, this.image});

  final int? id;
  final String? name;
  final String? image;
}
