import 'package:get/get.dart';
import '../../../models/transaction.dart';
import '../../../services/storage_service.dart';

class TransactionHistoryController extends GetxController {
  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // List of transactions
  final _transactions = <Transaction>[].obs;
  List<Transaction> get transactions => _transactions;

  // Filter by type
  final _selectedFilter = Rx<String>('all'); // all, mp_deposit, mp_withdraw, rp_earn, rp_spend
  String get selectedFilter => _selectedFilter.value;

  // Search query
  final _searchQuery = ''.obs;
  String get searchQuery => _searchQuery.value;

  final _storage = StorageService();
  static const String _transactionHistoryKey = 'transaction_history';

  @override
  void onInit() {
    super.onInit();
    _loadTransactions();
  }

  /// Load transactions from storage
  void _loadTransactions() {
    _isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        // final transactionJson = _storage.read<List<dynamic>>(_transactionHistoryKey) ?? [];
        // final loadedTransactions = transactionJson
        //     .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
        //     .toList();
        //
        // // Nếu không có lịch sử trong storage, tạo dữ liệu mẫu
        // if (loadedTransactions.isEmpty) {
        //   _transactions.assignAll(_createSampleTransactions());
        // } else {
        //   _transactions.assignAll(loadedTransactions);
        // }
      } catch (e) {
        // Nếu có lỗi, dùng dữ liệu mẫu
        _transactions.assignAll(_createSampleTransactions());
      } finally {
        _isLoading.value = false;
      }
    });
  }

  /// Create sample transactions for demo
  List<Transaction> _createSampleTransactions() {
    return [
      // Magic Points - Nạp
      Transaction(
        id: 'tx1',
        type: TransactionType.magicPointDeposit,
        amount: 5000.0,
        description: 'Nạp Magic Points qua ví điện tử',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Transaction(
        id: 'tx2',
        type: TransactionType.magicPointDeposit,
        amount: 3000.0,
        description: 'Nạp Magic Points qua thẻ ngân hàng',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      // Magic Points - Chi tiêu
      Transaction(
        id: 'tx3',
        type: TransactionType.magicPointWithdraw,
        amount: 1800.0,
        description: 'Thanh toán đơn hàng ORD-1703123456789',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        metadata: {'orderId': 'ORD-1703123456789'},
      ),
      Transaction(
        id: 'tx4',
        type: TransactionType.magicPointWithdraw,
        amount: 300.0,
        description: 'Thanh toán đơn hàng ORD-1703123456790',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        metadata: {'orderId': 'ORD-1703123456790'},
      ),
      Transaction(
        id: 'tx5',
        type: TransactionType.magicPointWithdraw,
        amount: 600.0,
        description: 'Thanh toán đơn hàng ORD-1703123456791',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        metadata: {'orderId': 'ORD-1703123456791'},
      ),
      // Reward Points - Nhận được
      Transaction(
        id: 'tx6',
        type: TransactionType.rewardPointEarn,
        amount: 180.0,
        description: 'Nhận điểm thưởng từ đơn hàng ORD-1703123456789',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        metadata: {'orderId': 'ORD-1703123456789'},
      ),
      Transaction(
        id: 'tx7',
        type: TransactionType.rewardPointEarn,
        amount: 30.0,
        description: 'Nhận điểm thưởng từ đơn hàng ORD-1703123456790',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        metadata: {'orderId': 'ORD-1703123456790'},
      ),
      Transaction(
        id: 'tx8',
        type: TransactionType.rewardPointEarn,
        amount: 60.0,
        description: 'Nhận điểm thưởng từ đơn hàng ORD-1703123456791',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        metadata: {'orderId': 'ORD-1703123456791'},
      ),
      // Reward Points - Đổi quà
      Transaction(
        id: 'tx9',
        type: TransactionType.rewardPointSpend,
        amount: 500.0,
        description: 'Đổi quà: Quả cầu pha lê thần bí',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        metadata: {'giftId': 'gift1', 'giftName': 'Quả cầu pha lê thần bí'},
      ),
      Transaction(
        id: 'tx10',
        type: TransactionType.rewardPointSpend,
        amount: 800.0,
        description: 'Đổi quà: Bộ bài Tarot cao cấp',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        metadata: {'giftId': 'gift2', 'giftName': 'Bộ bài Tarot cao cấp'},
      ),
      Transaction(
        id: 'tx11',
        type: TransactionType.rewardPointSpend,
        amount: 300.0,
        description: 'Đổi quà: Mặt dây chuyền pha lê',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        metadata: {'giftId': 'gift3', 'giftName': 'Mặt dây chuyền pha lê'},
      ),
    ];
  }

  /// Get filtered transactions
  List<Transaction> get filteredTransactions {
    var filtered = _transactions.where((tx) {
      // Filter by type
      if (_selectedFilter.value != 'all') {
        switch (_selectedFilter.value) {
          case 'mp_deposit':
            if (tx.type != TransactionType.magicPointDeposit) return false;
            break;
          case 'mp_withdraw':
            if (tx.type != TransactionType.magicPointWithdraw) return false;
            break;
          case 'rp_earn':
            if (tx.type != TransactionType.rewardPointEarn) return false;
            break;
          case 'rp_spend':
            if (tx.type != TransactionType.rewardPointSpend) return false;
            break;
        }
      }

      // Filter by search query
      if (_searchQuery.value.isNotEmpty) {
        final query = _searchQuery.value.toLowerCase();
        return tx.description.toLowerCase().contains(query);
      }

      return true;
    }).toList();

    // Sort by date (newest first)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

  /// Set filter
  void setFilter(String filter) {
    _selectedFilter.value = filter;
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  /// Add new transaction (called from other controllers)
  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction); // Add to beginning
    // Limit to 100 transactions
    if (_transactions.length > 100) {
      _transactions.removeRange(100, _transactions.length);
    }
    // Save to storage
    _saveTransactions();
  }

  /// Save transactions to storage
  void _saveTransactions() {
    try {
      final transactionJson = _transactions.map((tx) => tx.toJson()).toList();
      // _storage.write(_transactionHistoryKey, transactionJson);
    } catch (e) {
      print('Error saving transaction history: $e');
    }
  }

  /// Get filter options
  List<Map<String, String>> get filterOptions => [
        {'value': 'all', 'label': 'Tất cả'},
        {'value': 'mp_deposit', 'label': 'Nạp MP'},
        {'value': 'mp_withdraw', 'label': 'Chi tiêu MP'},
        {'value': 'rp_earn', 'label': 'Nhận RP'},
        {'value': 'rp_spend', 'label': 'Đổi quà RP'},
      ];
}

