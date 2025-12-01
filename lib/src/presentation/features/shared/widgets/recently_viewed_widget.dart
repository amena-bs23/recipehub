/*
import 'package:flutter/material.dart';

import '../../../../domain/entities/recipe_entity.dart';
import 'recipe_card.dart';

class RecentlyViewedWidget extends StatelessWidget {
  final List<Recipe> recipes;
  final Function(Recipe)? onRecipeTap;
  const RecentlyViewedWidget({
    super.key,
    required this.recipes,
    this.onRecipeTap,
  });
  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recently Viewed',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(right: 12),
                child: RecipeCard(
                  recipe: recipe,
                  onTap: () => onRecipeTap?.call(recipe),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
*/
