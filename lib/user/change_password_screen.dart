import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:hkd/shipper/shipper_home_page.dart';
import 'package:hkd/shop/shop_home_page.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/custom_textfield.dart';

class ChangPasswordScreen extends StatefulWidget {
  const ChangPasswordScreen({super.key});

  @override
  State<ChangPasswordScreen> createState() => _ChangPasswordScreenState();
}

class _ChangPasswordScreenState extends State<ChangPasswordScreen> {
  final _netUtil = NetworkUtil();
  String? _currentPass;
  String? _newPass;
  // String? _correctNewPass;
  bool _hideCurrentPass = false;
  bool _hideNewPass = false;
  bool _hideCorrectNewPass = false;
  final formKey = GlobalKey<FormState>();
  _submit() async {
    FocusScope.of(context).unfocus();

    final form = formKey.currentState;
    if (form?.validate() == true) {
      try {
        final result = await _netUtil.post(
            'change_password',
            {
              'old_password': _currentPass,
              'new_password': _newPass,
            },
            context);
        if (result != null && result['success'] == 1) {
          Fluttertoast.showToast(msg: 'Đổi mật khẩu thành công!');
          await _netUtil.login(Configs.login?.userName ?? '', _newPass ?? "",
              Configs.userGroup, context);

          if (mounted) {
            switch (Configs.userGroup) {
              case 3:
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return const ShipperPage();
                }), ModalRoute.withName('/home'));
                break;
              default:
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return const ShopPage();
                }), ModalRoute.withName('/home'));
            }
          }
        } else {
          Fluttertoast.showToast(msg: 'Đổi mật khẩu thất bại!');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Đổi mật khẩu thất bại!');
      }
      // form?.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Đổi mật khẩu",
                  style: Styles.headline1Style,
                ),
                const Gap(20),
                const Text(
                  'Mật khẩu cũ',
                  style: Styles.textStyle,
                ),
                const Gap(10),
                CustomTextfield(
                  onChanged: (val) => _currentPass = val,
                  validator: (val) {
                    return val?.isNotEmpty != true
                        ? "Mật khẩu cũ không được trống"
                        : null;
                  },
                  prefixIcon: const Icon(
                    Icons.lock_open_outlined,
                    color: Styles.fieldTextColor,
                  ),
                  suffixIcon: IconButton(
                    icon: _hideCurrentPass
                        ? const Icon(
                            Icons.visibility_off,
                            color: Styles.fieldTextColor,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Styles.fieldTextColor,
                          ),
                    onPressed: () =>
                        setState(() => _hideCurrentPass = !_hideCurrentPass),
                  ),
                  hintText: 'Mật khẩu cũ',
                  // hintStyle: TextStyle(color: Styles.fieldTextColor),
                  // ),
                  textInputAction: TextInputAction.done,
                  obscureText: _hideCurrentPass,
                ),
                const Gap(20),
                const Text(
                  'Mật khẩu mới',
                  style: Styles.textStyle,
                ),
                const Gap(10),
                CustomTextfield(
                  onChanged: (val) => _newPass = val,
                  validator: (val) {
                    return val?.isNotEmpty != true
                        ? "Mật khẩu mới không được trống"
                        : null;
                  },
                  prefixIcon: const Icon(
                    Icons.lock_open_outlined,
                    color: Styles.fieldTextColor,
                  ),
                  suffixIcon: IconButton(
                    icon: _hideNewPass
                        ? const Icon(
                            Icons.visibility_off,
                            color: Styles.fieldTextColor,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Styles.fieldTextColor,
                          ),
                    onPressed: () =>
                        setState(() => _hideNewPass = !_hideNewPass),
                  ),
                  hintText: 'Mật khẩu mới',
                  // hintStyle: TextStyle(color: Styles.fieldTextColor),
                  // ),
                  textInputAction: TextInputAction.done,
                  obscureText: _hideNewPass,
                ),
                const Gap(20),
                const Text(
                  'Nhập lại mật khẩu mới',
                  style: Styles.textStyle,
                ),
                const Gap(10),
                CustomTextfield(
                    // onSaved: (val) => _correctNewPass = val,
                    validator: (val) {
                      return val != _newPass
                          ? "Mật khẩu mới không giống"
                          : null;
                    },
                    prefixIcon: const Icon(
                      Icons.lock_open_outlined,
                      color: Styles.fieldTextColor,
                    ),
                    suffixIcon: IconButton(
                      icon: _hideCorrectNewPass
                          ? const Icon(
                              Icons.visibility_off,
                              color: Styles.fieldTextColor,
                            )
                          : const Icon(
                              Icons.visibility,
                              color: Styles.fieldTextColor,
                            ),
                      onPressed: () => setState(
                          () => _hideCorrectNewPass = !_hideCorrectNewPass),
                    ),
                    hintText: 'Nhập lại mật khẩu mới',
                    // hintStyle: TextStyle(color: Styles.fieldTextColor),
                    // ),
                    textInputAction: TextInputAction.done,
                    obscureText: _hideCorrectNewPass,
                    onSubmitted: _submit),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: GFButton(
          onPressed: _submit,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderShape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Styles.primaryColor3),
            borderRadius: BorderRadius.circular(6),
          ),
          size: 48,
          fullWidthButton: true,
          child: Text(
            "Đổi mật khẩu",
            style: Styles.headline4Style.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
