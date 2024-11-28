class HomeController {
  bool isExpanded = false;
  int selectedIndex = 0;

  void onItemTapped(int index) {
      selectedIndex = index;
  }
}