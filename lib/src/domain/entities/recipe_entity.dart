import 'package:equatable/equatable.dart';

enum Difficulty { easy, medium, hard }

class Recipe extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int cookingTime; // in minutes
  final Difficulty difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final bool isFavorite;
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
