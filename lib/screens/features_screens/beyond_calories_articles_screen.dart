import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../controllers/general_controller.dart';
import '../../core/utils/size_config.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../providers/features_provider.dart';
import '../food_screens/widgets/list_header.dart';
import 'add_article_screen.dart';

class BeyondCaloriesArticlesScreen extends StatefulWidget {
  const BeyondCaloriesArticlesScreen({super.key});

  @override
  State<BeyondCaloriesArticlesScreen> createState() =>
      _BeyondCaloriesArticlesScreenState();
}

class _BeyondCaloriesArticlesScreenState
    extends State<BeyondCaloriesArticlesScreen> {
  @override
  Widget build(BuildContext context) {
    final featuresProvider = Provider.of<FeaturesProvider>(context);
    final articles = featuresProvider.articles;

    return featuresProvider.isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(100)),
              child: SafeArea(
                child: ListHeader(
                  text: "beyond_calories",
                  onTap: () => Get.to(const AddArticleScreen()),
                  space: 350,
                ),
              ),
            ),
            backgroundColor: AppColors.backgroundColor,
            body: articles.isEmpty
                ? const Center(child: Text('No articles found'))
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getProportionalWidth(5),
                      vertical: SizeConfig.getProportionalHeight(20),
                    ),
                    child: GridView.custom(
                      gridDelegate: SliverWovenGridDelegate.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        pattern: const [
                          WovenGridTile(1),
                          WovenGridTile(
                            5 / 7,
                            crossAxisRatio: 0.9,
                            alignment: AlignmentDirectional.center,
                          ),
                        ],
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final article = articles[index];
                          return GestureDetector(
                            onTap: () => GeneralController()
                                .launchURL(context, Uri.parse(article.url)),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: Image.network(
                                      article.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Center(
                                              child: Icon(Icons.broken_image)),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        childCount: articles.length,
                      ),
                    ),
                  ),
          );
  }
}
