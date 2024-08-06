import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hkd/firebase_options.dart';
import 'package:hkd/notification_screen.dart';
import 'package:hkd/order_detail/buyer_order_detail_screen.dart';
import 'package:hkd/order_detail/shipper_order_detail_screen.dart';
import 'package:hkd/splash_screen.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    // name: "dothithongminh1",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("Handling a background message: ${message.messageId}");
  await setupFlutterNotifications();
  showFlutterNotification(message);
}

bool isFlutterLocalNotificationsInitialized = false;

late AndroidNotificationChannel channel;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  final notification = message.notification;
  final android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'ic_launcher',
        ),
      ),
    );
  }
}

listenFirebase(BuildContext context) {
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    debugPrint(
        'A new onMessageOpenedApp event was published getInitialMessage!');
    debugPrint(message.toString());
    if (message != null) {
      showFlutterNotification(message);

      // Navigator.pushNamed(context, '/list',
      //     arguments: MessageArguments(message, true));

      //   _netUtil.dismissBuyerNotification(dt['id'].toString());
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const NotificationScreen(),
        ),
      );
    }
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('A new onMessage event was published');
    debugPrint(jsonEncode(message));

    // Configs.appNotification.type = int.parse(dt["order_id"].toString());
    // Configs.appNotification.increaseNoti();
    showFlutterNotification(message);
    NetworkUtil().getUnreadNoti(context);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('A new onMessageOpenedApp!');
    try {
      debugPrint(message.data.toString());

      var dt = message.data;
      final orderId = dt["order_id"];
      if (orderId != null) {
        Configs.orderId = orderId;
        Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) {
              switch (Configs.userGroup) {
                case 0:
                  return const BuyerOrderDetailScreen();
                case 3:
                  return const ShipperOrderDetailScreen();
                default:
                  return const BuyerOrderDetailScreen();
              }
            },
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const NotificationScreen(),
          ),
        );
      }
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const NotificationScreen(),
        ),
      );
    }
  });
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
    runApp(const BSC());
  });
}

class BSC extends StatefulWidget {
  const BSC({Key? key}) : super(key: key);

  @override
  State<BSC> createState() => _BSCState();
}

class _BSCState extends State<BSC> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listenFirebase(context);
    });
    super.initState();
  }

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
      scrollBehavior: MyBehavior(),
      navigatorObservers: [ClearFocusOnPush()],
      builder: EasyLoading.init(),
      // routes: {
      //   '/home': (context) => const SearchScreen(
      //       // pageIndex: 0,
      //       ),
      //   // '/message': (context) => const MessageView(),
      //   // '/list': (context) => const MessageList(),
      // },
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
