import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmPayScreen extends StatefulWidget {
  const ConfirmPayScreen(
      {super.key, required this.model, required this.orderId});
  final CheckoutModel model;
  final int orderId;
  @override
  State<ConfirmPayScreen> createState() => _ConfirmPayScreenState();
}

class _ConfirmPayScreenState extends State<ConfirmPayScreen> {
  @override
  void initState() {
    _getShop();
    super.initState();
  }

  final renderObjectKey = GlobalKey();
  final _networkUtil = NetworkUtil();
  bool _firstLoad = true;
  ShopDetail? _shopDetail;

  _getShop() async {
    final result =
        await _networkUtil.get('shop', {'shop_id': widget.model.shopId ?? ''}, context);
    if (result != null) {
      _shopDetail = ShopDetail.fromJson(result);
    }
    _firstLoad = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: _firstLoad
          ? Center(
              child: Lottie.asset(
                "assets/images/loading.json",
                repeat: true,
                reverse: true,
                animate: true,
              ))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    const Center(
                      child: Text(
                        'Đơn hàng đã được gửi',
                        style: Styles.headline1Style,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Gap(20),
                    if (widget.model.qrcode != null)
                      RepaintBoundary(
                        key: renderObjectKey,
                        child: Image.memory(
                          base64Decode(widget.model.qrcode!),
                          width: 150,
                          height: 150,
                        ),
                      ),
                    if (widget.model.qrcode != null) const Gap(12),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                              text: 'Mã đơn hàng của bạn: #',
                              style: Styles.textStyle),
                          TextSpan(
                              text: widget.orderId.toString(),
                              style: Styles.headline4Style
                                  .copyWith(color: Styles.primaryColor3)),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const Gap(20),
                    const Text(
                        'Truy cập vào liên kết dưới đây để có thể theo dõi đơn hàng này:',
                        style: Styles.textStyle),
                    const Gap(12),
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(
                            'https://dothithongminh1.vn/muongi/order_buyer_detail?order_id=${widget.orderId}');

                        // if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                        // } else {
                        //   Fluttertoast.showToast(msg: 'Could not launch $url');
                        // }
                      },
                      child: Text(
                          'https://dothithongminh1.vn/muongi/order_buyer_detail?order_id=${widget.orderId}',
                          style: Styles.textStyle.copyWith(
                            color: Styles.primaryColor3,
                            decoration: TextDecoration.underline,
                          )),
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        Expanded(
                          child: GFButton(
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(
                                  text:
                                      'https://dothithongminh1.vn/muongi/order_buyer_detail?order_id=${widget.orderId}'));
                              Fluttertoast.showToast(
                                  msg:
                                      "Sao chép đường dẫn đơn hàng thành công ");
                            },
                            text: 'Chia sẻ link',
                            size: 46,
                            color: GFColors.PRIMARY,
                            icon: SvgPicture.asset(
                                'assets/icons/profile/bxs-share.svg'),
                            textStyle: Styles.headline4Style
                                .copyWith(color: Colors.white),
                            borderShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: GFButton(
                            onPressed: () => getWidgetImage(renderObjectKey),
                            size: 46,
                            text: 'Tải ảnh QR',
                            icon: SvgPicture.asset(
                                'assets/icons/profile/bxs-download.svg'),
                            color: const Color(0xFFEBF2F8),
                            textStyle: Styles.headline4Style
                                .copyWith(color: Styles.primaryColor3),
                            borderShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    const Text(
                      "Liên hệ trực tiếp với người bán",
                      style: Styles.hintStyle,
                    ),
                    const Gap(16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      clipBehavior: Clip.antiAlias,
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                child: Image.network(
                                  Configs.BASE_URL.replaceAll('/api', '') +
                                      (_shopDetail?.imgPath ?? ''),
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Styles.darkGrey,
                                    );
                                  },
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                  child: Column(
                                children: [
                                  Text(
                                    _shopDetail?.shopName ?? '',
                                    style: Styles.headline3Style,
                                  ),
                                  const Gap(8),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/profile/bxs-phone.svg'),
                                      const Gap(6),
                                      Expanded(
                                          child: Text(
                                        _shopDetail?.shopPhone ?? '',
                                        style: Styles.subtitle1Style,
                                      )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox.square(
                                          dimension: 24,
                                          child: Image.asset(
                                              'assets/images/location-pin.png')),
                                      const Gap(6),
                                      Expanded(
                                          child: Text(
                                        _shopDetail?.shopAddress ?? '',
                                        style: Styles.subtitle1Style,
                                      )),
                                    ],
                                  ),
                                ],
                              ))
                            ],
                          ),
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
                                  text: 'Gọi',
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
                                  size: 40,
                                  text: 'Tìm đường',
                                  icon: SizedBox.square(
                                      dimension: 24,
                                      child: Image.asset(
                                          'assets/images/location-pin.png')),
                                  color: const Color(0xFFEBF2F8),
                                  textStyle: Styles.headline4Style
                                      .copyWith(color: Styles.primaryColor3),
                                  borderShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
