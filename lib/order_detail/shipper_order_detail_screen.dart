import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/shipper/shipper_home_page.dart';
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

class ShipperOrderDetailScreen extends StatefulWidget {
  const ShipperOrderDetailScreen({
    Key? key,
    // required this.status,
  }) : super(key: key);
  // final Status status;

  @override
  State<ShipperOrderDetailScreen> createState() =>
      _ShipperOrderDetailScreenState();
}

class _ShipperOrderDetailScreenState extends State<ShipperOrderDetailScreen>
    with TickerProviderStateMixin {
  final tabTitles = ['DS sản phẩm', 'TT liên hệ', 'Chat'];
  final NumberFormat formatter = NumberFormat("#,###");
  final NetworkUtil _netUtil = NetworkUtil();
  ShipperDetail? shipper;
  final ScrollController _scrollController = ScrollController();
  List<OrderDetail> orderDetail = [];
  ShiperOrderDetail? order;
  int soLuongSanPham = 0;
  int _status = 0;
  final FocusNode _focusNodes = FocusNode();
  TextEditingController txtChat = TextEditingController();
  List<BuyerMessages> dataChat = [];
  late final TabController _tabController;
  Position? _currentPosition;
  int tabIndex = 0;
  Status? status;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
    getOrderDetail();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNodes.dispose();
    txtChat.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getChat() async {
    Map<String, String> body = {
      "token": Configs.login?.token ?? '',
      "order_id": Configs.orderId ?? '',
    };
    final rs = await _netUtil.get("ship_messages", body, context);
    if (rs != null) {
      dataChat = (rs)
          .map<BuyerMessages>((item) => BuyerMessages.fromJson(item))
          .toList();
    }
    setState(() {});
  }

  Future<void> getOrderDetail() async {
    Map<String, String> body = {
      "token": Configs.login?.token ?? '',
      "order_id": Configs.orderId ?? '',
    };
    orderDetail = [];
    final rs = await _netUtil.get("shipper_order_detail", body, context);
    if (rs != null) {
      if (rs['order'] != null) {
        order = ShiperOrderDetail.fromJson(rs['order']);
      }
      status = Configs.listShipperStatus
          .firstWhereOrNull((element) => element.status == order?.status);

      orderDetail = OrderDetail.fromListJson(rs['items'] ?? []);
      soLuongSanPham = orderDetail.length;

      _status = 2;
    } else {
      _status = 3;
    }
    setState(() {});
    getChat();
    if (order?.status == 3 && mounted) {
      _currentPosition = await getCurrentLocation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: _status == 0
          ? Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/images/loading.json",
                    repeat: true,
                    reverse: true,
                    animate: true,
                  ),
                  const Text("Đang tải dữ liệu..")
                ],
              ),
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
                                        color: status?.color,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                      child: Text(
                                          status?.status == 3
                                              ? 'Đang chuyển'
                                              : status?.status == 4
                                                  ? "Đã vận chuyển"
                                                  : 'Hoàn thành',
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
                                        // width: 24,
                                        // height: 24,
                                      ),
                                      const Gap(6),
                                      Text(
                                        'Ghi chú đơn',
                                        // style: TextStyle(
                                        //   color: Color(0xFFD89F2E),
                                        //   fontSize: 14,
                                        //   fontFamily: 'Roboto Flex',
                                        //   fontWeight: FontWeight.w400,
                                        //   height: 0.11,
                                        // ),
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
      // case 0:
      //   return btnStep0();
      // case 1:
      //   return btnStep1();
      // case 2:
      //   return btnStep2();
      case 3:
        return btnStep2();
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

  Widget btnStep2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GFButton(
          color: const Color(0xFFEBF2F8),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return DialogAction(
                    icon: Image.asset('assets/images/Failure.png'),
                    title: 'Huỷ vận chuyển đơn hàng này?',
                    content:
                        'Đơn hàng sẽ trở về trạng thái Đã xác nhận và người khác có thể nhận chuyển',
                    text1: 'Huỷ vận chuyển',
                    text2: 'Bỏ qua',
                    onTap1: () async {
                      Navigator.pop(context);
                      await EasyLoading.show(
                        status: 'Đang tải xử lý...',
                        maskType: EasyLoadingMaskType.clear,
                      );
                      Map<String, String> body = {
                        "token": Configs.login?.token ?? '',
                        "order_id": order?.id ?? '',
                      };
                      if (mounted) {
                        final rs = await _netUtil.get(
                            "shipper_reject_order", body, context);
                        await EasyLoading.dismiss();
                        if (rs != null && rs["success"].toString() == "1") {
                          Fluttertoast.showToast(
                              msg: "Huỷ vận chuyển thành công.");
                          if (mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                              return const ShipperPage();
                            }), (Route<dynamic> route) => false);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Có lỗi xảy ra, xin vui lòng thử lại.");
                        }
                      }

                      // setState(() {});
                    },
                    onTap2: () => Navigator.pop(context),
                  );
                });
          },
          // padding: const EdgeInsets.all(0),
          size: 40,
          text: 'Huỷ vận chuyển',
          textStyle: Styles.headline4Style.copyWith(color: Styles.moneyColor),
        ),
        const Gap(10),
        Expanded(
          child: GFButton(
            onPressed: hoanThanhDonHang,
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 24,
            ),
            size: 40,
            text: 'Hoàn thành chuyển',
            textStyle: Styles.headline4Style.copyWith(color: Colors.white),
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
            title: 'Hoàn thành vận chuyển đơn này?',
            content: 'Hãy đảm bảo rằng bạn đã gửi hàng đến nơi cho người mua',
            text1: 'Xác nhận',
            text2: 'Bỏ qua',
            icon: Image.asset('assets/images/icon-complete.png'),
            onTap2: () => Navigator.pop(context),
            onTap1: () async {
              Navigator.pop(context);
              await EasyLoading.show(
                status: 'Đang tải xử lý...',
                maskType: EasyLoadingMaskType.clear,
              );
              if (mounted) {
                _currentPosition ??= await getCurrentLocation(context);
                Map<String, String> body1 = {
                  "token": Configs.login?.token ?? '',
                  "lat": _currentPosition?.latitude.toString() ?? '',
                  "lon": _currentPosition?.longitude.toString() ?? '',
                };
                if (mounted) {
                  await _netUtil.get("shipper_update_gps", body1, context);
                }
                Map<String, String> body = {
                  "token": Configs.login?.token ?? '',
                  "order_id": order?.id ?? ''
                };
                if (mounted) {
                  final rs = await _netUtil.get("ship_complete", body, context);
                  await EasyLoading.dismiss();
                  if (rs == null || rs["success"].toString() != "1") {
                    Fluttertoast.showToast(
                        msg: "Có lỗi xảy ra, xin vui lòng thử lại.");
                    return;
                  }
                  Fluttertoast.showToast(msg: "Xác nhận đơn hàng thành công.");
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return const ShipperPage(
                        status: 3,
                      );
                    }), (Route<dynamic> route) => false);
                  }
                }
              }
            },
          );
        });
  }

  void guiTinNhan() {
    Map<String, String> body = {
      "token": Configs.login?.token ?? '',
      "order_id": order?.id ?? '',
      "content": txtChat.text
    };

    _netUtil.get("ship_add_message", body, context).then((rs) {
      if (rs != null) {
        if (!rs.toString().contains('0')) {
          txtChat.clear();
          getChat().then((value) {
            if (_focusNodes.hasFocus) _focusNodes.unfocus();
            Timer(
                const Duration(milliseconds: 500),
                () => _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent));
          });
        } else {
          Fluttertoast.showToast(msg: "Có lỗi xảy ra, xin vui lòng thử lại.");
        }
      }
    });
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
                case 1:
                  name = order?.shopName;
                  break;
                case 2:
                  name = order?.buyerName;
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
    widgetInfos.add(_InfoWidget(
      title: 'người bán',
      name: order?.shopName ?? '',
      phoneNumber: order?.shopPhone ?? '',
      location: order?.shopAddress ?? '',
      icon: SvgPicture.asset(
        'assets/icons/profile/bxs-map.svg',
        width: 42,
        height: 42,
        color: Colors.white,
      ),
    ));

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
