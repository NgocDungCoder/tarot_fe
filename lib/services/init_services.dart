import 'package:get/get.dart';
import 'package:tarot_fe/services/secure_storage_service.dart';
import 'package:tarot_fe/services/storage_service.dart';

import '../providers/api_client.dart';
import 'connectivity_service.dart';
import 'dio_service.dart';

Future initServices() async {
  // await Hive.initFlutter();
  // Get.put(LogService());
  // Get.put(RouteService());
  Get.put(ConnectivityService());
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => SecureStorageService().init());
  await Get.putAsync(
    () async => DioService().init(
    ),
  );
  await Get.put(ApiClient(
    Get.find<DioService>(),
    Get.find<StorageService>(),
  ));
}
