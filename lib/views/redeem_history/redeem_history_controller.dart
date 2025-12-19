import 'package:get/get.dart';
import '../../../models/redeem_history.dart';

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
      final sampleHistories = <RedeemHistory>[

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

