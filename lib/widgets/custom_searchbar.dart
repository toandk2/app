import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/custom_textfield.dart';

class CustomSearchBar<T> extends StatefulWidget {
  const CustomSearchBar(
      {Key? key,
      required this.onChanged,
      this.onTap,
      this.readOnly = true,
      required this.text,
      this.style,
      required this.onSelected,
      this.suffixIcon,
      this.prefixIcon,
      this.hintText,
      this.textCtrl,
      this.timeOutSearch = 1,
      this.waitTextSearch = 2,
      this.showDialog = true,
      this.initialValue})
      : super(key: key);
  final Function(T value) onSelected;
  final FutureOr<List<T>> Function(String? value) onChanged;
  final List<T> Function()? onTap;
  final bool readOnly;
  final String Function(T value) text;
  final TextStyle? style;
  final Widget? suffixIcon;
  final String? hintText;
  final TextEditingController? textCtrl;
  final Widget? prefixIcon;
  final int timeOutSearch;
  final String? initialValue;
  final bool showDialog;
  final int waitTextSearch;
  @override
  State<CustomSearchBar<T>> createState() => _CustomSearchBarState<T>();
}

class _CustomSearchBarState<T> extends State<CustomSearchBar<T>> {
  final _dropdownKey = GlobalKey();
  late final TextEditingController _textCtrl;
  late RenderBox _box;
  TextStyle style = Styles.textStyle;
  List<T> data = [];
  Timer? timer;
  Widget? suffixIcon;
  final _focusNode = FocusNode();
  OverlayEntry? _dialog;

  onTapDrowdown() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final offset = _box.localToGlobal(Offset(0, _box.size.height));
    if (mounted) {
      final height = MediaQuery.of(context).size.height;
      double? bottomPos;
      double? topPos = offset.dy;
      if (topPos > height / 2) {
        // verticalPos = verticalPos -
        //     halfHeight / 2 -
        //     50 -
        //     MediaQuery.of(context).viewInsets.bottom;
        // if (verticalPos < 0) verticalPos = 0;
        bottomPos = height - offset.dy + 50;
        // bottomPos = MediaQuery.of(context).viewInsets.bottom + 50;
        topPos = null;
      }
      _onRemoveDialog();
      _dialog = OverlayEntry(builder: (context) {
        return Positioned(
          top: topPos,
          bottom: bottomPos,
          left: offset.dx,
          child: TapRegion(
            onTapOutside: (details) => _onRemoveDialog(),
            child: _buildDropdown(),
          ),
        );
      });
      Overlay.of(context).insert(_dialog!);
    }
  }

  onPickItem(int index) {
    widget.onSelected(data[index]);
    setState(() {
      _textCtrl.text = widget.text(data[index]);
      _onRemoveDialog();
    });
  }

  _onSearch(String? value) async {
    if (value == null) return;
    if (value.length < widget.waitTextSearch) return;
    if (timer != null) timer?.cancel();
    timer = Timer(Duration(seconds: widget.timeOutSearch), () async {
      data = await widget.onChanged(value);
      if (widget.showDialog) {
        onTapDrowdown();
      }
    });
  }

  _onTapField() {
    if (widget.onTap != null) {
      data = widget.onTap?.call() ?? [];
      onTapDrowdown();
    }
  }

  _onRemoveDialog() {
    if (_dialog == null || _dialog?.mounted == false) return;
    _dialog?.remove();
    _dialog = null;
  }

  @override
  void initState() {
    if (widget.style != null) {
      style = widget.style!;
    }
    if (widget.textCtrl != null) {
      _textCtrl = widget.textCtrl!;
    } else {
      _textCtrl = TextEditingController();
    }
    suffixIcon = widget.suffixIcon;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        _box = _dropdownKey.currentContext?.findRenderObject() as RenderBox;
      },
    );
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    if (widget.textCtrl == null) {
      _textCtrl.dispose();
    }
    if (timer != null) {
      timer?.cancel();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextfield(
      key: _dropdownKey,
      textCtrl: _textCtrl,
      // focusNode: _focusNode,
      onTap: () {
        _onTapField();
        suffixIcon = GestureDetector(
            // behavior: HitTestBehavior.translucent,
            onTap: () {
              _textCtrl.text = '';
              setState(() {});
            },
            child: const Icon(Icons.close));
        setState(() {});
      },
      onTapOutside: () {
        suffixIcon = widget.suffixIcon;
        // _onRemoveDialog();
        setState(() {});
      },
      hintText: widget.hintText,
      readOnly: widget.readOnly,
      onChanged: _onSearch,
      initialValue: widget.initialValue,
      prefixIcon: widget.prefixIcon,
      suffixIcon: suffixIcon,
      // onTap: () => onTapDrowdown(),
    );
  }

  _buildDropdown() {
    // final offset = _box.localToGlobal(Offset(0, _box.size.height + 20));
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Styles.lightColor,
        width: 1,
      ),
      color: Colors.white,
    );
    return data.isNotEmpty
        ? Container(
            width: _box.size.width,
            decoration: boxDecoration,
            constraints: BoxConstraints(
              // minHeight: 38,
              maxHeight: MediaQuery.of(context).size.height / 4,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: ListView.separated(
              itemCount: data.length,
              padding: const EdgeInsets.all(0),
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = data[index];
                if (item == null) return const SizedBox();
                return InkWell(
                  onTap: () => onPickItem(index),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.text(data[index]),
                      style: style,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 1,
                  color: Styles.fieldTextColor,
                );
              },
            ))
        : Container(
            width: _box.size.width,
            decoration: boxDecoration,
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                'Không có dữ liệu',
                style: Styles.textStyle.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          );
  }
}

class LocationSearchbar extends StatefulWidget {
  const LocationSearchbar(
      {super.key,
      required this.onSelected,
      this.initValue,
      this.getInitPosition = true,
      this.initData = const []});
  final Function(AddressModel) onSelected;
  final String? initValue;
  final List<AddressModel> initData;
  final bool getInitPosition;
  @override
  State<LocationSearchbar> createState() => _LocationSearchbarState();
}

class _LocationSearchbarState extends State<LocationSearchbar> {
  @override
  void didUpdateWidget(covariant LocationSearchbar oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initData != oldWidget.initData) {
        initData = widget.initData;
      }
      if (widget.initValue != null && widget.initValue != oldWidget.initValue) {
        addressCtrl.text = widget.initValue!;
      }
      setState(() {});
    });
    super.didUpdateWidget(oldWidget);
  }

  final _networkUtil = NetworkUtil();
  AddressModel? addressModel;
  List<AddressModel> initData = [];
  final addressCtrl = TextEditingController();
  _getIntialAddress() async {
    final position = await getCurrentLocation(context);

    final result = await _networkUtil.get('thx_by_location', {
      'lat': position.latitude.toString(),
      'lon': position.longitude.toString()
    },context);
    if (result != null && result['kq'] == 1) {
      addressModel = AddressModel.fromJson(result['xa']);
      widget.onSelected(addressModel!);

      addressCtrl.text =
          '${addressModel?.tinh ?? ''}, ${addressModel?.huyen ?? ''}, ${addressModel?.xa ?? ''}';
    }
  }

  FutureOr<List<AddressModel>> _getAddress(String? data) async {
    if (data == null) return [];
    List<AddressModel> addressModels = [];
    final value = await _networkUtil.get('search_address', {'keyword': data},context);
    if (value != null) {
      addressModels = AddressModel.fromListJson(value);
    }
    return addressModels;
  }

  @override
  void initState() {
    final initValue = widget.initValue;
    if (initValue != null) {
      addressCtrl.text = initValue;
      return;
    }
    if (widget.getInitPosition) {
      _getIntialAddress();
    }
    super.initState();
  }

  @override
  void dispose() {
    addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSearchBar<AddressModel>(
      text: (value) {
        return '${value.tinh},${value.huyen},${value.xa}';
      },
      onChanged: _getAddress,
      readOnly: false,
      waitTextSearch: initData.isNotEmpty ? 0 : 2,
      hintText: 'Tỉnh Thành phố, Phường xã, Quận huyện',
      onTap: initData.isNotEmpty ? () => initData : null,
      onSelected: (item) {
        addressModel = item;
        widget.onSelected(addressModel!);
      },
      textCtrl: addressCtrl,
      suffixIcon: IconButton(
          onPressed: () async {
            await _getIntialAddress();
          },
          icon: Image.asset('assets/icons/register/location.png')),
    );
  }
}
