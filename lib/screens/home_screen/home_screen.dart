import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../providers/meal_categories_provider.dart';
import '../../providers/admins_provider.dart';
import '../widgets/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealCategoriesProvider mealCategoriesProvider =
        context.watch<MealCategoriesProvider>();
    AdminsProvider adminsProviderWatcher = context.watch<AdminsProvider>();

    return mealCategoriesProvider.isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(135)),
              child: AppHeader(
                adminId: adminsProviderWatcher.selectedAdmin!.adminId,
               ),
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.getProportionalHeight(28),
                  SizeConfig.getProportionalHeight(0),
                  SizeConfig.getProportionalHeight(28),
                  0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizeConfig.customSizedBox(null, 15, null),
                  ],
                ),
              ),
            ),
          );
  }
}
