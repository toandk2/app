import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/anmition/fadeanimation.dart';
import 'package:hkd/register/register_screen.dart';
import 'package:hkd/shipper/shipper_home_page.dart';
import 'package:hkd/shop/shop_home_page.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/user/forgot_password_screen.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/custom_textfield.dart';

enum Gender {
  email,
  password,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // Color deaible = Colors.grey;
  late TabController _tabController;
  // final mau = [Colors.blue, Colors.orange, Colors.red];
  bool ispasswordev = true;
  // Gender selected;
  final formKey = GlobalKey<FormState>();
  String? _username, _password;
  final networkUtil = NetworkUtil();
  bool _isLoading = false;
  // List<Map<String, String>> selectType = [];
  // PackageInfo _packageInfo = PackageInfo(
  //   appName: 'Unknown',
  //   packageName: 'Unknown',
  //   version: 'Unknown',
  //   buildNumber: 'Unknown',
  // );
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // selectType = Configs.selectType.nonNulls.toList();
    _initPackageInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    // final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      // _packageInfo = info;
    });
  }

  _onRegister() {
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const RegisterScreen(),
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const FadeAnimation(
                  delay: 1,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Đăng nhập",
                      style: Styles.headline1Style,
                    ),
                  ),
                ),
                FadeAnimation(
                  delay: 1,
                  child: Row(
                    children: List.generate(
                      Configs.selectType.length,
                      (index) {
                        final selectedType = Configs.selectType[index];
                        if (selectedType == null) return const SizedBox();
                        return Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(6.0),
                              padding: const EdgeInsets.all(12),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: selectedIndex == index
                                          ? GFColors.PRIMARY
                                          : Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x0A000000),
                                    blurRadius: 12,
                                    offset: Offset(0, 8),
                                    spreadRadius: -4,
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Image.asset(
                                        'assets/icons/login/${selectedType['icon']}.png'),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    selectedType['text'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Color(0xFF23313E), fontSize: 12),
                                  ),
                                  IgnorePointer(
                                    ignoring: true,
                                    child: Radio(
                                      // size: GFSize.SMALL,
                                      value: index,
                                      groupValue: selectedIndex,
                                      onChanged: (value) {
                                        // setState(() {
                                        //   selectedIndex = index;
                                        // });
                                      },
                                      // co: selectedIndex == index
                                      //     ? GFColors.PRIMARY
                                      //     : null,
                                      activeColor: selectedIndex == index
                                          ? GFColors.PRIMARY
                                          : GFColors.FOCUS,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 24),
                  child: Text(
                    'Số điện thoại',
                    style: TextStyle(
                      color: Color(0xFF808080),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 0.11,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextfield(
                    onTap: () {
                      // setState(() {
                      //   selected = Gender.email;
                      // });
                    },
                    onSaved: (val) => _username = val,
                    validator: (val) {
                      return val?.isNotEmpty != true
                          ? "Tài khoản không hợp lệ"
                          : null;
                    },
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Styles.fieldTextColor,
                    ),
                    hintText: 'Tài khoản/Số điện thoại',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 20),
                  child: Text(
                    'Mật khẩu',
                    style: TextStyle(
                      color: Color(0xFF808080),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 0.11,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextfield(
                      onSaved: (val) => _password = val,
                      validator: (val) {
                        return val?.isNotEmpty != true
                            ? "Mật khẩu không được trống"
                            : null;
                      },
                      prefixIcon: const Icon(
                        Icons.lock_open_outlined,
                        color: Styles.fieldTextColor,
                      ),
                      suffixIcon: IconButton(
                        icon: ispasswordev
                            ? const Icon(
                                Icons.visibility_off,
                                color: Styles.fieldTextColor,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Styles.fieldTextColor,
                              ),
                        onPressed: () =>
                            setState(() => ispasswordev = !ispasswordev),
                      ),
                      hintText: 'Mật khẩu',
                      // hintStyle: TextStyle(color: Styles.fieldTextColor),
                      // ),
                      textInputAction: TextInputAction.done,
                      obscureText: ispasswordev,
                      onSubmitted: _submit),
                ),
                const SizedBox(
                  height: 12,
                ),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Styles.primaryColor3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Styles.primaryColor3)),
                      )
                    : FadeAnimation(
                        delay: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: GFButton(
                            onPressed: _submit,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            borderShape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Styles.primaryColor3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            size: 48,
                            fullWidthButton: true,
                            child: Text(
                              "Đăng nhập",
                              style: Styles.headline4Style
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: GFButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    type: GFButtonType.transparent,
                    child: const Text(
                      'Quên mật khẩu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 14,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.w400,
                        height: 0.11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: GFButton(
          onPressed: _onRegister,
          padding: const EdgeInsets.all(16),
          borderShape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Styles.primaryColor3),
            borderRadius: BorderRadius.circular(6),
          ),
          size: 48,
          type: GFButtonType.outline,
          color: Colors.white,
          text: 'Chưa có tài khoản? Đăng ký ngay',
          textColor: Styles.primaryColor3,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final form = formKey.currentState;
    if (form?.validate() == true) {
      setState(() => _isLoading = true);
      form?.save();

      try {
        final loginResult = await networkUtil.login(
            _username ?? '', _password ?? "", selectedIndex,context);
        setState(() => _isLoading = false);

        if (!loginResult) {
          Fluttertoast.showToast(msg: "Đăng nhập không thành công.");
          return;
        }

        Fluttertoast.showToast(msg: "Đăng nhập thành công.");

        if (mounted) {
          switch (Configs.userGroup) {
            case 3:
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return const ShipperPage();
              }), (Route<dynamic> route) => false);
              break;
            default:
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return const ShopPage();
              }), (Route<dynamic> route) => false);
          }
        }
        // if (Configs.unSignedCart.isNotEmpty && mounted) {
          // showDialog(
          //   context: context,
          //   builder: (_) {
          //     return DialogAction(
          //       icon: Image.asset('assets/images/icons-complete.png'),
          //       title: 'Thêm hàng vãn lai',
          //       content:
          //           'Bạn có các sản phẩm trong giỏ hàng, bạn có muốn thêm vào giỏ hàng của mình không?',
          //       text1: 'Đồng ý',
          //       text2: 'Không',
          //       onTap1: () async {
          //         Navigator.pop(context);
          //         await EasyLoading.show(
          //           status: 'Đang tải xử lý...',
          //           maskType: EasyLoadingMaskType.clear,
          //         );
          //         final body = {
          //           'token': Configs.login?.token ?? '',
          //           'order_id': order?.id ?? ''
          //         };
          //         final result =
          //             await _netUtil.post('buyer_cancel_order', body);
          //         await EasyLoading.dismiss();
          //         if (result != null && result['success'] == 1) {
          //           Fluttertoast.showToast(msg: 'Huỷ đơn hàng thành công');
          //           if (mounted) {
          //             Navigator.of(context).pushAndRemoveUntil(
          //                 MaterialPageRoute(builder: (context) {
          //               return const ShopPage(
          //                 status: -3,
          //               );
          //             }), (Route<dynamic> route) => false);
          //           }
          //         } else {
          //           Fluttertoast.showToast(msg: 'Huỷ đơn hàng thất bại');
          //         }
          //       },
          //       onTap2: () => Navigator.pop(context),
          //     );
          //   });
        // }
      } catch (e) {
        Fluttertoast.showToast(msg: "Đăng nhập không thành công.");
        setState(() => _isLoading = false);
      }
    }
  }
}
