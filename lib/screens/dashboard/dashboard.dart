import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/screens/dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import '../../controllers/dashboard_controller.dart';
import '../../core/constants/colors.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/meals_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    MealsProvider().getAllPlannedMeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProviderWatcher = context.watch<DashboardProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        top: true,
        bottom: false,
        child: DashboardController()
            .dashBoardList[dashboardProviderWatcher.selectedIndex],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        fromDashboard: true,
      ),
    );
  }
}
