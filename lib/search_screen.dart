import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/anmition/fadeanimation.dart';
import 'package:hkd/firebase/notification_setup.dart';
import 'package:hkd/shipper/shipper_find_order_screen.dart';
import 'package:hkd/shop/shop_find_shipper_screen.dart';
import 'package:hkd/trade/shop_list_screen.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/bing_maps.dart';
import 'package:hkd/widgets/custom_searchbar.dart';
import 'package:latlong2/latlong.dart';

const textBottomButton = [
  'Đến xem, mua, ship, chat gần ngay 4.0km',
  'Xem, chat, mua với nhà phân phối gần ngay',
  "",
  'Xem các đơn cần vận chuyển gần đây',
];

class SearchScreen extends StatefulWidget {
  // const SearchScreen({
  //   Key? key,
  // }) : super(key: key);
  const SearchScreen({Key? key, this.tempUserGroup}) : super(key: key);
  final int? tempUserGroup;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _networkUtil = NetworkUtil();
  List<ShoptypeModel> shopsData = [];
  // String placeName;
  AddressModel? addressModel;
  int? productType;
  final _sellerMessageCtrl = TextEditingController();
  final _productCtrl = TextEditingController();
  Color userColor = Configs.getUserColor(Configs.userGroup);
  int temporaryUserGroup = Configs.userGroup;
  String _autoScrollText = '';
  final _scrollController = ScrollController();
  int speedFactor = 20;

  @override
  void initState() {
    if (widget.tempUserGroup != null) {
      temporaryUserGroup = widget.tempUserGroup!;
      userColor = Configs.getUserColor(temporaryUserGroup);
      setState(() {});
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _getAutoScroll();
      listenFirebase(context);
      readJson();
    });
    super.initState();
  }

  @override
  void dispose() {
    _sellerMessageCtrl.dispose();
    _productCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/json/roles.json');
    final models = await json.decode(response);
    shopsData = ShoptypeModel.fromListJson(models);
    setState(() {});
  }

  _getAutoScroll() async {
    final result = await _networkUtil.get('scrolling_shops', {}, context);
    if (result != null) {
      setState(() {
        _autoScrollText = result;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scroll();
      });
    }
  }

  _scroll() {
    if (_scrollController.hasClients) {
      double maxExtent = _scrollController.position.maxScrollExtent;
      double distanceDifference = maxExtent - _scrollController.offset;
      double durationDouble = distanceDifference / speedFactor;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(seconds: durationDouble.toInt()),
          curve: Curves.linear);
    }
  }

  Future<List<Product>> _getProducts(String? mainProduct) async {
    if (mainProduct == null) return [];
    // if (productType == null) {
    //   Fluttertoast.showToast(msg: 'Bạn cần chọn một loại sản phẩm để tìm kiếm');
    //   return [];
    // }
    List<Product> products = [];

    final value = await _networkUtil.get('lookup',
        {'type': productType?.toString() ?? '', 'kw': mainProduct}, context);
    if (value != null) {
      products = ProductSuggestion.fromJson(value).products ?? [];
    }
    return products;
  }

  Future<List<Suggestions>> _getShopByMessage(String? sellerMessage) async {
    if (sellerMessage == null) return [];
    List<Suggestions> shops = [];
    final Map<String, String> body = {'kw': sellerMessage};
    if (temporaryUserGroup == 1) {
      body['type'] = '100';
    }
    final value = await _networkUtil.get('quote', body, context);
    if (value != null) {
      shops = ShopSuggestion.fromJson(value).suggestions ?? [];
    }
    return shops;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.white,
        // backgroundColor: const Color(0xFFFEDD02),
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () {
            // if (Configs.userGroup == 1) {
            //   launchUrl(Uri.parse('https://hokinhdoanh.online/login'));
            //   return;
            // }
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
                temporaryUserGroup == 1
                    ? 'hokinhdoanh.\nonline'
                    : 'dothi\nthongminh1',
                style: const TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 40,
                child: VerticalDivider(
                  width: 20,
                  color: Styles.primaryText,
                  thickness: 1,
                ),
              ),
              Text(
                Configs.selectType[temporaryUserGroup]?['text'] ?? '',
                style: TextStyle(
                  color: Configs.getUserColor(temporaryUserGroup),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  // fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            const FadeAnimation(
              delay: 1,
              child: Text(
                'Bạn tìm gần vị trí',
                style: Styles.textStyle,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            LocationSearchbar(
              onSelected: (model) {
                addressModel = model;
              },
              getInitPosition: false,
            ),
            const SizedBox(
              height: 12,
            ),
            const FadeAnimation(
              delay: 1,
              child: Text(
                'và bạn là',
                style: Styles.textStyle,
              ),
            ),

            FadeAnimation(
              delay: 1,
              child: Row(
                children: List.generate(
                  Configs.selectType.length,
                  (index) {
                    final type = Configs.selectType[index];
                    if (type == null) return const SizedBox();
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          // if(Configs.user==nu)
                          setState(() {
                            temporaryUserGroup = index;
                            userColor =
                                Configs.getUserColor(temporaryUserGroup);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          padding: const EdgeInsets.all(10),
                          decoration: ShapeDecoration(
                            color: temporaryUserGroup == index
                                ? userColor
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              // side: BorderSide(
                              //     color: temporaryUserGroup == index
                              //         ? GFColors.PRIMARY
                              //         : Colors.white),
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
                                width: 40,
                                height: 40,
                                child: Image.asset(
                                    'assets/icons/login/${type['icon']}.png'),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${type['text']}\n',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: const TextStyle(
                                    color: Color(0xFF23313E), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            if (temporaryUserGroup != 3)
              FadeAnimation(
                delay: 1,
                child: Text(
                  temporaryUserGroup == 0
                      ? 'đến hoặc tìm mua ở 1 trong 36 hộ kinh doanh:'
                      : 'đang tìm kiếm nhà phân phối cho 1 trong 36 loại:',
                  style: Styles.textStyle,
                ),
              ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: temporaryUserGroup == 3
                  ? CustomBingMap(
                      markers: const [],
                      position: LatLng(double.parse(addressModel?.lat ?? '21'),
                          double.parse(addressModel?.lon ?? '105.85')),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, childAspectRatio: 0.8),
                      itemCount: shopsData.length,
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 6, top: 6),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (productType == shopsData[index].type) {
                              productType = null;
                            } else {
                              productType = shopsData[index].type;
                            }
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.all(3.0),
                            padding: const EdgeInsets.all(6),
                            decoration: ShapeDecoration(
                              color: productType == shopsData[index].type
                                  ? Styles.fieldTextColor
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                // side: BorderSide(
                                //   color: productType == shopsData[index].type
                                //       ? GFColors.PRIMARY
                                //       : Colors.white,
                                // ),
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
                                  child: SvgPicture.string(
                                    shopsData[index].image ?? '',
                                    color: userColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  shopsData[index].name ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color(0xFF23313E), fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
            ),
            const SizedBox(
              height: 12,
            ),
            // CustomTextfield(
            //   onSaved: (val) => mainProduct = val,
            //   hintText: 'Hoặc tìm theo sản phẩm chính',
            // ),
            if (temporaryUserGroup != 3)
              CustomSearchBar<Product>(
                text: (value) {
                  return (value.value ?? '').capitalizeByWord();
                },
                hintText: 'hoặc tìm theo sản phẩm chính',
                onChanged: _getProducts,
                textCtrl: _productCtrl,
                readOnly: false,
                onSelected: (item) {
                  _productCtrl.text = item.value ?? '';
                },
              ),
            if (temporaryUserGroup != 3)
              const SizedBox(
                height: 8,
              ),
            if (temporaryUserGroup != 3)
              CustomSearchBar<Suggestions>(
                text: (value) {
                  return '${value.name ?? ''} ${(value.value?.isNotEmpty == true ? '(${value.value})' : '')}'
                      .capitalizeByWord();
                },
                hintText: 'hoặc tìm theo tên cửa hàng/thông điệp người bán',
                onChanged: _getShopByMessage,
                textCtrl: _sellerMessageCtrl,
                readOnly: false,
                onSelected: (item) {
                  _sellerMessageCtrl.text = item.value ?? '';
                },
              ),
            if (temporaryUserGroup != 3)
              const SizedBox(
                height: 8,
              ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GFButton(
              onPressed: () async {
                if (temporaryUserGroup == 3) {
                  // if (Configs.user == null) {
                  //   Fluttertoast.showToast(
                  //       msg:
                  //           "Bạn cần đăng nhập vào tài khoản người vận chuyển để tiếp tục");
                  // } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => ShipperFindOrderPage(
                        addressModel: addressModel,
                      ),
                    ),
                  );
                  // }
                  return;
                }
                if (addressModel == null) {
                  Fluttertoast.showToast(msg: 'Yêu cầu nhập địa chỉ chính xác');
                  return;
                }
                final result = await _networkUtil.searchAll(
                    kw: _productCtrl.text.trim(),
                    shopType: (productType?.toString() ?? '').trim(),
                    quote: _sellerMessageCtrl.text.trim(),
                    lat: addressModel?.lat ?? '',
                    lon: addressModel?.lon ?? '',
                    userGroup: temporaryUserGroup,
                    context: context);
                (result?.shops ?? []).sort((a, b) =>
                    double.parse(a.distance ?? '0')
                        .compareTo(double.parse(b.distance ?? '0')));
                if (context.mounted && result != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => ShopListWidget(
                        shops: result.shops ?? [],
                        temporaryUserGroup: temporaryUserGroup,
                        position: LatLng(
                            double.parse(addressModel?.lat ?? '21'),
                            double.parse(addressModel?.lon ?? '105.85')),
                        shopsData: shopsData,
                      ),
                    ),
                  );
                }
              },
              borderShape: RoundedRectangleBorder(
                // side: const BorderSide(width: 1, color: Color(0xFF1076D0)),
                borderRadius: BorderRadius.circular(6),
              ),
              fullWidthButton: true,
              icon: temporaryUserGroup == 3
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset(
                          'assets/icons/login/${Configs.selectType[3]?['icon']}.png'),
                    )
                  : null,
              size: 48,
              color: userColor,
              type: GFButtonType.solid,
              text: textBottomButton[temporaryUserGroup],

              // textColor: Colors.white,
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (temporaryUserGroup == 3)
            const SizedBox(
              height: 8,
            ),
          if (temporaryUserGroup == 3)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GFButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const ShopFindShipperScreen();
                      },
                    ),
                  );
                },
                // padding: const EdgeInsets.all(16),
                borderShape: RoundedRectangleBorder(
                  // side: const BorderSide(width: 1, color: Color(0xFF1076D0)),
                  borderRadius: BorderRadius.circular(6),
                ),
                fullWidthButton: true,
                size: 48,
                color: const Color(0xFF34A853),
                type: GFButtonType.solid,
                text: 'Tìm người vận chuyển gần đây',
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                      'assets/icons/login/${Configs.selectType[1]?['icon']}.png'),
                ),
                // textColor: Colors.white,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (_autoScrollText.isNotEmpty)
            SafeArea(
              child: Container(
                color: Colors.black,
                height: 20,
                child: NotificationListener(
                  onNotification: (notif) {
                    if (notif is ScrollEndNotification) {
                      Timer(const Duration(seconds: 1), () {
                        _scroll();
                      });
                    }

                    return true;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _autoScrollText,
                      maxLines: 1,
                      style: Styles.textStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
