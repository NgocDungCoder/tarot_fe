import 'package:get/get.dart';
import '../../../models/redeem_history.dart';
import '../../../models/gift.dart';

class RedeemHistoryController extends GetxController {
  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // List of redeem histories
  final _redeemHistories = <RedeemHistory>[].obs;
  List<RedeemHistory> get redeemHistories => _redeemHistories;

  // Filter by status
  final _selectedStatus = 'all'.obs;
  String get selectedStatus => _selectedStatus.value;

  @override
  void onInit() {
    super.onInit();
    _loadRedeemHistories();
  }

  /// Load redeem histories (tạm thời dùng dữ liệu mẫu)
  void _loadRedeemHistories() {
    _isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      // Dữ liệu mẫu - tạo một số lịch sử đổi quà giả
      final sampleHistories = [
        RedeemHistory(
          id: 'redeem1',
          gift: Gift(
            id: 'gift1',
            name: 'Mystic Crystal Ball',
            nameVi: 'Quả cầu pha lê thần bí',
            description: 'Quả cầu pha lê cổ điển với khả năng nhìn thấy tương lai.',
            rewardPointsRequired: 500,
            imagePath: 'assets/images/gift1.jpg',
            category: 'decoration',
          ),
          rewardPointsUsed: 500,
          status: 'delivered',
          redeemedAt: DateTime.now().subtract(const Duration(days: 10)),
          shippingInfo: {
            'name': 'Nguyễn Văn A',
            'phone': '+84 123 456 789',
            'address': '123 Đường ABC, Quận XYZ, TP.HCM',
          },
        ),
        RedeemHistory(
          id: 'redeem2',
          gift: Gift(
            id: 'gift2',
            name: 'Tarot Card Set Premium',
            nameVi: 'Bộ bài Tarot cao cấp',
            description: 'Bộ bài Tarot được làm thủ công với thiết kế độc đáo.',
            rewardPointsRequired: 800,
            imagePath: 'assets/images/gift2.jpg',
            category: 'cards',
          ),
          rewardPointsUsed: 800,
          status: 'shipped',
          redeemedAt: DateTime.now().subtract(const Duration(days: 5)),
          shippingInfo: {
            'name': 'Nguyễn Văn A',
            'phone': '+84 123 456 789',
            'address': '123 Đường ABC, Quận XYZ, TP.HCM',
          },
        ),
        RedeemHistory(
          id: 'redeem3',
          gift: Gift(
            id: 'gift3',
            name: 'Crystal Pendant',
            nameVi: 'Mặt dây chuyền pha lê',
            description: 'Mặt dây chuyền pha lê tự nhiên với năng lượng tích cực.',
            rewardPointsRequired: 300,
            imagePath: 'assets/images/gift3.jpg',
            category: 'jewelry',
          ),
          rewardPointsUsed: 300,
          status: 'processing',
          redeemedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        RedeemHistory(
          id: 'redeem4',
          gift: Gift(
            id: 'gift4',
            name: 'Incense Set',
            nameVi: 'Bộ nhang thơm',
            description: 'Bộ nhang thơm với nhiều mùi hương khác nhau.',
            rewardPointsRequired: 200,
            imagePath: 'assets/images/gift4.jpg',
            category: 'wellness',
          ),
          rewardPointsUsed: 200,
          status: 'pending',
          redeemedAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ];

      _redeemHistories.assignAll(sampleHistories);
      _isLoading.value = false;
    });
  }

  /// Get filtered redeem histories based on status
  List<RedeemHistory> get filteredRedeemHistories {
    if (_selectedStatus.value == 'all') {
      return _redeemHistories;
    }
    return _redeemHistories
        .where((history) => history.status == _selectedStatus.value)
        .toList();
  }

  /// Set selected status filter
  void setStatus(String status) {
    _selectedStatus.value = status;
  }

  /// Get unique statuses
  List<String> get statuses => ['all', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'];

  /// Get status display name
  String getStatusDisplayName(String status) {
    switch (status) {
      case 'all':
        return 'Tất cả';
      case 'pending':
        return 'Chờ xử lý';
      case 'processing':
        return 'Đang xử lý';
      case 'shipped':
        return 'Đã giao hàng';
      case 'delivered':
        return 'Đã nhận quà';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  /// Add new redeem history (called from redeem gift controller)
  void addRedeemHistory(RedeemHistory history) {
    _redeemHistories.insert(0, history); // Add to beginning of list
  }
}

