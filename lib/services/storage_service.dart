/// Simple storage service using memory storage
/// 
/// Provides methods to save and load data
/// TODO: Có thể mở rộng để sử dụng SharedPreferences hoặc GetStorage sau
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Sử dụng memory storage
  // TODO: Có thể thay bằng SharedPreferences hoặc GetStorage để lưu persistent
  final _MemoryStorage _storage = _MemoryStorage();

  /// Read value from storage
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  /// Write value to storage
  void write(String key, dynamic value) {
    _storage.write(key, value);
  }

  /// Remove value from storage
  void remove(String key) {
    _storage.remove(key);
  }

  /// Clear all storage
  void clear() {
    _storage.erase();
  }
}

/// Memory storage fallback if GetStorage is not available
class _MemoryStorage {
  final Map<String, dynamic> _data = {};

  T? read<T>(String key) {
    return _data[key] as T?;
  }

  void write(String key, dynamic value) {
    _data[key] = value;
  }

  void remove(String key) {
    _data.remove(key);
  }

  void erase() {
    _data.clear();
  }
}

