import 'package:get/get.dart';
import '../../../models/card_draw_history.dart';
import '../../../services/storage_service.dart';

class CardDrawHistoryController extends GetxController {
  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // List of card draw histories
  final _histories = <CardDrawHistory>[].obs;
  List<CardDrawHistory> get histories => _histories;

  // Filter by reversed status
  final _filterReversed = Rx<String>('all'); // all, normal, reversed
  String get filterReversed => _filterReversed.value;

  // Search query
  final _searchQuery = ''.obs;
  String get searchQuery => _searchQuery.value;

  final _storage = StorageService();
  static const String _drawHistoryKey = 'card_draw_history';

  @override
  void onInit() {
    super.onInit();
    _loadHistories();
  }

  /// Load histories from storage
  void _loadHistories() {
    _isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        final historyJson = _storage.read<List<dynamic>>(_drawHistoryKey) ?? [];
        final loadedHistories = historyJson
            .map((json) => CardDrawHistory.fromJson(json as Map<String, dynamic>))
            .toList();

        // Nếu không có lịch sử trong storage, tạo dữ liệu mẫu
        if (loadedHistories.isEmpty) {
          _histories.assignAll(_createSampleHistories());
        } else {
          _histories.assignAll(loadedHistories);
        }
      } catch (e) {
        // Nếu có lỗi, dùng dữ liệu mẫu
        _histories.assignAll(_createSampleHistories());
      } finally {
        _isLoading.value = false;
      }
    });
  }

  /// Create sample histories for demo
  List<CardDrawHistory> _createSampleHistories() {
    return [
      CardDrawHistory(
        id: '1',
        cardId: '0',
        cardName: 'The Fool',
        cardNameVi: 'Kẻ Ngốc',
        cardImagePath: 'assets/images/fool.jpg',
        drawnAt: DateTime.now().subtract(const Duration(days: 1)),
        isReversed: false,
      ),
      CardDrawHistory(
        id: '2',
        cardId: '1',
        cardName: 'The Magician',
        cardNameVi: 'Pháp Sư',
        cardImagePath: 'assets/images/magician.jpg',
        drawnAt: DateTime.now().subtract(const Duration(days: 2)),
        isReversed: true,
      ),
      CardDrawHistory(
        id: '3',
        cardId: '2',
        cardName: 'The High Priestess',
        cardNameVi: 'Nữ Tư Tế',
        cardImagePath: 'assets/images/priestess.jpg',
        drawnAt: DateTime.now().subtract(const Duration(days: 3)),
        isReversed: false,
      ),
      CardDrawHistory(
        id: '4',
        cardId: '3',
        cardName: 'The Empress',
        cardNameVi: 'Hoàng Hậu',
        cardImagePath: 'assets/images/empress.jpg',
        drawnAt: DateTime.now().subtract(const Duration(days: 5)),
        isReversed: false,
      ),
      CardDrawHistory(
        id: '5',
        cardId: '4',
        cardName: 'The Emperor',
        cardNameVi: 'Hoàng Đế',
        cardImagePath: 'assets/images/emperor.jpg',
        drawnAt: DateTime.now().subtract(const Duration(days: 7)),
        isReversed: true,
      ),
    ];
  }

  /// Get filtered histories
  List<CardDrawHistory> get filteredHistories {
    var filtered = _histories.where((history) {
      // Filter by reversed status
      if (_filterReversed.value == 'normal' && history.isReversed) {
        return false;
      }
      if (_filterReversed.value == 'reversed' && !history.isReversed) {
        return false;
      }

      // Filter by search query
      if (_searchQuery.value.isNotEmpty) {
        final query = _searchQuery.value.toLowerCase();
        return history.cardNameVi.toLowerCase().contains(query) ||
            history.cardName.toLowerCase().contains(query);
      }

      return true;
    }).toList();

    return filtered;
  }

  /// Set filter reversed status
  void setFilterReversed(String filter) {
    _filterReversed.value = filter;
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  /// Add new history (called from card draw controller)
  void addHistory(CardDrawHistory history) {
    _histories.insert(0, history); // Add to beginning
    // Limit to 50 histories
    if (_histories.length > 50) {
      _histories.removeRange(50, _histories.length);
    }
    // Save to storage
    _saveHistories();
  }

  /// Save histories to storage
  void _saveHistories() {
    try {
      final historyJson = _histories.map((h) => h.toJson()).toList();
      _storage.write(_drawHistoryKey, historyJson);
    } catch (e) {
      print('Error saving draw history: $e');
    }
  }

  /// Clear all histories
  void clearHistories() {
    _histories.clear();
    _storage.write(_drawHistoryKey, []);
  }

  /// Delete a history
  void deleteHistory(String id) {
    _histories.removeWhere((h) => h.id == id);
    _saveHistories();
  }
}

