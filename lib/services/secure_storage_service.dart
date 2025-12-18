import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';

import '../configs/interfaces/storage_interface.dart';

class SecureStorageService extends GetxService implements IStorage {
  late final GetSecureStorage _box;

  Future<SecureStorageService> init() async {
    await GetSecureStorage.init();
    _box = GetSecureStorage();
    return this;
  }

  @override
  Future<bool> clear() async {
    await _box.erase();
    return true;
  }

  @override
  Future<String?> delete<T>(String key) async {
    final value = _box.read(key);
    await _box.remove(key);
    return value;
  }

  @override
  Future<String?> get<T>(String key) async {
    return _box.read(key);
  }

  @override
  Future<bool> set<T>(String key, String value) async {
    await _box.write(key, value);
    return true;
  }
}
