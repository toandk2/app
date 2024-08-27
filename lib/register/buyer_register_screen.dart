import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/anmition/fadeanimation.dart';
import 'package:hkd/shop/shop_home_page.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/custom_searchbar.dart';
import 'package:hkd/widgets/custom_textfield.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuyerRegisterScreen extends StatefulWidget {
  const BuyerRegisterScreen({Key? key}) : super(key: key);

  @override
  State<BuyerRegisterScreen> createState() => _BuyerRegisterScreenState();
}

class _BuyerRegisterScreenState extends State<BuyerRegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final networkUtil = NetworkUtil();
  String? placeName;
  final buyerModel = BuyerRegisterModel();
  bool _isLoading = false;
  WebViewController? _controller;
  bool _checkedTerm = false;
  String? validatePassword;

  @override
  void initState() {
    _loadHtml();
    super.initState();
  }

  _loadHtml() async {
    _controller = WebViewController();

    final htmlString =
        await rootBundle.loadString('assets/json/buyer_term.html');
    _controller?.loadHtmlString(htmlString);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final form = formKey.currentState;
    if (form?.validate() == true) {
      form?.save();
      if (validatePassword != buyerModel.password) {
        Fluttertoast.showToast(msg: "Mật khẩu không đúng.");
        return;
      }
      if (!_checkedTerm) {
        Fluttertoast.showToast(msg: 'Bạn cần chấp nhận điều khoản sử dụng');
        return;
      }
      setState(() => _isLoading = true);
      buyerModel.deviceType = 'mobile';
      buyerModel.deviceId = Configs.deviceData['id'] ?? "";

      final json = buyerModel.toJson();
      try {
        final result = await networkUtil.post('buyer_create', json, context);
        setState(() => _isLoading = false);
        if (result['success'] == 1 && mounted) {
          final loginResult = await networkUtil.login(
              buyerModel.phone ?? '', buyerModel.password ?? '', 0, context);

          if (!loginResult) {
            Fluttertoast.showToast(msg: "Đăng nhập không thành công.");
            return;
          }
          Fluttertoast.showToast(msg: "Đăng nhập thành công.");
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const ShopPage(),
                ),
                ModalRoute.withName('/home'));
          }
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Đăng nhập không thành công.");
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FadeAnimation(
                    delay: 1,
                    child: Text(
                      "Đăng ký tài khoản người tìm mua",
                      style: Styles.headline1Style,
                    ),
                  ),
                  const Gap(
                    12,
                  ),
                  const FadeAnimation(
                    delay: 1,
                    child: Text(
                      'Tạo tài khoản Đô thị Thông minh để theo dõi đơn hàng của bạn',
                      style: Styles.textStyle,
                    ),
                  ),
                  const Gap(
                    12,
                  ),
                  const FadeAnimation(
                    delay: 1,
                    child: Text(
                      'THÔNG TIN CÁ NHÂN',
                      style: Styles.headline3Style,
                    ),
                  ),
                  const Gap(
                    20,
                  ),
                  const Text('Họ và tên', style: Styles.textStyle),
                  const Gap(
                    8,
                  ),
                  CustomTextfield(
                    onSaved: (val) {
                      buyerModel.name = val;
                    },
                    validator: (val) {
                      return val?.isNotEmpty != true
                          ? "Họ và tên không để trống"
                          : null;
                    },
                    hintText: 'Nhập họ và tên',
                  ),
                  const Gap(
                    20,
                  ),
                  const Text('Vị trí', style: Styles.textStyle),
                  const Gap(
                    8,
                  ),
                  LocationSearchbar(
                    onSelected: (model) {
                      buyerModel.lat = model.lat;
                      buyerModel.lon = model.lon;
                      buyerModel.location =
                          '${model.tinh},${model.huyen},${model.xa}';
                    },
                  ),
                  const Gap(
                    20,
                  ),
                  const Text('Địa chỉ', style: Styles.textStyle),
                  const Gap(
                    8,
                  ),
                  CustomTextfield(
                    // textCtrl: _textCtrl,
                    onChanged: (val) {
                      buyerModel.address = val;
                    },
                    // onSaved: (val) {
                    //   widget.updateDiachi(val ?? '');
                    // },
                    validator: (val) {
                      return val?.isNotEmpty != true
                          ? "Địa chỉ không để trống"
                          : null;
                    },
                    hintText: 'Nhập địa chỉ',
                  ),
                  const Gap(
                    20,
                  ),
                  const Text('Số điện thoại', style: Styles.textStyle),
                  const Gap(
                    8,
                  ),
                  CustomTextfield(
                    onSaved: (val) {
                      buyerModel.phone = val;
                    },
                    validator: (val) {
                      if (val?.isNotEmpty != true) {
                        return "Số điện thoại không để trống";
                      }
                      if (val?.isNotEmpty == true && val?.length != 10) {
                        return "Số điện thoại chưa đúng";
                      }
                      return null;
                    },
                    hintText: 'Nhập số điện thoại',
                  ),
                  const Gap(
                    20,
                  ),
                  const Text('Mật khẩu', style: Styles.textStyle),
                  const Gap(
                    8,
                  ),
                  CustomTextfield(
                    onSaved: (val) {
                      buyerModel.password = val;
                    },
                    validator: (val) {
                      return val?.isNotEmpty != true
                          ? "Mật khẩu không để trống"
                          : null;
                    },
                    obscureText: true,
                    hintText: 'Nhập mật khẩu',
                  ),
                  const Gap(
                    20,
                  ),
                  const Text('Nhập lại mật khẩu', style: Styles.textStyle),
                  const Gap(
                    8,
                  ),
                  CustomTextfield(
                    onSaved: (val) => validatePassword = val,
                    validator: (val) {
                      return val?.isNotEmpty != true
                          ? "Mật khẩu không để trống"
                          : null;
                    },
                    obscureText: true,
                    hintText: 'Nhập lại mật khẩu',
                  ),
                  const Gap(
                    20,
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                            value: _checkedTerm,
                            onChanged: (value) {
                              _checkedTerm = value ?? false;
                              setState(() {});
                            }),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  if (_controller == null) {
                                    return const SizedBox();
                                  }
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 50, horizontal: 24),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          15.0,
                                        ),
                                      ),
                                    ),
                                    child:
                                        WebViewWidget(controller: _controller!),
                                  );
                                });
                          },
                          child: Text.rich(TextSpan(
                              text:
                                  'Khi nhấn vào nút Xác nhận đăng ký có nghĩa là bạn đã đồng ý với ',
                              style: Styles.textStyle,
                              children: [
                                TextSpan(
                                  text: 'Điều khoản sử dụng',
                                  style: Styles.textStyle
                                      .copyWith(color: Styles.primaryColor3),
                                )
                              ])),
                        ),
                      )
                    ],
                  ),
                  const Gap(
                    8,
                  ),
                ],
              ),
            )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                    backgroundColor: Styles.primaryColor3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Styles.primaryColor3)),
              )
            : GFButton(
                onPressed: _submit,
                // padding: const EdgeInsets.all(16),
                borderShape: RoundedRectangleBorder(
                  // side: const BorderSide(width: 1, color: Color(0xFF1076D0)),
                  borderRadius: BorderRadius.circular(6),
                ),
                size: 48,
                color: Styles.primaryColor3,
                type: GFButtonType.solid,
                text: 'Xác nhận đăng ký',
                // textColor: Colors.white,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
