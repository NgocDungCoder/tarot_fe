import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:google_fonts/google_fonts.dart';

import '../configs/routes/route.dart';
import '../env.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Env().appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // Set Dancing Script as default font family
        textTheme: GoogleFonts.dancingScriptTextTheme(),
        // Also set for other text styles
        primaryTextTheme: GoogleFonts.dancingScriptTextTheme(),
      ),
      locale: const Locale('vi'),
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash.p,
      getPages: getPages,
    );
  }
}