import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:hkd/order_detail/buyer_order_detail_screen.dart';
import 'package:hkd/order_detail/shipper_order_detail_screen.dart';
import 'package:hkd/order_detail/shop_order_detail_screen.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:material_dialogs/material_dialogs.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _getNoti();
  }

  _getNoti() async {
    await EasyLoading.show(
      status: 'Đang tải xử lý...',
      maskType: EasyLoadingMaskType.clear,
    );
    loadNotification();
    loadUnreadNoti();
    await EasyLoading.dismiss();
  }

  final _netUtil = NetworkUtil();
  // final pageLength = 20;
  int page = 0;
  int newsCount = 0;

  List<TiemNotification> _dataNotification = [];
  Future<void> loadNotification() async {
    final newData = await _netUtil.getNotis(page, context);
    _dataNotification = newData;
    setState(() {});
  }

  Future loadUnreadNoti() async {
    newsCount = await _netUtil.getUnreadNoti(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Thông báo',
                    style: Styles.headline1Style,
                  ),
                ),
                Text(
                  '$newsCount thông báo chưa đọc',
                  style: Styles.textStyle,
                ),
              ],
            ),
          ),
          Expanded(
            child: _dataNotification.isEmpty
                ? Lottie.asset(
                    "assets/images/nodata.json",
                    repeat: true,
                    reverse: true,
                    animate: true,
                  )
                : RefreshIndicator(
                    onRefresh: loadNotification,
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16),
                        shrinkWrap: true,
                        itemCount: _dataNotification.length,
                        itemBuilder: (context, index) {
                          final item = _dataNotification[index];

                          return Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: ShapeDecoration(
                              color: item.status2 != "0"
                                  ? const Color(0xFFF7F7F7)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                side: item.status2 != "0"
                                    ? const BorderSide(
                                        width: 1, color: Color(0xFFD9D9D9))
                                    : const BorderSide(
                                        width: 1, color: Colors.transparent),
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
                            child: InkWell(
                              onTap: () async {
                                Configs.orderId = item.orderId.toString();
                                // if (item.status2 != "0") {
                                try {
                                  if (context.mounted) {
                                    await _netUtil.dismissNotification(
                                        item.id.toString(), context);
                                    await loadUnreadNoti();
                                  }
                                } catch (e) {
                                  debugPrint(e.toString());
                                }

                                // }
                                if (mounted) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) {
                                      switch (Configs.userGroup) {
                                        case 0:
                                          return const BuyerOrderDetailScreen(
                                              // status: Configs.listShopStatus[
                                              //         int.parse(
                                              //             item.status1 ?? '0')] ??
                                              //     Configs.listShopStatus[0]!,

                                              );
                                        case 3:
                                          return const ShipperOrderDetailScreen();
                                        default:
                                          return const ShopOrderDetailScreen();
                                      }
                                    }),
                                  );
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/drawer/bill.png',
                                        width: 16,
                                        height: 16,
                                      ),
                                      const Gap(6),
                                      Expanded(
                                          child: Text(
                                        'Đơn hàng #${item.orderId}',
                                        style: Styles.textStyle
                                            .copyWith(color: Styles.textColor),
                                      )),
                                      if (item.status2 == "0")
                                        const Icon(
                                          Icons.circle,
                                          color: Colors.red,
                                          size: 12,
                                        )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22.0),
                                    child: Text('\n${item.content}',
                                        style: Styles.headline4Style.copyWith(
                                            color: item.status2 != "0"
                                                ? Styles.fieldTextColor
                                                : Styles.primaryColor3)),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: GFButton(
            onPressed: () async {
              await _netUtil.dismissAllNotification(context);
              _getNoti();
            },
            color: const Color(0xFFEBF2F8),
            padding: const EdgeInsets.all(16),
            borderShape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Styles.primaryColor3),
              borderRadius: BorderRadius.circular(6),
            ),
            size: 48,
            fullWidthButton: true,
            icon: Image.asset('assets/icons/checkbox-circle.png'),
            text: "Đánh dấu tất cả đã đọc",
            textStyle:
                Styles.headline4Style.copyWith(color: Styles.primaryColor3)),
      ),
    );
  }
}
