import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/core/utils/size_config.dart';
import 'package:foodlink_admin_panel/screens/food_screens/widgets/list_header.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/storage_provider.dart';
import 'add_dish_of_the_week_screen.dart';

class DishOfTheWeekScreen extends StatefulWidget {
  const DishOfTheWeekScreen({super.key});

  @override
  State<DishOfTheWeekScreen> createState() => _DishOfTheWeekScreenState();
}

class _DishOfTheWeekScreenState extends State<DishOfTheWeekScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StorageProvider>().listenToDowImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final storageProvider = context.watch<StorageProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: ListHeader(
          text: "Dish of the Week",
          onTap: () => Get.to(const AddDishOfTheWeekScreen()),
          spaceFactor: 3,
        ),
      ),
      body:ListView.builder(
        itemCount: storageProvider.dowImageURLs.length,
        itemBuilder: (context, index) {
          final dish = storageProvider.dowImageURLs[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                    Image.network(
                      dish.imageUrl,
                      height: SizeConfig.getProperVerticalSpace(3),
                      width: SizeConfig.getProperHorizontalSpace(2),
                      loadingBuilder: (context, child, loading) {
                        if (loading == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stack) => const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(onPressed: () => {}, icon: const Icon(Icons.delete)),
                      IconButton(onPressed: () => {}, icon: const Icon(Icons.disabled_by_default))
                    ],
                  )
                  ],
              ),
            ),
          );
        },
      )
    );
  }
}
