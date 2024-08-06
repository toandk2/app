// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';

// import 'package:flutter/material.dart';

// import 'package:hkd/shop/shop_home_page.dart';
// import 'package:hkd/main.dart';
// import 'package:hkd/shop/shop_order_detail_screen.dart';
// import 'package:hkd/ultils/func.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class ShopScreen extends StatefulWidget {
//   const ShopScreen({Key? key}) : super(key: key);
//   @override
//   HomeState createState() => HomeState();
// }

// class HomeState extends State<ShopScreen> with TickerProviderStateMixin {
//   int currentPage = 0;
//   GlobalKey bottomNavigationKey = GlobalKey();
//   PageController pageController;
//   Stream<String> _tokenStream;
//   final NetworkUtil _netUtil = NetworkUtil();
//   @override
//   void initState() {
//     pageController = PageController();
//     super.initState();
//     if (Platform.isIOS) iOSPermission();
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage message) {
//       if (kDebugMode) {
//         print(
//             'A new onMessageOpenedApp event was published getInitialMessage!');
//       }
//       if (message != null) {
//         var dt = message.data;
//         Configs.orderId = dt['order_id'];
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute<dynamic>(
//             builder: (BuildContext context) => const ShopOrderDetailScreen(),
//           ),
//         );
//       }
//     });
//     FirebaseMessaging.instance
//         .getToken(
//             vapidKey:
//                 'AAAAvQzF_fs:APA91bEFrvnXeXFa7OPtkzesc_pEFkJ5klk2k7SEOO1g8QnSWlGa0ml0nhHEv1MWOAcz1LIG8M3edxly0leJ_Th2-UZBtf_kySll2QM8KVSpb9i4IAi9t22jrSACQqXrimc29Cme-HSb')
//         .then(setToken);
//     _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
//     _tokenStream.listen(setToken);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification;
//       var dt = message.data;
//       Configs.appNotification.id = int.parse(dt["order_id"].toString());
//       Configs.appNotification.type = int.parse(dt["order_id"].toString());
//       Configs.appNotification.increaseNoti();

//       flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channelDescription: channel.description,
//                 icon: 'ic_launcher',
//               ),
//               iOS: const IOSNotificationDetails()));
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if (kDebugMode) {
//         print('A new onMessageOpenedApp!');
//       }
//       var dt = message.data;
//       Configs.orderId = dt['order_id'];
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute<dynamic>(
//           builder: (BuildContext context) => const ShopOrderDetailScreen(),
//         ),
//       );
//     });
//   }

//   void iOSPermission() async {
//     NotificationSettings settings = await FirebaseMessaging.instance
//         .requestPermission(
//             announcement: true,
//             carPlay: true,
//             criticalAlert: true,
//             provisional: false,
//             sound: true,
//             badge: true,
//             alert: true);
//   }

//   void setToken(String token) {
//     var data = Configs.deviceData;
//     Map<String, String> body = {
//       "token": Configs.login?.token,
//       "deviceId": data["deviceId"],
//       "userId": Configs.login?.userId,
//       "shopId": Configs.login?.shopId,
//       "platform": Platform.operatingSystem,
//       "noti_token": token,
//     };

//     _netUtil.get("update_noti_token", body).then((rs) {
//       if (kDebugMode) {
//         print(token);
//       }
//     });
//     try {
//       _netUtil
//           .getorther("http://210.211.116.207:8010/Upload/NotiToken", body)
//           .then((rs) {});
//       // ignore: empty_catches
//     } catch (e) {}
//   }

//   Future<bool> _onWillPop() async {
//     return (await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Cảnh báo?'),
//             content: const Text('Bạn có muốn thoát ứng dụng không'),
//             actions: <Widget>[
//               TextButton(
//                 style: ButtonStyle(
//                   foregroundColor:
//                       MaterialStateProperty.all<Color>(Colors.blue),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//                 child: const Text('Có'),
//               ),
//               TextButton(
//                 style: ButtonStyle(
//                   foregroundColor:
//                       MaterialStateProperty.all<Color>(Colors.blue),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//                 child: const Text('Không'),
//               )
//             ],
//           ),
//         )) ??
//         false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(onWillPop: _onWillPop, child: bodyView(currentPage));
//   }

//   bodyView(currentTab) {
//     List<Widget> tabView = [];

//     switch (currentTab) {
//       case 0:
//         tabView = [const ShopPage()];
//         break;
//       default:
//         tabView = [const ShopPage()];
//     }

//     return PageView(controller: pageController, children: tabView);
//   }
// }
