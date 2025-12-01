import '../../domain/entities/recipe_entity.dart';

class RecipeModel {
  RecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.ingredients,
    required this.steps,
    required this.instructions,
    required this.difficulty,
    required this.rating,
    required this.reviewCount,
  });

  final int id;
  final String name;
  final String description;
  final String image;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final List<String> ingredients;
  final List<String> steps;
  final List<String> instructions;
  final Difficulty difficulty;
  final double rating;
  final int reviewCount;

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      image: json['image'] as String,
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] as int? ?? 0,
      ingredients: List<String>.from(json['ingredients'] as List? ?? []),
      steps: List<String>.from(json['steps'] as List? ?? []),
      instructions: List<String>.from(json['instructions'] as List? ?? []),
      difficulty: difficultyFromJson(json['difficulty'] as String?),
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
    return Recipe(
      id: id.toString(),
      title: name,
      description: description,
      imageUrl: image,
      cookingTime: prepTimeMinutes + cookTimeMinutes,
      difficulty: difficulty,
      ingredients: ingredients,
      steps: instructions,
      isFavorite: isFavorite,
    );
  }

  RecipeListResponseEntity toListEntity() {
    return RecipeListResponseEntity(
      id: id.toString(),
      name: name,
      image: image,
      cookTimeMinutes: cookTimeMinutes,
      difficulty: difficulty,
    );
  }

  RecipeDetailsResponseEntity toDetailsEntity({bool isFavorite = false}) {
    return RecipeDetailsResponseEntity(
      id: id.toString(),
      name: name,
      image: image,
      cookTimeMinutes: cookTimeMinutes,
      difficulty: difficulty,
      isFavorite: isFavorite,
      description: description,
      ingredients: ingredients,
      steps: steps,
    );
  }
}

/*class RecipeListResponseModel extends RecipeListResponseEntity {
  final List<RecipeModel> recipes;
  final int total;
  final int skip;
  final int limit;

  RecipeListResponseModel({
    required this.recipes,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory RecipeListResponseModel.fromJson(Map<String, dynamic> json) {
    return RecipeListResponseModel(
      recipes: (json['recipes'] as List? ?? [])
          .map((item) => RecipeModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}*/

class RecipeListRequestModel {
  RecipeListRequestModel({
    this.query,
    this.difficulty,
    this.limit = 10,
    this.skip = 0,
  });

  final String? query;
  final String? difficulty;
  final int limit;
  final int skip;
}
