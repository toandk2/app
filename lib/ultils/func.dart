// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:device_info/device_info.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hkd/user/login_screen.dart';
import 'package:hkd/search_screen.dart';
import 'package:hkd/ultils/database_helper.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/widgets/custom_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:rxdart/subjects.dart';

class Configs {
  static const String BASE_URL = "https://test.hkdo.vn/api/";
  static Login? login;
  static User? user;
  static final countCart = BehaviorSubject.seeded(0);
  // static UserData? dbUser;
  static final unreadMessage = BehaviorSubject.seeded(0);
  static final Map<String, CartModel> unSignedCart = {};
  static Map<String, dynamic> deviceData = {};
  static const String MAIN_FONT = "roboto";
  static const String MAIN_FONT2 = "robotocondensed";
  static String? orderId;
  // static Status status;
  static String qrUrl = "https://dothithongminh1.vn";
  static int userGroup = 0;
  static final formatter = NumberFormat("#,###");
  static List<String> loginUrl = ["buyer_login", "login", '', "shipper_login"];
  static const messageType = [2, 1, 1, 3];
  static const selectType = [
    {
      "text": "Người tìm mua",
      "icon": "nguoi-tim-mua",
      "type": "buyer",
      "registerText": "Đăng ký tài khoản để theo dõi đơn hàng của bạn"
    },
    {
      "text": "Hộ kinh doanh",
      "icon": "ho-kinh-doanh",
      "type": "shop",
      "registerText": "Đăng ký tài khoản HKDO"
    },
    null,
    {
      "text": "Người vận chuyển",
      "icon": "nguoi-van-chuyen",
      "type": "shiper",
      "registerText": "Đăng ký tài khoản để theo dõi đơn hàng của bạn"
    }
  ];

  static List<String> role = ["buyer", "shop", "", "xeom"];
  static List<String> getNotificationUrl = [
    "buyer_get_notification",
    "shop_get_notification",
    "",
    "shipper_get_notification"
  ];

  static List<String> mainPageUrl = [
    'https://dothithongminh1.vn',
    "https://hokinhdoanh.online",
    "https://hokinhdoanh.online",
    "https://dothithongminh1.vn/ship/"
  ];

  static List<String> searchUrl = ['search_all', 'search_npp'];

  static String getSearchUrl(int index) => searchUrl[index];

  static List<Color> userColor = [
    Colors.yellow,
    const Color(0xFF34A853),
    const Color(0xFF34A853),
    Colors.deepOrange
  ];

  static Color getUserColor(int index) => userColor[index];

  static const List<Status> listShipperStatus = [
    Status(
        status: 0,
        name: "Có thể nhận",
        textColor: Color(0xFFAE832E),
        color: Color(0xFFFFC043),
        icon: 'assets/icons/profile/file.svg'),
    Status(
        status: 2,
        name: "Chờ xác nhận",
        textColor: Color(0xFF0053AE),
        color: Color(0xFF007AFF),
        icon: 'assets/icons/profile/check.svg'),
    // null,
    Status(
        status: 3,
        name: "Đã xác nhận",
        textColor: Color(0xFFA14C42),
        color: Color(0xFFEC6F61),
        icon: 'assets/icons/profile/biking.svg'),
    Status(
        status: 4,
        name: "Đã vận chuyển",
        textColor: Color(0xFF2A8045),
        color: Color(0xFF3CBA64),
        icon: 'assets/icons/profile/check-circle.svg'),
    Status(
        status: 5,
        name: "Thành công",
        textColor: Color(0xFF2A8045),
        color: Color(0xFF3CBA64),
        icon: 'assets/icons/profile/check-circle.svg'),
  ];

  static const List<Status> listShopStatus = [
    Status(
        status: 0,
        name: "Đơn mới",
        textColor: Color(0xFFAE832E),
        color: Color(0xFFFFC043),
        icon: 'assets/icons/profile/file.svg'),
    Status(
        status: 1,
        name: "Đã xác nhận",
        textColor: Color(0xFF0053AE),
        color: Color(0xFF007AFF),
        icon: 'assets/icons/profile/check.svg'),
    Status(
        status: 2,
        name: "Nhận chuyển",
        textColor: Color(0xFF219577),
        color: Color(0xFF31DAAE),
        icon: 'assets/icons/profile/bike.svg'),
    Status(
        status: 3,
        name: "Đang chuyển",
        textColor: Color(0xFFA14C42),
        color: Color(0xFFEC6F61),
        icon: 'assets/icons/profile/biking.svg'),
    Status(
        status: 4,
        name: "Đã vận chuyển",
        textColor: Color(0xFF2A8045),
        color: Color(0xFF3CBA64),
        icon: 'assets/icons/profile/check-circle.svg'),
    Status(
        status: 5,
        name: "Thành công",
        textColor: Color(0xFF2A8045),
        color: Color(0xFF3CBA64),
        icon: 'assets/icons/profile/check-circle.svg'),
    Status(
        status: -2,
        name: "Đã huỷ",
        textColor: Color(0xFFA14C42),
        color: Color(0xFFEC6F61),
        icon: 'assets/icons/close.svg'),
  ];

  static const List<Status> listBuyerStatus = [
    Status(
        status: 0,
        name: "Đơn đang chờ",
        textColor: Color(0xFFAE832E),
        color: Color(0xFFFFC043),
        icon: 'assets/icons/profile/file.svg'),
    Status(
        status: 1,
        name: "Đã xác nhận",
        textColor: Color(0xFF0053AE),
        color: Color(0xFF007AFF),
        icon: 'assets/icons/profile/check.svg'),
    // null,
    Status(
        status: 3,
        name: "Đang chuyển",
        textColor: Color(0xFFA14C42),
        color: Color(0xFFEC6F61),
        icon: 'assets/icons/profile/biking.svg'),
    Status(
        status: 4,
        name: "Đã vận chuyển",
        textColor: Color(0xFF2A8045),
        color: Color(0xFF3CBA64),
        icon: 'assets/icons/profile/check-circle.svg'),
    Status(
        status: 5,
        name: "Thành công",
        textColor: Color(0xFF2A8045),
        color: Color(0xFF3CBA64),
        icon: 'assets/icons/profile/check-circle.svg'),
    Status(
        status: -3,
        name: "Đã huỷ",
        textColor: Color(0xFFA14C42),
        color: Color(0xFFEC6F61),
        icon: 'assets/icons/close.svg'),
  ];

  static const iconsProfile = [
    'assets/icons/profile/user.svg',
    'assets/icons/profile/bxs-map.svg',
    'assets/icons/profile/bxs-map.svg',
    'assets/icons/profile/biking.svg'
  ];

  static const iconsMessageProfile = [
    'assets/icons/profile/bxs-map.svg',
    'assets/icons/profile/bxs-map.svg',
    'assets/icons/profile/user.svg',
    'assets/icons/profile/biking.svg'
  ];
}

class NetworkUtil {
  static final NetworkUtil _instance = NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;
  final JsonDecoder _decoder = const JsonDecoder();

  _handleResponse(res, BuildContext context) {
    try {
      final resBody = _decoder.convert(res);
      if (resBody != null && resBody is Map && resBody['success'] == -1) {
        Configs.login = null;
        Configs.user = null;
        final db = DatabaseHelper();
        db.deleteUsers();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }), (route) => route is SearchScreen);
        return;
      }
      return resBody;
    } catch (e) {
      return;
    }
  }

  Future<dynamic> get(
      String url, Map<String, String> par, BuildContext context) async {
    final Map<String, String> headers = {};
    final token = Configs.login?.token;
    if (token != null) {
      headers['Authorization'] = token;
    }
    String queryString = Uri(queryParameters: par).query;
    url += "?$queryString";
    url = Configs.BASE_URL + url;
    if (kDebugMode) print(url);
    try {
      return http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 3))
          .then((http.Response response) {
        final String res = response.body;
        // if (kDebugMode) print(res);
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400) {
          return null;
        }
        if (res.length > 4) {
          return _handleResponse(res, context);
        } else {
          return null;
        }
      });
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }

  Future<dynamic> post(
      String url, Map<String, dynamic> body, BuildContext context) async {
    url = Configs.BASE_URL + url;
    if (kDebugMode) print(url);
    final Map<String, String> headers = {};
    final token = Configs.login?.token;
    if (token != null) {
      headers['Authorization'] = token;
    }
    // body["token"] = Configs.login?.token ?? '';
    debugPrint(jsonEncode(body));
    try {
      return http
          .post(Uri.parse(url), body: body, headers: headers)
          .timeout(const Duration(seconds: 3))
          .then((http.Response response) {
        final String res = response.body;
        // if (kDebugMode) print(res);
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400) {
          return null;
        }
        if (res.length > 4) {
          return _handleResponse(res, context);
        } else {
          return null;
        }
      });
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }

  Future<dynamic> postNoUrl(
      String url, Map<String, dynamic> body, BuildContext context,
      {bool formData = true}) async {
    if (kDebugMode) print(url);
    dynamic sendBody;
    final Map<String, String> headers = {};
    final token = Configs.login?.token;
    if (token != null) {
      headers['Authorization'] = token;
    }
    if (formData) {
      sendBody = body;
      // headers['Content-Type'] = 'multipart/form-data';
    } else {
      sendBody = jsonEncode(body);
      headers['Content-Type'] = 'application/json';
    }

    try {
      return http
          .post(Uri.parse(url), body: sendBody, headers: headers)
          .timeout(const Duration(seconds: 3))
          .then((http.Response response) {
        final String res = response.body;
        // if (kDebugMode) print(res);
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400) {
          return null;
        }
        if (res.length > 4) {
          return _handleResponse(res, context);
        } else {
          return null;
        }
      });
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }

  multipartPost(
    String url,
    Map<String, String> body,
    List<http.MultipartFile> files,
    BuildContext context,
  ) async {
    final uri = Uri.parse(Configs.BASE_URL + url);
    final Map<String, String> headers = {};
    final token = Configs.login?.token;
    if (token != null) {
      headers['Authorization'] = token;
    }
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.files.addAll(files);

    request.fields.addAll(body);
    final streamedResponse =
        await request.send().timeout(const Duration(seconds: 5));
    var response = await http.Response.fromStream(streamedResponse);
    // ignore: unused_local_variable

    if (response.statusCode < 200 || response.statusCode > 400) {
      return null;
    }
    final resBody = _decoder.convert(response.body);
    if (resBody != null && resBody['success'] == -1 && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const LoginScreen();
      }), (route) => route is SearchScreen);
      return;
    }
    return resBody;
  }

  logout(BuildContext context) async {
    final token = Configs.login?.token;
    if (token == null) {
      var db = DatabaseHelper();
      db.deleteUsers();
      Configs.user = null;
      Configs.login = null;
      Configs.userGroup = 0;
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }), (route) => route is SearchScreen);
      }
      return;
    }
    Map<String, String> body = {"token": token};
    final result = await get("logout", body, context);
    if (result != null && result['success'] == 1) {
      var db = DatabaseHelper();
      db.deleteUsers();
      Configs.user = null;
      Configs.login = null;
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }), (route) => route is SearchScreen);
      }
    }
  }

  Future<List<TiemNotification>> getNotis(
    int page,
    BuildContext context,
  ) async {
    List<TiemNotification> newData = [];
    const pageLength = 500;
    Map<String, String> body = {
      "limit": pageLength.toString(),
      "offset": (pageLength * page).toString(),
    };
    final result =
        await get(Configs.getNotificationUrl[Configs.userGroup], body, context);
    if (result != null) {
      newData = (result)
          .map<TiemNotification>((item) => TiemNotification.fromJson(item))
          .toList();
    }
    return newData;
  }

  Future<SearchResult?> searchAll({
    String kw = '',
    String shopType = '',
    String quote = '',
    required String lat,
    required String lon,
    required int userGroup,
    required BuildContext context,
  }) async {
    Map<String, String> body = {
      "shop_type": shopType,
      "quote": quote,
      "kw-company": kw,
      "latitude": lat,
      "longitude": lon
    };

    final result = await get(Configs.getSearchUrl(userGroup), body, context);
    if (result == null) {
      return null;
    }
    return SearchResult.fromJson(result);
  }

  Future<int> getUnreadNoti(
    BuildContext context,
  ) async {
    if (Configs.login == null) return 0;
    // String id;
    // switch (Configs.userGroup) {
    //   case 0:
    //     id = Configs.login?.buyerId ?? '';
    //     break;
    //   case 1:
    //     id = Configs.login?.shopId ?? '';
    //     break;
    //   default:
    //     id = Configs.login?.userId ?? '';
    //     break;
    // }
    Map<String, String> body = {
      "role": Configs.role[Configs.userGroup],
      // "id": id
    };
    int unreadNotification = 0;
    final result =
        await get('count_order_notification_not_read', body, context);
    if (result != null) {
      unreadNotification = int.parse(result['c'] ?? '0');
      Configs.unreadMessage.value = unreadNotification;
    }
    // setState(() {});
    return unreadNotification;
  }

  Future<bool> login(
    String username,
    String password,
    int selectedIndex,
    BuildContext context,
  ) async {
    Map<String, String> body = {
      "phone": username,
      'password': password,
      'device_type': 'mobile',
      'device_id': Configs.deviceData['id'] ?? ""
    };
    try {
      final result = await post(Configs.loginUrl[selectedIndex], body, context);
      if (result == null) return false;
      final kq = Login.fromJson(result);
      if (kq.success == 0) return false;
      Configs.login = kq;
      Configs.login!.userName = username.toUpperCase();
      final u = UserData();
      u.taiKhoan = username;
      u.matKhau = password;
      u.loai = selectedIndex;
      // Configs.dbUser = u;
      Configs.login!.userPass = password;
      Configs.userGroup = selectedIndex;
      final db = DatabaseHelper();
      // if (oldUser != null) {
      //   u.cart = oldUser.cart;
      // }
      if (context.mounted) {
        updateCartCount(context);
        await Future.wait([
          db.saveUser(u),
          getProfileInfo(context),
          getUnreadNoti(context),
          _initFirebaseMessage(context),
        ]);
      }

      return true;
    } catch (e) {
      Configs.userGroup = 0;
      return false;
    }
  }

  Future<bool> getProfileInfo(
    BuildContext context,
  ) async {
    final response = await get('user_info', {}, context);
    if (response != null && response['status']) {
      Configs.user = User.fromJson(response['user']);

      return true;
    }
    return false;
  }

  Future<dynamic> dismissNotification(
    String id,
    BuildContext context,
  ) async {
    // String url =
    //     '${Configs.BASE_URL}dismiss_shop_notification?token=${Configs.login?.token}&id=${id}';
    String url = 'read_notification';
    if (kDebugMode) print(url);
    final query = {'noti_id': id};
    return await get(url, query, context);
  }

  Future<dynamic> dismissAllNotification(
    BuildContext context,
  ) async {
    final notificationUrls = [
      'update_read_notification_buyer',
      'update_read_notification_shop',
      'update_read_notification_shop',
      'update_read_notification_shipper'
    ];
    // String url =
    //     '${Configs.BASE_URL}dismiss_shop_notification?token=${Configs.login?.token}&id=${id}';
    String url = notificationUrls[Configs.userGroup];
    if (kDebugMode) print(url);

    return await get(url, {}, context);
  }

  // Future<dynamic> getorther(String url, Map<String, dynamic> par) async {
  //   String queryString = Uri(queryParameters: par).query;
  //   url += "?$queryString";

  //   if (kDebugMode) print(url);
  //   try {
  //     return http
  //         .get(Uri.parse(url))
  //         .timeout(const Duration(seconds: 3))
  //         .then((http.Response response) {
  //       final String res = response.body;
  //       // if (kDebugMode) print(res);
  //       final int statusCode = response.statusCode;

  //       if (statusCode < 200 || statusCode > 400) {
  //         return null;
  //       }
  //       if (res.length > 4) {
  //         return _decoder.convert(res);
  //       } else {
  //         return null;
  //       }
  //     });
  //   } catch (e) {
  //     if (kDebugMode) print(e);
  //     return null;
  //   }
  // }

  Future _initFirebaseMessage(
    BuildContext context,
  ) async {
    iOSPermission();
    String? apnsToken;
    if (Platform.isIOS) {
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      debugPrint("apnsToken: $apnsToken");
    }
    FirebaseMessaging.instance
        .getToken(
            // vapidKey:
            // 'AAAA0LOt9BA:APA91bEu8j477fvUsQGu-I4bgdkkiOohoa_yoiWhUHfpVIel5BfK9WrCyF72fhRGUvqhiqWydz8-3YomWBxk1p9qwfIR6h6GwptOA4cIgQvbl3DCH3UDU6XR6AdV7fVXJJov3zJ3rHBi',
            // 'AIzaSyCl4_vHUilnxQlqaL4qAVfLgkfCOj8rnQU',
            )
        .then((value) => setToken(value, context));
    final tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    tokenStream.listen((value) => setToken(value, context));
  }

  void iOSPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  setToken(
    String? token,
    BuildContext context,
  ) {
    debugPrint('token: $token');
    // var data = Configs.deviceData;
    Map<String, String> body = {
      // "deviceId": data["deviceId"],
      // "userId": Configs.login?.userId ?? '',
      // "shopId": Configs.login?.shopId ?? '',
      // "platform": Platform.operatingSystem,
      "noti_token": token ?? '',
    };

    get("update_noti_token", body, context).then((rs) {
      debugPrint('result: $rs');
      if (kDebugMode) {
        print(token);
      }
    });
    // try {
    //   _networkUtil
    //       .getorther("http://210.211.116.207:8010/Upload/NotiToken", body)
    //       .then((rs) {});
    //   // ignore: empty_catches
    // } catch (e) {}
  }

  deleteCartOnline(
    String? shopId,
    BuildContext context,
  ) async {
    final body = {
      'buyer_id': Configs.login?.buyerId,
      'shop_id': shopId ?? '',
    };
    final result = await post('delete_cart_in_shop', body, context);
    if (result != null && result['success'] == 1 && context.mounted) {
      await updateCartCount(context);
      return;
    }
  }

  updateCartCount(
    BuildContext context,
  ) async {
    if (Configs.userGroup == 0) {
      final carts = await get(
          'count_cart_number',
          {
            'buyer_id': Configs.login?.buyerId ?? '',
          },
          context);
      if (carts != null) {
        debugPrint(jsonEncode(carts));
        Configs.countCart.value = int.tryParse(carts['data']['count']) ?? 0;
      }
    }
  }
}

class BSCDeviceInfo {
  Future<void> initPlatformState(DeviceInfoPlugin deviceInfoPlugin) async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    Configs.deviceData = deviceData;
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'isPhysicalDevice': build.isPhysicalDevice,
      'deviceId': build.androidId,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'deviceId': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}

Future<Position> getCurrentLocation(BuildContext context) async {
  bool serviceEnabled;
  LocationSettings locationSettings;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled && context.mounted) {
    showDialog(
        context: context,
        builder: (_) {
          return DialogAction(
            icon: Image.asset('assets/images/logo.png'),
            title: 'Cho phép sử dụng vị trí của bạn',
            content:
                'Ứng dụng cần truy cập vị trí của bạn để có thể sử dụng tính năng',
            text1: 'Đồng ý',
            text2: 'Không',
            onTap1: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
            onTap2: () => Navigator.pop(context),
          );
        });
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "Example app will continue to receive your location even when you aren't using it",
          notificationTitle: "Running in Background",
          enableWakeLock: true,
        ));
  } else if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    locationSettings = AppleSettings(
      accuracy: LocationAccuracy.high,
      activityType: ActivityType.fitness,
      distanceFilter: 100,
      pauseLocationUpdatesAutomatically: true,
      showBackgroundLocationIndicator: false,
    );
  } else {
    locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
  }
  return await Geolocator.getPositionStream(locationSettings: locationSettings)
      .first;
}

getWidgetImage(GlobalKey? key) async {
  try {
    final boundary =
        key?.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      Fluttertoast.showToast(msg: "Lưu ảnh không thành công");
      return;
    }
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      Fluttertoast.showToast(msg: "Lưu ảnh không thành công");
      return;
    }
    var pngBytes = byteData.buffer.asUint8List();
    await ImageGallerySaver.saveImage(pngBytes);
    Fluttertoast.showToast(msg: "Lưu ảnh thành công ");
  } catch (exception) {
    Fluttertoast.showToast(msg: "Lưu ảnh không thành công");
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeByWord() {
    if (trim().isEmpty) {
      return '';
    }
    final listWord = split(' ');
    if (listWord.isEmpty) return '';
    if (listWord.length < 2) {
      return capitalize();
    }
    final listString = split(' ');
    for (var element in listString) {
      if (element.isNotEmpty) {
        element.capitalize();
      }
    }
    return listString.join(" ");
  }
}
