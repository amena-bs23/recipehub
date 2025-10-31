import 'package:dio/dio.dart';

import 'endpoints.dart';

class RestClient {
  RestClient(this.dio, {this.baseUrl});

  final Dio dio;
  final String? baseUrl;

  Future<Response> login(Map<String, dynamic> request) async {
    return dio.post(baseUrl! + Endpoints.login, data: request);
  }

  Future<Response> getRecipes({
    int skip = 0,
    int limit = 30,
    String? query,
  }) async {
    final queryParams = <String, dynamic>{
      'skip': skip,
      'limit': limit,
    };

    String endpoint = Endpoints.recipes;
    if (query != null && query.isNotEmpty) {
      endpoint = Endpoints.recipeSearch(query);
    }

    return dio.get(
      baseUrl! + endpoint,
      queryParameters: queryParams,
    );
  }

  Future<Response> getRecipeById(String id) async {
    return dio.get(baseUrl! + Endpoints.recipeById(int.parse(id)));
  }

  Future<Response> searchRecipes(String query) async {
    return dio.get(baseUrl! + Endpoints.recipeSearch(query));
  }
}
