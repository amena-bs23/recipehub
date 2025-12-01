import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/authentication_repository_impl.dart';
import '../../data/repositories/recipe_repository_impl.dart'; // Add this import
import '../../data/services/cache/cache_service.dart'; // Add this import
import '../../data/services/network/endpoints.dart';
import '../../data/services/network/interceptor/token_manager.dart';
import '../../data/services/network/rest_client.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/repositories/recipe_repository.dart'; // Add this import
import '../../domain/use_cases/authentication_use_case.dart';
import '../../domain/use_cases/favorite_use_case.dart'; // Add this if exists
import '../../domain/use_cases/recipe_use_case.dart'; // Add this if exists

part 'dependency_injection.g.dart';
part 'parts/externals.dart';
part 'parts/repository.dart';
part 'parts/services.dart';
part 'parts/use_cases.dart';
