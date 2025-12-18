import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../configs/interfaces/connectivity_interface.dart';

class ConnectivityService extends GetxService implements IConnectivity {
  @override
  Future<bool> checkConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
