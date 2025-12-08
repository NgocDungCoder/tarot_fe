import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/routes/route.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/user.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import 'user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}

class UserPage extends GetView<UserController> {
  const UserPage({super.key});

  // Tên hiển thị của trang là "Setting"

  @override
  Widget build(BuildContext context) {
    return VideoBackground(
      child: SafeArea(
      child: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: ThemeConfig.textGold,
            ),
          );
        }

        final user = controller.user;
        if (user == null) {
          return const Center(
            child: CustomText(
              'Không có dữ liệu người dùng',
              fontSize: 16,
              color: ThemeConfig.textWhite,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Title
              const CustomText(
                'Cài đặt',
                fontSize: 28,
                color: ThemeConfig.textGold,
                fontWeight: FontWeight.bold,
              ),
              
              const SizedBox(height: 20),
              
              // Avatar và thông tin cơ bản
              _buildUserHeader(user),
              
              const SizedBox(height: 30),
              
              // Magic Points và Reward Points
              _buildBalanceSection(user),
              
              const SizedBox(height: 30),
              
              // Cung hoàng đạo
              _buildZodiacSection(user),
              
              const SizedBox(height: 30),
              
              // Lịch sử và thống kê
              _buildHistorySection(),
              
              const SizedBox(height: 30),
              
              // Menu items
              _buildMenuSection(),
              
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
      ),
    );
  }

  /// Build user header với avatar và thông tin cơ bản - có thể click để mở profile
  Widget _buildUserHeader(User user) {
    return GestureDetector(
      onTap: controller.navigateToProfile,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeConfig.deepPurple.withOpacity(0.8),
              ThemeConfig.secondaryColor.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ThemeConfig.textGold.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeConfig.textGold.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ThemeConfig.textGold,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeConfig.textGold.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  user.avatarPath ?? 'assets/icons/tarot_logo.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: ThemeConfig.deepPurple,
                      child: const Icon(
                        Icons.person,
                        color: ThemeConfig.textGold,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(width: 20),
            
            // Thông tin người dùng
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    user.name,
                    fontSize: 24,
                    color: ThemeConfig.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    user.email,
                    fontSize: 14,
                    color: ThemeConfig.textWhite.withOpacity(0.8),
                  ),
                  if (user.phone != null) ...[
                    const SizedBox(height: 4),
                    CustomText(
                      user.phone!,
                      fontSize: 14,
                      color: ThemeConfig.textWhite.withOpacity(0.8),
                    ),
                  ],
                ],
              ),
            ),
            
            // Icon mũi tên để chỉ ra có thể click
            Icon(
              Icons.arrow_forward_ios,
              color: ThemeConfig.textGold.withOpacity(0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Build balance section với Magic Points và Reward Points
  Widget _buildBalanceSection(User user) {
    return Column(
      children: [
        Row(
          children: [
            // Magic Points - điểm ma thuật (nạp tiền để mua)
            Expanded(
              child: _buildBalanceCard(
                title: 'Magic Points',
                value: '${_formatNumber(user.magicPoints.toInt())}',
                icon: Icons.auto_awesome,
                color: ThemeConfig.secondaryColor,
              ),
            ),
            
            const SizedBox(width: 15),
            
            // Reward Points - điểm tích lũy/thưởng
            Expanded(
              child: _buildBalanceCard(
                title: 'Reward Points',
                value: '${_formatNumber(user.rewardPoints)}',
                icon: Icons.card_giftcard,
                color: ThemeConfig.textGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Nạp tiền button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: controller.navigateToDeposit,
            icon: const Icon(Icons.account_balance_wallet, color: Colors.black),
            label: const CustomText(
              'Nạp tiền',
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.textGold,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
          ),
        ),
      ],
    );
  }

  /// Build balance card
  Widget _buildBalanceCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 12),
          CustomText(
            title,
            fontSize: 14,
            color: ThemeConfig.textWhite.withOpacity(0.7),
          ),
          const SizedBox(height: 8),
          CustomText(
            value,
            fontSize: 20,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  /// Build zodiac section
  Widget _buildZodiacSection(User user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeConfig.textGold.withOpacity(0.2),
            ThemeConfig.textGoldLight.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeConfig.textGold.withOpacity(0.2),
              border: Border.all(
                color: ThemeConfig.textGold,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.star,
              color: ThemeConfig.textGold,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Cung hoàng đạo',
                  fontSize: 14,
                  color: ThemeConfig.textWhite.withOpacity(0.7),
                ),
                const SizedBox(height: 8),
                CustomText(
                  user.zodiacSign,
                  fontSize: 20,
                  color: ThemeConfig.textGold,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build history section với lịch sử rút bài và giao dịch
  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Lịch sử',
          fontSize: 18,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 15),
        _buildMenuItem(
          icon: Icons.style,
          title: 'Lịch sử rút bài',
          subtitle: 'Xem các lá bài đã rút',
          onTap: controller.viewCardHistory,
        ),
        _buildMenuItem(
          icon: Icons.history,
          title: 'Lịch sử giao dịch',
          subtitle: 'Xem lịch sử nạp/rút điểm',
          onTap: controller.viewTransactionHistory,
        ),
        _buildMenuItem(
          icon: Icons.shopping_bag,
          title: 'Đơn hàng của tôi',
          subtitle: 'Xem các đơn hàng đã mua',
          onTap: controller.viewOrders,
        ),
        _buildMenuItem(
          icon: Icons.card_giftcard,
          title: 'Lịch sử đổi quà',
          subtitle: 'Xem các quà đã đổi bằng điểm',
          onTap: controller.viewRedeemHistory,
        ),
      ],
    );
  }

  /// Build menu section với các mục như chính sách, đăng xuất
  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Cài đặt',
          fontSize: 18,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 15),
        _buildMenuItem(
          icon: Icons.policy,
          title: 'Chính sách',
          onTap: controller.goToPolicy,
        ),
        _buildMenuItem(
          icon: Icons.description,
          title: 'Điều khoản sử dụng',
          onTap: controller.goToTerms,
        ),
        _buildMenuItem(
          icon: Icons.privacy_tip,
          title: 'Quyền riêng tư',
          onTap: controller.goToPrivacy,
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Trợ giúp',
          onTap: controller.goToHelp,
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'Về chúng tôi',
          onTap: controller.goToAbout,
        ),
        const SizedBox(height: 10),
        _buildMenuItem(
          icon: Icons.logout,
          title: 'Đăng xuất',
          onTap: controller.logout,
          isDestructive: true,
        ),
      ],
    );
  }

  /// Build menu item
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDestructive
              ? Colors.red.withOpacity(0.3)
              : ThemeConfig.textGold.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : ThemeConfig.textGold,
        ),
        title: CustomText(
          title,
          fontSize: 16,
          color: isDestructive ? Colors.red : ThemeConfig.textWhite,
        ),
        subtitle: subtitle != null
            ? CustomText(
                subtitle,
                fontSize: 12,
                color: ThemeConfig.textWhite.withOpacity(0.6),
              )
            : null,
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive ? Colors.red.withOpacity(0.5) : ThemeConfig.textGold.withOpacity(0.5),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Format number with thousand separator
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
