import 'package:flutter/material.dart';
import 'package:hkd/ultils/func.dart';
import 'package:webview_flutter/webview_flutter.dart';

final productListDetails = [
  {"title": 'Phần mềm quản lý bán hàng thực', "supTitle": '', "checked": false},
  {
    "title": 'Phần mềm quản lý gian hàng online',
    "supTitle": '',
    "checked": false
  },
  {
    "title": 'Phần mềm gọi xe ôm công nghệ, ship hàng',
    "supTitle": '',
    "checked": false
  },
  {
    "title": 'Phần mềm kế toán:',
    "supTitle":
        'Theo thông tư 78, 88, 40 cho Hộ kinh doanh\nTheo thông tư 132 cho Doanh nghiệp siêu nhỏ',
    "checked": false
  },
  {"title": 'Thành viên dothithongminh1.vn', "supTitle": '', "checked": false},
];

class ShopRegisterScreen extends StatefulWidget {
  const ShopRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ShopRegisterScreen> createState() => _ShopRegisterScreenState();
}

class _ShopRegisterScreenState extends State<ShopRegisterScreen> {
  final url = 'https://hokinhdoanh.online/index.php/m/reg';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // readJson();
  }

  final formKey = GlobalKey<FormState>();
  final networkUtil = NetworkUtil();
  // Position _currentPosition;
  // LocationSettings locationSettings;
  // List<ShoptypeModel> shopsData = [];
  // ShoptypeModel shopType;
  late final WebViewController controller;
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url))
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
    super.initState();
  }

  // Future<void> readJson() async {
  //   final String response =
  //       await rootBundle.loadString('assets/json/roles.json');
  //   final models = await json.decode(response);
  //   shopsData = ShoptypeModel.fromListJson(models);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: controller,
    );

    // return Scaffold(
    //   appBar: GFAppBar(
    //     backgroundColor: const Color(0xFFFEDD02),
    //     automaticallyImplyLeading: false,
    //     title: Row(
    //       children: [
    //         FadeAnimation(
    //           delay: 0.8,
    //           child: SizedBox(
    //             width: 36,
    //             height: 36,
    //             child: Image.asset(
    //               "assets/images/logo.png",
    //             ),
    //           ),
    //         ),
    //         const Text(
    //           'dothi\nthongminh1',
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
    //   ),
    //   body: SingleChildScrollView(
    //     child: Form(
    //         key: formKey,
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: Text(
    //                   'Tên Tiệm/Hộ kinh doanh/Cửa hàng/NPP/Công ty/Kho/Điểm bán/Sản xuất/Vận chuyển',
    //                   style: Styles.headline1Style,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   validator: (val) {
    //                     return val?.isNotEmpty != true
    //                         ? "Tên cửa hàng không để trống"
    //                         : null;
    //                   },

    //                   hintText: 'Tên cửa hàng/thương hiệu',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // initialValue: _currentPosition.,
    //                   // onSaved: (val) => _username = val,
    //                   validator: (val) {
    //                     return val?.isNotEmpty != true
    //                         ? "Tên chủ hộ không để trống"
    //                         : null;
    //                   },

    //                   hintText: 'Tên chủ hộ kinh doanh',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   validator: (val) {
    //                     return val?.isNotEmpty != true
    //                         ? "Mã số thuế không để trống"
    //                         : null;
    //                   },

    //                   hintText: 'Mã số thuế',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: Text(
    //                   "Sản phẩm đăng ký",
    //                   style: Styles.headline1Style,
    //                 ),
    //               ),
    //               // const SizedBox(
    //               //   height: 20,
    //               // ),
    //               Column(
    //                 children: List.generate(
    //                   productListDetails.length,
    //                   (index) {
    //                     return CheckboxListTile(
    //                       title: Text(
    //                         '${index + 1}. ${productListDetails[index]['title']}',
    //                         style: Styles.textStyle,
    //                       ),
    //                       subtitle: productListDetails[index]['supTitle'] != ''
    //                           ? Text(
    //                               productListDetails[index]['supTitle'],
    //                               style: Styles.textStyle,
    //                             )
    //                           : null,
    //                       contentPadding: EdgeInsets.zero,
    //                       activeColor: Styles.primaryColor3,
    //                       controlAffinity: ListTileControlAffinity.leading,
    //                       onChanged: (value) {
    //                         setState(() {
    //                           productListDetails[index]['checked'] = value;
    //                         });
    //                       },
    //                       value: productListDetails[index]['checked'],
    //                       // inactiveIcon: null,
    //                     );
    //                   },
    //                 ),
    //               ),
    //               // const SizedBox(
    //               //   height: 20,
    //               // ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: Text(
    //                   'Chọn Loại Tiệm/Hộ kinh doanh/Cửa hàng/NPP/Công ty/Kho/Điểm bán/Sản xuất/Vận chuyển',
    //                   style: Styles.headline1Style,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               SizedBox(
    //                 height: 48,
    //                 child: DropdownButtonHideUnderline(
    //                   child: GFDropdown<ShoptypeModel>(
    //                     iconSize: 24,
    //                     icon: SvgPicture.asset(
    //                       'assets/icons/dropdown.svg',
    //                       color: Styles.primaryText,
    //                     ),
    //                     padding: const EdgeInsets.all(12),
    //                     borderRadius: BorderRadius.circular(6),
    //                     value: shopType,
    //                     border:
    //                         const BorderSide(color: Colors.black12, width: 1),
    //                     items: shopsData
    //                         .map((value) => DropdownMenuItem(
    //                               value: value,
    //                               child: Text(
    //                                 value.name,
    //                                 style: Styles.inputStyle,
    //                               ),
    //                             ))
    //                         .toList(),
    //                     dropdownButtonColor: Colors.white,
    //                     onChanged: (value) {
    //                       setState(() {
    //                         shopType = value;
    //                       });
    //                     },
    //                     underline: null,
    //                     hint: Text(
    //                       'Chọn loại hộ kinh doanh',
    //                       style: Styles.inputStyle,
    //                     ),
    //                     isExpanded: true,
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: Text(
    //                   'Thông điệp người bán',
    //                   style: Styles.headline1Style,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   // validator: (val) {
    //                   //   return val?.isNotEmpty != true
    //                   //       ? "Tên cửa hàng không để trống"
    //                   //       : null;
    //                   // },
    //                   lines: 3,
    //                   maxLength: 80,
    //                   hintText:
    //                       'Hãy cập nhật các thông điệp, sản phẩm, dịch vụ thu hút, hấp dẫn tới người tìm mua trên internet (80 ký tự)',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: Text(
    //                   'Thông tin liên hệ',
    //                   style: Styles.headline1Style,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 20,
    //               ),
    //               GFButton(
    //                 onPressed: () {},
    //                 icon: Image.asset('assets/icons/register/location.png'),
    //                 text: 'Tự động lấy vị trí',
    //                 textStyle: Styles.headline4Style
    //                     .copyWith(color: Styles.primaryColor3),
    //                 padding: const EdgeInsets.symmetric(
    //                     horizontal: 16, vertical: 12),
    //                 borderShape: RoundedRectangleBorder(
    //                   side: const BorderSide(
    //                       width: 1, color: Styles.primaryColor3),
    //                   borderRadius: BorderRadius.circular(6),
    //                 ),
    //                 fullWidthButton: true,
    //                 size: 48,
    //                 type: GFButtonType.outline,
    //                 color: Colors.white,
    //               ),
    //               const SizedBox(
    //                 height: 12,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   validator: (val) {
    //                     return val?.isNotEmpty != true
    //                         ? "Phường/Xã không để trống"
    //                         : null;
    //                   },

    //                   hintText: 'Phường/Xã',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 12,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   validator: (val) {
    //                     return val?.isNotEmpty != true
    //                         ? "Tỉnh/Thành phố không để trống"
    //                         : null;
    //                   },

    //                   hintText: 'Tỉnh/Thành phố',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 12,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   validator: (val) {
    //                     return val?.isNotEmpty != true
    //                         ? "Địa chỉ không để trống"
    //                         : null;
    //                   },

    //                   hintText: 'Địa chỉ',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 12,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   validator: (val) {
    //                     return val?.isNotEmpty != true
    //                         ? "Họ tên người đại diện không để trống"
    //                         : null;
    //                   },

    //                   hintText: 'Họ tên người đại diện',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 12,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   validator: (val) {
    //                     return val?.isNotEmpty != true
    //                         ? "Email không để trống"
    //                         : null;
    //                   },

    //                   hintText: 'Email',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 12,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   validator: (val) {
    //                     return val?.isNotEmpty != true
    //                         ? "Điện thoại không để trống"
    //                         : null;
    //                   },

    //                   hintText: 'Điện thoại',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 12,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   validator: (val) {
    //                     return val?.isNotEmpty != true
    //                         ? "Mật khẩu không để trống"
    //                         : null;
    //                   },
    //                   obscureText: true,
    //                   hintText: 'Mật khẩu',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 12,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   validator: (val) {
    //                     return val?.isNotEmpty != true
    //                         ? "Mật khẩu không để trống"
    //                         : null;
    //                   },
    //                   obscureText: true,

    //                   hintText: 'Nhập lại mật khẩu',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 12,
    //               ),
    //               FadeAnimation(
    //                 delay: 1,
    //                 child: CustomTextfield(
    //                   onTap: () {
    //                     setState(() {
    //                       // selected = Gender.email;
    //                     });
    //                   },
    //                   // onSaved: (val) => _username = val,
    //                   // validator: (val) {
    //                   //   return val?.isNotEmpty != true ? "Phường/Xã không để trống" : null;
    //                   // },

    //                   hintText: 'Số điện thoại người giới thiệu',
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 12,
    //               ),
    //             ],
    //           ),
    //         )),
    //   ),
    //   bottomNavigationBar: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Text.rich(
    //           TextSpan(
    //             children: [
    //               TextSpan(
    //                 text:
    //                     'Khi nhấn vào nút Mở cửa hàng có nghĩa là bạn đã đồng ý với ',
    //                 style: Styles.textStyle,
    //               ),
    //               TextSpan(
    //                 text: 'Điều khoản sử dụng của Hokinhdoanh.online',
    //                 style:
    //                     Styles.textStyle.copyWith(color: Styles.primaryColor3),
    //               ),
    //             ],
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 12,
    //         ),
    //         GFButton(
    //           onPressed: () {},
    //           padding: const EdgeInsets.all(16),
    //           borderShape: RoundedRectangleBorder(
    //             // side: const BorderSide(width: 1, color: Color(0xFF1076D0)),
    //             borderRadius: BorderRadius.circular(6),
    //           ),
    //           fullWidthButton: true,
    //           size: 48,
    //           color: Styles.primaryColor3,
    //           type: GFButtonType.solid,
    //           text: 'Mở cửa hàng',
    //           // textColor: Colors.white,
    //           textStyle: const TextStyle(
    //             color: Colors.white,
    //             fontSize: 14,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
