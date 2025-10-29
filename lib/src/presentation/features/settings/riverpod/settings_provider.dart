import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utiliity/jwt_utility.dart';
import '../../../../data/services/cache/cache_service.dart' as cache;

final userEmailProvider = FutureProvider<String?>((ref) async {
  final cacheService = ref.watch(cacheServiceProvider);
  final token = cacheService.get<String>(cache.CacheKey.accessToken);

  if (token == null) return null;

  return JwtUtility.getEmailFromToken(token);
});
