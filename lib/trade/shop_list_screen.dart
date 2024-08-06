import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hkd/trade/shop_detail_screen.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/bing_maps.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:collection/collection.dart';

class ShopListWidget extends StatefulWidget {
  const ShopListWidget(
      {super.key,
      required this.shops,
      required this.position,
      required this.shopsData,
      required this.temporaryUserGroup});
  final List<Shops> shops;
  final LatLng position;
  final int temporaryUserGroup;
  final List<ShoptypeModel> shopsData;
  @override
  State<ShopListWidget> createState() => _ShopListWidgetState();
}

class _ShopListWidgetState extends State<ShopListWidget> {
  final titleList = [
    'Danh sách hộ kinh doanh',
    'Danh sách nhà phân phối',
  ];
  final markers = <LatLng>[];
  int? choosedShopIndex;
  bool _firstLoad = true;

  @override
  void initState() {
    for (var i = 0; i < widget.shops.length; i++) {
      final shop = widget.shops[i];
      markers.add(
        LatLng(
          double.parse(shop.lat ?? '0'),
          double.parse(shop.lon ?? '0'),
        ),
      );
    }

    _firstLoad = false;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(24),
          Text(
            titleList[widget.temporaryUserGroup],
            style: Styles.headline1Style,
          ),
          const Gap(24),
          Expanded(
              flex: 1,
              child: CustomBingMap(
                  // key: Key(choosedShopIndex.toString()),
                  marker: Image.asset('assets/images/location-pin.png'),
                  pickedMarker:
                      Image.asset('assets/images/location-pin-picked.png'),
                  position: widget.position,
                  markers: markers)),
          if (_firstLoad)
            Expanded(
                child: Lottie.asset(
                  "assets/images/loading.json",
                  repeat: true,
                  reverse: true,
                  animate: true,
                )),
          if (!_firstLoad)
            Expanded(
                flex: 2,
                child: widget.shops.isEmpty
                    ? Lottie.asset(
                      "assets/images/nodata.json",
                      repeat: true,
                      reverse: true,
                      animate: true,
                    )
                    : ListView.builder(
                        // shrinkWrap: true,
                        itemCount: widget.shops.length,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemBuilder: (context, index) {
                          final shop = widget.shops[index];
                          final typeIndex = int.tryParse(shop.type ?? '0') ?? 0;
                          final type = widget.shopsData.firstWhereOrNull(
                              (element) => element.type == typeIndex);
                          if (type == null) return const SizedBox();
                          final distance = double.parse(shop.distance ?? '0');
                          String distanceStr =
                              '${distance.toStringAsFixed(1)}m';
                          if (distance > 100) {
                            distanceStr =
                                '${(distance / 1000).toStringAsFixed(1)}km';
                          }
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ShopDetailScreen(
                                    shopId: shop.id ?? '',
                                  ),
                                ),
                              );
                            },
                            child: _ShopWidget(
                              shop: shop,
                              type: type,
                              distance: distanceStr,
                            ),
                          );
                        },
                      )),
        ],
      ),
    ));
  }
}

class _ShopWidget extends StatelessWidget {
  const _ShopWidget(
      {required this.shop, required this.type, required this.distance});
  final Shops shop;
  final ShoptypeModel type;
  final String distance;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: const Color(0xFFEAEAEA),
              height: 120,
              width: 120,
              child: Stack(
                children: [
                  Image.network(
                    Configs.BASE_URL.replaceAll('/api', '') +
                        (shop.linkImg ?? ''),
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                          child: SvgPicture.string(
                        type.image ?? '',
                        width: 48,
                        height: 48,
                        color: Colors.white,
                      ));
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 2, left: 6, right: 4, bottom: 2),
                      decoration: const ShapeDecoration(
                        color: Color(0xFFFEDD02),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(8)),
                        ),
                      ),
                      child: Text(
                        shop.distance == null ? '~' : distance,
                        style: Styles.headline4Style,
                      ),
                    ),
                  )
                ],
              )),
          const Gap(12),
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name ?? '',
                      style: Styles.headline4Style
                          .copyWith(color: Styles.primaryColor3),
                      maxLines: 2,
                    ),
                    const Gap(4),
                    Text(
                      type.name ?? '',
                      style: Styles.subtitle1Style,
                    ),
                    const Gap(4),
                    Text(
                      shop.address ?? '',
                      style: Styles.textStyle
                          .copyWith(color: const Color(0xFF6B6B6B)),
                      maxLines: 2,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
