import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/user/login_screen.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/custom_dialog.dart';
import 'package:hkd/widgets/custom_searchbar.dart';
import 'package:hkd/widgets/custom_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ShopProfileScreen extends StatefulWidget {
  const ShopProfileScreen({Key? key}) : super(key: key);

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final _networkUtil = NetworkUtil();
  // final listTitles = 'Sửa thông tin hộ kinh doanh';
  final updateInfoUrl = 'update_shop';

  User? _user;
  String title = 'Sửa thông tin hộ kinh doanh';
  // String icon = '';
  bool _isLoading = false;
  File? avatar;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  // final _addressCtrl = TextEditingController();
  final _adminNameCtrl = TextEditingController();
  final _quoteCtrl = TextEditingController();
  List<AddressModel> initBuyerAddresses =
      List<AddressModel>.filled(3, AddressModel(), growable: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    // _addressCtrl.dispose();
    _adminNameCtrl.dispose();
    _quoteCtrl.dispose();
    super.dispose();
  }

  _init() async {
    // title = listTitles[Configs.userGroup == 1 ? 1 : 0];
    // icon = icons[Configs.userGroup];
    _user = Configs.user;
    _nameCtrl.text = _user?.name ?? '';
    _phoneCtrl.text = _user?.phone ?? '';
    // _addressCtrl.text = _user?.address ?? '';
    _adminNameCtrl.text = _user?.adminName ?? '';
    _quoteCtrl.text = _user?.quote ?? '';

    setState(() {});
  }

  _updateProfile() async {
    final form = formKey.currentState;
    if (form?.validate() == true) {
      form?.save();
      if (_user == null) return;
      List<http.MultipartFile> files = [];
      if (avatar != null) {
        // Fluttertoast.showToast(msg: "Thiếu ảnh nhận diện.");
        files.add(
          await http.MultipartFile.fromPath('avatar', avatar!.path),
        );
      }
      setState(() => _isLoading = true);

      Map<String, String> body = _user!.toJson();
      body.remove('user_name');
      body.remove('link_img');

      if (Configs.userGroup == 1) {
        body['shop_id'] = Configs.login?.shopId ?? '';
        body['phone'] = _phoneCtrl.text;
        body['name'] = _nameCtrl.text;
        // body['admin_id'] = Configs.user. ?? '';
      }

      try {
        final result = await _networkUtil.multipartPost(
            updateInfoUrl, body, files, context);
        setState(() => _isLoading = false);

        if (result['success'] == 1) {
          await _networkUtil.login(Configs.login?.userName ?? '',
              Configs.login?.userPass ?? '', Configs.userGroup, context);
          await _networkUtil.getProfileInfo(context);
          Fluttertoast.showToast(msg: 'Cập nhật thông tin thành công.');
        } else {
          Fluttertoast.showToast(msg: 'Cập nhật thông tin không thành công.');
        }
      } catch (e) {
        debugPrint(e.toString());
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: 'Cập nhật thông tin không thành công.');
      }
      setState(() => _isLoading = false);
    }
  }

  _deleteAccount() async {
    showDialog(
        context: context,
        builder: (_) {
          return DialogAction(
            icon: Image.asset('assets/images/icons-cancel.png'),
            title: 'Xoá tài khoản này?',
            content:
                'Thông tin tài khoản của bạn sẽ bị xoá hoàn toàn khỏi hệ thống, bạn có đồng ý?',
            text1: 'Đồng ý',
            text2: 'Không',
            onTap1: () async {
              Navigator.pop(context);
              await EasyLoading.show(
                status: 'Đang tải xử lý...',
                maskType: EasyLoadingMaskType.clear,
              );
              final result =
                  await _networkUtil.post('delete_account', {}, context);
              await EasyLoading.dismiss();
              if (result != null && result['success'] == 1) {
                Fluttertoast.showToast(msg: 'Xoá tài khoản thành công.');
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    ModalRoute.withName('/home'));
              } else {
                Fluttertoast.showToast(msg: 'Xoá tài khoản không thành công.');
              }
            },
            onTap2: () => Navigator.pop(context),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 12,
          right: 12,
          bottom: 16,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Styles.headline1Style,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFB2B2B2),
                      shape: OvalBorder(),
                    ),
                    height: 100,
                    width: 100,
                    child: avatar != null
                        ? Image.file(avatar!)
                        : Image.network(
                            Configs.BASE_URL
                                    .replaceAll('/api', '/images/avatars') +
                                (_user?.linkImg ?? ''),
                            errorBuilder: (context, error, stackTrace) {
                              return SvgPicture.asset(
                                Configs.iconsProfile[Configs.userGroup],

                                color: Colors.white,
                                // width: 100,
                                // height: 100,
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: GFButton(
                    onPressed: () async {
                      var result = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      // final result = await FilePicker.platform
                      //     .pickFiles(type: FileType.image, withData: true);

                      if (result == null) {
                        return;
                      }
                      final pickedFile = File(result.path);
                      final sizeFile = pickedFile.lengthSync();
                      if (sizeFile > 30000000) {
                        Fluttertoast.showToast(
                            msg: 'Ảnh quá lớn, xin hãy chọn ảnh dưới 30mb');
                        return;
                      }
                      avatar = pickedFile;
                      setState(() {});
                    },
                    type: GFButtonType.transparent,
                    text: 'Thêm ảnh',
                    textStyle:
                        Styles.textStyle.copyWith(color: Styles.primaryColor3),
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
                  textCtrl: _nameCtrl,
                  onSaved: (val) {
                    _user?.userName = val;
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
                const Text('Số điện thoại', style: Styles.textStyle),
                const SizedBox(
                  height: 8,
                ),
                CustomTextfield(
                  textCtrl: _phoneCtrl,
                  onSaved: (val) {
                    _user?.phone = val;
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
                const Text('Tên hộ kinh doanh', style: Styles.textStyle),
                const Gap(
                  8,
                ),
                CustomTextfield(
                  textCtrl: _adminNameCtrl,
                  onSaved: (val) {
                    _user?.adminName = val;
                  },
                  validator: (val) {
                    return val?.isNotEmpty != true
                        ? "Tên hộ kinh doanh không để trống"
                        : null;
                  },
                  hintText: 'Nhập tên hộ kinh doanh',
                ),
                const Gap(
                  20,
                ),
                const Text('Tên cửa hàng/thương hiệu', style: Styles.textStyle),
                const Gap(
                  8,
                ),
                CustomTextfield(
                  textCtrl: _nameCtrl,
                  onSaved: (val) {
                    _user?.name = val;
                  },
                  validator: (val) {
                    return val?.isNotEmpty != true
                        ? "Tên cửa hàng/thương hiệu không để trống"
                        : null;
                  },
                  hintText: 'Nhập tên cửa hàng/thương hiệu',
                ),
                const Gap(
                  20,
                ),
                const Text('Địa chỉ', style: Styles.textStyle),
                const SizedBox(
                  height: 8,
                ),
                LocationSearchbar(
                  initValue: _user?.address,
                  onSelected: (model) {
                    _user?.lat = model.lat;
                    _user?.lon = model.lon;
                    _user?.address = '${model.tinh},${model.huyen},${model.xa}';
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Thông điệp kinh doanh', style: Styles.textStyle),
                const Gap(
                  8,
                ),
                CustomTextfield(
                  textCtrl: _quoteCtrl,
                  onSaved: (val) {
                    _user?.quote = val;
                  },
                  // validator: (val) {
                  //   return val?.isNotEmpty != true
                  //       ? "Thông điệp kinh doanh không để trống"
                  //       : null;
                  // },
                  hintText: 'Nhập thông điệp kinh doanh',
                ),
                const Gap(
                  20,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16, top: 8),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                    backgroundColor: Styles.primaryColor3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Styles.primaryColor3)),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GFButton(
                    onPressed: _updateProfile,
                    // padding: const EdgeInsets.all(16),
                    borderShape: RoundedRectangleBorder(
                      // side: const BorderSide(width: 1, color: Color(0xFF1076D0)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    size: 48,
                    fullWidthButton: true,
                    color: Styles.primaryColor3,
                    type: GFButtonType.solid,
                    text: 'Xác nhận thay đổi',
                    // textColor: Colors.white,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(6),
                  GFButton(
                    onPressed: _deleteAccount,
                    // padding: const EdgeInsets.all(16),
                    borderShape: RoundedRectangleBorder(
                      // side: const BorderSide(width: 1, color: Color(0xFF1076D0)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    size: 48,
                    color: Styles.moneyColor,
                    type: GFButtonType.solid,
                    text: 'Xoá tài khoản',
                    // textColor: Colors.white,
                    fullWidthButton: true,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// class _BuyerWidget extends StatelessWidget {
//   const _BuyerWidget({required this.addresses});
//   final List<AddressModel> addresses;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: List.generate(3, (index) {
//         // final address = addresses.elementAtOrNull(index) ?? AddressModel();
//         return _AddressWidget(
//             index: index,
//             initModel: addresses[index],
//             updateDiachi: (value) {
//               addresses[index].diachi = value;
//             },
//             updateTHX: (tinh, huyen, xa, lat, lon) {
//               addresses[index].tinh = tinh;
//               addresses[index].huyen = huyen;
//               addresses[index].xa = xa;
//               addresses[index].lat = lat;
//               addresses[index].lon = lon;
//             });
//       }),
//     );
//   }
// }

// class _AddressWidget extends StatefulWidget {
//   const _AddressWidget({
//     required this.initModel,
//     required this.index,
//     required this.updateDiachi,
//     required this.updateTHX,
//   });
//   final AddressModel? initModel;
//   final int index;
//   final Function(String) updateDiachi;
//   final Function(String tinh, String huyen, String xa, String lat, String lon)
//       updateTHX;

//   @override
//   State<_AddressWidget> createState() => _AddressWidgetState();
// }

// class _AddressWidgetState extends State<_AddressWidget> {
//   final _textCtrl = TextEditingController();
//   @override
//   void initState() {
//     _textCtrl.text = widget.initModel?.diachi ?? '';
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(covariant _AddressWidget oldWidget) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.initModel != null && widget.initModel != oldWidget.initModel) {
//         _textCtrl.text = widget.initModel?.diachi ?? '';
//       }
//     });
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void dispose() {
//     _textCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(
//           height: 20,
//         ),
//         Text('Vị trí ${widget.index + 1}', style: Styles.textStyle),
//         const SizedBox(
//           height: 8,
//         ),
//         LocationSearchbar(
//           initValue:
//               '${widget.initModel?.tinh ?? ''}, ${widget.initModel?.huyen ?? ''}, ${widget.initModel?.xa ?? ''}',
//           getInitPosition: false,
//           onSelected: (model) async {
//             widget.updateTHX(model.tinh ?? '', model.huyen ?? '',
//                 model.xa ?? '', model.lat ?? '', model.lon ?? '');
//           },
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Text('Địa chỉ ${widget.index + 1}', style: Styles.textStyle),
//         const SizedBox(
//           height: 8,
//         ),
//         CustomTextfield(
//           textCtrl: _textCtrl,
//           onChanged: (val) {
//             widget.updateDiachi(val ?? '');
//           },
//           // onSaved: (val) {
//           //   widget.updateDiachi(val ?? '');
//           // },
//           validator: (val) {
//             return val?.isNotEmpty != true
//                 ? "Địa chỉ ${widget.index + 1} không để trống"
//                 : null;
//           },
//           hintText: 'Nhập địa chỉ',
//         ),
//       ],
//     );
//   }
// }

// class _ShipeerWidget extends StatefulWidget {
//   const _ShipeerWidget();

//   @override
//   State<_ShipeerWidget> createState() => _ShipeerWidgetState();
// }

// class _ShipeerWidgetState extends State<_ShipeerWidget> {
//   File? license;
//   File? motorReg;
//   File? warranty;
//   File? personalPhoto;
//   File? cccd;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const FadeAnimation(
//           delay: 1,
//           child: Text(
//             'GIẤY TỜ XÁC NHẬN',
//             style: Styles.headline3Style,
//           ),
//         ),
//         _PickFileWidget(
//           headerText: 'Ảnh cá nhân',
//           pickedFile: (file) {
//             personalPhoto = file;
//           },
//         ),
//         _PickFileWidget(
//           headerText: 'Chứng minh thư/CCCD (2 mặt)',
//           pickedFile: (file) {
//             cccd = file;
//           },
//         ),
//         _PickFileWidget(
//           headerText: 'Bằng lái xe (2 mặt)',
//           pickedFile: (file) {
//             license = file;
//           },
//         ),
//         _PickFileWidget(
//           headerText: 'Giấy đăng ký xe (2 mặt)',
//           pickedFile: (file) {
//             motorReg = file;
//           },
//         ),
//         _PickFileWidget(
//           headerText: 'Bảo hiểm xe máy',
//           pickedFile: (file) {
//             warranty = file;
//           },
//         ),
//       ],
//     );
//   }
// }

// class _PickFileWidget extends StatefulWidget {
//   final String headerText;
//   final Function(File file) pickedFile;
//   const _PickFileWidget({
//     Key? key,
//     required this.headerText,
//     required this.pickedFile,
//   }) : super(key: key);
//   @override
//   State<_PickFileWidget> createState() => _PickFileWidgetState();
// }

// class _PickFileWidgetState extends State<_PickFileWidget> {
//   File? file;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(
//           height: 10,
//         ),
//         Text(widget.headerText, style: Styles.textStyle),
//         const SizedBox(
//           height: 8,
//         ),
//         Row(
//           children: [
//             GFButton(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               size: 40,
//               onPressed: () async {
//                 final result = await FilePicker.platform
//                     .pickFiles(type: FileType.image, withData: true);

//                 if (result != null) {
//                   file = File(result.files.single.path!);
//                   widget.pickedFile.call(file!);
//                 } else {
//                   // User canceled the picker
//                 }
//               },
//               text: "Đính kèm file",
//               textStyle: Styles.textStyle.copyWith(
//                   color: Styles.primaryColor3, fontWeight: FontWeight.w600),
//               color: const Color(0xFFEBF2F8),
//             ),
//             const SizedBox(
//               width: 8,
//             ),
//             Expanded(
//               child: Text(
//                 file == null
//                     ? 'Chưa có file được đính kèm'
//                     : path.basename(file!.path),
//                 style: Styles.headline3Style.copyWith(
//                   fontWeight: FontWeight.w400,
//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//       ],
//     );
//   }
// }
