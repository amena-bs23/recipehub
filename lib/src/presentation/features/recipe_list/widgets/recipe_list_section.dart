import 'package:flutter/material.dart';

class RecipeListSection extends StatelessWidget {
  const RecipeListSection({super.key});

  @override
  Widget build(BuildContext context) {
    // mock recipes
    final recipes = List.generate(
      20,
      (i) => {
        'title': 'Recipe $i',
        'time': '${15 + i} min',
        'difficulty': ['Easy', 'Medium', 'Hard'][i % 3],
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'All Recipes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          itemCount: recipes.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return ListTile(
              leading: Container(
                width: 70,
                height: 70,
                color: Colors.orange.shade100,
                child: const Icon(Icons.food_bank),
              ),
              title: Text(recipe['title']!),
              subtitle: Text('${recipe['time']} • ${recipe['difficulty']}'),
              onTap: () {
                // navigate to detail page
              },
            );
          },
        ),
      ],
    );
  }
}
