import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/anmition/fadeanimation.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class ShipperNotificationScreen extends StatefulWidget {
  const ShipperNotificationScreen({Key? key}) : super(key: key);

  @override
  State<ShipperNotificationScreen> createState() =>
      _ShipperNotificationScreenState();
}

class _ShipperNotificationScreenState extends State<ShipperNotificationScreen>
    with TickerProviderStateMixin {
  late final AnimationController animationController;

  final _netUtil = NetworkUtil();

  int _status = 0;
  final ScrollController scrollController = ScrollController();
  final NumberFormat formatter = NumberFormat("#,###");

  List<TiemNotification> _dataNotification = [];
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    loadNotification();
  }

  @override
  void dispose() {
    animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadNotification() async {
    Map<String, String> body = {
      "limit": "5000",
      "offset": "0",
    };
    setState(() {
      _status = 0;
    });
    // String url = "shop_unread_notification";
    // if (Configs.userGroup == 1)
    //   url = "buyer_unread_notifications";
    // else if (Configs.userGroup == 3) url = "shipper_unread_notifications";
    _netUtil.get("shipper_get_notification", body, context).then((rs) {
      if (rs != null) {
        _dataNotification = (rs)
            .map<TiemNotification>((item) => TiemNotification.fromJson(item))
            .toList();
        if (_dataNotification.isNotEmpty) {
          _status = 2;
        } else {
          _status = 3;
        }
      } else {
        _dataNotification = [];
        _status = 3;
      }
      setState(() {});
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        leading: InkWell(
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            MdiIcons.chevronLeftCircle,
            color: Colors.white,
            size: 30,
          ),
        ),
        backgroundColor: Styles.primaryColor,
        searchBar: false,
        title: const Text(
          "Thông báo",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const Gap(5),
          if (_status == 0)
            Expanded(
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(50),
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
                    ))),
          if (_status == 2) Expanded(child: _getList(context)),
          if (_status == 3)
            Expanded(
                child: Lottie.asset(
              "assets/images/nodata.json",
              repeat: true,
              reverse: true,
              animate: true,
            ))
        ],
      ),
    );
  }

  // void _scrollToTop() {
  //   scrollController.animateTo(0,
  //       duration: const Duration(seconds: 1), curve: Curves.linearToEaseOut);
  // }

  Future<void> _onRefresh() async {
    await loadNotification();
  }

  // Future<void> _onLoading() async {
  //   await loadNotification();
  // }

  Widget _getList(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            itemCount: _dataNotification.length,
            controller: scrollController,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var thongBao = _dataNotification[index];
              final ngayThongBao = DateTime.tryParse(thongBao.time ?? '');
              return FadeAnimation(
                  delay: 1,
                  child: InkWell(
                      onTap: () {
                        Configs.orderId = thongBao.orderId.toString();
                        if (thongBao.status2 == "0") {
                          // _netUtil.dismissShipperNotification(
                          //     thongBao.id.toString());
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute<dynamic>(
                        //     builder: (BuildContext context) =>
                        //         const ShipperOrderDetailScreen(),
                        //   ),
                        // ).then((_) {
                        //   loadNotification();
                        // });
                      },
                      child: Container(
                          alignment: AlignmentDirectional.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 7),
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
                          child: Column(children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '#${thongBao.orderId}',
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.clip,
                                    maxLines: 2,
                                    softWrap: true,
                                    style: Styles.textStyle.copyWith(
                                      color: Styles.black50,
                                      fontWeight: thongBao.status2 == "0"
                                          ? FontWeight.w500
                                          : FontWeight.w300,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  FluentSystemIcons
                                      .ic_fluent_calendar_date_regular,
                                  color: Styles.primaryColor3,
                                  size: 16,
                                ),
                                const Gap(3),
                                Text(
                                  ngayThongBao != null
                                      ? DateFormat('dd/MM/yyyy HH:mm')
                                          .format(ngayThongBao)
                                      : '',
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontWeight: thongBao.status2 == "0"
                                          ? FontWeight.w500
                                          : FontWeight.w300,
                                      fontSize: 11,
                                      letterSpacing: 0.0,
                                      color: thongBao.status2 == "0"
                                          ? Styles.moneyColor
                                          : Styles.primaryColor3),
                                )
                              ],
                            ),
                            const Gap(3),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Styles.blueGrey,
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                padding: const EdgeInsets.all(
                                  10,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      FluentSystemIcons
                                          .ic_fluent_comment_regular,
                                      color: Styles.primaryColor,
                                      size: 20,
                                    ),
                                    const Gap(5),
                                    Expanded(
                                      child: Text(
                                        thongBao.content ?? '',
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                        maxLines: 2,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontWeight: thongBao.status2 == "0"
                                              ? FontWeight.w500
                                              : FontWeight.w300,
                                          fontSize: 12,
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                          ]))));
            }));
  }
}
