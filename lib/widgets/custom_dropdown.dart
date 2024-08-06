import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/custom_textfield.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    Key? key,
    required this.text,
    this.style,
    required this.onSelected,
    this.suffixIcon,
    this.prefixIcon,
    this.hintText,
    this.textCtrl,
    this.data = const [],
    this.initData,
    this.readOnly = false,
  }) : super(key: key);
  final Function(T value) onSelected;
  final String Function(T value) text;
  final TextStyle? style;
  final Widget? suffixIcon;
  final String? hintText;
  final TextEditingController? textCtrl;
  final Widget? prefixIcon;
  final List<T> data;
  final String? initData;
  final bool readOnly;
  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final _dropdownKey = GlobalKey();
  late final TextEditingController _textCtrl;
  late RenderBox _box;
  TextStyle style = Styles.textStyle;
  Timer? timer;

  OverlayEntry? _dialog;

  onTapDrowdown() async {
    if (!widget.readOnly) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    final offset = _box.localToGlobal(Offset(0, _box.size.height));
    if (mounted) {
      final height = MediaQuery.of(context).size.height;
      double? bottomPos;
      double? topPos = offset.dy;
      if (topPos > height * 2 / 3) {
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

  _onRemoveDialog() {
    if (_dialog == null || _dialog?.mounted == false) return;
    _dialog?.remove();
    _dialog = null;
  }

  onPickItem(int index) {
    widget.onSelected(widget.data[index]);
    setState(() {
      _textCtrl.text = widget.text(widget.data[index]);
      _onRemoveDialog();
    });
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
    if (widget.initData != null) {
      _textCtrl.text = widget.initData!;
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        _box = _dropdownKey.currentContext?.findRenderObject() as RenderBox;
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 8),
            spreadRadius: -4,
          )
        ],
      ),
      child: CustomTextfield(
        key: _dropdownKey,
        textCtrl: _textCtrl,
        hintText: widget.hintText,
        showBorder: false,
        prefixIcon: widget.prefixIcon,
        readOnly: widget.readOnly,
        suffixIcon: widget.suffixIcon,
        onTap: () => onTapDrowdown(),
      ),
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
    return widget.data.isNotEmpty
        ? Container(
            width: _box.size.width,
            decoration: boxDecoration,
            constraints: BoxConstraints(
              // minHeight: 38,
              maxHeight: MediaQuery.of(context).size.height / 4,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.separated(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: widget.data.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) => InkWell(
                onTap: () => onPickItem(index),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.text(widget.data[index]),
                    style: style,
                  ),
                ),
              ),
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 1,
                  color: Styles.lightColor,
                );
              },
            ))
        : Container(
            height: double.minPositive,
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
