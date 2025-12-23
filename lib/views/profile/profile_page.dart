import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tarot_fe/models/user_entity.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../models/user.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_snackbar.dart';
import '../../../widget/video_background.dart';
import 'profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find()));
  }
}

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: ThemeConfig.textGold,
            size: 28,
          ),
        ),
        title: const CustomText(
          'Thông tin cá nhân',
          fontSize: 24,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/loading_ball.json',
              repeat: true,
              height: 70,
              width: 70,
              fit: BoxFit.contain,
            ),
          );
        }

        final user = controller.user.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Thông tin chi tiết
              _buildDetailSection(user),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    ),);
  }

  /// Build user header với avatar và thông tin cơ bản - copy từ trang user
  Widget _buildUserHeader(UserEntity user) {
    return Container(
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
          // Avatar với icon chỉnh sửa
          Stack(
            children: [
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
                  child: Image.network(
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
              // Icon chỉnh sửa avatar
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: controller.editAvatar,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: ThemeConfig.textGold,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 20),
          
          // Thông tin người dùng
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  user.name ?? "",
                  fontSize: 24,
                  color: ThemeConfig.textWhite,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 8),
                CustomText(
                  user.email ?? "",
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
        ],
      ),
    );
  }

  /// Build balance section với Magic Points và Reward Points
  Widget _buildBalanceSection(UserEntity user) {
    return Row(
      children: [
        // Magic Points - điểm ma thuật (nạp tiền để mua)
        Expanded(
          child: _buildBalanceCard(
            title: 'Magic Points',
            value: _formatNumber((user.magicPoints ?? 0).toInt()),
            icon: Icons.auto_awesome,
            color: ThemeConfig.secondaryColor,
          ),
        ),

        const SizedBox(width: 15),

        // Reward Points - điểm tích lũy/thưởng
        Expanded(
          child: _buildBalanceCard(
            title: 'Reward Points',
            value: _formatNumber((user.rewardPoints ?? 0).toInt()),
            icon: Icons.card_giftcard,
            color: ThemeConfig.textGold,
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
  Widget _buildZodiacSection(UserEntity user) {
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
                  user.zodiacSign ?? "",
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

  /// Build detail section với thông tin chi tiết
  Widget _buildDetailSection(UserEntity user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Thông tin chi tiết',
          fontSize: 18,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 15),
        _buildDetailItem(
          icon: Icons.person,
          label: 'Tên',
          value: user.name ?? "",
          onTap: () => controller.editField('name'),
        ),
        _buildDetailItem(
          icon: Icons.email,
          label: 'Email',
          value: user.email ?? "",
          onTap: () => controller.editField('email'),
        ),
        if (user.phone != null)
          _buildDetailItem(
            icon: Icons.phone,
            label: 'Số điện thoại',
            value: user.phone!,
            onTap: () => controller.editField('phone'),
          ),
        _buildDetailItem(
          icon: Icons.star,
          label: 'Cung hoàng đạo',
          value: user.zodiacSign ?? "",
          onTap: () => controller.editField('zodiac'),
        ),
      ],
    );
  }

  /// Build detail item
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeConfig.textGold.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: ThemeConfig.textGold,
        ),
        title: CustomText(
          label,
          fontSize: 12,
          color: ThemeConfig.textWhite.withOpacity(0.7),
        ),
        subtitle: CustomText(
          value,
          fontSize: 16,
          color: ThemeConfig.textWhite,
        ),
        trailing: Icon(
          Icons.edit_outlined,
          color: ThemeConfig.textGold.withOpacity(0.5),
          size: 20,
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
