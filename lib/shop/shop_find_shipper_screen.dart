import 'dart:convert';

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
import 'package:hkd/widgets/custom_searchbar.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopFindShipperScreen extends StatefulWidget {
  const ShopFindShipperScreen({super.key});
  @override
  State<ShopFindShipperScreen> createState() => _ShopFindShipperScreenState();
}

class _ShopFindShipperScreenState extends State<ShopFindShipperScreen> {
  final _networkUtil = NetworkUtil();
  final markers = <LatLng>[];
  AddressModel? addressModel;
  bool _firstLoad = true;
  List<Xeoms> xeoms = [];
  // LatLng latLng = LatLng(double.parse(Configs.user?.lat ?? '21'),
  //     double.parse(Configs.user?.lon ?? '105.85'));

  _getListShipper() async {
    final data = {
      "lat": addressModel?.lat ?? '',
      "lon": addressModel?.lon ?? '',
      "shop_id": Configs.login?.shopId ?? '',
    };
    final result = await _networkUtil.post("list_xeom", data, context);
    if (result != null) {
      final findShipper = FindShipper.fromJson(result);
      xeoms = findShipper.xeoms ?? [];
      for (var i = 0; i < xeoms.length; i++) {
        final shop = xeoms[i];
        markers.add(
          LatLng(
            double.parse(shop.lat ?? '0'),
            double.parse(shop.lon ?? '0'),
          ),
        );
      }
    }
    xeoms.sort((a, b) => double.parse(a.distance ?? '0')
        .compareTo(double.parse(b.distance ?? '0')));
    _firstLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // _getListShipper();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Gap(12),
          const Text(
            'Tìm người vận chuyển gần bạn',
            style: Styles.headline1Style,
          ),
          const Gap(24),
          LocationSearchbar(
            onSelected: (model) {
              addressModel = model;
              _getListShipper();
            },
          ),
          const Gap(
            12,
          ),
          Expanded(
              flex: 1,
              child: CustomBingMap(
                  // key: Key(choosedShopIndex.toString()),
                  marker: Image.asset('assets/images/location-pin.png'),
                  pickedMarker:
                      Image.asset('assets/images/location-pin-picked.png'),
                  position: LatLng(double.parse(addressModel?.lat ?? '21'),
                      double.parse(addressModel?.lon ?? '105.85')),
                  markers: markers)),
          const Gap(
            12,
          ),
          if (_firstLoad)
            Expanded(
                flex: 2,
                child: Lottie.asset(
                  "assets/images/loading.json",
                  repeat: true,
                  reverse: true,
                  animate: true,
                )),
          if (!_firstLoad && xeoms.isEmpty)
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  SizedBox.square(
                      dimension: 120,
                      child: Image.asset('assets/images/directions-bike.png')),
                  const SizedBox(
                    width: 240,
                    child: Text('Hiện không có người vận chuyển nào gần bạn',
                        textAlign: TextAlign.center, style: Styles.hintStyle),
                  ),
                ],
              ),
            ),
          if (!_firstLoad && xeoms.isNotEmpty)
            Expanded(
              flex: 2,
              child: FadeAnimation(
                delay: 1,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: xeoms.length,
                  itemBuilder: (context, index) {
                    final model = xeoms[index];
                    final distance = double.parse(model.distance ?? '0');
                    String distanceStr = '${distance.toStringAsFixed(1)}m';
                    if (distance > 100) {
                      distanceStr = '${(distance / 1000).toStringAsFixed(1)}km';
                    }
                    return _ShipperWidget(
                      model: model,
                      showSendOrder: () => showDialogShipper(model.id ?? ''),
                      distance: distanceStr,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Gap(
                      12,
                    );
                  },
                ),
              ),
            ),
          const Gap(
            12,
          ),
        ],
      ),
    ));
  }

  showDialogShipper(String xeomId) {
    showDialog(
        context: context,
        builder: (_) {
          return _DialogSendShipper(
            xeomId: xeomId,
          );
        });
  }
}

class _ShipperWidget extends StatelessWidget {
  const _ShipperWidget(
      {required this.model,
      required this.showSendOrder,
      required this.distance});
// 'assets/icons/profile/biking.svg'
  final Xeoms model;
  final Function showSendOrder;
  final String distance;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 55,
                height: 55,
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.all(6),
                decoration: ShapeDecoration(
                  color: const Color(0xFFB2B2B2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Image.network(
                  Configs.BASE_URL.replaceAll('/api', '') +
                      (model.linkImg ?? ''),
                  errorBuilder: (context, error, stackTrace) {
                    return SvgPicture.asset(
                      'assets/icons/profile/biking.svg',
                      color: Colors.white,
                    );
                  },
                ),
              ),
              const Gap(
                12,
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: model.name,
                    style: Styles.headline4Style
                        .copyWith(color: Styles.primaryColor3),
                    children: [
                      const TextSpan(
                          text: '\n\nĐã nhận chuyển: ',
                          style: Styles.subtitle1Style),
                      TextSpan(
                          text: '${model.countOrder ?? 0} chuyến',
                          style: Styles.subtitle1Style.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF303030))),
                      const TextSpan(
                        text: '\nBiển số xe: ',
                        style: Styles.subtitle1Style,
                      ),
                      TextSpan(
                          text: model.plate,
                          style: Styles.subtitle1Style.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF303030))),
                    ],
                  ),
                ),
              ),
              Text(
                'cách $distance',
                style: Styles.subtitle1Style.copyWith(
                  color: const Color(0xFFBEA500),
                ),
              ),
            ],
          ),
          const Gap(
            8,
          ),
          Row(
            children: [
              GFIconButton(
                onPressed: () async {
                  final url = Uri.parse("tel://${model.phone}");

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    Fluttertoast.showToast(msg: 'Could not launch $url');
                  }
                },
                size: 40,
                iconSize: 24,
                padding: const EdgeInsets.all(8),
                color: const Color(0xFFEBF2F8),
                borderShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                icon: SvgPicture.asset(
                  'assets/icons/profile/bxs-phone.svg',
                  // width: 24,
                  // height: 24,
                ),
              ),
              const Gap(6),
              Expanded(
                child: GFButton(
                  onPressed: () {
                    showSendOrder();
                  },
                  borderShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  size: 40,
                  color: Styles.primaryColor3,
                  type: GFButtonType.solid,
                  text: 'Gọi vận chuyển',
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _DialogSendShipper extends StatefulWidget {
  const _DialogSendShipper({required this.xeomId});
  final String xeomId;
  @override
  State<_DialogSendShipper> createState() => __DialogSendShipperState();
}

class __DialogSendShipperState extends State<_DialogSendShipper>
    with TickerProviderStateMixin {
  final textBottomButton = [
    'Gửi cho người vận chuyển',
    'Xác nhận và gửi cho người vận chuyển',
  ];
  final List<Status?> listStatus = [
    const Status(
        status: 1,
        name: "Đã xác nhận",
        textColor: Color(0xFF0053AE),
        color: Color(0xFF007AFF),
        icon: 'assets/icons/profile/check.svg'),
    const Status(
        status: 0,
        name: "Đơn mới",
        textColor: Color(0xFFAE832E),
        color: Color(0xFFFFC043),
        icon: 'assets/icons/profile/file.svg'),
  ];
  List<Order> orders = [];
  Order? pickedOrders;
  final ScrollController _scrollController = ScrollController();
  int _statusOrderList = 0;
  Status? status;
  late final TabController _tabController;
  final NetworkUtil _netUtil = NetworkUtil();
  @override
  void initState() {
    super.initState();
    status = listStatus[0];
    _tabController = TabController(length: listStatus.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        status = listStatus[_tabController.index];
        getOders();
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
    _statusOrderList = 0;
    pickedOrders = null;
    setState(() {});
    Map<String, String> body = {
      "token": Configs.login?.token ?? '',
      "status": (status?.status ?? 0).toString(),
    };

    final result = await _netUtil.get('get_orders', body, context);
    if (result == null) {
      // txtStatus = "Không tìm thấy đơn hàng";
      orders = [];
      _statusOrderList = 3;
      setState(() {});
      return;
    }
    if (Configs.userGroup == 1) {
      orders = (result).map<Order>((item) => Order.fromJson(item)).toList();
    } else {
      orders = (result['orders'])
          .map<Order>((item) => Order.fromJson(item))
          .toList();
    }
    if (orders.isEmpty) {
      // txtStatus = "Không tìm thấy đơn hàng";
      orders = [];
      _statusOrderList = 3;
      setState(() {});
      return;
    }
    _statusOrderList = 2;
    // txtStatus = "Đã tìm thấy ${orders.length} đơn hàng";
    setState(() {});
  }

  _confirmOrders(String xeomId, bool needConfirm) async {
    if (pickedOrders == null) return;
    await EasyLoading.show(
      status: 'Đang tải xử lý...',
      maskType: EasyLoadingMaskType.clear,
    );
    if (needConfirm) {
      Map<String, String> body = {
        "token": Configs.login?.token ?? '',
        "order_id": pickedOrders?.id ?? '',
        "status": "1"
      };

      final rs = await _netUtil.get("change_order_status", body, context);
      await EasyLoading.dismiss();
      if (rs == null || rs["success"].toString() != "1") {
        Fluttertoast.showToast(msg: "Có lỗi xảy ra, xin vui lòng thử lại.");
        return;
      }
      // Fluttertoast.showToast(msg: "Xác nhận đơn hàng thành công.");
    }
    final sendShipperBody = {
      'order_id_array': jsonEncode([pickedOrders?.id ?? '']),
      'xeom_id': xeomId
    };
    final result = await _netUtil.post('hkdo_gui_shiper', sendShipperBody, context);
    await EasyLoading.dismiss();

    if (result != null) {
      Fluttertoast.showToast(msg: "Gửi đơn hàng thành công.");
    } else {
      Fluttertoast.showToast(msg: "Có lỗi xảy ra, xin vui lòng thử lại.");
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      decoration: ShapeDecoration(
        color: Styles.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(12),
          const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text(
              'Lựa chọn đơn cần chuyển',
              style: Styles.headline2Style,
            ),
          ),
          const Gap(24),
          TabBar(
            controller: _tabController,
            labelPadding: const EdgeInsets.all(0),
            indicatorColor: Colors.transparent,
            // tabAlignment: TabAlignment.start,
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
            )),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GFButton(
              onPressed: () {
                _confirmOrders(widget.xeomId, _tabController.index == 1);
              },
              // padding: const EdgeInsets.all(16),
              buttonBoxShadow: true,
              borderShape: RoundedRectangleBorder(
                // side: const BorderSide(width: 1, color: Color(0xFF1076D0)),
                borderRadius: BorderRadius.circular(6),
              ),
              fullWidthButton: true,
              size: 48,
              color: Styles.primaryColor3,
              type: GFButtonType.solid,
              text: textBottomButton[_tabController.index],

              // textColor: Colors.white,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final donHang = orders[index];
              DateTime ngayDonHang = DateTime.parse(donHang.time ?? '');
              final picked = donHang == pickedOrders;
              return FadeAnimation(
                  delay: 1,
                  child: InkWell(
                    onTap: () {
                      pickedOrders = null;

                      if (!picked) {
                        pickedOrders = donHang;
                      }
                      setState(() {});
                    },
                    child: Container(
                        alignment: AlignmentDirectional.center,
                        // width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 7),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: picked
                                ? Border.all(color: Styles.primaryColor3)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 1,
                                  spreadRadius: 1)
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: _status1Widget(
                            donHang, ngayDonHang, context, picked)),
                  ));
            }));
  }

  Widget _status1Widget(
      Order donHang, DateTime ngayDonHang, BuildContext context, bool picked) {
    return Row(
      children: [
        IgnorePointer(
            ignoring: true,
            child: Radio(
              // size: GFSize.SMALL,
              value: picked,
              groupValue: true,
              onChanged: (value) {
                // setState(() {
                //   selectedIndex = index;
                // });
              },
              // co: selectedIndex == index
              //     ? GFColors.PRIMARY
              //     : null,
              activeColor: picked ? GFColors.PRIMARY : GFColors.FOCUS,
            )),
        Expanded(
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    // '${index + 1}. #${donHang.id} ${donHang.orderName.toUpperCase()} - ${DateFormat('dd/MM/yyyy').format(ngayDonHang)}',
                    '${donHang.orderName ?? ''.toUpperCase()} - ${DateFormat('dd/MM/yyyy').format(ngayDonHang)}',
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    softWrap: true,
                    style: Styles.headline4Style
                        .copyWith(color: Styles.primaryColor3),
                  ),
                ),
              ],
            ),
            const Gap(8),
            Column(
              children: <Widget>[
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/profile/user.svg'),
                    const Gap(4),
                    Expanded(
                        child: Text(
                      donHang.buyerName ?? '',
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      softWrap: true,
                      style: Styles.textStyle,
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
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ]),
        ),
      ],
    );
  }
}
