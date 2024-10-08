import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hkd/order_detail/buyer_order_detail_screen.dart';
// import 'package:hkd/order_detail/shipper_order_detail_screen.dart';
// import 'package:hkd/order_detail/shop_order_detail_screen.dart';
import 'package:hkd/search_screen.dart';
import 'package:hkd/shipper/shipper_home_page.dart';
import 'package:hkd/shop/shop_home_page.dart';
import 'package:hkd/ultils/database_helper.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:package_info/package_info.dart';

import 'anmition/fadeanimation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
    // this.isNotificationNavigate = false,
  }) : super(key: key);
  // final bool isNotificationNavigate;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color enabled = const Color(0xFF827F8A);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;

  Color backgroundColor = const Color(0xFF1F1A30);
  BSCDeviceInfo info = BSCDeviceInfo();
  final _networkUtil = NetworkUtil();
  // final bool _isLoading = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    // info.initPlatformState(deviceInfoPlugin).then((value) {
    //     _login();
    //     // if (mounted) {
    //     //   _goLogin(context);
    //     // }
    // });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  _init() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    await info.initPlatformState(deviceInfoPlugin);
    await Future.delayed(const Duration(seconds: 1), () async {
      await _login();
    });
  }

  // advancedStatusCheck(NewVersion newVersion) async {
  //   final status = await newVersion.getVersionStatus();
  //   if (status != null) {
  //     if (status.canUpdate) {
  //       newVersion.showUpdateDialog(
  //           context: context,
  //           versionStatus: status,
  //           dialogTitle: 'Cảnh báo',
  //           dialogText:
  //               'Tìm thấy phiên bản mới, vui lòng cập nhật để tiếp tục sử dụng.',
  //           updateButtonText: 'Cập nhật',
  //           dismissButtonText: 'Bỏ qua',
  //           dismissAction: () {
  //             _login();
  //           },
  //           allowDismissal: true);
  //     } else {
  //       _login();
  //     }
  //   } else {
  //     _login();
  //   }
  // }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color(0xFF1F1A30),
        body: SizedBox(
          width: we,
          height: he,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              FadeAnimation(
                delay: 0.8,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: we * 0.5,
                  height: he * 0.3,
                ),
              ),
              FadeAnimation(
                delay: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Ứng dụng dành cho chủ hộ kinh doanh, người tìm mua và người vận chuyển",
                    textAlign: TextAlign.center,
                    style: Styles.headline2Style.copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: he * 0.04,
              ),
              const FadeAnimation(
                  delay: 1,
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.orangeAccent,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.orange))),
            ],
          ),
        ),
        bottomNavigationBar: FadeAnimation(
          delay: 1,
          child: Container(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Phiên bản ", style: Styles.textStyle),
                Text(_packageInfo.version,
                    style: Styles.textStyle.copyWith(color: Styles.orangeColor))
              ],
            ),
          ),
        ));
  }

  Future<void> _login() async {
    final helper = DatabaseHelper();
    final isLoggedin = await helper.isLoggedIn();
    if (!isLoggedin && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return const SearchScreen();
        }),
      );
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }
    final user = await helper.getUser();
    if (user == null && mounted) {
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (context) {
      //     return const SearchScreen();
      //   }),
      // );
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }
    if (mounted) {
      final result = await _networkUtil.login(
        user?.taiKhoan ?? '',
        user?.matKhau ?? '',
        user?.loai ?? 0, context,
        // oldUser: user,
      );

      // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //   return const SearchScreen();
      // }));
      if (result && mounted) {
        Fluttertoast.showToast(msg: "Chào mừng quay trở lại.");
        // if (!widget.isNotificationNavigate) {
        Navigator.pushReplacementNamed(context, '/home');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          switch (Configs.userGroup) {
            case 3:
              return const ShipperPage();
            default:
              return const ShopPage();
          }
        }));
        //   return;
        // }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute<dynamic>(
        //     builder: (BuildContext context) {
        //       switch (Configs.userGroup) {
        //         case 0:
        //           return const BuyerOrderDetailScreen();
        //         case 3:
        //           return const ShipperOrderDetailScreen();
        //         default:
        //           return const ShopOrderDetailScreen();
        //       }
        //     },
        //   ),
        // );
      }
    }
  }
}
