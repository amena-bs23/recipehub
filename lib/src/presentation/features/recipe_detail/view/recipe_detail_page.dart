import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../riverpod/recipe_detail_provider.dart';
import '../widgets/recipe_detail_page_widgets.dart';

class RecipeDetailPage extends ConsumerStatefulWidget {
  const RecipeDetailPage({super.key, required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends ConsumerState<RecipeDetailPage> {
  @override
  void initState() {
    super.initState();
    // ref is available in ConsumerStatefulWidget's initState
    ref.read(recipeDetailNotifierProvider.notifier).loadRecipe(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipeDetailNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: state.isLoading
                ? FlexibleSpaceBar(
                    background: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.grey[300]),
                    ),
                  )
                : FlexibleSpaceBar(
                    background: state.recipe != null
                        ? CachedNetworkImage(
                            imageUrl: state.recipe!.imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                          )
                        : null,
                  ),
            actions: [
              if (state.recipe != null)
                IconButton(
                  icon: Icon(
                    state.recipe!.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: state.recipe!.isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    ref
                        .read(recipeDetailNotifierProvider.notifier)
                        .toggleFavorite();
                  },
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: state.isLoading
                ? const RecipeDetailLoadingContent()
                : state.error != null
                    ? RecipeDetailErrorContent(
                        error: state.error!,
                        onRetry: () {
                          ref
                              .read(recipeDetailNotifierProvider.notifier)
                              .loadRecipe(widget.recipeId);
                        },
                      )
                    : state.recipe != null
                        ? RecipeDetailContent(recipe: state.recipe!)
                        : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
