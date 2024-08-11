import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/custom_dropdown.dart';
import 'package:hkd/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _netUtil = NetworkUtil();
  String? _mail;
  String? _phoneNumber;
  String? _typeUser;
  // String? _correctNewPass;
  final types = Configs.selectType.nonNulls.toList();
  final formKey = GlobalKey<FormState>();
  _submit() async {
    FocusScope.of(context).unfocus();

    final form = formKey.currentState;
    if (form?.validate() == true) {
      try {
        final result = await _netUtil.post(
          'forgot_password',
          {
            'email': _mail,
            'phone': _phoneNumber,
            'role': _typeUser,
          }, context
        );
        if (result != null && result['success'] == 1) {
          Fluttertoast.showToast(
              msg: 'Gửi yêu cầu thay đổi mật khẩu thành công!');
     
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
                  "Quên mật khẩu",
                  style: Styles.headline1Style,
                ),
                const Gap(20),
                const Text(
                  'Vai trò của bạn',
                  style: Styles.textStyle,
                ),
                const Gap(10),
                CustomDropdown(
                  data: types,
                  initData: types[0]['text'],
                  text: (value) => value['text'] ?? '',
                  onSelected: (val) => _typeUser = val['type'],
                  suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                  readOnly: true,
                  hintText: 'Vai trò của bạn',
                  // hintStyle: TextStyle(color: Styles.fieldTextColor),
                  // ),
                  // textInputAction: TextInputAction.done,
                  // obscureText: _hideCurrentPass,
                ),
                const Gap(20),
                const Text(
                  'Số điện thoại',
                  style: Styles.textStyle,
                ),
                const Gap(10),
                CustomTextfield(
                  onChanged: (val) => _phoneNumber = val,
                  validator: (val) {
                    return val?.isNotEmpty != true
                        ? "Số điện thoại không được trống"
                        : null;
                  },

                  hintText: 'Số điện thoại',
                  // hintStyle: TextStyle(color: Styles.fieldTextColor),
                  // ),
                ),
                const Gap(20),
                const Text(
                  'Email',
                  style: Styles.textStyle,
                ),
                const Gap(10),
                CustomTextfield(
                    onChanged: (val) => _mail = val,
                    validator: (val) {
                      return val?.isNotEmpty != true
                          ? "Email không được để trống"
                          : null;
                    },
                    hintText: 'Nhập email',
                    // hintStyle: TextStyle(color: Styles.fieldTextColor),
                    // ),
                    textInputAction: TextInputAction.done,
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
            "Xác nhận",
            style: Styles.headline4Style.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
