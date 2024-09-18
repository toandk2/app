import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/anmition/fadeanimation.dart';
import 'package:hkd/buyer/buyer_profile_screen.dart';
import 'package:hkd/order_detail/buyer_order_detail_screen.dart';
import 'package:hkd/shop/shop_profile_screen.dart';
import 'package:hkd/order_detail/shop_order_detail_screen.dart';
import 'package:hkd/trade/shop_detail_screen.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/custom_dialog.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key, this.status}) : super(key: key);
  final int? status;
  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  List<Order> orders = [];

  final NetworkUtil _netUtil = NetworkUtil();
  final NumberFormat formatter = NumberFormat("#,###");
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;
  int _statusOrderList = 0;
  Status? status;
  List<Status?> listStatus = [];
  late final TabController _tabController;
  // String txtStatus = "Đang tải dữ liệu";
  @override
  void initState() {
    if (Configs.userGroup == 0) {
      listStatus = Configs.listBuyerStatus;
    }
    if (Configs.userGroup == 1) {
      listStatus = Configs.listShopStatus;
    }
    if (widget.status != null) {
      status =
          listStatus.firstWhere((element) => element?.status == widget.status);
    } else {
      status = listStatus[0];
    }
    _tabController = TabController(
        initialIndex: listStatus.indexOf(status),
        length: listStatus.length,
        vsync: this);
    super.initState();
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        status = listStatus[_tabController.index];
        getOders();
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.offset >= 100) {
        if (!_showBackToTopButton) {
          setState(() {
            _showBackToTopButton = true;
          });
        }
      } else {
        if (_showBackToTopButton) {
          setState(() {
            _showBackToTopButton = false;
          });
        }
      }
    });
    getOders();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getOders() async {
    // txtStatus = "Đang tải dữ liệu";
    orders = [];
    _statusOrderList = 0;
    setState(() {});
    orders.addAll(await _getOrders(status?.status ?? 0));
    if (status?.status == -2) {
      orders.addAll(await _getOrders(-3));
    }
    if (status?.status == -3) {
      orders.addAll(await _getOrders(-2));
    }
    if (status?.status == 2) {
      orders.addAll(await _getOrders(10));
    }

    // if (status?.status == 3) {
    //   orders.addAll(await _getOrders(4));
    // }
    if (orders.isEmpty) {
      // txtStatus = "Không tìm thấy đơn hàng";
      _statusOrderList = 3;
      setState(() {});
      return;
    }
    _statusOrderList = 2;
    // txtStatus = "Đã tìm thấy ${orders.length} đơn hàng";
    setState(() {});
  }

  Future<List<Order>> _getOrders(int status) async {
    List<Order> localOrders = [];
    Map<String, String> body = {
      "status": status.toString(),
    };

    final result = await _netUtil.get(_getUrlOrder(), body, context);
    if (result == null) {
      return [];
    }
    if (Configs.userGroup == 1) {
      localOrders = result.map<Order>((item) => Order.fromJson(item)).toList();
    } else {
      final orderJson = result['orders'];
      if (orderJson == null) {
        return [];
      }
      //   // txtStatus = "Không tìm thấy đơn hàng";
      //   orders = [];
      //   _statusOrderList = 3;
      //   setState(() {});
      //   return;
      // }
      localOrders =
          orderJson.map<Order>((item) => Order.fromJson(item)).toList();
    }
    return localOrders;
  }

  String _getUrlOrder() {
    String url;
    switch (Configs.userGroup) {
      case 1:
        url = 'get_orders';
        break;
      // case 2:
      //   if (_statusOrderList == 0) {
      //     url = "shipper_open_orders";
      //   } else if (_statusOrderList == 3) {
      //     url = "shipper_completed_orders";
      //   } else {
      //     url = "shipper_orders";
      //   }
      //   break;
      default:
        url = 'buyer_orders';
        break;
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: Styles.background,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: InkWell(
                            onTap: () async {
                              final url = Uri.parse(
                                  Configs.mainPageUrl[Configs.userGroup]);

                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Could not launch $url');
                              }
                            },
                            child: Image.network(
                              Configs.BASE_URL
                                      .replaceAll('/api', '/images/avatars') +
                                  (Configs.user?.linkImg ?? ''),
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/logo.png');
                              },
                            )),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Configs.user?.name ?? 'Test',
                              style: Styles.headline2Style
                                  .copyWith(color: Styles.black50),
                            ),
                            const Gap(8),
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/phone.svg'),
                                const Gap(4),
                                Text(
                                  Configs.user?.phone ?? '',
                                  style: Styles.textStyle,
                                ),
                              ],
                            ),
                            const Gap(8),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/icons/profile/bxs-map.svg'),
                                const Gap(4),
                                Expanded(
                                  child: Text(
                                    Configs.user?.address ?? '',
                                    style: Styles.textStyle,
                                  ),
                                ),
                              ],
                            ),

                            const Gap(8),
                            if (Configs.userGroup == 1)
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ShopDetailScreen(
                                        shopId: Configs.login?.shopId ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/bx-store.svg',
                                      color: Colors.blue,
                                      width: 16,
                                      height: 16,
                                    ),
                                    const Gap(4),
                                    Text(
                                      'dothithongminh1.vn/${Configs.login?.shopId}',
                                      style: Styles.textStyle.copyWith(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            //  Text(
                            //   Configs.login,
                            //   style: Styles.headline2Style
                            //       .copyWith(color: Styles.black50),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GFButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            switch (Configs.userGroup) {
                              case 0:
                                return const BuyerProfileScreen();
                              default:
                                return const ShopProfileScreen();
                            }
                          },
                        ),
                      );
                    },
                    size: 46,
                    text: 'Sửa thông tin',
                    icon: SvgPicture.asset(
                        'assets/icons/profile/bxs-edit-alt.svg'),
                    color: const Color(0xFFEBF2F8),
                    textStyle: Styles.headline4Style
                        .copyWith(color: Styles.primaryColor3),
                    fullWidthButton: true,
                    borderShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                const Gap(10),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.all(0),
                  indicatorColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  tabs: List.generate(
                    listStatus.length,
                    (index) {
                      final status = listStatus[index];
                      if (status == null) return const SizedBox();
                      return Container(
                        padding: const EdgeInsets.all(16),
                        height: 56,
                        decoration: BoxDecoration(
                          color: _tabController.index == index
                              ? const Color(0xFFF7F7F7)
                              : Colors.white,
                          borderRadius: _tabController.index == index
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                )
                              : null,
                          border: Border(
                            // left: BorderSide(color: Color(0xFF3CBA64)),
                            // top: BorderSide(color: Color(0xFF3CBA64)),
                            // right: BorderSide(color: Color(0xFF3CBA64)),
                            bottom: _tabController.index == index
                                ? BorderSide.none
                                : BorderSide(width: 4, color: status.color),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              status.icon,
                              color: _tabController.index == index
                                  ? const Color(0xFFB2B2B2)
                                  : null,
                              // color: null,
                            ),
                            const SizedBox(width: 8),
                            Text(status.name,
                                style: Styles.headline4Style.copyWith(
                                    color: _tabController.index == index
                                        ? const Color(0xFFB2B2B2)
                                        : status.textColor))
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          if (_statusOrderList == 0)
            Expanded(
                child: Lottie.asset(
              "assets/images/loading.json",
              repeat: true,
              reverse: true,
              animate: true,
            )),
          if (_statusOrderList == 2) Expanded(child: _getList(context)),
          if (_statusOrderList == 3)
            Expanded(
                child: Lottie.asset(
              "assets/images/nodata.json",
              repeat: true,
              reverse: true,
              animate: true,
            ))
        ],
      ),
      // floatingActionButton: _showBackToTopButton
      //     ? FloatingActionButton(
      //         onPressed: _scrollToTop,
      //         backgroundColor: Styles.primaryColor,
      //         child: const Icon(
      //           FluentSystemIcons.ic_fluent_arrow_up_circle_filled,
      //           color: Colors.white,
      //           size: 30,
      //         ),
      //       )
      //     : null,
    );
  }

  Future<void> _onRefresh() async {
    await getOders();
  }

  Widget _getList(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            itemCount: orders.length,
            controller: _scrollController,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var donHang = orders[index];
              DateTime ngayDonHang = DateTime.parse(donHang.time ?? '');
              return FadeAnimation(
                  delay: 1,
                  child: Container(
                      alignment: AlignmentDirectional.center,
                      // width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 7),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 1,
                                spreadRadius: 1)
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: _status1Widget(donHang, ngayDonHang, context)));
            }));
  }

  Widget _status1Widget(
      Order donHang, DateTime ngayDonHang, BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Expanded(
            child: Text(
              // '${index + 1}. #${donHang.id} ${donHang.orderName.toUpperCase()} - ${DateFormat('dd/MM/yyyy').format(ngayDonHang)}',
              'Đơn ${donHang.id ?? ''}:  ${donHang.orderName ?? ''.toUpperCase()} - ${DateFormat('dd/MM/yyyy HH:mm:ss').format(ngayDonHang)}',
              textAlign: TextAlign.justify,
              overflow: TextOverflow.clip,
              maxLines: 2,
              softWrap: true,
              style:
                  Styles.headline4Style.copyWith(color: Styles.primaryColor3),
            ),
          ),
        ],
      ),
      const Gap(8),
      Column(
        children: <Widget>[
          if (Configs.userGroup == 0)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => ShopDetailScreen(
                      shopId: donHang.shopId ?? '',
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/profile/location-pin.svg',
                    color: Styles.moneyColor,
                  ),
                  const Gap(4),
                  Expanded(
                      child: Text(
                    donHang.shopName ?? '',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    softWrap: true,
                    style: Styles.textStyle.copyWith(color: Styles.moneyColor),
                  ))
                ],
              ),
            ),
          const Gap(4),
          Row(
            children: [
              SvgPicture.asset('assets/icons/profile/user.svg'),
              const Gap(4),
              Expanded(
                  child: Text(
                donHang.buyerName?.capitalize() ?? '',
                textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
                maxLines: 2,
                softWrap: true,
                style: Styles.textStyle.copyWith(color: Styles.primaryColor3),
              ))
            ],
          ),
          const Gap(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SvgPicture.asset('assets/icons/profile/bxs-map.svg'),
              const Gap(4),
              Expanded(
                child: Text(
                  donHang.buyerAddress ?? '',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                  style: Styles.textStyle,
                ),
              ),
            ],
          ),
          const Gap(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  // final url = Uri.tryParse(
                  //     "tel://${donHang.buyerPhone}");

                  // if (await canLaunchUrl(url)) {
                  //   await launchUrl(url);
                  // } else {
                  //   throw 'Could not launch $url';
                  // }
                  _showMaterialDialog(context, donHang);
                },
                child: Container(
                    width: 48,
                    height: 36,
                    padding: const EdgeInsets.all(6),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEBF2F8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/profile/bx-qr.svg',
                      width: 24,
                      height: 24,
                    )),
              ),
              const Gap(6),
              InkWell(
                onTap: () async {
                  final url = Uri.parse("tel://${donHang.buyerPhone}");

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    Fluttertoast.showToast(msg: 'Could not launch $url');
                  }
                },
                child: Container(
                    width: 48,
                    height: 36,
                    padding: const EdgeInsets.all(6),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEBF2F8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/profile/bxs-phone.svg',
                      width: 24,
                      height: 24,
                    )),
              ),
              const Gap(6),
              Expanded(
                child: GFButton(
                  onPressed: () {
                    Configs.orderId = donHang.id.toString();

                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) {
                        if (Configs.userGroup == 0) {
                          return const BuyerOrderDetailScreen();
                        } else {
                          return const ShopOrderDetailScreen();
                        }
                      }),
                    ).then((_) {
                      getOders();
                    });
                  },
                  borderShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  size: 36,
                  color: Styles.primaryColor3,
                  type: GFButtonType.solid,
                  text: 'Xem chi tiết',
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(
        height: 8,
      ),
      Column(
        children: [
          Row(
            children: [
              const Text('Giá trị: ', style: Styles.subtitle1Style),
              const SizedBox(
                height: 5,
              ),
              Text('${formatter.format(donHang.amount)}đ',
                  style: Styles.headline5Style),
              const Spacer(),
              const Text('Phí giao hàng: ', style: Styles.subtitle1Style),
              const SizedBox(
                height: 5,
              ),
              Text('${formatter.format(donHang.shippingCost)}đ',
                  style: Styles.headline5Style),
              const Spacer(),
            ],
          ),
          const Gap(6),
          Container(
            alignment: Alignment.center,
            child: Row(
              children: [
                const Text('Giờ nhận hàng: ', style: Styles.subtitle1Style),
                const SizedBox(
                  height: 5,
                ),
                Text(
                    '${donHang.shippingTimeSlot == null ? "" : '${donHang.shippingTimeSlot}, '}${donHang.shippingTimeSlotFrom}h - ${donHang.shippingTimeSlotTo}h',
                    style: Styles.headline5Style
                        .copyWith(color: Styles.moneyColor))
              ],
            ),
          )
        ],
      ),
    ]);
  }

  void _showMaterialDialog(BuildContext context, Order order) {
    showDialog(
        context: context,
        builder: (_) {
          return DialogQr(
            title: "Đơn #${order.id}. ${order.orderName}",
            qrUrl:
                '${Configs.qrUrl}/shop/order_hkd_detail?order_id=${order.id}',
          );
        });
  }
}
