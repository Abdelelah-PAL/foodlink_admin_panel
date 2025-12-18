import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../controllers/general_controller.dart';
import '../../core/utils/size_config.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/beyond_calories_article.dart';
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
    FeaturesProvider featuresProvider = Provider.of<FeaturesProvider>(context);
    List<BeyondCaloriesArticle> articles = featuresProvider.articles;

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
                  spaceFactor: 3,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.getProportionalWidth(5),
                      ),
                      gridDelegate: SliverWovenGridDelegate.count(
                        crossAxisCount: 2,
                        pattern: [
                          const WovenGridTile(1),
                          const WovenGridTile(
                            5 / 7,
                            crossAxisRatio: 0.9,
                            alignment: AlignmentDirectional.center,
                          ),
                        ],
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                            onTap: () => GeneralController().launchURL(
                                context,
                                Uri.parse(
                                    featuresProvider.articles[index].url)),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Image.network(
                                    featuresProvider.articles[index].imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    right: 10,
                                    top: 10,
                                    child: IconButton(
                                        onPressed: () async {
                                          await featuresProvider.deleteArticle(
                                              featuresProvider
                                                  .articles[index].documentId);
                                        },
                                        icon: const Icon(Icons.delete))),
                              ],
                            ),
                          );
                        },
                        childCount: featuresProvider.articles.length,
                      ),
                    ),
                  ),
          );
  }
}
