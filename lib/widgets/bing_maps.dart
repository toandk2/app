// All compatible imagery sets
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as map;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

const apiKey =
    'AjsqZsSF_6SlXESkFDvM26dF8lWiuegEcM_1EzZkhvTWRfESmiRZWOuYn0H-XF0Q';

enum BingMapsImagerySet {
  road('RoadOnDemand', zoomBounds: (min: 0, max: 21)),
  aerial('Aerial', zoomBounds: (min: 0, max: 20)),
  aerialLabels('AerialWithLabelsOnDemand', zoomBounds: (min: 0, max: 20)),
  canvasDark('CanvasDark', zoomBounds: (min: 0, max: 21)),
  canvasLight('CanvasLight', zoomBounds: (min: 0, max: 21)),
  canvasGray('CanvasGray', zoomBounds: (min: 0, max: 21)),
  ordnanceSurvey('OrdnanceSurvey', zoomBounds: (min: 12, max: 17));

  final String urlValue;
  final ({int min, int max}) zoomBounds;

  const BingMapsImagerySet(this.urlValue, {required this.zoomBounds});
}

// Custom tile provider that contains the quadkeys logic
// Note that you can also extend from the CancellableNetworkTileProvider
class BingMapsTileProvider extends map.NetworkTileProvider {
  BingMapsTileProvider({super.headers});

  String _getQuadKey(int x, int y, int z) {
    final quadKey = StringBuffer();
    for (int i = z; i > 0; i--) {
      int digit = 0;
      final int mask = 1 << (i - 1);
      if ((x & mask) != 0) digit++;
      if ((y & mask) != 0) digit += 2;
      quadKey.write(digit);
    }
    return quadKey.toString();
  }

  @override
  Map<String, String> generateReplacementMap(
    String urlTemplate,
    map.TileCoordinates coordinates,
    map.TileLayer options,
  ) =>
      super.generateReplacementMap(urlTemplate, coordinates, options)
        ..addAll(
          {
            'culture': 'en-GB', // Or your culture value of choice
            'subdomain': options.subdomains[
                (coordinates.x + coordinates.y) % options.subdomains.length],
            'quadkey': _getQuadKey(coordinates.x, coordinates.y, coordinates.z),
          },
        );
}

// Custom `TileLayer` wrapper that can be inserted into a `FlutterMap`
class BingMapsTileLayer extends StatelessWidget {
  const BingMapsTileLayer({
    super.key,
    // required this.apiKey,
    required this.imagerySet,
  });

  // final String apiKey;
  final BingMapsImagerySet imagerySet;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http.get(
        Uri.parse(
          'https://dev.virtualearth.net/REST/V1/Imagery/Metadata/${imagerySet.urlValue}?output=json&include=ImageryProviders&key=$apiKey',
          // 'https://www.bing.com/api/maps/mapcontrol?callback=getlocation0&key=AjsqZsSF_6SlXESkFDvM26dF8lWiuegEcM_1EzZkhvTWRfESmiRZWOuYn0H-XF0Q',
        ),
      ),
      builder: (context, response) {
        if (response.data == null) return const SizedBox();
        return map.TileLayer(
          urlTemplate: (((((jsonDecode(response.data!.body)
                          as Map<String, dynamic>)['resourceSets']
                      as List<dynamic>)[0] as Map<String, dynamic>)['resources']
                  as List<dynamic>)[0] as Map<String, dynamic>)['imageUrl']
              as String,
          tileProvider: BingMapsTileProvider(),
          subdomains: const ['t0', 't1', 't2', 't3'],
          minNativeZoom: imagerySet.zoomBounds.min,
          maxNativeZoom: imagerySet.zoomBounds.max,
        );
      },
    );
  }
}

class CustomBingMap extends StatefulWidget {
  const CustomBingMap({
    super.key,
    required this.markers,
    required this.position,
    this.marker,
    this.pickedMarker,
  });

  final List<LatLng> markers;
  final LatLng position;
  final Widget? marker;
  final Widget? pickedMarker;

  @override
  State<CustomBingMap> createState() => _CustomBingMapState();
}

class _CustomBingMapState extends State<CustomBingMap> {
  // LatLng initialCenter = const LatLng(21, 105.85);
  int? choosedShopIndex;
  List<map.Marker> markers = [];
  final _controller = map.MapController();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // initialCenter = widget.position;
    _updateMarker(widget.markers);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomBingMap oldWidget) {
    if (widget.position != oldWidget.position) {
      // initialCenter = widget.position;
      _controller.move(widget.position, _controller.camera.zoom);
    }
    if (listEquals(widget.markers, oldWidget.markers)) {
      _updateMarker(widget.markers);
    }
    super.didUpdateWidget(oldWidget);
  }

  _updateMarker(List<LatLng> newMarkers) {
    markers = [];
    for (var i = 0; i < newMarkers.length; i++) {
      final shop = newMarkers[i];
      markers.add(
        map.Marker(
          point: LatLng(
            shop.latitude,
            shop.longitude,
          ),
          child: GestureDetector(
              onTap: () {
                choosedShopIndex = i;
                _updateMarker(widget.markers);
                setState(() {});
              },
              child:
                  choosedShopIndex == i ? widget.pickedMarker : widget.marker),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'map',
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: map.FlutterMap(
                mapController: _controller,
                options: map.MapOptions(
                  initialCenter: widget.position,
                  initialZoom: 12,
                ),
                children: [
                  const BingMapsTileLayer(
                    imagerySet: BingMapsImagerySet.road,
                  ),
                  map.MarkerLayer(
                    markers: markers,
                  ),
                ]),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: GFButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return FullBingMap(
                    markers: markers,
                    position: widget.position,
                  );
                }));
              },
              text: 'Mở rộng',
              color: Colors.white,
              size: 40,
              textStyle: Styles.headline4Style,
              icon: SvgPicture.asset('assets/icons/bx-expand.svg'),
            ),
          ),
        )
      ],
    );
  }
}

class FullBingMap extends StatefulWidget {
  const FullBingMap({
    super.key,
    required this.markers,
    required this.position,
  });

  final List<map.Marker> markers;
  final LatLng position;

  @override
  State<FullBingMap> createState() => _FullBingMapState();
}

class _FullBingMapState extends State<FullBingMap> {
  final mapController = MapController();
  double initialZoom = 12;
  _zoomUp() {
    initialZoom++;
    mapController.move(widget.position, initialZoom);
  }

  _zoomDown() {
    initialZoom--;
    mapController.move(widget.position, initialZoom);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Hero(
            tag: 'map',
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: map.FlutterMap(
                  mapController: mapController,
                  options: map.MapOptions(
                    initialCenter: widget.position,
                    initialZoom: initialZoom,
                  ),
                  children: [
                    const BingMapsTileLayer(
                      imagerySet: BingMapsImagerySet.road,
                    ),
                    map.MarkerLayer(
                      markers: widget.markers,
                    )
                  ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(5),
              width: 50,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 12,
                    offset: Offset(0, 8),
                    spreadRadius: -4,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GFIconButton(
                    onPressed: _zoomUp,
                    color: Colors.white,
                    size: 40,
                    padding: const EdgeInsets.all(0),
                    shape: GFIconButtonShape.square,
                    icon: const Icon(
                      Icons.add_rounded,
                      color: Styles.primaryColor3,
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  GFIconButton(
                    onPressed: _zoomDown,
                    color: Colors.white,
                    size: 40,
                    padding: const EdgeInsets.all(0),
                    shape: GFIconButtonShape.square,
                    icon: const Icon(
                      Icons.remove_rounded,
                      color: Styles.primaryColor3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GFButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'Quay lại',
                color: Colors.white,
                size: 40,
                textStyle: Styles.headline4Style,
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
