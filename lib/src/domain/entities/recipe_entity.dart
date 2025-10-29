class RecipeRequestEntity {
  RecipeRequestEntity({required this.name, required this.link, this.time = 0});

  final String name;
  final String link;
  final int? time;
}

class RecipeResponseEntity {
  RecipeResponseEntity({required this.title});

  final String title;
}
