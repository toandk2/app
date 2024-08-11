import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hkd/notification_screen.dart';
import 'package:hkd/order_detail/buyer_order_detail_screen.dart';
import 'package:hkd/order_detail/shipper_order_detail_screen.dart';
import 'package:hkd/order_detail/shop_order_detail_screen.dart';
import 'package:hkd/ultils/func.dart';

bool isFlutterLocalNotificationsInitialized = false;

// late AndroidNotificationChannel channel;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  // channel = const AndroidNotificationChannel(
  //   'high_importance_channel', // id
  //   'High Importance Notifications', // title
  //   description:
  //       'This channel is used for important notifications.', // description
  //   importance: Importance.high,
  // );

  // _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // /// Create an Android Notification Channel.
  // ///
  // /// We use this channel in the `AndroidManifest.xml` file to override the
  // /// default FCM channel to enable heads up notifications.
  // await _flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

// void _showFlutterNotification(RemoteMessage message) {
//   final notification = message.notification;
//   final android = message.notification?.android;
//   if (notification != null && android != null && !kIsWeb) {
//     _flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           icon: 'ic_launcher',
//         ),
//       ),
//     );
//   }
// }

listenFirebase(BuildContext context) {
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    debugPrint(
        'A new onMessageOpenedApp event was published getInitialMessage!');
    debugPrint(message.toString());
    if (message != null) {
      Future.delayed(const Duration(seconds: 3)).then(
        (value) => _navigatorOnMessage(message, context),
      );
      //  Navigator.push(
      //   context,
      //   MaterialPageRoute<dynamic>(
      //     builder: (BuildContext context) {
      //       return const SplashScreen(
      //         isNotificationNavigate: true,
      //       );
      //     },
      //   ),
      // );
    }
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('A new onMessage event was published');
    // showFlutterNotification(message);
    // _navigatorOnMessage(message, context);
    NetworkUtil().getUnreadNoti(context);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('A new onMessageOpenedApp!');
    // showFlutterNotification(message);
    _navigatorOnMessage(message, context);
  });
}

// late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

_navigatorOnMessage(RemoteMessage message, BuildContext context) {
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
                return const ShopOrderDetailScreen();
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
}
