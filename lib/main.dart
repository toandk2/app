import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hkd/firebase/notification_setup.dart';
import 'package:hkd/firebase_options.dart';
import 'package:hkd/search_screen.dart';
import 'package:hkd/splash_screen.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    // name: "dothithongminh1",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("Handling a background message: ${message.messageId}");
  // await setupFlutterNotifications();
  // showFlutterNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  initializeDateFormatting('vi_VN').then((_) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'dothithongminh1.vn',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1),
          primaryColor: Styles.primaryColor,
          fontFamily: Configs.MAIN_FONT,
          focusColor: Styles.primaryColor,
          scaffoldBackgroundColor: const Color(0xFFF7F7F7),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white, elevation: 6)),
      home: const SplashScreen(),
      // initialRoute: '/home',
      scrollBehavior: MyBehavior(),
      navigatorObservers: [ClearFocusOnPush()],
      builder: EasyLoading.init(),
      routes: {
        '/home': (context) => const SearchScreen(
            // pageIndex: 0,
            ),
        // '/message': (context) => const MessageView(),
        // '/list': (context) => const MessageList(),
      },
    );
  }
}

/// disable hiệu ứng scroll của android và scroll quá của ios
class MyBehavior extends ScrollBehavior {
  //ios
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class ClearFocusOnPush extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final focus = FocusManager.instance.primaryFocus;
    focus?.unfocus();
  }
}
