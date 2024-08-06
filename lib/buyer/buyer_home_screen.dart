// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:flutter/material.dart';
// import 'package:hkd/buyer/buyer_home_page.dart';
// import 'package:hkd/buyer/buyer_notification_screen.dart';

// import 'package:hkd/main.dart';
// import 'package:hkd/ultils/func.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class BuyerHomeScreen extends StatefulWidget {
//   const BuyerHomeScreen({Key? key}) : super(key: key);
//   @override
//   State<BuyerHomeScreen> createState() => _BuyerHomeScreen();
// }

// class _BuyerHomeScreen extends State<BuyerHomeScreen>
//     with TickerProviderStateMixin {
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
//       debugPrint(
//           'A new onMessageOpenedApp event was published getInitialMessage!');
//       if (message != null) {
//         // Navigator.pushNamed(context, '/list',
//         //     arguments: MessageArguments(message, true));
//         //TODO: dont know implement
//         // final dt = message.data;

//         //   _netUtil.dismissBuyerNotification(dt['id'].toString());
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute<dynamic>(
//             builder: (BuildContext context) => const BuyerNotificationScreen(),
//           ), (route) => route is SearchScreen
//         );
//       }
//     });
//     FirebaseMessaging.instance
//         .getToken(
//             vapidKey:
//                 'AAAA0LOt9BA:APA91bEu8j477fvUsQGu-I4bgdkkiOohoa_yoiWhUHfpVIel5BfK9WrCyF72fhRGUvqhiqWydz8-3YomWBxk1p9qwfIR6h6GwptOA4cIgQvbl3DCH3UDU6XR6AdV7fVXJJov3zJ3rHBi')
//         .then(setToken);
//     _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
//     _tokenStream.listen(setToken);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification;
//       //TODO: anroid notification
//       final android = message.notification?.android;
//       var dt = message.data;
//       Configs.appNotification.id = int.parse(dt["order_id"].toString());
//       Configs.appNotification.type = int.parse(dt["order_id"].toString());
//       Configs.appNotification.increaseNoti();
//       // print(message.data.toString());
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
//       //  }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint('A new onMessageOpenedApp!');
//       // var dt = message.data;
//       //   _netUtil.dismissBuyerNotification(dt['id'].toString());

//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute<dynamic>(
//           builder: (BuildContext context) => const BuyerNotificationScreen(),
//         ), (route) => route is SearchScreen
//       );
//       // Navigator.pushNamed(context, '/list',
//       //     arguments: MessageArguments(message, true));
//     });
//   }

//   void iOSPermission() async {
//     await FirebaseMessaging.instance.requestPermission(
//         announcement: true,
//         carPlay: true,
//         criticalAlert: true,
//         provisional: false,
//         sound: true,
//         badge: true,
//         alert: true);
//   }

//   void setToken(String token) {
//     var data = Configs.deviceData;
//     Map<String, dynamic> body = {
//       "token": Configs.login?.token,
//       "deviceId": data["deviceId"],
//       "userId": Configs.login?.userId,
//       "shopId": Configs.login?.shopId,
//       "platform": Platform.operatingSystem,
//       "noti_token": token,
//     };
//     debugPrint(token);
//     _netUtil.get("update_noti_token", body).then((rs) {
//       try {
//         _netUtil
//             .getorther("http://210.211.116.207:8010/Upload/NotiToken", body)
//             .then((rs) {});
//         // ignore: empty_catches
//       } catch (e) {}
//     });
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
//     return WillPopScope(
//         onWillPop: _onWillPop,
//         child: Container(
//             color: const Color(0xFFF2F3F8),
//             child: Scaffold(
//                 backgroundColor: Colors.transparent, body: bodyView(currentPage)

//                 // bottomNavigationBar: GHSoftBottomNavigation(
//                 //     tabs: [
//                 //       TabData(iconData: Feather.home, title: "Trang chủ"),
//                 //       TabData(
//                 //           iconData: Feather.message_circle, title: "Trao đổi"),
//                 //       TabData(iconData: Feather.bell, title: "Thông báo"),
//                 //       TabData(
//                 //         iconData: Feather.align_right,
//                 //         title: "Khác",
//                 //       ),
//                 //     ],
//                 //     circleColor: AppColors.primaryColor,
//                 //     initialSelection: currentPage,
//                 //     key: bottomNavigationKey,
//                 //     onTabChangedListener: (position) {
//                 //       setState(() {
//                 //         currentPage = position;
//                 //         pageController.jumpToPage(0);
//                 //       });
//                 //     })
//                 )));
//   }

//   bodyView(currentTab) {
//     List<Widget> tabView = [];

//     switch (currentTab) {
//       case 0:
//         tabView = [const BuyerHomePage()];
//         break;
//       default:
//         tabView = [const BuyerHomePage()];
//     }

//     return PageView(controller: pageController, children: tabView);
//   }
// }
