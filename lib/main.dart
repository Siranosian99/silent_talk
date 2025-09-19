import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/routes.dart';
import 'package:silent_talk/screens/chat_screen.dart';
import 'package:silent_talk/screens/login_page.dart';
import 'package:silent_talk/screens/main_screen.dart';
import 'package:silent_talk/screens/people_screen.dart';
import 'package:silent_talk/screens/settings_screen.dart';
import 'package:silent_talk/screens/signUp_page.dart';
import 'package:silent_talk/themes/app_themes.dart';
import 'package:silent_talk/utils/image_picker/image_picker.dart';
import 'package:silent_talk/utils/themes/theme_data.dart';
import 'package:silent_talk/utils/themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('themes');
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAwMCb9JOyl-8RCA6iPxnGlVw89AajFilc",
          appId: "1:156704193316:ios:8f808066187c855d3211b1",//1:156704193316:ios:8f808066187c855d3211b1  //1:156704193316:android:12088ea8a9934d143211b1
          messagingSenderId: "156704193316",
          projectId: "silenttalk-53850")
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),),
  ChangeNotifierProvider(
  create: (_) => Picker(),
      ),
    ],  child: const MyApp(),)

  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      routerConfig: router,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      darkTheme:AppTheme.darkTheme,
      title: 'Silent Talk',
      theme: AppTheme.lightTheme,
    );
  }
}

// Widget build(BuildContext context) {
//   return MaterialApp(
//     debugShowCheckedModeBanner: false,
//     title: 'Silent Talk',
//     theme: AppThemeData.lightTheme,
//     home: MainScreen(),
//   );
// }