import 'package:equatable/equatable.dart';

enum Difficulty { easy, medium, hard }

Difficulty difficultyFromJson(String? value) {
  switch (value?.toLowerCase()) {
    case 'easy':
      return Difficulty.easy;
    case 'medium':
      return Difficulty.medium;
    case 'hard':
      return Difficulty.hard;
    default:
      return Difficulty.easy; // fallback
  }
}

class Recipe extends Equatable {
  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cookingTime,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int cookingTime; // in minutes
  final Difficulty difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final bool isFavorite;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    cookingTime,
    difficulty,
    ingredients,
    steps,
    isFavorite,
  ];

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? cookingTime,
    Difficulty? difficulty,
    List<String>? ingredients,
    List<String>? steps,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class RecipeResponseBaseEntity {
  RecipeResponseBaseEntity({
    required this.name,
    required this.image,
    required this.cookTimeMinutes,
    required this.difficulty,
    this.isFavorite = false,
  });

  final String name;
  final String image;
  final int cookTimeMinutes; // in minutes
  final Difficulty difficulty;
  final bool isFavorite;
}

class RecipeListResponseEntity extends RecipeResponseBaseEntity {
  RecipeListResponseEntity({
    required super.name,
    required super.image,
    required super.cookTimeMinutes,
    required super.difficulty,
    super.isFavorite = false,
  });
}

class RecipeDetailsResponseEntity extends RecipeResponseBaseEntity {
  RecipeDetailsResponseEntity({
    required super.name,
    required super.image,
    required super.cookTimeMinutes,
    required super.difficulty,
    super.isFavorite = false,
    required this.description,
    required this.ingredients,
    required this.steps,
  });

  final String description;
  final List<String> ingredients;
  final List<String> steps;
}

class RecipeListRequestEntity {
  RecipeListRequestEntity({required this.query, required this.difficulty});

  final String query;
  final Difficulty difficulty;
}
