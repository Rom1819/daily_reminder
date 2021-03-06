import 'package:daily_reminder/database/db_helper.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:daily_reminder/services/theme_services.dart';
import 'package:daily_reminder/ui/home_page.dart';
import 'package:get_storage/get_storage.dart';
import 'package:daily_reminder/ui/theme.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: const HomePage(),
    );
  }
}
