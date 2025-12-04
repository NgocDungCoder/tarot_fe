enum MainTab {
  home,
  explore,
  cart,
  user,
}

extension MainTabExtension on MainTab {
  String get label {
    switch (this) {
      case MainTab.home:
        return 'Home';
      case MainTab.explore:
        return 'Explore';
      case MainTab.cart:
        return 'Cart';
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
      case MainTab.cart:
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
        return MainTab.cart;
      case 3:
        return MainTab.user;
      default:
        return MainTab.home;
    }
  }
}

