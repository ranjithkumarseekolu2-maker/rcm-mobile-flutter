import 'package:brickbuddy/commons/dependency_injection.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:upgrader/upgrader.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

Future<void> main() async {
  await Future.delayed(const Duration(milliseconds: 150));

  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  DependencyInjection.init();

// Define the missing `initPlatformState` function
  await FlutterDownloader.initialize(
      //   // debug: true
      );
  // await GetStorage.init();
  try {
    await Firebase.initializeApp();
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.

  final MoEngageFlutter _moengagePlugin =
      MoEngageFlutter("CAS6Y3UYSRYJ3CNHZMZ8WTCA");
  @override
  void initState() {
    super.initState();
    initPlatformState();
    _moengagePlugin.initialise();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Brick Buddy',
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      initialRoute: Routes.splashScreen,
      transitionDuration: const Duration(seconds: 0),
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: ThemeConstants.fontFamily,
        primarySwatch: const MaterialColor(0XFF3F51B5, {
          50: Color.fromRGBO(25, 93, 44, .1),
          100: Color.fromRGBO(25, 93, 44, .2),
          200: Color.fromRGBO(25, 93, 44, .3),
          300: Color.fromRGBO(25, 93, 44, .4),
          400: Color.fromRGBO(25, 93, 44, .5),
          500: Color.fromRGBO(25, 93, 44, .6),
          600: Color.fromRGBO(25, 93, 44, .7),
          700: Color.fromRGBO(25, 93, 44, .8),
          800: Color.fromRGBO(25, 93, 44, .9),
          900: Color.fromRGBO(25, 93, 44, 1)
        }),
      ),
    );
  }
}
