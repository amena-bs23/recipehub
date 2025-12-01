import 'dart:async';

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../models/recipe_model.dart';
import '../services/cache/cache_service.dart'; // Add this import
import '../services/network/rest_client.dart'; // Add this import

final class RecipeRepositoryImpl extends RecipeRepository {
  RecipeRepositoryImpl({required this.remote, required this.local});

  final RestClient remote; // Change from Dio
  final CacheService local; // Change from cacheService

  Set<String> get _favoriteIds {
    final cached = local.get<Set<String>>(CacheKey.favoriteRecipeIds);
    return cached ?? {};
  }

  Future<void> _saveFavoriteIds(Set<String> ids) async {
    await local.save(CacheKey.favoriteRecipeIds, ids);
  }

  @override
  FutureOr<Set<String>> getFavoriteIds() {
    try {
      return local.get<Set<String>>(CacheKey.favoriteRecipeIds) ?? <String>{};
    } catch (e) {
      return <String>{};
    }
  }

  @override
  Future<bool> saveFavoriteIds(Set<String> favoriteIds) async {
    try {
      await local.save(CacheKey.favoriteRecipeIds, favoriteIds);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Result<List<RecipeListResponseEntity>, Failure>> getRecipes({
    int skip = 0,
    int limit = 30,
    String? query,
    String? difficulty,
  }) async {
    return asyncGuard(() async {
      // Use RestClient instead of direct Dio call
      final response = await remote.getRecipes(
        skip: skip,
        limit: limit,
        query: query,
      );

      // Parse response similar to AuthenticationRepositoryImpl
      final responseData = response.data['recipes'] as List<dynamic>? ?? [];
      final recipeModel = responseData
          .map((json) => RecipeModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return recipeModel.map((item) => item.toListEntity()).toList();

      /*final recipeListModel =
          (responseData['recipes'] as List<dynamic>?)
              ?.map(
                (json) => RecipeModel.fromJson(json as Map<String, dynamic>),
              )
              .toList() ??
          [];

      // Convert to RecipeListResponseEntity with proper isFavorite flag.
      final favoriteIds = _favoriteIds;
      List<RecipeListResponseEntity> recipes = recipeListModel
          .map(
            (model) => model.toListEntity(
              isFavorite: favoriteIds.contains(model.id.toString()),
            ),
          )
          .toList();

      // Filter by difficulty if provided
      if (difficulty != null && difficulty.isNotEmpty && difficulty != 'All') {
        recipes = recipes.where((recipe) {
          return recipe.difficulty.name.toLowerCase() ==
              difficulty.toLowerCase();
        }).toList();
      }

      return recipes;*/
    });
  }

  @override
  Future<Result<RecipeDetailsResponseEntity, Failure>> getRecipeById(
    String id,
  ) async {
    return asyncGuard(() async {
      // Use RestClient
      final response = await remote.getRecipeById(id);

      final model = RecipeModel.fromJson(response.data);
      final favoriteIds = _favoriteIds;

      // Save to recently viewed
      await _addToRecentlyViewed(id);

      return model.toDetailsEntity();
    });
  }

  /*@override
  Future<Result<List<Recipe>, Failure>> searchRecipes(String query) async {
    return asyncGuard(() async {
      // Use RestClient
      final response = await remote.searchRecipes(query);

      final data = response.data;
      final recipeListResponse = RecipeListResponseModel.fromJson(data);
      final favoriteIds = _favoriteIds;

      return recipeListResponse.recipes
          .map(
            (model) => model.toEntity(
              isFavorite: favoriteIds.contains(model.id.toString()),
            ),
          )
          .toList();
    });
  }*/

  @override
  Future<Result<void, Failure>> toggleFavorite(String recipeId) async {
    return asyncGuard(() async {
      final favoriteIds = Set<String>.from(_favoriteIds);

      if (favoriteIds.contains(recipeId)) {
        favoriteIds.remove(recipeId);
      } else {
        favoriteIds.add(recipeId);
      }

      await _saveFavoriteIds(favoriteIds);
      return;
    });
  }

  Future<void> _addToRecentlyViewed(String recipeId) async {
    final viewed = List<String>.from(
      local.get<List<String>>(CacheKey.recentlyViewedRecipeIds) ?? [],
    );

    viewed.remove(recipeId);
    viewed.insert(0, recipeId);

    // Keep only last 10
    if (viewed.length > 10) {
      viewed.removeRange(10, viewed.length);
    }

    await local.save(CacheKey.recentlyViewedRecipeIds, viewed);
  }

  List<String> getRecentlyViewed() {
    return List<String>.from(
      local.get<List<String>>(CacheKey.recentlyViewedRecipeIds) ?? [],
    );
  }
}
