import '../../domain/entities/recipe_entity.dart';

class RecipeModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final List<String> ingredients;
  final List<String> instructions;
  final String difficulty;
  final double rating;
  final int reviewCount;

  RecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.ingredients,
    required this.instructions,
    required this.difficulty,
    required this.rating,
    required this.reviewCount,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      image: json['image'] as String,
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] as int? ?? 0,
      ingredients: List<String>.from(json['ingredients'] as List? ?? []),
      instructions: List<String>.from(json['instructions'] as List? ?? []),
      difficulty: json['difficulty'] as String? ?? 'Easy',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image,
    'prepTimeMinutes': prepTimeMinutes,
    'cookTimeMinutes': cookTimeMinutes,
    'ingredients': ingredients,
    'instructions': instructions,
    'difficulty': difficulty,
    'rating': rating,
    'reviewCount': reviewCount,
  };

  Recipe toEntity({bool isFavorite = false}) {
    Difficulty difficultyEnum;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        difficultyEnum = Difficulty.easy;
        break;
      case 'medium':
        difficultyEnum = Difficulty.medium;
        break;
      case 'hard':
        difficultyEnum = Difficulty.hard;
        break;
      default:
        difficultyEnum = Difficulty.easy;
    }

    return Recipe(
      id: id.toString(),
      title: name,
      description: description,
      imageUrl: image,
      cookingTime: prepTimeMinutes + cookTimeMinutes,
      difficulty: difficultyEnum,
      ingredients: ingredients,
      steps: instructions,
      isFavorite: isFavorite,
    );
  }
}

class RecipeListResponse {
  final List<RecipeModel> recipes;
  final int total;
  final int skip;
  final int limit;

  RecipeListResponse({
    required this.recipes,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory RecipeListResponse.fromJson(Map<String, dynamic> json) {
    return RecipeListResponse(
      recipes: (json['recipes'] as List? ?? [])
          .map((item) => RecipeModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}
