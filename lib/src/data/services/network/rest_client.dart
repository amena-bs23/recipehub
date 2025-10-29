import 'package:dio/dio.dart';

import 'endpoints.dart';

class RestClient {
  RestClient(this.dio, {this.baseUrl});

  final Dio dio;
  final String? baseUrl;

  Future<Response> login(Map<String, dynamic> request) async {
    return dio.post(baseUrl! + Endpoints.login, data: request);
  }
}
