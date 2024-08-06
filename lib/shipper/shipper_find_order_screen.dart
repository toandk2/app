import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/anmition/fadeanimation.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/bing_maps.dart';
import 'package:hkd/widgets/custom_dialog.dart';
import 'package:hkd/widgets/custom_searchbar.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class ShipperFindOrderPage extends StatefulWidget {
  const ShipperFindOrderPage({
    Key? key,
    required this.addressModel,
  }) : super(key: key);
  final AddressModel? addressModel;
  @override
  State<ShipperFindOrderPage> createState() => _ShipperFindOrderPageState();
}

class _ShipperFindOrderPageState extends State<ShipperFindOrderPage>
    with TickerProviderStateMixin {
  List<ShiperOrder> orders = [];

  final NetworkUtil _netUtil = NetworkUtil();
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;
  int _statusShiperOrderList = 0;
  Status? status;
  AddressModel? addressModel;
  // String txtStatus = "Đang tải dữ liệu";
  @override
  void initState() {
    // switch (Configs.userGroup) {
    //   case 0:
    //   Configs.listShipperStatus[0].name = "Có thể nhận";
    //   break;
    // default:
    // }

    status = Configs.listShipperStatus[0];

    super.initState();

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
    addressModel = widget.addressModel;
    getOders();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getOders() async {
    // txtStatus = "Đang tải dữ liệu";
    _statusShiperOrderList = 0;
    setState(() {});
    Map<String, String> body = {
      "token": Configs.login?.token ?? '',
      "status": (status?.status ?? 0).toString(),
    };

    final result = await _netUtil.get(_getUrlShiperOrder(), body, context);
    if (result == null || result['success'] == 0) {
      // txtStatus = "Không tìm thấy đơn hàng";
      orders = [];
      _statusShiperOrderList = 3;
      setState(() {});
      return;
    }

    orders = (result['orders'])
        .map<ShiperOrder>((item) => ShiperOrder.fromJson(item))
        .toList();
    if (orders.isEmpty) {
      // txtStatus = "Không tìm thấy đơn hàng";
      orders = [];
      _statusShiperOrderList = 3;
      setState(() {});
      return;
    }
    _statusShiperOrderList = 2;
    // txtStatus = "Đã tìm thấy ${orders.length} đơn hàng";
    setState(() {});
  }

  String _getUrlShiperOrder() {
    String url;
    // switch (Configs.userGroup) {
    //   case 1:
    //     url = 'get_orders';
    //     break;
    //   case 2:
    if (status?.status == 0) {
      url = "shipper_open_orders";
    } else if (status?.status == 4) {
      url = "shipper_completed_orders";
    } else {
      url = "shipper_orders";
    }
    //     break;
    //   default:
    //     url = 'buyer_orders';
    //     break;
    // }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: Styles.background,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Danh sách đơn chờ vận chuyển',
                style: Styles.headline1Style,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const FadeAnimation(
              delay: 1,
              child: Text(
                'Địa điểm của bạn',
                style: Styles.textStyle,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            LocationSearchbar(
              initValue:
                  '${addressModel?.tinh ?? ''}, ${addressModel?.huyen ?? ''}, ${addressModel?.xa ?? ''}',
              getInitPosition: false,
              onSelected: (model) {
                addressModel = model;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              flex: 1,
              child: CustomBingMap(
                markers: const [],
                position: LatLng(double.parse(addressModel?.lat ?? '21'),
                    double.parse(addressModel?.lon ?? '105.85')),
              ),
            ),
            const Gap(10),
            if (_statusShiperOrderList == 0)
              Expanded(
                  flex: 2,
                  child: Lottie.asset(
                    "assets/images/loading.json",
                    repeat: true,
                    reverse: true,
                    animate: true,
                  )),
            if (_statusShiperOrderList == 2)
              Expanded(flex: 2, child: _getList(context)),
            if (_statusShiperOrderList == 3)
              Expanded(
                  flex: 2,
                  child: Lottie.asset(
                    "assets/images/nodata.json",
                    repeat: true,
                    reverse: true,
                    animate: true,
                  ))
          ],
        ),
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

  // void _scrollToTop() {
  //   _scrollController.animateTo(0,
  //       duration: const Duration(seconds: 1), curve: Curves.linearToEaseOut);
  // }

  Future<void> _onRefresh() async {
    await getOders();
  }

  Widget _getList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        itemCount: orders.length,
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var donHang = orders[index];
          DateTime ngayDonHang = DateTime.parse(donHang.time ?? '');
          return FadeAnimation(
              delay: 1,
              child: Container(
                  alignment: AlignmentDirectional.center,
                  // width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
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
        },
        separatorBuilder: (context, _) {
          return const Gap(10);
        },
      ),
    );
  }

  Widget _status1Widget(
      ShiperOrder donHang, DateTime ngayDonHang, BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Expanded(
            child: Text(
              // '${index + 1}. #${donHang.id} ${donHang.orderName.toUpperCase()} - ${DateFormat('dd/MM/yyyy').format(ngayDonHang)}',
              'Đơn ${donHang.orderId ?? ''}:  ${donHang.orderName ?? ''.toUpperCase()} - ${DateFormat('dd/MM/yyyy HH:mm:ss').format(ngayDonHang)}',
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/profile/bxs-map.svg',
                color: Styles.moneyColor,
              ),
              const Gap(4),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Chuyển từ:\n',
                        style: Styles.textStyle,
                      ),
                      TextSpan(
                        text: donHang.shopAddress ?? '',
                        style:
                            Styles.textStyle.copyWith(color: Styles.textColor),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          const Gap(6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SvgPicture.asset(
                  'assets/icons/profile/bxs-right-arrow-circle.svg'),
              const Gap(4),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Chuyển đến:\n',
                        style: Styles.textStyle,
                      ),
                      TextSpan(
                        text: donHang.buyerAddress ?? '',
                        style:
                            Styles.textStyle.copyWith(color: Styles.textColor),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          const Gap(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // InkWell(
              //   onTap: () async {
              //     // final url = Uri.tryParse(
              //     //     "tel://${donHang.buyerPhone}");

              //     // if (await canLaunchUrl(url)) {
              //     //   await launchUrl(url);
              //     // } else {
              //     //   throw 'Could not launch $url';
              //     // }
              //     _showMaterialDialog(context, donHang);
              //   },
              //   child: Container(
              //       width: 48,
              //       height: 36,
              //       padding: const EdgeInsets.all(6),
              //       decoration: ShapeDecoration(
              //         color: const Color(0xFFEBF2F8),
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(6)),
              //       ),
              //       child: SvgPicture.asset(
              //         'assets/icons/profile/bx-phone.svg',
              //         width: 24,
              //         height: 24,
              //       )),
              // ),
              // const Gap(6),
              // InkWell(
              //   onTap: () async {

              //     final url = Uri.parse("tel://${donHang.shopPhone}");

              //     if (await canLaunchUrl(url)) {
              //       await launchUrl(url);
              //     } else {
              //       Fluttertoast.showToast(msg: 'Could not launch $url');
              //     }
              //   },
              //   child: Container(
              //       width: 48,
              //       height: 36,
              //       padding: const EdgeInsets.all(6),
              //       decoration: ShapeDecoration(
              //         color: const Color(0xFFEBF2F8),
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(6)),
              //       ),
              //       child: SvgPicture.asset(
              //         'assets/icons/profile/bxs-phone.svg',
              //         width: 24,
              //         height: 24,
              //       )),
              // ),
              Expanded(
                child: GFButton(
                  onPressed: () async {
                    final url = Uri.parse("tel://${donHang.shopPhone}");

                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      Fluttertoast.showToast(msg: 'Could not launch $url');
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
              const Gap(6),
              Expanded(
                child: GFButton(
                  onPressed: () {
                    if (Configs.user == null || Configs.userGroup != 3) {
                      Fluttertoast.showToast(
                          msg:
                              "Bạn cần đăng nhập vào tài khoản người vận chuyển để tiếp tục");
                      return;
                    }
                    showDialog(
                        context: context,
                        builder: (_) {
                          return DialogAction(
                            title: 'Nhận chuyển đơn hàng này',
                            content:
                                'Người bán sẽ nhận được yêu cầu vận chuyển của bạn',
                            text1: 'Nhận chuyển',
                            text2: 'Bỏ qua',
                            // icon: Image.asset('assets/images/shipper-2.png'),
                            contentWidget: Container(),
                            onTap2: () => Navigator.pop(context),
                            onTap1: () async {
                              Navigator.pop(context);
                              await EasyLoading.show(
                                status: 'Đang tải xử lý...',
                                maskType: EasyLoadingMaskType.clear,
                              );
                              Map<String, String> body = {
                                "token": Configs.login?.token ?? '',
                                "order_id": donHang.orderId ?? '',
                              };

                              final rs = await _netUtil.get(
                                  "shipper_ship_order", body, context);

                              await EasyLoading.dismiss();
                              if (rs == null ||
                                  rs["success"].toString() != "1") {
                                Fluttertoast.showToast(
                                    msg:
                                        "Có lỗi xảy ra, xin vui lòng thử lại.");
                                return;
                              }
                              Fluttertoast.showToast(
                                  msg:
                                      "Yêu cầu vận chuyển đã gửi cho chủ cửa hàng.");
                              getOders();
                            },
                          );
                        });
                  },
                  borderShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  size: 40,
                  color: Styles.primaryColor3,
                  type: GFButtonType.solid,
                  text: 'Nhận chuyển',
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
      const Divider(
        thickness: 1,
        color: Color(0xFFEAEAEA),
        height: 16,
      ),
      Column(
        children: [
          Row(
            children: [
              const Text('Giá trị: ', style: Styles.subtitle1Style),
              const SizedBox(
                height: 5,
              ),
              Text('${Configs.formatter.format(donHang.amount)}đ',
                  style: Styles.headline5Style),
              const Spacer(),
              const Text('Phí giao hàng: ', style: Styles.subtitle1Style),
              const SizedBox(
                height: 5,
              ),
              Text('${Configs.formatter.format(donHang.shippingCost)}đ',
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
}
