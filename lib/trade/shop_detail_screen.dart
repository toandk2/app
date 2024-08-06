import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/trade/payment_screen.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/custom_dialog.dart';
import 'package:hkd/widgets/custom_searchbar.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';

class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({super.key, required this.shopId});
  final String shopId;
  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final _networkUtil = NetworkUtil();
  ShopDetail? _shopDetail;
  bool _isExtended = false;
  bool _showGroups = false;
  List<Products> _products = [];
  final Set<Products> _initProducts = {};
  Iterable<List<Products>> _slicedproduct = [];
  int groupPickedIndex = 0;
  bool _isGridView = false;
  final _checkoutModel = CheckoutModel();
  double _totalProductCost = 0;
  // double _totalCost = 0;
  final double _shippingCost = 0;
  int _pageCount = 0;
  bool _firstLoad = true;
  final ScrollController _scrollController = ScrollController();
  final NumberPaginatorController _pageController = NumberPaginatorController();

  // final NumberFormat Configs.formatter = NumberFormat("#,###");
  @override
  void initState() {
    _getShop();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollDown() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  getCartShop() async {
    final result = await _networkUtil.get('get_cart_by_shop_id',
        {'shop_id': widget.shopId, 'buyer_id': Configs.login?.buyerId ?? ''}, context);
    if (result != null && result['success'] == 1 && result['data'] != null) {
      try {
        final products = CartItem.fromListCartShopJson(
            jsonDecode(result['data']['products']));
        _checkoutModel.data = products;
        _totalProductCost = 0;
        for (var element in _checkoutModel.data) {
          _totalProductCost += element.subTotal ?? 0;
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Lỗi lấy thông tin giỏ hàng!');
      }
    }
  }

  _getShop() async {
    final result = await _networkUtil.get('shop', {'shop_id': widget.shopId}, context);
    if (result != null) {
      try {
        _shopDetail = ShopDetail.fromJson(result);
        final products = _shopDetail?.products;
        if (products != null) {
          _initProducts.addAll(products);
          _slicedproduct = _initProducts.slices(10);
          _updatePage();
        }
        _checkoutModel.shopName = _shopDetail?.shopName;
        _checkoutModel.shopAddress = _shopDetail?.shopAddress;
        _checkoutModel.bank = _shopDetail?.bank;
        _checkoutModel.bankAccountName = _shopDetail?.bankAccountName;
        _checkoutModel.bankAccountNumber = _shopDetail?.bankAccountNumber;
        _checkoutModel.bankId = _shopDetail?.shop?.bankId;
        _checkoutModel.shopPhone = _shopDetail?.shopPhone;
        _checkoutModel.shopId = _shopDetail?.shopId;
        _checkoutModel.buyerName = Configs.user?.name;
        _checkoutModel.buyerPhone = Configs.user?.phone;
        _checkoutModel.buyerAddress = Configs.user?.address;
        _checkoutModel.lat1 = _shopDetail?.lat1?.toString() ?? '';
        _checkoutModel.lon1 = _shopDetail?.lon1?.toString() ?? '';
        _checkoutModel.lat2 = Configs.user?.lat ?? '';
        _checkoutModel.lon2 = Configs.user?.lon ?? '';
        final currentUnsignedCart = Configs.unSignedCart[widget.shopId];
        if (Configs.login == null && currentUnsignedCart == null) {
          Configs.unSignedCart[widget.shopId] = CartModel(
            products: [],
            shopId: widget.shopId,
            shopName: _shopDetail?.shopName,
          );
        }
        if (currentUnsignedCart != null && Configs.login != null) {
          currentUnsignedCart.buyerId = Configs.login?.buyerId ?? '';
          await _syncCart(currentUnsignedCart);
        }
        if (Configs.login != null) {
          await getCartShop();
        }
      } catch (e) {
        _firstLoad = false;
        setState(() {});
      }
    }
    _firstLoad = false;
    setState(() {});
  }

  _syncCart(CartModel model) {
    showDialog(
        context: context,
        builder: (_) {
          return DialogAction(
            icon: const Icon(
              Icons.sync_outlined,
              size: 60,
              color: Styles.primaryColor,
            ),
            title: 'Đồng bộ các sản phẩm đã cho vào giỏ hàng trước đó',
            content:
                'Xác nhận đồng bộ với các sản phẩm cho vào giỏ hàng trước đó',
            text1: 'Đồng ý',
            text2: 'Không',
            onTap1: () async {
              Navigator.pop(context);
              await EasyLoading.show(
                status: 'Đang tải xử lý...',
                maskType: EasyLoadingMaskType.clear,
              );
              try {
                final products = Configs.unSignedCart[widget.shopId]?.products;
                final body = {
                  'buyer_id': model.buyerId,
                  'shop_id': model.shopId,
                  'products':
                      json.encode(CartItem.toListSyncCartJson(products ?? []))
                };
                final result =
                    await _networkUtil.post('async_cart_in_shop', body, context);
                await EasyLoading.dismiss();
                if (result != null && result['success'] == 1) {
                  Configs.unSignedCart.remove(widget.shopId);
                  await getCartShop();
                  setState(() {});
                  Fluttertoast.showToast(msg: 'Đồng bộ thành công');
                } else {
                  Fluttertoast.showToast(msg: 'Đồng bộ thất bại');
                }
              } catch (e) {
                await EasyLoading.dismiss();
                Fluttertoast.showToast(msg: 'Đồng bộ thất bại');
              }
            },
            onTap2: () {
              Configs.unSignedCart.remove(widget.shopId);
              Navigator.pop(context);
            },
          );
        });
  }

  _changedView(bool value) {
    _isGridView = value;
    setState(() {});
  }

  _changedExtend(bool value) {
    _isExtended = value;
    setState(() {});
  }

  List<Products> _onSearch(String? value) {
    if (value == null || value.isEmpty) {
      return <Products>[];
    }

    _slicedproduct = _initProducts
        .where((element) => element.productName?.contains(value) == true)
        .slices(10);
    _pageController.currentPage = 0;
    _updatePage();
    return [];
  }

  _updatePage() {
    _pageCount = _slicedproduct.length;
    _products =
        _slicedproduct.elementAtOrNull(_pageController.currentPage) ?? [];
    setState(() {});
  }

  _addItembyIndex(int index) async {
    if (Configs.userGroup != 0) {
      Fluttertoast.showToast(
          msg:
              'Bạn cần chuyển sang chế độ Người tìm mua để có thể thực hiện chức năng này');
      return;
    }
    final isNewCart = _checkoutModel.data.isEmpty;
    final product = _products.elementAtOrNull(index);
    if (product == null) return;

    CartItem? currentProduct = _checkoutModel.data
        .firstWhereOrNull((element) => element.productId == product.id);
    if (currentProduct != null) {
      currentProduct.quantity = currentProduct.quantity + 1;
      currentProduct.subTotal =
          (currentProduct.price ?? 0) * currentProduct.quantity;
    } else {
      currentProduct = CartItem(
          productId: product.id,
          productName: product.productName,
          quantity: 1,
          price: double.tryParse(product.listPrice ?? '0') ?? 0,
          subTotal: double.tryParse(product.listPrice ?? '0') ?? 0,
          unitDefault: product.unitDefault,
          image: product.imageFile);
      _checkoutModel.data.add(currentProduct);
    }
    await _updateCart(isNewCart, currentProduct);
  }

  _addItem(CartItem item) async {
    if (Configs.userGroup != 0) {
      Fluttertoast.showToast(
          msg:
              'Bạn cần chuyển sang chế độ Người tìm mua để có thể thực hiện chức năng này');
      return;
    }
    final isNewCart = _checkoutModel.data.isEmpty;
    CartItem? currentProduct = _checkoutModel.data
        .firstWhereOrNull((element) => element.productId == item.productId);
    if (currentProduct != null) {
      currentProduct.quantity = currentProduct.quantity + 1;
      currentProduct.subTotal =
          (currentProduct.price ?? 0) * currentProduct.quantity;
    } else {
      currentProduct = item;
      _checkoutModel.data.add(item);
    }
    await _updateCart(isNewCart, currentProduct);
  }

  _updateCart(bool isNewCart, CartItem currentProduct) async {
    _totalProductCost = 0;
    for (var element in _checkoutModel.data) {
      _totalProductCost += element.subTotal ?? 0;
    }
    setState(() {});
    await _addItemToCart(currentProduct);
    if (isNewCart && Configs.login != null) {
      await _networkUtil.updateCartCount(context);
    }
  }

  _removeItem(CartItem item) async {
    final currentProduct = _checkoutModel.data
        .firstWhereOrNull((element) => element.productId == item.productId);
    if (currentProduct != null) {
      if (currentProduct.quantity > 1) {
        currentProduct.quantity = currentProduct.quantity - 1;
        currentProduct.subTotal =
            (currentProduct.price ?? 0) * currentProduct.quantity;
        await _addItemToCart(currentProduct);
      } else {
        _checkoutModel.data.remove(currentProduct);
        await _addItemToCart(currentProduct);
      }
    }
    _totalProductCost = 0;
    for (var element in _checkoutModel.data) {
      _totalProductCost += element.subTotal ?? 0;
    }
    setState(() {});
    if (Configs.login != null) {
      if (_checkoutModel.data.isEmpty) {
        await _networkUtil.deleteCartOnline(_checkoutModel.shopId, context);
      } else {
        await _deleteItemCartOnline(item);
      }
    } else {
      _deleteCartUnsigned(item);
    }
  }

  _addItemToCart(CartItem item) async {
    if (Configs.login == null) {
      _addItemToCartUnsinged(item);
    } else {
      await _addItemToCartOnline(item);
    }
  }

  _addItemToCartOnline(CartItem item) async {
    Map<String, dynamic> body;
    dynamic result;
    if (item.quantity > 1) {
      body = {
        'buyer_id': Configs.login?.buyerId,
        'shop_id': _checkoutModel.shopId ?? '',
        'product_id': item.productId ?? '',
        'quantity': item.quantity.toString()
      };
      result = await _networkUtil.post('update_product_in_cart', body, context);
    } else {
      body = {
        'buyer_id': Configs.login?.buyerId,
        'shop_id': _checkoutModel.shopId ?? '',
        'product_id': item.productId ?? '',
        'product_quantity': '1'
      };
      result = await _networkUtil.post('add_product_in_cart', body, context);
    }
    if (result != null && result['success'] == 1) {
      return;
    }
    Fluttertoast.showToast(msg: 'Thêm sản phẩm không thành công');
  }

  _addItemToCartUnsinged(CartItem item) async {
    final products = Configs.unSignedCart[widget.shopId]?.products;
    final currentProducts = products
        ?.firstWhereOrNull((element) => element.productId == item.productId);
    if (currentProducts == null) {
      products?.add(item);
    } else {
      currentProducts.quantity += 1;
    }
  }

  _deleteCartUnsigned(CartItem item) {
    final products = Configs.unSignedCart[widget.shopId]?.products;
    final currentProducts = products
        ?.firstWhereOrNull((element) => element.productId == item.productId);
    if (currentProducts == null) {
      return;
    }
    if (currentProducts.quantity >= 1) {
      currentProducts.quantity--;
    }
  }

  _deleteItemCartOnline(CartItem item) async {
    final body = {
      'buyer_id': Configs.login?.buyerId,
      'shop_id': _checkoutModel.shopId ?? '',
      'product_id': item.productId ?? '',
    };
    final result = await _networkUtil.post('delete_product_in_cart', body, context);
    if (result != null && result['success'] == 1) {
      return;
    }
  }

  _genQr() async {
    final data = {
      "accountNo": _checkoutModel.bankAccountNumber ?? '',
      "accountName": _checkoutModel.bankAccountName ?? '',
      "acqId": _checkoutModel.bankId ?? '',
      "format": "text",
      "template": "qr_only",
      "amount": _totalProductCost + _shippingCost,
      "addInfo": _checkoutModel.name ?? '',
    };

    final result = await _networkUtil
        .postNoUrl('https://api.vietqr.io/v2/generate', data, context, formData: false);
    if (result != null && result['data'] != null) {
      _checkoutModel.qrcode =
          result['data']['qrDataURL'].toString().split(',')[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: _firstLoad
            ? Lottie.asset(
                "assets/images/loading.json",
                repeat: true,
                reverse: true,
                animate: true,
              )
            : Column(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 2,
                      child: Image.network(
                        Configs.BASE_URL.replaceAll('/api/', '') +
                            (_shopDetail?.imgPath ?? ''),
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Styles.darkGrey,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 2,
                          );
                        },
                      )),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_shopDetail?.shopName ?? '',
                            style: Styles.headline1Style),
                        const Gap(12),
                        Row(
                          children: [
                            Expanded(
                              child: GFButton(
                                onPressed: () async {
                                  final url = Uri.parse(
                                      "tel://${_shopDetail?.shopPhone ?? ''}");

                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Could not launch $url');
                                  }
                                },
                                size: 40,
                                text: 'Liên hệ',
                                icon: SvgPicture.asset(
                                  'assets/icons/profile/bxs-phone.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                color: const Color(0xFFEBF2F8),
                                textStyle: Styles.headline4Style
                                    .copyWith(color: Styles.primaryColor3),
                                borderShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: GFButton(
                                onPressed: () async {
                                  // final url = Uri.parse("tel://${_shopDetail?.url??''}");

                                  // if (await canLaunchUrl(url)) {
                                  //   await launchUrl(url);
                                  // } else {
                                  //   Fluttertoast.showToast(msg: 'Could not launch $url');
                                  // }
                                  await Clipboard.setData(ClipboardData(
                                      text:
                                          'https://dothithongminh1.vn/${_shopDetail?.shopId ?? ''}'));
                                  Fluttertoast.showToast(
                                      msg:
                                          "Sao chép đường dẫn cửa hàng thành công ");
                                  // Share.share(_shopDetail?.url ?? '');
                                },
                                size: 40,
                                text: 'Chia sẻ',
                                icon: SvgPicture.asset(
                                  'assets/icons/profile/bxs-share.svg',
                                  width: 24,
                                  height: 24,
                                  color: Styles.primaryColor3,
                                ),
                                color: const Color(0xFFEBF2F8),
                                textStyle: Styles.headline4Style
                                    .copyWith(color: Styles.primaryColor3),
                                borderShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/profile/bxs-map.svg',
                              width: 24,
                              height: 24,
                            ),
                            const Gap(12),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _shopDetail?.shopAddress ?? '',
                                  style: Styles.textStyle,
                                ),
                                GFButton(
                                  onPressed: () async {
                                    final availableMaps =
                                        await MapLauncher.installedMaps;
                                    await availableMaps.firstOrNull
                                        ?.showDirections(
                                            destination: Coords(
                                                _shopDetail?.lat1?.toDouble() ??
                                                    0,
                                                _shopDetail?.lon1?.toDouble() ??
                                                    0));
                                  },
                                  text: 'Chỉ đường',
                                  icon: SvgPicture.asset(
                                    'assets/icons/send-plane-line.svg',
                                    width: 24,
                                    height: 24,
                                    color: Styles.primaryColor3,
                                  ),
                                  textStyle: Styles.subtitle1Style.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Styles.primaryColor3,
                                  ),
                                  type: GFButtonType.transparent,
                                  padding: const EdgeInsets.all(0),
                                  // borderShape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(6)),
                                ),
                              ],
                            ))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/profile/bxs-phone.svg',
                              width: 24,
                              height: 24,
                            ),
                            const Gap(12),
                            Expanded(
                              child: Text(
                                _shopDetail?.shopPhone ?? '',
                                style: Styles.textStyle,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: _isExtended,
                          child: Column(
                            children: [
                              const Gap(8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset('assets/images/location-pin.png'),
                                  const Gap(12),
                                  Expanded(
                                    child: Text(
                                      _shopDetail?.website ?? '',
                                      style: Styles.textStyle,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/share-network.svg'),
                                  const Gap(12),
                                  Expanded(
                                    child: Text(
                                      _shopDetail?.facebook ?? '',
                                      style: Styles.textStyle,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              if (_shopDetail?.type != null &&
                                  ["11"].contains(_shopDetail!.shopType!))
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (_shopDetail?.shop?.gpp != null)
                                        ? Image.asset(
                                            'assets/images/secure.png')
                                        : Image.asset(
                                            'assets/images/secure.png',
                                            color: Styles.fieldTextColor,
                                          ),
                                    const Gap(12),
                                    const Expanded(
                                      child: Text(
                                        'Có Giấy chứng nhận đủ điều kiện kinh doanh dược',
                                        style: Styles.textStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              if (_shopDetail?.type != null &&
                                  ["31", "0", "30", "29", "33", "7"]
                                      .contains(_shopDetail!.shopType!))
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (_shopDetail?.shop?.gpp != null)
                                        ? Image.asset(
                                            'assets/images/secure.png')
                                        : Image.asset(
                                            'assets/images/secure.png',
                                            color: Styles.fieldTextColor,
                                          ),
                                    const Gap(12),
                                    const Expanded(
                                      child: Text(
                                        'Xem giấy chứng nhận VSATTP',
                                        style: Styles.textStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              const Gap(8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (_shopDetail?.shopEbillExist == 1)
                                      ? Image.asset(
                                          'assets/images/tick-hddt.png',
                                        )
                                      : Image.asset(
                                          'assets/images/tick-hddt.png',
                                          color: Styles.fieldTextColor,
                                        ),
                                  const Gap(12),
                                  const Expanded(
                                    child: Text(
                                      'Có xuất hoá đơn điện tử',
                                      style: Styles.textStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _isExtended
                            ? GFButton(
                                onPressed: () {
                                  _changedExtend(false);
                                },
                                icon:
                                    const Icon(Icons.keyboard_arrow_up_rounded),
                                text: 'Thu gọn',
                                fullWidthButton: true,
                                type: GFButtonType.transparent,
                                textStyle: Styles.textStyle
                                    .copyWith(color: Styles.primaryColor3),
                                position: GFPosition.end,
                              )
                            : GFButton(
                                onPressed: () {
                                  _changedExtend(true);
                                },
                                type: GFButtonType.transparent,
                                fullWidthButton: true,
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                                text: 'Xem thêm thông tin',
                                textStyle: Styles.textStyle
                                    .copyWith(color: Styles.primaryColor3),
                                position: GFPosition.end,
                              )
                      ],
                    ),
                  ),
                  if (_initProducts.isEmpty)
                    SvgPicture.asset(
                      'assets/icons/bx-box.svg',
                      width: 120,
                      height: 120,
                    ),
                  if (_initProducts.isEmpty)
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60.0, vertical: 24),
                      child: Text(
                          'Hộ kinh doanh này hiện tại chưa có sản phẩm nào.',
                          textAlign: TextAlign.center,
                          style: Styles.hintStyle),
                    ),
                  if (_initProducts.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CustomSearchBar<Products>(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Styles.fieldTextColor,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _showGroups = !_showGroups;
                            });
                          },
                          child: const Icon(
                            Icons.menu,
                            color: Styles.fieldTextColor,
                          ),
                        ),
                        readOnly: false,
                        showDialog: false,
                        onChanged: _onSearch,
                        text: (text) {
                          return text.productName ?? '';
                        },
                        onSelected: (value) {},
                        timeOutSearch: 0,
                      ),
                    ),
                  if (_showGroups &&
                      _shopDetail?.productGroups != null &&
                      _shopDetail?.productGroups?.isNotEmpty == true)
                    SizedBox(
                      height: 54,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          _GroupProductWidget(
                            group: 'Tất cả',
                            picked: groupPickedIndex == 0,
                            onTap: () {
                              _slicedproduct = _initProducts.slices(10);

                              groupPickedIndex = 0;
                              _pageController.currentPage = 0;
                              _updatePage();
                            },
                          ),
                          ...List.generate(
                              _shopDetail?.productGroups?.length ?? 0, (index) {
                            final group = _shopDetail?.productGroups?[index];
                            if (group == null) return const SizedBox();
                            return _GroupProductWidget(
                              group: group.name ?? '',
                              picked: groupPickedIndex == index + 1,
                              onTap: () {
                                if (group.name == 'Sản phẩm dịch vụ bán') {
                                  _slicedproduct = _initProducts.slices(10);
                                } else {
                                  _slicedproduct = _shopDetail
                                          ?.groups?[group.id]
                                          ?.slices(10) ??
                                      [];
                                }
                                groupPickedIndex = index + 1;
                                _pageController.currentPage = 0;
                                _updatePage();
                              },
                            );
                          })
                        ],
                      ),
                    ),
                  // ListView.builder(
                  //   itemCount: _shopDetail?.productGroups?.length??0,
                  //   itemBuilder: (context, index) {

                  // }),
                  if (_initProducts.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Gap(12),
                        const Text(
                          'Kiểu xem: ',
                          style: Styles.subtitle1Style,
                        ),
                        const Gap(6),
                        GFButton(
                          onPressed: () {
                            _changedView(false);
                          },
                          type: GFButtonType.solid,
                          color: _isGridView
                              ? Colors.white
                              : const Color(0xFFEAEAEA),
                          icon: const Icon(Icons.list_rounded),
                          text: 'Danh sách',
                          textStyle: Styles.subtitle1Style,
                        ),
                        const Gap(6),
                        GFButton(
                          onPressed: () {
                            _changedView(true);
                          },
                          type: GFButtonType.solid,
                          color: _isGridView
                              ? const Color(0xFFEAEAEA)
                              : Colors.white,
                          icon: const Icon(Icons.grid_view),
                          text: 'Lưới',
                          textStyle: Styles.subtitle1Style,
                        ),
                        const Gap(12),
                      ],
                    ),
                  if (_initProducts.isNotEmpty && _products.isEmpty)
                    SvgPicture.asset(
                      'assets/icons/bx-search.svg',
                      width: 120,
                      height: 120,
                    ),
                  if (_initProducts.isNotEmpty && _products.isEmpty)
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60.0, vertical: 24),
                      child: Text('Không có kết quả tìm kiếm phù hợp.',
                          textAlign: TextAlign.center, style: Styles.hintStyle),
                    ),

                  if (_shopDetail != null &&
                      _products.isNotEmpty == true &&
                      !_isGridView)
                    ...List.generate(
                        _products.length,
                        (index) => InkWell(
                            onTap: () {
                              _addItembyIndex(index);
                            },
                            child: _ItemWidget(product: _products[index]))),
                  if (_shopDetail != null &&
                      _products.isNotEmpty == true &&
                      _isGridView)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.64),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                _addItembyIndex(index);
                              },
                              child: _ItemGridWidget(product: _products[index]),
                            );
                          }),
                    ),
                  const Gap(12),
                  if (_pageCount > 0)
                    NumberPaginator(
                      numberPages: _pageCount,
                      controller: _pageController,
                      onPageChange: (int index) {
                        _updatePage();
                      },
                    ),
                  _CheckoutWidget(
                    model: _checkoutModel,
                    key: Key(_checkoutModel.data.toString()),
                    addItem: _addItem,
                    removeItem: _removeItem,
                    shippingCost: _shippingCost,
                    productCost: _totalProductCost,
                  )
                ],
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            GFIconBadge(
              key: Key(_checkoutModel.data.length.toString()),
              counterChild: GFBadge(
                text: _checkoutModel.data.length.toString(),
              ),
              child: GFIconButton(
                  icon: Image.asset(
                    'assets/icons/bxs-cart.png',
                    color: Colors.white,
                  ),
                  color: _checkoutModel.data.isNotEmpty == true
                      ? Styles.primaryColor3
                      : Styles.fieldTextColor,
                  onPressed: _scrollDown),
            ),
            const Gap(12),
            Expanded(
              child: GFButton(
                onPressed: () async {
                  _checkoutModel.name =
                      _checkoutModel.data.firstOrNull?.productName;
                  await _genQr();

                  if (mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          model: _checkoutModel,
                        ),
                      ),
                    );
                  }
                },
                padding: const EdgeInsets.all(16),
                borderShape: RoundedRectangleBorder(
                  // side: const BorderSide(width: 1, color: Styles.primaryColor3),
                  borderRadius: BorderRadius.circular(6),
                ),
                size: 48,
                type: GFButtonType.solid,
                color: _checkoutModel.data.isNotEmpty == true
                    ? Styles.primaryColor3
                    : Styles.fieldTextColor,
                // text: 'Chưa có tài khoản? Đăng ký ngay',
                // textColor: Styles.primaryColor3,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Thanh toán',
                        style:
                            Styles.headline4Style.copyWith(color: Colors.white),
                      ),
                    ),
                    Text(
                      '${Configs.formatter.format(_shippingCost + _totalProductCost)}đ',
                      // '${Configs.formatter.format(donHang.shippingCost)}đ',
                      style:
                          Styles.headline4Style.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({required this.product});
  final Products product;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      // padding: const EdgeInsets.only(top: 12, right: 12, bottom: 12),
      clipBehavior: Clip.antiAlias,
      height: 100,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: const Color(0xFFEAEAEA),
              height: 100,
              width: 100,
              child: Image.network(
                Configs.BASE_URL.replaceAll('/api', '') +
                    (product.imageFile ?? ''),
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                      child: SvgPicture.asset(
                    'assets/icons/bx-box.svg',
                    width: 48,
                    height: 48,
                    color: Colors.white,
                  ));
                },
              )),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Text(
                  product.productName ?? '',
                  style: Styles.headline4Style.copyWith(
                    color: const Color(0xFF303030),
                  ),
                  maxLines: 2,
                ),
                const Gap(4),
                Text(product.unitDefault ?? '', style: Styles.textStyle),
                const Spacer(),
                Text(
                  '${Configs.formatter.format(double.parse(product.listPrice ?? '0.0'))}đ',
                  style: Styles.headline4Style
                      .copyWith(color: const Color(0xFF278D47)),
                ),
                const Gap(10),
              ],
            ),
          ),
          const Gap(12),
          const Center(
            child: Icon(
              Icons.add,
              color: Styles.primaryColor3,
              size: 24,
            ),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}

class _ItemGridWidget extends StatelessWidget {
  const _ItemGridWidget({required this.product});
  final Products product;
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      // padding: const EdgeInsets.only(top: 12, right: 12, bottom: 12),
      clipBehavior: Clip.antiAlias,
      // height: 100,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
                color: const Color(0xFFEAEAEA),
                child: Image.network(
                  Configs.BASE_URL.replaceAll('/api', '') +
                      (product.imageFile ?? ''),
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                        child: SvgPicture.asset(
                      'assets/icons/bx-box.svg',
                      width: 48,
                      height: 48,
                      color: Colors.white,
                    ));
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName ?? '',
                  style: Styles.headline4Style.copyWith(
                    color: const Color(0xFF303030),
                  ),
                  maxLines: 2,
                ),
                const Gap(6),
                Text(product.unitDefault ?? '', style: Styles.textStyle),
                const Gap(12),
                Text(
                  '${Configs.formatter.format(double.parse(product.listPrice ?? '0.0'))}đ',
                  style: Styles.headline4Style
                      .copyWith(color: const Color(0xFF278D47)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupProductWidget extends StatelessWidget {
  const _GroupProductWidget(
      {required this.group, required this.onTap, this.picked = false});
  final String group;
  final Function onTap;
  final bool picked;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: ShapeDecoration(
          color: picked ? const Color(0xFFEAEAEA) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
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
        child: Text(
          group,
          style: Styles.textStyle.copyWith(
              color: picked ? Styles.primaryText : Styles.primaryColor3),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CheckoutWidget extends StatelessWidget {
  const _CheckoutWidget(
      {super.key,
      required this.model,
      required this.addItem,
      required this.removeItem,
      required this.shippingCost,
      required this.productCost});
  final CheckoutModel model;
  final Function(CartItem) addItem;
  final Function(CartItem) removeItem;
  final double shippingCost;
  final double productCost;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                  child: Text(
                'Giỏ hàng',
                style: Styles.hintStyle,
              )),
              Text(
                '${model.data.length} sản phẩm',
                style: Styles.textStyle,
              ),
            ],
          ),
          const Gap(12),
          Container(
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final item = model.data[index];
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: item.productName,
                                          style: Styles.headline4Style,
                                        ),
                                        TextSpan(
                                            text: '\n${item.unitDefault}',
                                            style: Styles.subtitle1Style),
                                      ],
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Text(
                                  '${item.quantity} x ${Configs.formatter.format(item.price ?? 0)} đ',
                                  style: Styles.hintStyle.copyWith(
                                    color: const Color(0xFF6B6B6B),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(6),
                            Row(
                              children: [
                                GFIconButton(
                                  size: 30,
                                  iconSize: 16,
                                  borderShape: const RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                      color: Color(0xFFE5E5E5),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Styles.primaryColor3,
                                  ),
                                  type: GFButtonType.outline,
                                  onPressed: () => removeItem(item),
                                ),
                                Container(
                                  width: 36,
                                  height: 32,
                                  decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        color: Color(0xFFE5E5E5),
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.quantity.toString(),
                                      style: Styles.textStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GFIconButton(
                                  size: 30,
                                  iconSize: 16,
                                  borderShape: const RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                      color: Color(0xFFE5E5E5),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.add,
                                    color: Styles.primaryColor3,
                                  ),
                                  type: GFButtonType.outline,
                                  onPressed: () => addItem(item),
                                ),
                                const Spacer(),
                                Text(
                                  '${Configs.formatter.format(item.subTotal ?? 0)} đ',
                                  style: Styles.hintStyle
                                      .copyWith(color: const Color(0xFF278D47)),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Color(0xFFEAEAEA),
                          height: 24,
                        );
                      },
                      itemCount: model.data.length),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Flex(
                        direction: Axis.horizontal,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                            (constraints.constrainWidth() / 12).floor(),
                            (index) => const SizedBox(
                                  height: 1,
                                  width: 5,
                                  child: DecoratedBox(
                                    decoration:
                                        BoxDecoration(color: Colors.grey),
                                  ),
                                )),
                      );
                    },
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Thành tiền',
                          style: Styles.textStyle.copyWith(
                            color: const Color(0xFF6B6B6B),
                          ),
                        ),
                      ),
                      Text(
                        '${Configs.formatter.format(productCost)} đ',
                        style: Styles.textStyle,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Phí vận chuyển',
                          style: Styles.textStyle.copyWith(
                            color: const Color(0xFF6B6B6B),
                          ),
                        ),
                      ),
                      Text(
                        '${Configs.formatter.format(shippingCost)} đ',
                        style: Styles.textStyle,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Thành tiền',
                          style: Styles.textStyle.copyWith(
                            color: const Color(0xFF6B6B6B),
                          ),
                        ),
                      ),
                      Text(
                        '${Configs.formatter.format(productCost + shippingCost)} đ',
                        style: Styles.textStyle,
                      ),
                    ],
                  ),
                  const Gap(12),
                ],
              )),
        ],
      ),
    );
  }
}
