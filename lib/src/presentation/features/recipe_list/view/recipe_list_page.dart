import 'package:flutter/material.dart';

import '../../shared/widgets/search_bar.dart';
import '../widgets/recipe_list_section.dart';

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RecipeHub')),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: trigger provider refresh
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RecipeSearchBar(),
              ),
              // SizedBox(height: 16),
              // RecentlyViewedSection(),
              SizedBox(height: 16),
              RecipeListSection(),
            ],
          ),
        ),
      ),
    );
  }
}
