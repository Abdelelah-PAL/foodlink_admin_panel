import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/dashboard_provider.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      DashboardProvider().onItemTapped(index);
    });
    if(!widget.fromDashboard) {
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
          _buildNavItem(Icons.list, 0),
          _buildNavItem(Icons.fastfood_sharp, 1),
          _buildNavItem(Icons.add_a_photo_outlined, 2),
          _buildNavItem(Icons.article_outlined, 3),
          _buildNavItem(Icons.settings, 4),
        ],
      ),
    );
  }
  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
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
