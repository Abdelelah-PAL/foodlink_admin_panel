import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/features_provider.dart';
import '../../../providers/storage_provider.dart';
import '../dashboard.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key, required this.fromDashboard});

  final bool fromDashboard;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, StorageProvider? storageProvider) {
    setState(() {
      _selectedIndex = index;
      DashboardProvider().onItemTapped(index);
      if (index == 2) {
        FeaturesProvider().getAllArticles();
      }
    });
    if (!widget.fromDashboard) {
      Get.to(const Dashboard());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getProportionalWidth(355),
      height: SizeConfig.getProportionalHeight(61),
      margin: EdgeInsets.fromLTRB(
          SizeConfig.getProportionalWidth(20),
          SizeConfig.getProportionalHeight(10),
          SizeConfig.getProportionalWidth(20),
          SizeConfig.getProportionalHeight(25)),
      decoration: BoxDecoration(
        color: AppColors.widgetsColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.list, 0, null),
          _buildNavItem(Icons.add_a_photo_outlined, 1, null),
          _buildNavItem(Icons.article_outlined, 2, null),
          _buildNavItem(Icons.design_services, 3, null),
          _buildNavItem(Icons.settings, 4, null),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, int index, StorageProvider? storageProvider) {
    return GestureDetector(
      onTap: () => _onItemTapped(index, storageProvider),
      child: Icon(
        size: 32,
        icon,
        color: _selectedIndex == index
            ? AppColors.backgroundColor
            : AppColors.fontColor,
      ),
    );
  }
}
