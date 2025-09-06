import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmbl/firebase_options.dart';
import 'package:mmbl/utils/router/router.dart';
import 'package:sizer/sizer.dart';
import 'controller/filter_form_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(FilterFormController());
    return Sizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.amber,
            //accentColor: Colors.amber,
            appBarTheme: const AppBarTheme(color: Colors.amber),
            cardColor: Colors.white,
            //buttonColor: Colors.amber,
          ),
          initialRoute: homeScreen,
          getPages: getPages,
        );
      },
    );
  }
}
