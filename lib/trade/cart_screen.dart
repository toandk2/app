import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hkd/trade/payment_screen.dart';
import 'package:hkd/trade/shop_detail_screen.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _netUtil = NetworkUtil();
  List<CartModel> models = [];
  _calculateTotal(CartModel model) {
    double totalProductCost = 0;
    for (var element in model.products) {
      totalProductCost += element.subTotal ?? 0;
    }
    return totalProductCost;
  }

  @override
  void initState() {
    super.initState();
    _getCart();
  }

  _getCart() async {
    // if (Configs.login == null) {
    //   models = Configs.unSignedCart.values.toList();
    //   setState(() {});
    //   return;
    // }
    final result = await _netUtil.get(
        'get_cart', {'buyer_id': Configs.login?.buyerId ?? ''}, context);
    if (result != null && result['success'] == 1) {
      models = CartModel.fromListJson(result['data']);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(12),
          const Text(
            'Thông tin giỏ hàng',
            style: Styles.headline1Style,
            textAlign: TextAlign.center,
          ),
          const Gap(12),
          if (models.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: models.length,
                  itemBuilder: (context, index) {
                    final shopItem = models[index];
                    final totalPrice = _calculateTotal(shopItem);
                    return _CartItemWidget(
                      model: shopItem,
                      totalPrice: totalPrice,
                    );
                  }),
            )
        ],
      ),
    ));
  }
}

class _CartItemWidget extends StatefulWidget {
  const _CartItemWidget({
    required this.model,
    required this.totalPrice,
  });
  final CartModel model;
  final double totalPrice;

  @override
  State<_CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<_CartItemWidget> {
  final _netUtil = NetworkUtil();
  onTapCheckout() async {
    final result = await _netUtil.get(
        'shop', {'shop_id': widget.model.shopId ?? ''}, context);
    if (result != null) {
      try {
        final shopDetail = ShopDetail.fromJson(result);
        final checkoutModel = CheckoutModel();
        checkoutModel.shopName = shopDetail.shopName;
        checkoutModel.shopAddress = shopDetail.shopAddress;
        checkoutModel.bank = shopDetail.bank;
        checkoutModel.bankAccountName = shopDetail.bankAccountName;
        checkoutModel.bankAccountNumber = shopDetail.bankAccountNumber;
        checkoutModel.bankId = shopDetail.shop?.bankId;
        checkoutModel.shopPhone = shopDetail.shopPhone;
        checkoutModel.shopId = shopDetail.shopId;
        checkoutModel.buyerName = Configs.user?.name;
        checkoutModel.buyerPhone = Configs.user?.phone;
        checkoutModel.buyerAddress = Configs.user?.address;
        checkoutModel.data = widget.model.products;
        checkoutModel.lat1 = shopDetail.lat1?.toString() ?? '';
        checkoutModel.lon1 = shopDetail.lon1?.toString() ?? '';
        checkoutModel.lat2 = Configs.user?.lat ?? '';
        checkoutModel.lon2 = Configs.user?.lon ?? '';
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                model: checkoutModel,
              ),
            ),
          );
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Lỗi lấy thông tin cửa hàng!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      padding: const EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
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
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ShopDetailScreen(
                  shopId: widget.model.shopId ?? '',
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                widget.model.shopName ?? '',
                style:
                    Styles.headline2Style.copyWith(color: Styles.primaryColor3),
              ),
            ),
          ),
          const Divider(
            height: 24,
          ),
          InkWell(
            onTap: onTapCheckout,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(widget.model.products.length, (index) {
                  final item = widget.model.products.elementAtOrNull(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Styles.black50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Image.network(
                            Configs.BASE_URL.replaceAll('/api', '') +
                                (item?.image ?? ''),
                            // base64Decode(item.image ?? ''),

                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox();
                            },
                          ),
                        ),
                        const Gap(4),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: item?.productName ?? '',
                              style: Styles.headline3Style,
                              children: [
                                TextSpan(
                                  text:
                                      '\n${Configs.formatter.format(item?.price ?? 0)}đ',
                                  style: Styles.headline4Style
                                      .copyWith(color: Styles.primaryText),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const Gap(4),
                        Text.rich(
                          TextSpan(
                            text: 'x${item?.quantity ?? 0}',
                            style: Styles.headline3Style,
                            children: [
                              TextSpan(
                                text:
                                    '\n${Configs.formatter.format((item?.price ?? 0) * (item?.quantity ?? 0))}đ',
                                style: Styles.headline4Style
                                    .copyWith(color: Styles.moneyColor),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  );
                })),
          ),
          const Divider(
            height: 24,
          ),
          Row(
            children: [
              const Expanded(
                  child: Text(
                'Tổng số tiền',
                style: Styles.headline3Style,
              )),
              Text(
                '${Configs.formatter.format(widget.totalPrice)}đ',
                style: Styles.headline3Style
                    .copyWith(color: const Color(0xFF34A853)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
