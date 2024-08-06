import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/anmition/fadeanimation.dart';
import 'package:hkd/shop/shop_home_page.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/custom_searchbar.dart';
import 'package:hkd/widgets/custom_textfield.dart';

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
  String? validatePassword;
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final form = formKey.currentState;
    if (form?.validate() == true) {
      form?.save();
      if (validatePassword != buyerModel.password) {
        Fluttertoast.showToast(msg: "Mật khẩu không đúng.");
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
                (route) => false);
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
                  const SizedBox(
                    height: 12,
                  ),
                  const FadeAnimation(
                    delay: 1,
                    child: Text(
                      'Tạo tài khoản Đô thị Thông minh để theo dõi đơn hàng của bạn',
                      style: Styles.textStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const FadeAnimation(
                    delay: 1,
                    child: Text(
                      'THÔNG TIN CÁ NHÂN',
                      style: Styles.headline3Style,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Họ và tên', style: Styles.textStyle),
                  const SizedBox(
                    height: 8,
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Địa chỉ', style: Styles.textStyle),
                  const SizedBox(
                    height: 8,
                  ),
                  LocationSearchbar(
                    onSelected: (model) {
                      buyerModel.lat = model.lat;
                      buyerModel.lon = model.lon;
                      // buyerModel = '${model.tinh},${model.huyen},${model.xa}';
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Số điện thoại', style: Styles.textStyle),
                  const SizedBox(
                    height: 8,
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Mật khẩu', style: Styles.textStyle),
                  const SizedBox(
                    height: 8,
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Nhập lại mật khẩu', style: Styles.textStyle),
                  const SizedBox(
                    height: 8,
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
                padding: const EdgeInsets.all(16),
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
