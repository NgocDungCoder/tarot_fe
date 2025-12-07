import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../../../configs/styles/theme_config.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_snackbar.dart';
import 'main_controller.dart';
import 'main_tab_enum.dart';
import 'home/home_page.dart';
import 'home/home_controller.dart';
import 'explore/explore_page.dart';
import 'explore/explore_controller.dart';
import 'shop/shop_page.dart';
import 'shop/shop_controller.dart';
import 'user/user_page.dart';
import 'user/user_controller.dart';
import 'cart/cart_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Sử dụng put với permanent: true để MainController không bị dispose
    // Đảm bảo video background luôn hoạt động khi ở main screen
    if (!Get.isRegistered<MainController>()) {
      Get.put<MainController>(MainController(), permanent: true);
    }
    
    // Khởi tạo CartController để có thể truy cập từ nhiều nơi
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(CartController(), permanent: true);
    }
  }
}

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false, // Chặn back button mặc định
        onPopInvoked: (didPop) async {
          if (didPop) return;
          
          // Kiểm tra double back press
          final shouldExit = controller.handleBackPress();
          
          if (shouldExit) {
            // Exit app
            exit(0);
          } else {
            // Hiển thị snackbar yêu cầu back thêm lần nữa
            CustomSnackbar.warning(
              title: 'Nhấn lại để thoát',
              message: 'Nhấn nút back thêm một lần nữa để thoát ứng dụng',
              duration: const Duration(seconds: 2),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true, // Cho phép body mở rộng ra toàn bộ màn hình, không tự động thêm padding
          body: SafeArea(
            child: Obx(() {
              return Stack(
                children: [
                  // Background video
                  Positioned.fill(
                    child: _buildBackground(),
                  ),
                  Column(
                    children: [
                      // Page content
                      Expanded(
                        child: Container(child: _buildCurrentPage()),
                      ),
                      // Bottom navigation bar trong suốt
                      _buildBottomNavigationBar(),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  /// Build background - video là nền mặc định, nếu có lỗi thì hiển thị gradient màu vàng huyền diệu
  Widget _buildBackground() {
    final videoController = controller.videoController;
    final hasError = controller.hasVideoError;

    // Nếu có lỗi video, hiển thị hình ảnh fallback
    if (hasError) {
      return SizedBox.expand(
        child: Image.asset(
          'assets/images/bg_fallback.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Nếu hình ảnh fallback cũng lỗi, hiển thị nền đen
            return Container(color: Colors.black);
          },
        ),
      );
    }

    if (videoController != null) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: videoController.value.size.width > 0
                ? videoController.value.size.width
                : 1920,
            height: videoController.value.size.height > 0
                ? videoController.value.size.height
                : 1080,
            child: VideoPlayer(videoController),
          ),
        ),
      );
    }

    // Nếu chưa có controller, hiển thị hình ảnh fallback
    return SizedBox.expand(
      child: Image.asset(
        'assets/images/bg_fallback.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Nếu hình ảnh fallback cũng lỗi, hiển thị nền đen
          return Container(color: Colors.black);
        },
      ),
    );
  }

  /// Build current page based on selected tab
  Widget _buildCurrentPage() {
    switch (controller.currentTab) {
      case MainTab.home:
        // Lazy load HomeController khi cần
        if (!Get.isRegistered<HomeController>()) {
          HomeBinding().dependencies();
        }
        return const HomePage();
      case MainTab.explore:
        // Lazy load ExploreController khi cần
        if (!Get.isRegistered<ExploreController>()) {
          ExploreBinding().dependencies();
        }
        return const ExplorePage();
      case MainTab.shop:
        // Lazy load ShopController khi cần
        if (!Get.isRegistered<ShopController>()) {
          ShopBinding().dependencies();
        }
        return const ShopPage();
      case MainTab.user:
        // Lazy load UserController khi cần
        if (!Get.isRegistered<UserController>()) {
          UserBinding().dependencies();
        }
        return const UserPage();
    }
  }

  /// Build bottom navigation bar trong suốt với viền vàng
  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent, // Hoàn toàn trong suốt
        border: Border.all(
            color: ThemeConfig.textGold,
            width: 2.0, 
          ),
      ),
      child: SafeArea(
        bottom: true, // Chỉ áp dụng SafeArea cho bottom
        top: false,
        left: false,
        right: false,
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentTab.index,
            onTap: (index) {
              controller.changeTab(MainTabExtension.fromIndex(index));
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: ThemeConfig.textGold,
            unselectedItemColor: ThemeConfig.textWhite.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/c0.png",
                  width: 35,
                  height: 35,
                  fit: BoxFit.contain,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/s0.png",
                  width: 35,
                  height: 35,
                  fit: BoxFit.contain,
                ),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/w0.png",
                  width: 35,
                  height: 35,
                  fit: BoxFit.contain,
                ),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/p0.png",
                  width: 35,
                  height: 35,
                  fit: BoxFit.contain,
                ),
                label: 'Setting',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
