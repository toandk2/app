import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/anmition/fadeanimation.dart';
import 'package:hkd/shipper/shipper_home_page.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/custom_searchbar.dart';
import 'package:hkd/widgets/custom_textfield.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class ShipperRegisterScreen extends StatefulWidget {
  const ShipperRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ShipperRegisterScreen> createState() => _ShipperRegisterScreenState();
}

class _ShipperRegisterScreenState extends State<ShipperRegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final networkUtil = NetworkUtil();
  // Position? _currentPosition;
  final ShipperRegisterModel _model = ShipperRegisterModel();
  File? license;
  File? motorReg;
  File? warranty;
  File? personalPhoto;
  File? cccd;
  bool _isLoading = false;
  String? validatePassword;
  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final form = formKey.currentState;
    if (form?.validate() == true) {
      form?.save();
      if (validatePassword != _model.xeomPassword) {
        Fluttertoast.showToast(msg: "Mật khẩu không đúng.");
      }
      if (license == null) {
        Fluttertoast.showToast(msg: "Thiếu bằng lái xe.");
        return;
      }
      if (motorReg == null) {
        Fluttertoast.showToast(msg: "Thiếu đăng ký xe.");
        return;
      }
      if (warranty == null) {
        Fluttertoast.showToast(msg: "Thiếu bảo hiểm xe.");
        return;
      }
      if (cccd == null) {
        Fluttertoast.showToast(msg: "Thiếu căn cước công dân.");
        return;
      }
      if (personalPhoto == null) {
        Fluttertoast.showToast(msg: "Thiếu ảnh nhận diện.");
        return;
      }
      setState(() => _isLoading = true);
      // _model.deviceType = 'mobile';
      // _model.deviceId = Configs.deviceData['id'] ?? "";
      List<http.MultipartFile> files = [
        await http.MultipartFile.fromPath('licence', license!.path),
        await http.MultipartFile.fromPath('motor_reg', motorReg!.path),
        await http.MultipartFile.fromPath('warranty', warranty!.path),
        await http.MultipartFile.fromPath('cccd', cccd!.path),
        await http.MultipartFile.fromPath(
            'personal_photo', personalPhoto!.path),
      ];
      final json = _model.toJson();
      try {
        final result =
            await networkUtil.multipartPost('xeom_reg', json, files, context);
        if (result['success'] == 1 && mounted) {
          final loginResult = await networkUtil.login(
              _model.xeomPhone ?? '', _model.xeomPassword ?? '', 3, context);
          setState(() => _isLoading = false);

          if (!loginResult) {
            Fluttertoast.showToast(msg: "Đăng nhập không thành công.");
            setState(() => _isLoading = false);
            return;
          }
          Fluttertoast.showToast(msg: "Đăng nhập thành công.");
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
              return const ShipperPage();
            }), ModalRoute.withName('/home'));
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
                      "Đăng ký làm người vận chuyển",
                      style: Styles.headline1Style,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const FadeAnimation(
                    delay: 1,
                    child: Text(
                      'Đăng ký làm người vận chuyển/shipper chính thức của Đô thị Thông minh, hoàn toàn miễn phí!',
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
                    onTap: () {
                      setState(() {
                        // selected = Gender.email;
                      });
                    },
                    onSaved: (val) => _model.xeomName = val,
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
                  const Text('Email', style: Styles.textStyle),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextfield(
                    onTap: () {
                      setState(() {
                        // selected = Gender.email;
                      });
                    },
                    onSaved: (val) => _model.xeomEmail = val,
                    validator: (val) {
                      return val?.isNotEmpty != true
                          ? "Email không để trống"
                          : null;
                    },
                    hintText: 'Nhập email',
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
                      _model.xeomAddress =
                          '${model.tinh},${model.huyen},${model.xa}';
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Biển số xe', style: Styles.textStyle),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextfield(
                    onTap: () {
                      setState(() {
                        // selected = Gender.email;
                      });
                    },
                    onSaved: (val) => _model.xeomPlate = val,
                    validator: (val) {
                      return val?.isNotEmpty != true
                          ? "Biển số xe không để trống"
                          : null;
                    },
                    hintText: 'Nhập biển số xe',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Số điện thoại', style: Styles.textStyle),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextfield(
                    onTap: () {
                      setState(() {
                        // selected = Gender.email;
                      });
                    },
                    onSaved: (val) => _model.xeomPhone = val,
                    validator: (val) {
                      if (val?.isNotEmpty != true) {
                        return "Số điện thoại không để trống";
                      }
                      if (val?.isNotEmpty == true && val?.length != 10) {
                        return "Số điện thoại chưa đúng";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
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
                    onTap: () {
                      setState(() {
                        // selected = Gender.email;
                      });
                    },
                    onSaved: (val) => _model.xeomPassword = val,
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
                    onTap: () {
                      setState(() {
                        // selected = Gender.email;
                      });
                    },
                    onSaved: (val) => validatePassword = val,
                    validator: (val) {
                      return val?.isNotEmpty != true
                          ? "Mật khẩu không để trống"
                          : null;
                    },
                    obscureText: true,
                    hintText: 'Nhập lại mật khẩu',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FadeAnimation(
                    delay: 1,
                    child: Text(
                      'GIẤY TỜ XÁC NHẬN',
                      style: Styles.headline3Style,
                    ),
                  ),
                  _PickFileWidget(
                    headerText: 'Ảnh cá nhân',
                    pickedFile: (file) {
                      personalPhoto = file;
                    },
                  ),
                  _PickFileWidget(
                    headerText: 'Chứng minh thư/CCCD (2 mặt)',
                    pickedFile: (file) {
                      cccd = file;
                    },
                  ),
                  _PickFileWidget(
                    headerText: 'Bằng lái xe (2 mặt)',
                    pickedFile: (file) {
                      license = file;
                    },
                  ),
                  _PickFileWidget(
                    headerText: 'Giấy đăng ký xe (2 mặt)',
                    pickedFile: (file) {
                      motorReg = file;
                    },
                  ),
                  _PickFileWidget(
                    headerText: 'Bảo hiểm xe máy',
                    pickedFile: (file) {
                      warranty = file;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FadeAnimation(
                    delay: 1,
                    child: Text(
                      'MÃ GIỚI THIỆU',
                      style: Styles.headline3Style,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                      'Nhập số điện thoại của HKDO giới thiệu đã mời bạn sử dụng dothithongminh1 (nếu có)',
                      style: Styles.textStyle),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextfield(
                    onTap: () {
                      setState(() {
                        // selected = Gender.email;
                      });
                    },
                    // onSaved: (val) => _username = val,

                    keyboardType: TextInputType.phone,
                    hintText: 'Nhập số điện thoại',
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
                onPressed: () => _submit(context),
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
                textStyle: Styles.headline4Style.copyWith(color: Colors.white),
              ),
      ),
    );
  }
}

class _PickFileWidget extends StatefulWidget {
  final String headerText;
  final Function(File file) pickedFile;
  const _PickFileWidget({
    Key? key,
    required this.headerText,
    required this.pickedFile,
  }) : super(key: key);
  @override
  State<_PickFileWidget> createState() => _PickFileWidgetState();
}

class _PickFileWidgetState extends State<_PickFileWidget> {
  File? file;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(widget.headerText, style: Styles.textStyle),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            GFButton(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              size: 40,
              onPressed: () async {
                final result =
                    await FilePicker.platform.pickFiles(type: FileType.image);

                if (result != null) {
                  file = File(result.files.single.path!);
                  widget.pickedFile.call(file!);
                } else {
                  // User canceled the picker
                }
              },
              text: "Đính kèm file",
              textStyle: Styles.textStyle.copyWith(
                  color: Styles.primaryColor3, fontWeight: FontWeight.w600),
              color: const Color(0xFFEBF2F8),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                file == null
                    ? 'Chưa có file được đính kèm'
                    : basename(file!.path),
                style: Styles.headline3Style.copyWith(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}