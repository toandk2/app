import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/search_screen.dart';
import 'package:hkd/shop/shop_home_page.dart';
import 'package:hkd/ultils/chat_models.dart';

import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/chat_message.dart';
import 'package:hkd/widgets/custom_dialog.dart';
import 'package:hkd/widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

import 'package:material_dialogs/material_dialogs.dart';

import 'package:url_launcher/url_launcher.dart';

class ShopOrderDetailScreen extends StatefulWidget {
  const ShopOrderDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ShopOrderDetailScreen> createState() => _ShopOrderDetailScreenState();
}

class _ShopOrderDetailScreenState extends State<ShopOrderDetailScreen>
    with TickerProviderStateMixin {
  // final orderApis = ['order_buyer_detail', 'get_order_detail'];
  final tabTitles = ['DS sản phẩm', 'TT liên hệ', 'Chat'];
  final NumberFormat formatter = NumberFormat("#,###");
  final NetworkUtil _netUtil = NetworkUtil();
  ShipperDetail? shipper;
  final ScrollController _scrollController = ScrollController();
  List<OrderDetail> orderDetail = [];
  OrderDetails? order;
  int soLuongSanPham = 0;
  int _status = 0;
  // final FocusNode _focusNodes = FocusNode();
  TextEditingController txtChat = TextEditingController();
  List<BuyerMessages> dataChat = [];
  late final TabController _tabController;
  int tabIndex = 0;
  Status? status;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
    getShipper();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // _focusNodes.dispose();
    txtChat.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getChat() async {
    Map<String, String> body = {
      "order_id": Configs.orderId ?? '',
    };
    final rs = await _netUtil.get("shop_messages", body, context);
    if (rs != null) {
      dataChat = (rs)
          .map<BuyerMessages>((item) => BuyerMessages.fromJson(item))
          .toList();
    }

    setState(() {});
  }

  Future<void> getShipper() async {
    Map<String, String> body = {"order_id": Configs.orderId ?? '', 'type': '1'};
    soLuongSanPham = 0;
    _status = 0;
    setState(() {});
    final rs = await _netUtil.get("show_shipper_detail", body, context);
    if (rs != null) {
      shipper = ShipperDetail.fromJson(rs);
    }
    await getOrderDetail();
  }

  Future<void> getOrderDetail() async {
    Map<String, String> body = {
      "order_id": Configs.orderId ?? '',
    };
    orderDetail = [];
    final rs = await _netUtil.get('get_order_detail', body, context);
    if (rs != null) {
      order = OrderDetails.fromJson(rs);
      status = Configs.listShopStatus
          .firstWhereOrNull((element) => element.status == order?.status);
      orderDetail = order?.items ?? [];
      soLuongSanPham = orderDetail.length;
      _status = 2;
    } else {
      _status = 3;
    }
    setState(() {});
    getChat();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: _status == 0
          ? Lottie.asset(
              "assets/images/loading.json",
              repeat: true,
              reverse: true,
              animate: true,
            )
          : _status == 3
              ? Lottie.asset(
                  "assets/images/nodata.json",
                  repeat: true,
                  reverse: true,
                  animate: true,
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 12,
                            offset: Offset(0, 8),
                            spreadRadius: -4,
                          )
                        ],
                      ),
                      // padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Đơn #${order?.id ?? ''}: ${order?.orderName ?? ''.toUpperCase()}',
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: true,
                                      style: Styles.headline1Style
                                          .copyWith(fontSize: 20),
                                    ),
                                    const Gap(6),
                                    Container(
                                      height: 27,
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        top: 6,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: order?.status == -3
                                            ? const Color(0xFFEC6F61)
                                            : status?.color,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                      child: Text(
                                          order?.status == -3
                                              ? 'Đơn hàng bị huỷ bởi người mua'
                                              : order?.status == -2
                                                  ? 'Đơn hàng bị huỷ bởi người bán'
                                                  : status?.name ?? '',
                                          style: Styles.subtitle1Style
                                              .copyWith(color: Colors.white)),
                                    ),
                                    const Gap(6),
                                  ],
                                ),
                              ),
                              const Gap(4),
                              InkWell(
                                onTap: () {
                                  _showMaterialDialog();
                                },
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  padding: const EdgeInsets.all(12),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFEAEAEA),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/profile/bx-qr.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(6),
                          if (tabIndex != 2)
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/icons/profile/bx-time.svg'),
                                const Gap(6),
                                Expanded(
                                  child: Text(
                                    'Giờ nhận hàng: ',
                                    style: Styles.subtitle1Style
                                        .copyWith(fontSize: 14),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  child: Text(
                                      '${order?.shippingTimeSlot == null ? "" : '${order?.shippingTimeSlot}, '}${order?.shippingTimeSlotFrom}h - ${order?.shippingTimeSlotTo}h',
                                      style: Styles.headline5Style),
                                )
                              ],
                            ),
                          const Gap(6),
                          if (tabIndex != 2)
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/icons/profile/bx-money.svg'),
                                const Gap(6),
                                Expanded(
                                  child: Text(
                                    'Phương thức TT: ',
                                    style: Styles.subtitle1Style
                                        .copyWith(fontSize: 14),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  child: Text(
                                      order?.paymentMethod == "1"
                                          ? 'Chuyển khoản'
                                          : 'Thanh toán lúc nhận hàng',
                                      style: Styles.headline5Style),
                                ),
                              ],
                            ),
                          const Gap(5),
                          if (tabIndex != 2)
                            Container(
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFFFF9EC),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/profile/bx-note.svg',
                                      ),
                                      const Gap(6),
                                      Text(
                                        'Ghi chú đơn',
                                        style: Styles.textStyle.copyWith(
                                          color: const Color(0xFFD89F2E),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(4),
                                  Text(
                                    order?.note ?? '',
                                    style: Styles.headline3Style,
                                  ),
                                ],
                              ),
                            ),
                          const Gap(10),
                          if (tabIndex != 2) getButton(context),
                          const Gap(10),
                          TabBar(
                            controller: _tabController,
                            labelPadding: const EdgeInsets.all(12),
                            // indicatorPadding: const EdgeInsets.all(0),
                            indicatorColor: Styles.primaryColor3,
                            indicatorSize: TabBarIndicatorSize.tab,
                            onTap: ((index) {
                              setState(() {
                                tabIndex = index;
                              });
                            }),
                            tabs: List.generate(
                              tabTitles.length,
                              (index) {
                                return Text(
                                  tabTitles[index],
                                  style: Styles.textStyle.copyWith(
                                      color: tabIndex == index
                                          ? Styles.primaryColor3
                                          : Styles.textColor),
                                );
                              },
                            ),
                          ),
                          const Gap(10),
                        ],
                      ),
                    ),
                    if (tabIndex == 0) ...buildStates(),
                    if (tabIndex == 1) buildInfos(),
                    if (tabIndex == 2) ...buildChat(),
                  ],
                ),
    );
  }

  Widget getButton(BuildContext context) {
    switch (order?.status) {
      case 0:
        return btnStep0();
      // case 1:
      //   return btnStep1();
      case 2:
        return btnStep2();
      // case 3:
      //   return btnStep1();
      default:
        return const SizedBox();
    }
  }

  List<Widget> buildStates() {
    List<Widget> allStates = [];
    for (var order in orderDetail) {
      allStates
          .add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Gap(2),
        Text(
          order.productName ?? '',
          style: Styles.headline4Style,
        ),
        const Gap(4),
        Row(
          children: [
            Expanded(
              child: Text(
                '${formatter.format(order.quantity)} x ${formatter.format(order.price)} đ',
                style: Styles.textStyle,
              ),
            ),
            Text(
              '${formatter.format(order.amount)} đ',
              style: Styles.headline5Style
                  .copyWith(color: const Color(0xFF278D47)),
            ),
          ],
        ),
        const Gap(2),
        Divider(
          color: Colors.grey.shade300,
        ),
        const Gap(2),
      ]));
    }
    if (soLuongSanPham > 0) {
      allStates.add(Row(
        children: [
          const Expanded(child: Text('Tiền hàng', style: Styles.textStyle)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      '${formatter.format(soLuongSanPham > 0 ? orderDetail.map<double>((m) => m.amount?.toDouble() ?? 0).reduce((a, b) => a + b) : 0)}đ',
                  style: Styles.headline5Style,
                ),
              ],
            ),
            textAlign: TextAlign.left,
          )
        ],
      ));
    }
    if (soLuongSanPham > 0) allStates.add(const Gap(5));
    if (soLuongSanPham > 0) {
      allStates.add(Row(
        children: [
          const Expanded(child: Text('Phí giao hàng', style: Styles.textStyle)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${formatter.format(order?.shippingCost)}đ',
                  style: Styles.headline5Style,
                ),
              ],
            ),
            textAlign: TextAlign.left,
          )
        ],
      ));
    }
    if (soLuongSanPham > 0) allStates.add(const Gap(5));
    if (soLuongSanPham > 0) {
      allStates.add(Row(
        children: [
          const Expanded(
              child: Text('Tổng thanh toán', style: Styles.textStyle)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      '${formatter.format((soLuongSanPham > 0 ? orderDetail.map<double>((m) => m.amount?.toDouble() ?? 0).reduce((a, b) => a + b) : 0) + (order?.shippingCost ?? 0))}đ',
                  style: Styles.headline5Style
                      .copyWith(color: const Color(0xFF278D47)),
                ),
              ],
            ),
            textAlign: TextAlign.left,
          )
        ],
      ));
    }

    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Thông tin Sản phẩm',
                style: Styles.hintStyle,
              ),
            ),
            Text(
              '$soLuongSanPham sản phẩm',
              style: Styles.subtitle1Style
                  .copyWith(color: const Color(0xFF303030)),
            )
          ],
        ),
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
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
                offset: Offset(0, 0),
                spreadRadius: 8,
              )
            ],
          ),
          child: ListView(shrinkWrap: true, children: allStates),
        ),
      )
    ];
  }

  Widget btnStep0() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: GFButton(
            color: const Color(0xFFFCE7EB),
            size: 40,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return DialogAction(
                      icon: Image.asset('assets/images/icons-cancel.png'),
                      title: 'Từ chối đơn hàng này?',
                      content: 'Đơn hàng sẽ bị từ chối',
                      text1: 'Từ chối đơn hàng',
                      text2: 'Bỏ qua',
                      onTap1: () async {
                        Navigator.pop(context);
                        await EasyLoading.show(
                          status: 'Đang tải xử lý...',
                          maskType: EasyLoadingMaskType.clear,
                        );
                        final body = {
                          'token': Configs.login?.token ?? '',
                          'order_id': order?.id ?? ''
                        };
                        final result = await _netUtil.post(
                            'shop_reject_order', body, context);
                        await EasyLoading.dismiss();
                        if (result != null && result['success'] == 1) {
                          Fluttertoast.showToast(msg: 'Huỷ đơn thành công');
                          if (mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                              return const ShopPage(
                                status: -2,
                              );
                            }),
                                (Route<dynamic> route) =>
                                    route is SearchScreen);
                          }
                        } else {
                          Fluttertoast.showToast(msg: 'Huỷ đơn thất bại');
                        }
                      },
                      onTap2: () => Navigator.pop(context),
                    );
                  });
            },
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
            icon: const Icon(
              Icons.close,
              color: Styles.moneyColor,
              size: 24,
            ),
            child: Text(
              'Huỷ đơn',
              style: Styles.headline4Style.copyWith(color: Styles.moneyColor),
            ),
          ),
        ),
        const Gap(5),
        Expanded(
          child: GFButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return DialogAction(
                      title: 'Xác nhận đơn hàng này',
                      content:
                          'Đơn hàng sẽ chuyển sang trạng thái Đã xác nhận và bạn có thể giao dịch với người mua',
                      text1: 'Xác nhận đơn hàng',
                      text2: 'Bỏ qua',
                      icon: Image.asset('assets/images/icons8-pass.png'),
                      onTap2: () => Navigator.pop(context),
                      onTap1: () async {
                        Navigator.pop(context);
                        await EasyLoading.show(
                          status: 'Đang tải xử lý...',
                          maskType: EasyLoadingMaskType.clear,
                        );
                        Map<String, String> body = {
                          "order_id": order?.id ?? '',
                          "status": "1"
                        };
                        try {
                          final rs = await _netUtil.get(
                              "change_order_status", body, context);
                          await EasyLoading.dismiss();
                          if (rs == null || rs["success"].toString() != "1") {
                            Fluttertoast.showToast(
                                msg: "Có lỗi xảy ra, xin vui lòng thử lại.");
                            return;
                          }
                          Fluttertoast.showToast(
                              msg: "Xác nhận đơn hàng thành công.");
                          if (mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                              return const ShopPage(
                                status: 1,
                              );
                            }),
                                (Route<dynamic> route) =>
                                    route is SearchScreen);
                          }
                        } catch (e) {
                          await EasyLoading.dismiss();
                          Fluttertoast.showToast(
                              msg: "Có lỗi xảy ra, xin vui lòng thử lại.");
                          return;
                        }
                      });
                },
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
            size: 40,
            icon: const Icon(
              Icons.check,
              color: Colors.white,
              size: 24,
            ),
            text: 'Xác nhận đơn',
            textStyle: Styles.textStyle.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget btnStep1() {
    return GFButton(
      color: const Color(0xFFEBF2F8),
      size: 40,
      onPressed: () {
        hoanThanhDonHang();
      },
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
      fullWidthButton: true,
      icon: const Icon(
        Icons.check_circle_outline,
        color: Styles.primaryColor3,
        size: 24,
      ),
      text: 'Hoàn thành đơn hàng',
      textStyle: Styles.headline4Style.copyWith(color: Styles.primaryColor3),
    );
  }

  Widget btnStep2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GFIconButton(
          color: const Color(0xFFEBF2F8),
          onPressed: () {
            hoanThanhDonHang();
          },
          padding: const EdgeInsets.all(0),
          iconSize: 40,
          shape: GFIconButtonShape.square,
          icon: const Icon(
            Icons.check_circle_outline,
            color: Styles.primaryColor3,
            size: 24,
          ),
        ),
        const Gap(10),
        Expanded(
          child: GFButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return DialogAction(
                      title: 'Xác nhận người vận chuyển này?',
                      content:
                          'Người vận chuyển có thể xem đơn hàng và đơn sẽ chuyển sang trạng thái Đang chuyển',
                      text1: 'Xác nhận',
                      text2: 'Bỏ qua',
                      icon: Image.asset('assets/images/Success.png'),
                      onTap2: () => Navigator.pop(context),
                      onTap1: () async {
                        Navigator.pop(context);
                        await EasyLoading.show(
                          status: 'Đang tải xử lý...',
                          maskType: EasyLoadingMaskType.clear,
                        );
                        Map<String, String> body = {
                          "order_id": order?.id ?? '',
                        };

                        final rs = await _netUtil.get(
                            "approve_shipper", body, context);
                        await EasyLoading.dismiss();
                        if (rs == null || rs["success"].toString() != "1") {
                          Fluttertoast.showToast(
                              msg: "Có lỗi xảy ra, xin vui lòng thử lại.");
                          return;
                        }
                        Fluttertoast.showToast(
                            msg: "Xác nhận người vận chuyển thành công.");
                        if (mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                            return const ShopPage(
                              status: 3,
                            );
                          }), ModalRoute.withName('/home'));
                        }
                      });
                },
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/profile/biking.svg',
              color: Colors.white,
              height: 24,
              width: 24,
            ),
            size: 40,
            text: 'Xác nhận xe',
            textStyle: Styles.headline4Style.copyWith(color: Colors.white),
          ),
        ),
        const Gap(10),
        Expanded(
          child: GFButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return DialogAction(
                      title: 'Từ chối người vận chuyển này?',
                      content:
                          'Đơn hàng sẽ trở về trạng thái Đã xác nhận và người khác có thể nhận chuyển',
                      text1: 'Từ chối xe',
                      text2: 'Bỏ qua',
                      icon: Image.asset('assets/images/Failure.png'),
                      colorButton1: const Color(0xFFEB3B5B),
                      onTap2: () => Navigator.pop(context),
                      onTap1: () async {
                        Navigator.pop(context);
                        await EasyLoading.show(
                          status: 'Đang tải xử lý...',
                          maskType: EasyLoadingMaskType.clear,
                        );
                        Map<String, String> body = {
                          "order_id": order?.id ?? '',
                        };

                        final rs =
                            await _netUtil.get("reject_shipper", body, context);
                        await EasyLoading.dismiss();
                        if (rs == null || rs["success"].toString() != "1") {
                          Fluttertoast.showToast(
                              msg: "Có lỗi xảy ra, xin vui lòng thử lại.");
                          return;
                        }
                        Fluttertoast.showToast(
                            msg: "Từ chối người vận chuyển thành công.");
                        if (mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                            return const ShopPage(
                              status: 2,
                            );
                          }), ModalRoute.withName('/home'));
                        }
                      });
                },
              );
            },
            color: const Color(0xFFFCE7EB),
            icon: SvgPicture.asset(
              'assets/icons/profile/biking.svg',
              color: Styles.moneyColor,
              height: 24,
              width: 24,
            ),
            size: 40,
            text: 'Từ chối xe',
            textStyle: Styles.headline4Style.copyWith(color: Styles.moneyColor),
          ),
        ),
      ],
    );
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return DialogQr(
            title: "Đơn #${order?.id}. ${order?.orderName}",
            qrUrl:
                '${Configs.qrUrl}/shop/order_hkd_detail?order_id=${order?.id}',
          );
        });
  }

  void hoanThanhDonHang() {
    showDialog(
        context: context,
        builder: (_) {
          return DialogAction(
            icon: Image.asset('assets/images/icon-complete.png'),
            title: 'Hoàn thành đơn hàng này',
            content:
                'Hãy đảm bảo rằng bạn đã gửi hàng thành công cho người vận chuyển',
            text1: 'Hoàn thành đơn hàng',
            text2: 'Bỏ qua',
            onTap1: () async {
              Navigator.pop(context);
              await EasyLoading.show(
                status: 'Đang tải xử lý...',
                maskType: EasyLoadingMaskType.clear,
              );
              Map<String, String> body = {
                "order_id": order?.id ?? '',
                "status": "5"
              };
              final rs =
                  await _netUtil.get("change_order_status", body, context);
              await EasyLoading.dismiss();
              if (rs == null || rs["success"].toString() != "1") {
                Fluttertoast.showToast(
                    msg: "Có lỗi xảy ra, xin vui lòng thử lại.");
                return;
              }

              Fluttertoast.showToast(msg: "Kết thúc đơn hàng thành công.");
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) {
                      return const ShopPage(
                        status: 5,
                      );
                    },
                  ),
                  ModalRoute.withName('/home'),
                );
              }
            },
            onTap2: () => Navigator.pop(context),
          );
        });
  }

  Future<void> guiTinNhan() async {
    Map<String, String> body = {
      "order_id": order?.id ?? '',
      "content": txtChat.text
    };

    final rs = await _netUtil.get("shop_add_message", body, context);
    FocusManager.instance.primaryFocus?.unfocus();
    if (rs != null && !rs.toString().contains('0')) {
      txtChat.clear();
      await getChat();
      Timer(
          const Duration(milliseconds: 500),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    } else {
      Fluttertoast.showToast(msg: "Có lỗi xảy ra, xin vui lòng thử lại.");
    }
  }

  List<Widget> buildChat() {
    List<Widget> allStates = [];

    allStates.add(Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: dataChat.length,
          itemBuilder: (context, index) {
            bool isSameType = false;
            String? name;
            final chat = dataChat.elementAtOrNull(index);
            final type = int.tryParse(chat?.type ?? '0') ?? 0;
            if (index > 0) {
              final previousChat = dataChat.elementAtOrNull(index - 1);
              isSameType = chat?.type == previousChat?.type;
            }

            if (!isSameType) {
              switch (type) {
                case 2:
                  name = order?.buyerName;
                  break;
                case 3:
                  name = shipper?.name;
                  break;
              }
            }
            return MessageWidgget(
              type: type,
              message: chat?.content ?? '',
              name: name,
            );
          }),
    ));

    allStates.add(SizedBox(
      height: 65,
      child: CustomTextfield(
          textCtrl: txtChat,
          hintText: 'Gửi tin nhắn...',
          lines: 5,
          suffixIcon: InkWell(
            onTap: () {
              guiTinNhan();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset(
                'assets/icons/profile/send-plane.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
          keyboardType: TextInputType.multiline,
          onTap: () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500),
            );
          },
          onSubmitted: () {
            guiTinNhan();
          },
          // focusNode: _focusNodes,
          textInputAction: TextInputAction.done),
    ));
    // allStates.add(SizedBox(height: MediaQuery.of(context).,))
    return allStates;
  }

  buildInfos() {
    List<Widget> widgetInfos = [];

    if (Configs.userGroup == 1) {
      widgetInfos.add(_InfoWidget(
        title: 'người mua',
        name: order?.buyerName ?? '',
        phoneNumber: order?.buyerPhone ?? '',
        location: order?.buyerAddress ?? '',
        icon: SvgPicture.asset(
          'assets/icons/profile/user.svg',
          width: 42,
          height: 42,
          color: Colors.white,
        ),
      ));
    }
    if (shipper != null) {
      widgetInfos.add(_InfoWidget(
        title: 'người vận chuyển',
        name: shipper?.name ?? '',
        phoneNumber: shipper?.phone ?? '',
        location: shipper?.address ?? '',
        icon: SvgPicture.asset(
          'assets/icons/profile/biking.svg',
          width: 42,
          height: 42,
          color: Colors.white,
        ),
      ));
    }
    return ListView(shrinkWrap: true, children: widgetInfos);
  }
}

class _InfoWidget extends StatelessWidget {
  const _InfoWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.name,
    required this.phoneNumber,
    required this.location,
  }) : super(key: key);
  final Widget icon;
  final String title;
  final String name;
  final String phoneNumber;
  final String location;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
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
            width: 55,
            height: 55,
            decoration: const ShapeDecoration(
              color: Color(0xFFB2B2B2),
              shape: OvalBorder(),
            ),
            padding: const EdgeInsets.all(6),
            child: icon,
          ),
          const Gap(12),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: title.toUpperCase(),
                              style: Styles.subtitle1Style.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFBEA500),
                              ),
                            ),
                            TextSpan(
                              text: '\n$name',
                              style: Styles.headline3Style
                                  .copyWith(color: Styles.primaryColor3),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse("tel://$phoneNumber");

                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFEBF2F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        width: 48,
                        height: 48,
                        child: SvgPicture.asset(
                            'assets/icons/profile/bxs-phone.svg'),
                      ),
                    )
                  ],
                ),
                const Gap(2),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/profile/bxs-phone.svg',
                      width: 16,
                      height: 16,
                      color: const Color(0xFFB2B2B2),
                    ),
                    const Gap(4),
                    Expanded(
                      child: Text(
                        phoneNumber,
                        style: Styles.subtitle1Style,
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/profile/bxs-map.svg',
                      width: 16,
                      height: 16,
                      color: const Color(0xFFB2B2B2),
                    ),
                    const Gap(4),
                    Expanded(
                      child: Text(
                        location,
                        style: Styles.subtitle1Style,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
