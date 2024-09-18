import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hkd/trade/confirm_screen.dart';
import 'package:hkd/ultils/func.dart';
import 'package:hkd/ultils/models.dart';
import 'package:hkd/ultils/styles.dart';
import 'package:hkd/widgets/appbar.dart';
import 'package:hkd/widgets/custom_dropdown.dart';
import 'package:hkd/widgets/custom_searchbar.dart';
import 'package:hkd/widgets/custom_textfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:collection/collection.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.model});
  final CheckoutModel model;
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _networkUtil = NetworkUtil();
  final paymentMethod = <Map<String, String>>[
    {'type': '0', 'text': 'Thanh toán khi nhận hàng'},
    {'type': '1', 'text': 'Chuyển khoản ngay'},
  ];
  bool distanceToofar = false;
  double _totalProductCost = 0;
  AddressModel? addressBuyerModel;
  AddressModel? addressShopModel;
  List<AddressModel> initAddressesBuyer = [];
  final _formKey = GlobalKey<FormState>();
  final _timeFrom = TextEditingController();
  final _timeTo = TextEditingController();
  DateTime _timeSlotDateTime = DateTime.now();
  final _timeSlot = TextEditingController();
  final _addressNumberCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.model.shippingTimeSlot =
        DateFormat('dd/MM/yyyy').format(_timeSlotDateTime);
    widget.model.shippingTimeSlotFrom = DateFormat('HH')
        .format(_timeSlotDateTime.add(const Duration(hours: 1)));
    widget.model.shippingTimeSlotTo = DateFormat('HH')
        .format(_timeSlotDateTime.add(const Duration(hours: 2)));
    _timeFrom.text = '${widget.model.shippingTimeSlotFrom ?? ''}h';
    _timeTo.text = '${widget.model.shippingTimeSlotTo ?? ''}h';
    _timeSlot.text = widget.model.shippingTimeSlot ?? '';
    _calculateTotal();
    _getBuyerAddress();
    setState(() {});
    _getShopAddress();
  }

  _calculateTotal() {
    for (var element in widget.model.data) {
      _totalProductCost += element.subTotal ?? 0;
    }
  }

  _calculateShipCost() async {
    final body = {
      'shop_city': addressShopModel?.tinh ?? '',
      'shop_district': addressShopModel?.huyen ?? '',
      'shop_ward': addressShopModel?.xa ?? '',
      'buyer_city': addressBuyerModel?.tinh ?? '',
      'buyer_district': addressBuyerModel?.huyen ?? '',
      'buyer_ward': addressBuyerModel?.xa ?? '',
    };
    final result = await _networkUtil.post('create_ship_fee', body, context);
    if (result != null && result['message'] == 'Success') {
      widget.model.shippingCost = result['data']?['total'] ?? 0;
    }
    setState(() {});
  }

  _getShopAddress() async {
    final result = await _networkUtil.get(
        'thx_by_location',
        {'lat': widget.model.lat1 ?? '', 'lon': widget.model.lon1 ?? ''},
        context);
    if (result != null && result['kq'] == 1) {
      addressShopModel = AddressModel.fromJson(result['xa']);
    }
  }

  _getBuyerAddress() async {
    if (Configs.login?.token == null) return;

    List<AddressModel> addresses = [];
    final result = await _networkUtil.get(
        'get_buyer_address', {'token': Configs.login?.token ?? ''}, context);
    if (result != null && result is List) {
      for (var i = 0; i < result.length; i++) {
        final stringAddressSplited =
            result[i]['location'].toString().split(',');
        if (stringAddressSplited.length < 3 ||
            stringAddressSplited.elementAtOrNull(1)?.contains("Quận") != true) {
          continue;
        }
        addresses.add(AddressModel(
            tinh: stringAddressSplited[2],
            huyen: stringAddressSplited[1],
            xa: stringAddressSplited[0],
            diachi: result[i]['address'],
            lat: result[i]['lat'],
            lon: result[i]['lon']));
      }
    }
    initAddressesBuyer = addresses.take(3).toList();
    setState(() {});
  }

  _deleteCartUnsigned() {
    Configs.unSignedCart.remove(widget.model.shopId);
    // final products = Configs.unSignedCart[widget.model.shopId]?.products;
    // final currentProducts = products
    //     ?.firstWhereOrNull((element) => element.productId == item.productId);
    // if (currentProducts == null) {
    //   return;
    // }
    // if (currentProducts.quantity >= 1) {
    //   currentProducts.quantity--;
    // }
  }

  @override
  void dispose() {
    _timeFrom.dispose();
    _timeTo.dispose();
    _timeSlot.dispose();
    _addressNumberCtrl.dispose();
    widget.model.shippingCost = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            const Text('Thông tin thanh toán', style: Styles.headline1Style),
            const Gap(20),
            const Text('Tên đơn hàng', style: Styles.textStyle),
            const Gap(8),
            CustomTextfield(
              initialValue: widget.model.name ?? '',
              onSaved: (val) {
                widget.model.name = val;
              },
              validator: (val) {
                return val?.isNotEmpty != true
                    ? "Tên đơn hàng không để trống"
                    : null;
              },
              hintText: 'Nhập tên đơn hàng',
            ),
            const Gap(20),
            const Text('Họ tên khách hàng', style: Styles.textStyle),
            const Gap(8),
            CustomTextfield(
              initialValue: widget.model.buyerName ?? '',
              // readOnly: true,
              onSaved: (val) {
                widget.model.buyerName = val;
              },
              validator: (val) {
                return val?.isNotEmpty != true
                    ? "Tên người mua không để trống"
                    : null;
              },
              hintText: 'Nhập tên người mua',
            ),
            const Gap(20),
            const Text('Số điện thoại', style: Styles.textStyle),
            const Gap(8),
            CustomTextfield(
              initialValue: widget.model.buyerPhone ?? '',
              // readOnly: true,
              onSaved: (val) {
                widget.model.buyerPhone = val;
              },
              validator: (val) {
                if (val?.isNotEmpty != true) {
                  return "Số điện thoại không để trống";
                }
                if (val?.isNotEmpty == true && val?.length != 10) {
                  return "Số điện thoại chưa đúng";
                }
                return null;
              },
              hintText: 'Nhập số điện thoại',
            ),
            const Gap(20),
            const Text('Ghi chú đơn hàng', style: Styles.textStyle),
            const Gap(8),
            CustomTextfield(
              onSaved: (val) {
                widget.model.note = val;
              },
              hintText: 'Nhập ghi chú đơn hàng',
            ),
            const Gap(20),
            const Text('Vị trí nhận hàng', style: Styles.textStyle),
            const Gap(8),
            LocationSearchbar(
              initData: initAddressesBuyer,
              getInitPosition: false,
              onClear: () {
                addressBuyerModel = null;
                widget.model.shippingCost = 0;
                distanceToofar = false;
                setState(() {});
              },
              onSelected: (model) async {
                distanceToofar = false;
                setState(() {});
                addressBuyerModel = model;
                try {
                  final distance = Geolocator.distanceBetween(
                      double.parse(addressBuyerModel!.lat!),
                      double.parse(addressBuyerModel!.lon!),
                      double.parse(addressShopModel!.lat!),
                      double.parse(addressShopModel!.lon!));
                  if (distance > 50000) {
                    distanceToofar = true;
                    widget.model.shippingCost = 0;
                    setState(() {});
                  } else {
                    _addressNumberCtrl.text = addressBuyerModel?.diachi ?? '';
                    await _calculateShipCost();
                  }
                } catch (e) {}
              },
            ),
            const Gap(6),
            if (distanceToofar)
              const Text(
                  'Khoảng cách vận chuyển quá lớn, bạn cần tham khảo phí vận chuyển với Người bán',
                  style: Styles.subtitle1Style),
            const Gap(14),
            const Text('Địa chỉ nhận hàng', style: Styles.textStyle),
            const Gap(8),
            CustomTextfield(
              // initialValue: widget.model.buyerAddress ?? '',
              textCtrl: _addressNumberCtrl,
              // onSaved: (val) async {
              //   addressNumber = val;
              // },
              validator: (val) {
                return val?.isNotEmpty != true
                    ? "Địa chỉ nhận hàng không để trống"
                    : null;
              },
              hintText: 'Nhập địa chỉ nhận hàng',
            ),
            const Gap(20),
            const Text('Thời gian nhận hàng', style: Styles.textStyle),
            const Gap(8),
            CustomTextfield(
              textCtrl: _timeSlot,
              readOnly: true,
              onSaved: (val) {
                widget.model.shippingTimeSlot = val;
              },
              validator: (val) {
                return val?.isNotEmpty != true
                    ? "Ngày nhận hàng không để trống"
                    : null;
              },
              hintText: 'Nhập ngày nhận hàng',
              suffixIcon: InkWell(
                  onTap: _showDate,
                  child: const Icon(Icons.calendar_month_rounded)),
            ),
            const Gap(20),
            const Text('Khung giờ nhận hàng', style: Styles.textStyle),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: CustomTextfield(
                    textCtrl: _timeFrom,
                    readOnly: true,
                    onSaved: (val) {
                      widget.model.shippingTimeSlotFrom = val;
                    },
                    validator: (val) {
                      return val?.isNotEmpty != true
                          ? "Giờ nhận hàng không để trống"
                          : null;
                    },
                    hintText: 'Nhập giờ nhận hàng',
                    suffixIcon: InkWell(
                        onTap: _showTimeFrom,
                        child: const Icon(Icons.keyboard_arrow_down_rounded)),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: CustomTextfield(
                    textCtrl: _timeTo,
                    readOnly: true,
                    onSaved: (val) {
                      widget.model.shippingTimeSlotTo = val;
                    },
                    validator: (val) {
                      return val?.isNotEmpty != true
                          ? "Giờ nhận hàng không để trống"
                          : null;
                    },
                    hintText: 'Nhập giờ nhận hàng',
                    suffixIcon: InkWell(
                        onTap: _showTimeTo,
                        child: const Icon(Icons.keyboard_arrow_down_rounded)),
                  ),
                ),
              ],
            ),
            const Gap(20),
            const Text('Phương thức thanh toán', style: Styles.textStyle),
            const Gap(8),
            CustomDropdown(
              text: (value) {
                return value['text'] ?? '';
              },
              onSelected: (value) {
                widget.model.payment = value['type'];
              },
              readOnly: true,
              data: paymentMethod,
              initData: paymentMethod[1]['text'],
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            if (widget.model.qrcode != null) const Gap(20),
            if (widget.model.qrcode != null)
              Row(
                children: [
                  // Image.memory(
                  //   data: widget.model.qrcode!,
                  //   size: 80,
                  // ),
                  Image.memory(
                    base64Decode(widget.model.qrcode!),
                    width: 60,
                    height: 60,
                  ),
                  const Gap(20),

                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Tên ngân hàng: ${widget.model.bank}',
                            style: Styles.textStyle,
                          ),
                          TextSpan(
                            text:
                                '\nTên người nhận: ${widget.model.bankAccountName}',
                            style: Styles.textStyle,
                          ),
                          TextSpan(
                            text:
                                '\nSố tài khoản: ${widget.model.bankAccountNumber}',
                            style: Styles.textStyle,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            const Gap(20),
            GFButton(
              onPressed: () async {
                final form = _formKey.currentState;
                final validated = form?.validate();
                if (validated == false) {
                  Fluttertoast.showToast(
                      msg: "Yêu cầu nhập đầy đủ trường thông tin");
                }
                if (validated == true) {
                  // setState(() => _isLoading = true);
                  form?.save();
                  widget.model.buyerAddress =
                      '${_addressNumberCtrl.text}, ${addressBuyerModel?.xa ?? ''}, ${addressBuyerModel?.huyen ?? ''}, ${addressBuyerModel?.tinh ?? ''}';
                  widget.model.lat2 = addressBuyerModel?.lat;
                  widget.model.lon2 = addressBuyerModel?.lon;
                  final result = await _networkUtil.post(
                      'checkout', widget.model.toJson(), context);
                  if (result != null && result['success'] > 0) {
                    if (Configs.user != null && context.mounted) {
                      await _networkUtil.deleteCartOnline(
                          widget.model.shopId, context);
                    }
                    _deleteCartUnsigned();
                    Fluttertoast.showToast(
                        msg: 'Đơn hàng đã được gửi thành công');

                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ConfirmPayScreen(
                            model: widget.model,
                            orderId: result['order_id'],
                          ),
                        ),
                      );
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Đơn hàng gửi không thành công');
                  }
                }
              },
              padding: const EdgeInsets.all(16),
              borderShape: RoundedRectangleBorder(
                // side: const BorderSide(width: 1, color: Color(0xFF1076D0)),
                borderRadius: BorderRadius.circular(6),
              ),
              size: 48,
              fullWidthButton: true,
              color: Styles.primaryColor3,
              type: GFButtonType.solid,
              text: 'Xác nhận mua hàng',
              // textColor: Colors.white,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(20),
            _CheckoutWidget(
              model: widget.model,
              productCost: _totalProductCost,
            )
          ],
        ),
      ),
    ));
  }

  _showDate() async {
    final result = await showDatePicker(
        context: context,
        firstDate: _timeSlotDateTime,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        lastDate: _timeSlotDateTime.add(const Duration(days: 30)));
    if (result != null) {
      _timeSlotDateTime = result;
      _timeSlot.text = DateFormat('dd/MM/yyyy').format(result);
      setState(() {});
    }
  }

  _showTimeFrom() async {
    // final result = await showTimePicker(
    //     context: context,
    //     initialTime: widget.model.shippingTimeSlotFrom != null
    //         ? TimeOfDay(
    //             hour: int.parse(widget.model.shippingTimeSlotFrom!), minute: 0)
    //         : TimeOfDay.fromDateTime(now),
    //     builder: (context, child) {
    //       return MediaQuery(
    //         data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
    //         child: child ?? const SizedBox(),
    //       );
    //     });
    // if (result != null) {
    //   _timeFrom.text = '${result.hour}h';
    //   setState(() {});
    // }
    final maxTime = DateTime(
      _timeSlotDateTime.year,
      _timeSlotDateTime.month,
      _timeSlotDateTime.day + 1,
    );
    final result = await picker.DatePicker.showDateTimePicker(
      context,
      minTime: _timeSlotDateTime,
      maxTime: maxTime,
    );
    if (result != null) {
      _timeFrom.text = '${result.hour}h';
      setState(() {});
    }
  }

  _showTimeTo() async {
    final minTime = DateTime(
        _timeSlotDateTime.year,
        _timeSlotDateTime.month,
        _timeSlotDateTime.day,
        (int.tryParse(_timeFrom.text.substring(0, _timeFrom.text.length - 1)) ??
                _timeSlotDateTime.hour) +
            1);
    final maxTime = DateTime(
      _timeSlotDateTime.year,
      _timeSlotDateTime.month,
      _timeSlotDateTime.day + 1,
    );
    final result = await picker.DatePicker.showDateTimePicker(
      context,
      minTime: minTime,
      maxTime: maxTime,
    );
    if (result != null) {
      _timeTo.text = '${result.hour}h';
      setState(() {});
    }
  }
}

class _CheckoutWidget extends StatelessWidget {
  const _CheckoutWidget({required this.model, required this.productCost});
  final CheckoutModel model;

  final double productCost;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
                child: Text(
              'Giỏ hàng',
              style: Styles.hintStyle,
            )),
            Text(
              '${model.data.length} sản phẩm',
              style: Styles.textStyle,
            ),
          ],
        ),
        const Gap(12),
        Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
            child: Column(
              children: [
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final item = model.data[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: item.productName,
                                  style: Styles.headline4Style,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const Gap(6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.quantity} x ${Configs.formatter.format(item.price ?? 0)} đ',
                                  style: Styles.hintStyle.copyWith(
                                    color: const Color(0xFF6B6B6B),
                                  ),
                                ),
                              ),
                              Text(
                                '${Configs.formatter.format(item.subTotal ?? 0)} đ',
                                style: Styles.hintStyle
                                    .copyWith(color: const Color(0xFF278D47)),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Color(0xFFEAEAEA),
                        height: 24,
                      );
                    },
                    itemCount: model.data.length),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Flex(
                      direction: Axis.horizontal,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                          (constraints.constrainWidth() / 12).floor(),
                          (index) => const SizedBox(
                                height: 1,
                                width: 5,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: Colors.grey),
                                ),
                              )),
                    );
                  },
                ),
                const Gap(12),
                if (model.qrcode != null)
                  // QrImage(
                  //   data: model.qrcode!,
                  //   size: 80,
                  // ),
                  Image.memory(
                    base64Decode(model.qrcode!),
                    width: 150,
                    height: 150,
                  ),
                if (model.qrcode != null) const Gap(12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Thành tiền',
                          style: Styles.textStyle.copyWith(
                            color: const Color(0xFF6B6B6B),
                          ),
                        ),
                      ),
                      Text(
                        '${Configs.formatter.format(productCost)} đ',
                        style: Styles.textStyle,
                      ),
                    ],
                  ),
                ),
                const Gap(6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Phí vận chuyển',
                          style: Styles.textStyle.copyWith(
                            color: const Color(0xFF6B6B6B),
                          ),
                        ),
                      ),
                      Text(
                        '${Configs.formatter.format(model.shippingCost ?? 0)} đ',
                        style: Styles.textStyle,
                      ),
                    ],
                  ),
                ),
                const Gap(6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Thành tiền',
                          style: Styles.textStyle.copyWith(
                            color: const Color(0xFF6B6B6B),
                          ),
                        ),
                      ),
                      Text(
                        '${Configs.formatter.format(productCost + (model.shippingCost ?? 0))} đ',
                        style: Styles.textStyle,
                      ),
                    ],
                  ),
                ),
                const Gap(12),
              ],
            )),
      ],
    );
  }
}
