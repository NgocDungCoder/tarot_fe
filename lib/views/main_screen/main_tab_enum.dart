enum MainTab {
  home,
  explore,
  shop,
  user,
}

extension MainTabExtension on MainTab {
  String get label {
    switch (this) {
      case MainTab.home:
        return 'Home';
      case MainTab.explore:
        return 'Explore';
      case MainTab.shop:
        return 'Shop';
      case MainTab.user:
        return 'User';
    }
  }

  int get index {
    switch (this) {
      case MainTab.home:
        return 0;
      case MainTab.explore:
        return 1;
      case MainTab.shop:
        return 2;
      case MainTab.user:
        return 3;
    }
  }

  static MainTab fromIndex(int index) {
    switch (index) {
      case 0:
        return MainTab.home;
      case 1:
        return MainTab.explore;
      case 2:
        return MainTab.shop;
      case 3:
        return MainTab.user;
      default:
        return MainTab.home;
    }
  }
}

