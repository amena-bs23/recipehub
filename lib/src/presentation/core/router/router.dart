import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipehub/src/presentation/core/router/routes.dart';

import '../../features/favorites/view/favorites_page.dart';
import '../../features/recipe_detail/view/recipe_detail_page.dart';
import '../../features/recipe_list/view/recipe_list_page.dart';
import '../../features/splash/view/splash_page.dart';
import '../widgets/app_startup/startup_widget.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.initial,
    routes: [
      GoRoute(
        path: Routes.initial,
        name: Routes.initial,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: AppStartupWidget(
              loading: SplashPage(),
              loaded: RecipeListPage(),
            ),
          );
        },
      ),
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
