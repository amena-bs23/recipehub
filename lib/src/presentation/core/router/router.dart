import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/favorites/view/favorites_page.dart';
import '../../features/recipe_detail/view/recipe_detail_page.dart';
import '../../features/recipe_list/view/recipe_list_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/home', builder: (_, __) => const RecipeListPage()),
      GoRoute(path: '/favorites', builder: (_, __) => const FavoritesPage()),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RecipeDetailPage(recipeId: id);
        },
      ),
    ],
  );
});
