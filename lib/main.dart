import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tarot_fe/services/init_services.dart';
import 'package:tarot_fe/views/app.dart';

void main() async {
  await runZonedGuarded<Future<void>>(() async {
    await initServices();

    runApp(const MyApp());
  }, (error, stack) async {
    print("Error in main app: $error");
  });
}

