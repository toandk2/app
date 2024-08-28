import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/anmition/fadeanimation.dart';
import 'package:hkd/register/register_screen.dart';
import 'package:hkd/trade/shop_list_screen.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/user/change_password_screen.dart';
import 'package:hkd/user/login_screen.dart';
import 'package:hkd/notification_screen.dart';
import 'package:hkd/search_screen.dart';
import 'package:hkd/shipper/shipper_home_page.dart';
import 'package:hkd/shop/shop_find_shipper_screen.dart';
import 'package:hkd/shop/shop_home_page.dart';
import 'package:hkd/trade/cart_screen.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

// myAppBar() {
//   return GFAppBar(
//     backgroundColor: const Color(0xFFFEDD02),
//     automaticallyImplyLeading: false,
//     title: Row(
//       children: [
//         FadeAnimation(
//           delay: 0.8,
//           child: Gap(
//             width: 36,
//             height: 36,
//             child: Image.asset(
//               "assets/images/logo.png",
//             ),
//           ),
//         ),
//         const Text(
//           'hokinhdoanh.\nonline',
//           style: TextStyle(
//             color: Color(0xFF303030),
//             fontSize: 14,
//             fontFamily: 'Inter',
//             fontWeight: FontWeight.w600,
//             height: 0,
//           ),
//         ),
//       ],
//     ),
//   );
// }

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
    required this.parentContext,
    // required this.countNoti,
  }) : super(key: key);
  final BuildContext parentContext;
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // final int countNoti;
  final _netUtil = NetworkUtil();
  bool _showSecondProfile = false;
  toggleShow() {
    _showSecondProfile = !_showSecondProfile;
    setState(() {});
  }

  _findNpp() async {
    const tempUser = 1;
    try {
      await EasyLoading.show();
      final String response =
          await rootBundle.loadString('assets/json/roles.json');
      final models = await json.decode(response);
      final shopsData = ShoptypeModel.fromListJson(models);
      // if (Configs.userGroup != 1) return;
      final parentContext = widget.parentContext;
      if (parentContext.mounted) {
        final result = await _netUtil.searchAll(
          kw: '',
          shopType: '',
          quote: '',
          lat: '21',
          lon: '105.85',
          userGroup: tempUser,
          context: parentContext,
        );
        (result?.shops ?? []).sort((a, b) => double.parse(a.distance ?? '0')
            .compareTo(double.parse(b.distance ?? '0')));
        await EasyLoading.dismiss();
        Navigator.of(parentContext).pushAndRemoveUntil(
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => ShopListWidget(
              shops: result?.shops ?? [],
              temporaryUserGroup: tempUser,
              position: LatLng(double.parse('21'), double.parse('105.85')),
              shopsData: shopsData,
            ),
          ),
          ModalRoute.withName('/home'),
        );
      }
    } catch (e) {
      await EasyLoading.dismiss();
      debugPrint(jsonEncode(e));
    }
  }

  SecondProfile? _firstProfile;
  SecondProfile? _secondProfile;

  @override
  void initState() {
    if (Configs.login == null) return;
    _netUtil.getUnreadNoti(widget.parentContext);
    if (Configs.userGroup == 3) {
      _firstProfile = SecondProfile(
        id: Configs.login?.userId ?? '',
        name: Configs.login?.name ?? '',
        type: 3,
      );
      return;
    }
    _netUtil.updateCartCount(widget.parentContext);
    if (Configs.userGroup == 0) {
      _firstProfile = SecondProfile(
        id: Configs.login?.buyerId ?? '',
        name: Configs.login?.buyerName ?? '',
        type: 0,
      );
      if (Configs.login?.shopId != null && Configs.login?.shopId != '0') {
        _secondProfile = SecondProfile(
          id: Configs.login?.shopId ?? '',
          name: Configs.login?.shopName ?? '',
          type: 1,
        );
      }
    }
    if (Configs.userGroup == 1) {
      _firstProfile = SecondProfile(
        id: Configs.login?.shopId ?? '',
        name: Configs.login?.shopName ?? '',
        type: 1,
      );
      if (Configs.login?.buyerId != null && Configs.login?.buyerId != '0') {
        _secondProfile = SecondProfile(
          id: Configs.login?.buyerId ?? '',
          name: Configs.login?.buyerName ?? '',
          type: 0,
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GFDrawer(
      color: const Color(0xFFF7F7F7),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Configs.user == null
            ? Column(
                children: [
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // if (Configs.userGroup == 1) {
                            //   launchUrl(Uri.parse(
                            //       'https://hokinhdoanh.online/login'));
                            //   return;
                            // }
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const SearchScreen(),
                                ),
                                ModalRoute.withName('/home'));
                          },
                          child: Row(
                            children: [
                              FadeAnimation(
                                delay: 0.8,
                                child: SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                  ),
                                ),
                              ),
                              const Text(
                                // Configs.userGroup == 1
                                //     ? 'hokinhdoanh.\nonline'
                                //     :
                                'dothi\nthongminh1',
                                style: Styles.headline3Style,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset('assets/icons/drawer/close.png'),
                        ),
                      )
                    ],
                  ),
                  const Gap(20),
                  GFButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                const RegisterScreen(),
                          ),
                          ModalRoute.withName('/home'));
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    borderShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    size: 48,
                    fullWidthButton: true,
                    child: Text(
                      "Đăng ký",
                      style:
                          Styles.headline4Style.copyWith(color: Colors.white),
                    ),
                  ),
                  const Gap(12),
                  GFButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) {
                        return const LoginScreen();
                      }), ModalRoute.withName('/home'));
                    },
                    padding: const EdgeInsets.all(16),
                    borderShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    fullWidthButton: true,
                    size: 48,
                    // type: GFButtonType.outline,
                    color: Colors.white,
                    text: 'Đã có tài khoản? Đăng nhập',
                    textColor: Styles.primaryColor3,
                  ),
                ],
              )
            : Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (Configs.userGroup == 0)
                  const Gap(20),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 12,
                            offset: Offset(0, 8),
                            spreadRadius: -4,
                          ),
                        ]),
                    // height: 50,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: toggleShow,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFFB2B2B2),
                                backgroundImage: NetworkImage(Configs.BASE_URL
                                        .replaceAll('/api', '/images/avatars') +
                                    (Configs.user?.linkImg ?? '')),
                                radius: 20,
                              ),
                              if (_secondProfile != null)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const ShapeDecoration(
                                      color: Styles.textColor,
                                      shape: OvalBorder(),
                                    ),
                                    height: 20,
                                    width: 20,
                                    child: Icon(
                                      _showSecondProfile
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) {
                                  if (Configs.userGroup != 3) {
                                    return const ShopPage(
                                        // pageIndex: 0,
                                        );
                                  }
                                  return const ShipperPage();
                                }),
                                ModalRoute.withName('/home'),
                              );
                            },
                            child: Row(
                              children: [
                                const Gap(
                                  6,
                                ),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _firstProfile?.name ?? '',
                                          style: Styles.headline4Style,
                                        ),
                                        const Gap(4),
                                        Text(
                                          '${Configs.selectType[_firstProfile?.type ?? 0]?['text'] ?? ''} - ${_firstProfile?.id ?? ''}',
                                          style: Styles.headline4Style.copyWith(
                                              color: Styles.textColor,
                                              fontSize: 13),
                                        )
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(
                          12,
                        ),
                        if (Configs.userGroup == 0)
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const CartScreen(),
                                ),
                                ModalRoute.withName('/home'),
                              );
                            },
                            child: Stack(
                              children: [
                                const Icon(
                                  Icons.shopping_cart_rounded,
                                  size: 24,
                                ),
                                Positioned(
                                  // draw a red marble
                                  top: 0.0,
                                  right: 0.0,
                                  child: StreamBuilder<int>(
                                      stream: Configs.countCart,
                                      builder: (context, snapshot) {
                                        return Badge.count(
                                            count: snapshot.data ?? 0);
                                      }),
                                )
                              ],
                            ),
                          ),
                        const Gap(
                          12,
                        ),
                        InkWell(
                            onTap: () async {
                              await _netUtil.logout(widget.parentContext);
                            },
                            // child: Lottie.asset("assets/images/logout.json",
                            //     repeat: true,
                            //     reverse: true,
                            //     animate: true,
                            //     height: 40),
                            child: Image.asset(
                              'assets/images/bx-log-out.png',
                              height: 40,
                            ))
                      ],
                    ),
                  ),
                  if (_showSecondProfile && _secondProfile != null)
                    InkWell(
                      onTap: () async {
                        final result = await _netUtil.post(
                            'switch_user', {}, widget.parentContext);
                        if (result != null &&
                            result['success'] == 1 &&
                            mounted) {
                          Configs.login?.token = result['token'];
                          final oldUserGroup = Configs.userGroup;
                          Configs.userGroup = oldUserGroup == 1 ? 0 : 1;
                          await _netUtil.getProfileInfo(widget.parentContext);
                          switch (Configs.userGroup) {
                            case 3:
                              Navigator.of(widget.parentContext)
                                  .pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) {
                                  return const ShipperPage();
                                }),
                                ModalRoute.withName('/home'),
                              );
                              break;
                            default:
                              Navigator.of(widget.parentContext)
                                  .pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) {
                                  return const ShopPage();
                                }),
                                ModalRoute.withName('/home'),
                              );
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Đổi tài khoản không thành công');
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 12,
                                offset: Offset(0, 8),
                                spreadRadius: -4,
                              ),
                            ]),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFFB2B2B2),
                              backgroundImage: NetworkImage(Configs.BASE_URL
                                      .replaceAll('/api', '/images/avatars') +
                                  (Configs.user?.linkImg ?? '')),
                              radius: 20,
                            ),
                            const Gap(4),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _secondProfile?.name ?? '',
                                      style: Styles.headline4Style,
                                    ),
                                    const Gap(4),
                                    Text(
                                      '${Configs.selectType[_secondProfile?.type ?? 0]?['text'] ?? ''} - ${_secondProfile?.id ?? ''}',
                                      style: Styles.textStyle,
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),

                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const Text(
                          'DÀNH CHO NGƯỜI MUA',
                          style: Styles.textStyle,
                        ),
                        const Gap(
                          8,
                        ),
                        DrawerButton(
                          icon: 'assets/icons/drawer/cart.png',
                          text: 'Tìm kiếm sản phẩm',
                          isBold: Configs.userGroup == 0,
                          onTap: () {
                            // if (Configs.userGroup != 0) return;
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const SearchScreen(
                                    tempUserGroup: 0,
                                  ),
                                ),
                                ModalRoute.withName('/home'));
                          },
                        ),
                        const Gap(
                          12,
                        ),
                        const Text(
                          'DÀNH CHO HỘ KINH DOANH',
                          style: Styles.textStyle,
                        ),
                        const Gap(
                          8,
                        ),
                        DrawerButton(
                          icon: 'assets/icons/drawer/box.png',
                          text: 'Tìm kiếm nhà cung cấp',
                          isBold: Configs.userGroup == 1,
                          onTap: () => _findNpp(),
                        ),
                        DrawerButton(
                          icon: 'assets/icons/drawer/bill.png',
                          text: 'Xem đơn nhập dự kiến',
                          isBold: Configs.userGroup == 1,
                          onTap: () {
                            if (Configs.userGroup != 1) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Bạn đang không đăng nhập với tư cách là hộ kinh doanh.\nVui lòng đăng nhập đúng đối tượng để thao tác');
                              return;
                            }
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const ShopPage(),
                              ),
                              ModalRoute.withName('/home'),
                            );
                          },
                        ),
                        if (Configs.userGroup == 1)
                          DrawerButton(
                            icon: 'assets/icons/drawer/bike.png',
                            text: 'Tìm người vận chuyển',
                            isBold: Configs.userGroup == 1,
                            onTap: () {
                              if (Configs.userGroup != 1) return;
                              Navigator.of(widget.parentContext)
                                  .pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const ShopFindShipperScreen(),
                                ),
                                ModalRoute.withName('/home'),
                              );
                            },
                          ),
                        const Gap(
                          12,
                        ),
                        const Text(
                          'DÀNH CHO NGƯỜI VẬN CHUYỂN',
                          style: Styles.textStyle,
                        ),
                        const Gap(
                          8,
                        ),
                        DrawerButton(
                          icon: 'assets/icons/drawer/bill.png',
                          text: 'Xem đơn cần chuyển',
                          isBold: Configs.userGroup == 3,
                          onTap: () {
                            if (Configs.userGroup != 3) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Bạn đang không đăng nhập với tư cách là người vận chuyển.\nVui lòng đăng nhập đúng đối tượng để thao tác');
                              return;
                            }
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const ShipperPage(),
                                ),
                                ModalRoute.withName('/home'));
                          },
                        ),
                      ],
                    ),
                  ),
                  const Gap(6),

                  Column(
                    children: [
                      DrawerButton(
                        icon: 'assets/icons/drawer/lock.png',
                        text: 'Thay đổi mật khẩu',
                        isBold: true,
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) {
                              return const ChangPasswordScreen();
                            }),
                            ModalRoute.withName('/home'),
                          );
                        },
                      ),
                      const Gap(2),
                      DrawerButton(
                        icon: 'assets/icons/drawer/bell.png',
                        text: 'Thông báo',
                        isBold: true,
                        suffixIcon: StreamBuilder<int>(
                            stream: Configs.unreadMessage,
                            builder: (context, snapshot) {
                              return Badge.count(
                                // count: 100,
                                smallSize: 12,
                                largeSize: 28,
                                count: snapshot.data ?? 0,
                              );
                            }),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) {
                                return const NotificationScreen();
                              },
                            ),
                            ModalRoute.withName('/home'),
                          );
                        },
                      ),
                      const Gap(4),
                    ],
                  ),
                  Container(
                    // height: 56,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 12,
                          offset: Offset(0, 8),
                          spreadRadius: -4,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (Configs.userGroup == 1) {
                                launchUrl(Uri.parse(
                                    'https://hokinhdoanh.online/login?token=${Configs.login?.token}'));
                                return;
                              }
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const SearchScreen(),
                                  ),
                                  ModalRoute.withName('/home'));
                            },
                            child: Row(
                              children: [
                                FadeAnimation(
                                  delay: 0.8,
                                  child: SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Image.asset(
                                      "assets/images/logo.png",
                                    ),
                                  ),
                                ),
                                Text(
                                  Configs.userGroup == 1
                                      ? 'hokinhdoanh.\nonline'
                                      : 'dothi\nthongminh1',
                                  style: Styles.headline4Style,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset('assets/icons/drawer/close.png'),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.suffixIcon,
    this.isBold = false,
  }) : super(key: key);
  final String icon;
  final String text;
  final Function onTap;
  final bool isBold;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap.call();
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 12,
              offset: Offset(0, 8),
              spreadRadius: -4,
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              color: Configs.getUserColor(Configs.userGroup),
            ),
            const Gap(12),
            Expanded(
              child: Text(
                text,
                style: Styles.headline3Style.copyWith(
                    color: isBold ? Styles.textColor : Styles.fieldTextColor,
                    fontSize: 15),
              ),
            ),
            suffixIcon ?? const SizedBox()
          ],
        ),
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final GFAppBar? appBar;
  final bool resizeToAvoidBottomInset;
  const MyScaffold(
      {Key? key,
      required this.body,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.backgroundColor,
      this.appBar,
      this.resizeToAvoidBottomInset = true})
      : super(key: key);

  // final _netUtil = NetworkUtil();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          GFAppBar(
            // backgroundColor: Colors.white,
            backgroundColor: const Color(0xFFFEDD02),
            automaticallyImplyLeading: false,
            title: InkWell(
              onTap: () {
                // if (Configs.userGroup == 1) {
                //   launchUrl(Uri.parse('https://hokinhdoanh.online/login'));
                //   return;
                // }
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const SearchScreen(),
                    ),
                    ModalRoute.withName('/home'));
              },
              child: Row(
                children: [
                  FadeAnimation(
                    delay: 0.8,
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Image.asset(
                        "assets/images/logo.png",
                      ),
                    ),
                  ),
                  const Text(
                    // Configs.userGroup == 1
                    //     ? 'hokinhdoanh.\nonline'
                    //     :
                    'dothi\nthongminh1',
                    style: TextStyle(
                      color: Color(0xFF303030),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
      endDrawer: MyDrawer(
        // countNoti: newsCount,
        parentContext: context,
      ),
      // drawer: const GFDrawer(),
      body: body,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor ?? const Color(0xFFF7F7F7),
    );
  }
}

class SecondProfile {
  String id;
  String name;
  int type;

  SecondProfile({
    required this.id,
    required this.name,
    required this.type,
  });
}
