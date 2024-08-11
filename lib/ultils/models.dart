import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Status {
  final int status;
  final String name;
  final Color textColor;
  final Color color;
  final String icon;
  const Status(
      {required this.status,
      required this.name,
      required this.color,
      required this.textColor,
      required this.icon});
}

class ShoptypeModel {
  String? name;
  String? image;
  int? type;

  ShoptypeModel({this.name, this.image, this.type});

  ShoptypeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['type'] = type;
    return data;
  }

  static List<ShoptypeModel> fromListJson(Iterable list) {
    return list.map((data) => ShoptypeModel.fromJson(data)).toList();
  }
}

class Login {
  int? success;
  String? token;
  String? userId;
  String? buyerId;
  String? shopId;
  String? shopType;
  String? userName;
  String? name;
  String? buyerName;
  String? shopName;
  String? userPass;
  Login(
      {this.success,
      this.token,
      this.userId,
      this.buyerId,
      this.buyerName,
      this.shopId,
      this.shopName,
      this.shopType,
      this.userName,
      this.name,
      this.userPass});

  Login.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token'];
    userId = json['user_id'];
    buyerId = json['buyer_id'];
    buyerName = json['buyer_name'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    shopType = json['shop_type'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['token'] = token;
    data['user_id'] = userId;
    data['shop_id'] = shopId;
    data['buyer_id'] = buyerId;
    data['buyer_name'] = buyerName;
    data['shop_name'] = shopName;
    data['shop_type'] = shopType;
    data['name'] = name;
    return data;
  }
}

class UserData {
  String? taiKhoan;
  String? matKhau;
  int? loai;
  UserData({
    this.taiKhoan,
    this.matKhau,
    this.loai,
  });
  factory UserData.fromJson(Map<String, dynamic> json) {
    // final Map<String, dynamic> cartJson = jsonDecode(json['Cart']);
    // Map<String, CheckoutModel> model = {};
    // cartJson.forEach(
    //   (key, value) {
    //     model[key] = CheckoutModel.fromJson(value);
    //   },
    // );
    return UserData(
      taiKhoan: json['TaiKhoan'],
      matKhau: json['MatKhau'],
      loai: json['Loai'],
    );
  }
  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};
    json['TaiKhoan'] = taiKhoan;
    json['MatKhau'] = matKhau;
    json['Loai'] = loai;
    return json;
  }
}

// class UserData {
//   String? taiKhoan;
//   String? matKhau;
//   int? loai;
//   Map<String, CheckoutModel> cart;
//   UserData({this.taiKhoan, this.matKhau, this.loai, required this.cart});
//   factory UserData.fromJson(Map<String, dynamic> json) {
//     final Map<String, dynamic> cartJson = jsonDecode(json['Cart']);
//     Map<String, CheckoutModel> model = {};
//     cartJson.forEach(
//       (key, value) {
//         model[key] = CheckoutModel.fromJson(value);
//       },
//     );
//     return UserData(
//         taiKhoan: json['TaiKhoan'],
//         matKhau: json['MatKhau'],
//         loai: json['Loai'],
//         cart: model);
//   }
//   Map<String, dynamic> toJson() {
//     var json = <String, dynamic>{};
//     json['TaiKhoan'] = taiKhoan;
//     json['MatKhau'] = matKhau;
//     json['Loai'] = loai;
//     json['Cart'] = jsonEncode(cart);
//     return json;
//   }
// }

class Order {
  String? id;
  String? shopId;
  String? orderName;
  num? amount;
  String? time;
  String? buyerId;
  String? buyerName;
  String? buyerPhone;
  String? buyerAddress;
  String? type;
  String? status;
  String? note;
  num? shippingCost;
  String? lat1;
  String? lon1;
  String? lat2;
  String? lon2;
  String? paymentMethod;
  String? shippingTimeSlot;
  String? xeomId;
  String? code;
  String? xeomApprovalTime;
  String? confirmTime;
  String? xeomGetTime;
  String? system;
  String? shopBank;
  String? shopBankAccountName;
  String? shopBankAccountNumber;
  String? shopPhone;
  String? shopAddress;
  String? shopName;
  String? shippingTimeSlotFrom;
  String? shippingTimeSlotTo;

  Order(
      {this.id,
      this.shopId,
      this.orderName,
      this.amount,
      this.time,
      this.buyerId,
      this.buyerName,
      this.buyerPhone,
      this.buyerAddress,
      this.type,
      this.status,
      this.note,
      this.shippingCost,
      this.lat1,
      this.lon1,
      this.lat2,
      this.lon2,
      this.paymentMethod,
      this.shippingTimeSlot,
      this.xeomId,
      this.code,
      this.xeomApprovalTime,
      this.confirmTime,
      this.xeomGetTime,
      this.system,
      this.shopBank,
      this.shopBankAccountName,
      this.shopBankAccountNumber,
      this.shopPhone,
      this.shopAddress,
      this.shopName,
      this.shippingTimeSlotFrom,
      this.shippingTimeSlotTo});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    orderName = json['order_name'];
    amount = json['amount'] == null ? 0 : double.parse(json['amount']);
    time = json['time'];
    buyerId = json['buyer_id'];
    buyerName = json['buyer_name'];
    buyerPhone = json['buyer_phone'];
    buyerAddress = json['buyer_address'];
    type = json['type'];
    status = json['status'];
    note = json['note'];
    shippingCost =
        json['shipping_cost'] == null ? 0 : double.parse(json['shipping_cost']);
    lat1 = json['lat1'];
    lon1 = json['lon1'];
    lat2 = json['lat2'];
    lon2 = json['lon2'];
    paymentMethod = json['payment_method'];
    shippingTimeSlot = json['shipping_time_slot'];
    xeomId = json['xeom_id'];
    code = json['code'];
    xeomApprovalTime = json['xeom_approval_time'];
    confirmTime = json['confirm_time'];
    xeomGetTime = json['xeom_get_time'];
    system = json['system'];
    shopBank = json['shop_bank'];
    shopBankAccountName = json['shop_bank_account_name'];
    shopBankAccountNumber = json['shop_bank_account_number'];
    shopPhone = json['shop_phone'];
    shopAddress = json['shop_address'];
    shopName = json['shop_name'];
    shippingTimeSlotFrom = json['shipping_time_slot_from'];
    shippingTimeSlotTo = json['shipping_time_slot_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['order_name'] = orderName;
    data['amount'] = amount;
    data['time'] = time;
    data['buyer_id'] = buyerId;
    data['buyer_name'] = buyerName;
    data['buyer_phone'] = buyerPhone;
    data['buyer_address'] = buyerAddress;
    data['type'] = type;
    data['status'] = status;
    data['note'] = note;
    data['shipping_cost'] = shippingCost;
    data['lat1'] = lat1;
    data['lon1'] = lon1;
    data['lat2'] = lat2;
    data['lon2'] = lon2;
    data['payment_method'] = paymentMethod;
    data['shipping_time_slot'] = shippingTimeSlot;
    data['xeom_id'] = xeomId;
    data['code'] = code;
    data['xeom_approval_time'] = xeomApprovalTime;
    data['confirm_time'] = confirmTime;
    data['xeom_get_time'] = xeomGetTime;
    data['system'] = system;
    data['shop_bank'] = shopBank;
    data['shop_bank_account_name'] = shopBankAccountName;
    data['shop_bank_account_number'] = shopBankAccountNumber;
    data['shop_phone'] = shopPhone;
    data['shop_address'] = shopAddress;
    data['shop_name'] = shopName;
    data['shipping_time_slot_from'] = shippingTimeSlotFrom;
    data['shipping_time_slot_to'] = shippingTimeSlotTo;
    return data;
  }
}

class TiemNotification {
  String? id;
  String? type;
  String? objectId;
  String? content;
  String? orderId;
  String? time;
  String? status;
  String? system;
  String? status1;
  String? status2;
  TiemNotification(
      {this.id,
      this.type,
      this.objectId,
      this.content,
      this.orderId,
      this.time,
      this.status,
      this.system,
      this.status1,
      this.status2});

  TiemNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    objectId = json['object_id'];
    content = json['content'];
    orderId = json['order_id'];
    time = json['time'];
    status = json['status'];
    system = json['system'];
    status1 = json['status1'];
    status2 = json['status2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['object_id'] = objectId;
    data['content'] = content;
    data['order_id'] = orderId;
    data['time'] = time;
    data['status'] = status;
    data['system'] = system;
    data['status1'] = status1;
    return data;
  }
}

class ShipperDetail {
  String? id;
  String? name;
  String? phone;
  String? address;
  String? portrait;
  String? cmnd;
  String? licence;
  String? warranty;
  String? timeType;
  String? lat;
  String? lon;
  String? motorReg;

  String? plate;
  String? province;
  String? district;
  String? ward;
  String? code;

  ShipperDetail(
      {this.id,
      this.name,
      this.phone,
      this.address,
      this.portrait,
      this.cmnd,
      this.licence,
      this.warranty,
      this.timeType,
      this.lat,
      this.lon,
      this.motorReg,
      this.plate,
      this.province,
      this.district,
      this.ward,
      this.code});

  ShipperDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    portrait = json['portrait'];
    cmnd = json['cmnd'];
    licence = json['licence'];
    warranty = json['warranty'];
    timeType = json['time_type'];
    lat = json['lat'];
    lon = json['lon'];
    motorReg = json['motor_reg'];

    plate = json['plate'];
    province = json['province'];
    district = json['district'];
    ward = json['ward'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['portrait'] = portrait;
    data['cmnd'] = cmnd;
    data['licence'] = licence;
    data['warranty'] = warranty;
    data['time_type'] = timeType;
    data['lat'] = lat;
    data['lon'] = lon;
    data['motor_reg'] = motorReg;

    data['plate'] = plate;
    data['province'] = province;
    data['district'] = district;
    data['ward'] = ward;
    data['code'] = code;
    return data;
  }
}

class OrderDetail {
  String? id;
  String? shopId;
  String? orderId;
  String? productId;
  String? productName;
  num? quantity;
  num? price;
  num? amount;
  String? status;

  OrderDetail(
      {this.id,
      this.shopId,
      this.orderId,
      this.productId,
      this.productName,
      this.quantity,
      this.price,
      this.amount,
      this.status});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    quantity = double.parse(json['quantity']);
    price = double.parse(json['price']);
    amount = double.parse(json['amount']);
    status = json['status'];
  }

  static List<OrderDetail> fromListJson(Iterable list) {
    return list.map((data) => OrderDetail.fromJson(data)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['price'] = price;
    data['amount'] = amount;
    data['status'] = status;
    return data;
  }
}

class OrderDetails {
  String? id;
  String? shopId;
  String? orderName;
  String? amount;
  String? time;
  String? buyerId;
  String? buyerName;
  String? buyerPhone;
  String? buyerAddress;
  String? type;
  int? status;
  String? note;
  num? shippingCost;
  String? lat1;
  String? lon1;
  String? lat2;
  String? lon2;
  String? paymentMethod;
  String? shippingTimeSlot;
  String? xeomId;
  String? code;
  String? xeomApprovalTime;
  String? confirmTime;
  String? xeomGetTime;
  String? system;
  String? shopBank;
  String? shopBankAccountName;
  String? shopBankAccountNumber;
  String? shopPhone;
  String? shopAddress;
  String? shippingTimeSlotFrom;
  String? shippingTimeSlotTo;
  List<OrderDetail>? items;

  OrderDetails(
      {this.id,
      this.shopId,
      this.orderName,
      this.amount,
      this.time,
      this.buyerId,
      this.buyerName,
      this.buyerPhone,
      this.buyerAddress,
      this.type,
      this.status,
      this.note,
      this.shippingCost,
      this.lat1,
      this.lon1,
      this.lat2,
      this.lon2,
      this.paymentMethod,
      this.shippingTimeSlot,
      this.xeomId,
      this.code,
      this.xeomApprovalTime,
      this.confirmTime,
      this.xeomGetTime,
      this.system,
      this.shopBank,
      this.shopBankAccountName,
      this.shopBankAccountNumber,
      this.shopPhone,
      this.shopAddress,
      this.shippingTimeSlotFrom,
      this.shippingTimeSlotTo,
      this.items});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    orderName = json['order_name'];
    amount = json['amount'];
    time = json['time'];
    buyerId = json['buyer_id'];
    buyerName = json['buyer_name'];
    buyerPhone = json['buyer_phone'];
    buyerAddress = json['buyer_address'];
    type = json['type'];
    status = int.parse(json['status']);
    note = json['note'];
    shippingCost = double.parse(json['shipping_cost']);
    lat1 = json['lat1'];
    lon1 = json['lon1'];
    lat2 = json['lat2'];
    lon2 = json['lon2'];
    paymentMethod = json['payment_method'];
    shippingTimeSlot = json['shipping_time_slot'];
    xeomId = json['xeom_id'];
    code = json['code'];
    xeomApprovalTime = json['xeom_approval_time'];
    confirmTime = json['confirm_time'];
    xeomGetTime = json['xeom_get_time'];
    system = json['system'];
    shopBank = json['shop_bank'];
    shopBankAccountName = json['shop_bank_account_name'];
    shopBankAccountNumber = json['shop_bank_account_number'];
    shopPhone = json['shop_phone'];
    shopAddress = json['shop_address'];
    shippingTimeSlotFrom = json['shipping_time_slot_from'];
    shippingTimeSlotTo = json['shipping_time_slot_to'];
    items = [];
    if (json['items'] != null) {
      //  List<OrderDetail> items = [];
      json['items'].forEach((v) {
        items!.add(OrderDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['order_name'] = orderName;
    data['amount'] = amount;
    data['time'] = time;
    data['buyer_id'] = buyerId;
    data['buyer_name'] = buyerName;
    data['buyer_phone'] = buyerPhone;
    data['buyer_address'] = buyerAddress;
    data['type'] = type;
    data['status'] = status;
    data['note'] = note;
    data['shipping_cost'] = shippingCost;
    data['lat1'] = lat1;
    data['lon1'] = lon1;
    data['lat2'] = lat2;
    data['lon2'] = lon2;
    data['payment_method'] = paymentMethod;
    data['shipping_time_slot'] = shippingTimeSlot;
    data['xeom_id'] = xeomId;
    data['code'] = code;
    data['xeom_approval_time'] = xeomApprovalTime;
    data['confirm_time'] = confirmTime;
    data['xeom_get_time'] = xeomGetTime;
    data['system'] = system;
    data['shop_bank'] = shopBank;
    data['shop_bank_account_name'] = shopBankAccountName;
    data['shop_bank_account_number'] = shopBankAccountNumber;
    data['shop_phone'] = shopPhone;
    data['shop_address'] = shopAddress;
    data['shipping_time_slot_from'] = shippingTimeSlotFrom;
    data['shipping_time_slot_to'] = shippingTimeSlotTo;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BuyerOrder {
  String? id;
  String? shopId;
  String? orderName;
  num? amount;
  String? time;
  String? buyerId;
  String? buyerName;
  String? buyerPhone;
  String? buyerAddress;
  String? type;
  String? status;
  String? note;
  num? shippingCost;
  String? lat1;
  String? lon1;
  String? lat2;
  String? lon2;
  String? paymentMethod;
  String? shippingTimeSlot;
  String? xeomId;
  String? code;
  String? xeomApprovalTime;
  String? confirmTime;
  String? xeomGetTime;
  String? system;
  String? shopBank;
  String? shopBankAccountName;
  String? shopBankAccountNumber;
  String? shopPhone;
  String? shopAddress;
  String? shippingTimeSlotFrom;
  String? shippingTimeSlotTo;

  BuyerOrder(
      {this.id,
      this.shopId,
      this.orderName,
      this.amount,
      this.time,
      this.buyerId,
      this.buyerName,
      this.buyerPhone,
      this.buyerAddress,
      this.type,
      this.status,
      this.note,
      this.shippingCost,
      this.lat1,
      this.lon1,
      this.lat2,
      this.lon2,
      this.paymentMethod,
      this.shippingTimeSlot,
      this.xeomId,
      this.code,
      this.xeomApprovalTime,
      this.confirmTime,
      this.xeomGetTime,
      this.system,
      this.shopBank,
      this.shopBankAccountName,
      this.shopBankAccountNumber,
      this.shopPhone,
      this.shopAddress,
      this.shippingTimeSlotFrom,
      this.shippingTimeSlotTo});

  BuyerOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    orderName = json['order_name'];
    amount = json['amount'] == null ? 0 : double.parse(json['amount']);
    time = json['time'];
    buyerId = json['buyer_id'];
    buyerName = json['buyer_name'];
    buyerPhone = json['buyer_phone'];
    buyerAddress = json['buyer_address'];
    type = json['type'];
    status = json['status'];
    note = json['note'];
    shippingCost =
        json['shipping_cost'] == null ? 0 : double.parse(json['shipping_cost']);
    lat1 = json['lat1'];
    lon1 = json['lon1'];
    lat2 = json['lat2'];
    lon2 = json['lon2'];
    paymentMethod = json['payment_method'];
    shippingTimeSlot = json['shipping_time_slot'];
    xeomId = json['xeom_id'];
    code = json['code'];
    xeomApprovalTime = json['xeom_approval_time'];
    confirmTime = json['confirm_time'];
    xeomGetTime = json['xeom_get_time'];
    system = json['system'];
    shopBank = json['shop_bank'];
    shopBankAccountName = json['shop_bank_account_name'];
    shopBankAccountNumber = json['shop_bank_account_number'];
    shopPhone = json['shop_phone'];
    shopAddress = json['shop_address'];
    shippingTimeSlotFrom = json['shipping_time_slot_from'];
    shippingTimeSlotTo = json['shipping_time_slot_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['order_name'] = orderName;
    data['amount'] = amount;
    data['time'] = time;
    data['buyer_id'] = buyerId;
    data['buyer_name'] = buyerName;
    data['buyer_phone'] = buyerPhone;
    data['buyer_address'] = buyerAddress;
    data['type'] = type;
    data['status'] = status;
    data['note'] = note;
    data['shipping_cost'] = shippingCost;
    data['lat1'] = lat1;
    data['lon1'] = lon1;
    data['lat2'] = lat2;
    data['lon2'] = lon2;
    data['payment_method'] = paymentMethod;
    data['shipping_time_slot'] = shippingTimeSlot;
    data['xeom_id'] = xeomId;
    data['code'] = code;
    data['xeom_approval_time'] = xeomApprovalTime;
    data['confirm_time'] = confirmTime;
    data['xeom_get_time'] = xeomGetTime;
    data['system'] = system;
    data['shop_bank'] = shopBank;
    data['shop_bank_account_name'] = shopBankAccountName;
    data['shop_bank_account_number'] = shopBankAccountNumber;
    data['shop_phone'] = shopPhone;
    data['shop_address'] = shopAddress;
    data['shipping_time_slot_from'] = shippingTimeSlotFrom;
    data['shipping_time_slot_to'] = shippingTimeSlotTo;
    return data;
  }
}

class BuyerOrderDetail {
  String? id;
  String? shopId;
  String? orderName;
  String? amount;
  String? time;
  String? buyerId;
  String? buyerName;
  String? buyerPhone;
  String? buyerAddress;
  String? type;
  int? status;
  String? note;
  num? shippingCost;
  String? lat1;
  String? lon1;
  String? lat2;
  String? lon2;
  String? paymentMethod;
  String? shippingTimeSlot;
  String? xeomId;
  String? code;
  String? xeomApprovalTime;
  String? confirmTime;
  String? xeomGetTime;
  String? system;
  String? shopBank;
  String? shopBankAccountName;
  String? shopBankAccountNumber;
  String? shopPhone;
  String? shopName;
  String? shopAddress;
  String? shippingTimeSlotFrom;
  String? shippingTimeSlotTo;
  int? xeomShipped;
  BuyerOrderDetail(
      {this.id,
      this.shopId,
      this.orderName,
      this.amount,
      this.time,
      this.buyerId,
      this.buyerName,
      this.buyerPhone,
      this.buyerAddress,
      this.type,
      this.status,
      this.note,
      this.shippingCost,
      this.lat1,
      this.lon1,
      this.lat2,
      this.lon2,
      this.paymentMethod,
      this.shippingTimeSlot,
      this.xeomId,
      this.code,
      this.xeomApprovalTime,
      this.confirmTime,
      this.xeomGetTime,
      this.system,
      this.shopBank,
      this.shopBankAccountName,
      this.shopBankAccountNumber,
      this.shopPhone,
      this.shopName,
      this.shopAddress,
      this.shippingTimeSlotFrom,
      this.shippingTimeSlotTo,
      this.xeomShipped});

  BuyerOrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    orderName = json['order_name'];
    amount = json['amount'];
    time = json['time'];
    buyerId = json['buyer_id'];
    buyerName = json['buyer_name'];
    buyerPhone = json['buyer_phone'];
    buyerAddress = json['buyer_address'];
    type = json['type'];
    status = int.parse(json['status']);
    note = json['note'];
    shippingCost =
        json['shipping_cost'] == null ? 0 : double.parse(json['shipping_cost']);
    lat1 = json['lat1'];
    lon1 = json['lon1'];
    lat2 = json['lat2'];
    lon2 = json['lon2'];
    paymentMethod = json['payment_method'];
    shippingTimeSlot = json['shipping_time_slot'];
    xeomId = json['xeom_id'];
    code = json['code'];
    xeomApprovalTime = json['xeom_approval_time'];
    confirmTime = json['confirm_time'];
    xeomGetTime = json['xeom_get_time'];
    system = json['system'];
    shopBank = json['shop_bank'];
    shopBankAccountName = json['shop_bank_account_name'];
    shopBankAccountNumber = json['shop_bank_account_number'];
    shopPhone = json['shop_phone'];
    shopName = json['shop_name'];
    shopAddress = json['shop_address'];
    shippingTimeSlotFrom = json['shipping_time_slot_from'];
    shippingTimeSlotTo = json['shipping_time_slot_to'];
    xeomShipped = int.parse(json['xeom_shipped']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['order_name'] = orderName;
    data['amount'] = amount;
    data['time'] = time;
    data['buyer_id'] = buyerId;
    data['buyer_name'] = buyerName;
    data['buyer_phone'] = buyerPhone;
    data['buyer_address'] = buyerAddress;
    data['type'] = type;
    data['status'] = status;
    data['note'] = note;
    data['shipping_cost'] = shippingCost;
    data['lat1'] = lat1;
    data['lon1'] = lon1;
    data['lat2'] = lat2;
    data['lon2'] = lon2;
    data['payment_method'] = paymentMethod;
    data['shipping_time_slot'] = shippingTimeSlot;
    data['xeom_id'] = xeomId;
    data['code'] = code;
    data['xeom_approval_time'] = xeomApprovalTime;
    data['confirm_time'] = confirmTime;
    data['xeom_get_time'] = xeomGetTime;
    data['system'] = system;
    data['shop_bank'] = shopBank;
    data['shop_bank_account_name'] = shopBankAccountName;
    data['shop_bank_account_number'] = shopBankAccountNumber;
    data['shop_phone'] = shopPhone;
    data['shop_name'] = shopName;
    data['shop_address'] = shopAddress;
    data['shipping_time_slot_from'] = shippingTimeSlotFrom;
    data['shipping_time_slot_to'] = shippingTimeSlotTo;
    return data;
  }
}

class BuyerOrderItem {
  String? id;
  String? shopId;
  String? orderId;
  String? productId;
  String? productName;
  num? quantity;
  num? price;
  num? amount;
  String? startDate;
  String? endDate;
  String? status;

  BuyerOrderItem(
      {this.id,
      this.shopId,
      this.orderId,
      this.productId,
      this.productName,
      this.quantity,
      this.price,
      this.amount,
      this.startDate,
      this.endDate,
      this.status});

  BuyerOrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    quantity = double.parse(json['quantity']);
    price = double.parse(json['price']);
    amount = double.parse(json['amount']);
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['price'] = price;
    data['amount'] = amount;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    return data;
  }
}

class ShiperOrder {
  String? id;
  String? orderId;
  String? shopId;
  String? orderName;
  num? amount;
  String? time;
  String? buyerId;
  String? buyerName;
  String? buyerPhone;
  String? buyerAddress;
  String? type;
  int? status;
  String? note;
  num? shippingCost;
  String? lat1;
  String? lon1;
  String? lat2;
  String? lon2;
  String? paymentMethod;
  String? shippingTimeSlot;
  String? xeomId;
  String? code;
  String? xeomApprovalTime;
  String? confirmTime;
  String? xeomGetTime;
  String? system;
  String? shopBank;
  String? shopBankAccountName;
  String? shopBankAccountNumber;
  String? shopPhone;
  String? shopAddress;
  String? shippingTimeSlotFrom;
  String? shippingTimeSlotTo;

  ShiperOrder(
      {this.id,
      this.orderId,
      this.shopId,
      this.orderName,
      this.amount,
      this.time,
      this.buyerId,
      this.buyerName,
      this.buyerPhone,
      this.buyerAddress,
      this.type,
      this.status,
      this.note,
      this.shippingCost,
      this.lat1,
      this.lon1,
      this.lat2,
      this.lon2,
      this.paymentMethod,
      this.shippingTimeSlot,
      this.xeomId,
      this.code,
      this.xeomApprovalTime,
      this.confirmTime,
      this.xeomGetTime,
      this.system,
      this.shopBank,
      this.shopBankAccountName,
      this.shopBankAccountNumber,
      this.shopPhone,
      this.shopAddress,
      this.shippingTimeSlotFrom,
      this.shippingTimeSlotTo});

  ShiperOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderId ??= json['id'];
    id = json['id'];
    shopId = json['shop_id'];
    orderName = json['order_name'];
    amount = json['amount'] == null ? 0 : double.parse(json['amount']);
    time = json['time'];
    buyerId = json['buyer_id'];
    buyerName = json['buyer_name'];
    buyerPhone = json['buyer_phone'];
    buyerAddress = json['buyer_address'];
    type = json['type'];
    status = int.parse(json['status']);
    note = json['note'];
    shippingCost = amount =
        json['shipping_cost'] == null ? 0 : double.parse(json['shipping_cost']);
    lat1 = json['lat1'];
    lon1 = json['lon1'];
    lat2 = json['lat2'];
    lon2 = json['lon2'];
    paymentMethod = json['payment_method'];
    shippingTimeSlot = json['shipping_time_slot'];
    xeomId = json['xeom_id'];
    code = json['code'];
    xeomApprovalTime = json['xeom_approval_time'];
    confirmTime = json['confirm_time'];
    xeomGetTime = json['xeom_get_time'];
    system = json['system'];
    shopBank = json['shop_bank'];
    shopBankAccountName = json['shop_bank_account_name'];
    shopBankAccountNumber = json['shop_bank_account_number'];
    shopPhone = json['shop_phone'];
    shopAddress = json['shop_address'];
    shippingTimeSlotFrom = json['shipping_time_slot_from'];
    shippingTimeSlotTo = json['shipping_time_slot_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['shop_id'] = shopId;
    data['order_name'] = orderName;
    data['amount'] = amount;
    data['time'] = time;
    data['buyer_id'] = buyerId;
    data['buyer_name'] = buyerName;
    data['buyer_phone'] = buyerPhone;
    data['buyer_address'] = buyerAddress;
    data['type'] = type;
    data['status'] = status;
    data['note'] = note;
    data['shipping_cost'] = shippingCost;
    data['lat1'] = lat1;
    data['lon1'] = lon1;
    data['lat2'] = lat2;
    data['lon2'] = lon2;
    data['payment_method'] = paymentMethod;
    data['shipping_time_slot'] = shippingTimeSlot;
    data['xeom_id'] = xeomId;
    data['code'] = code;
    data['xeom_approval_time'] = xeomApprovalTime;
    data['confirm_time'] = confirmTime;
    data['xeom_get_time'] = xeomGetTime;
    data['system'] = system;
    data['shop_bank'] = shopBank;
    data['shop_bank_account_name'] = shopBankAccountName;
    data['shop_bank_account_number'] = shopBankAccountNumber;
    data['shop_phone'] = shopPhone;
    data['shop_address'] = shopAddress;
    data['shipping_time_slot_from'] = shippingTimeSlotFrom;
    data['shipping_time_slot_to'] = shippingTimeSlotTo;
    return data;
  }
}

class ShiperOrderDetail {
  String? id;
  String? shopId;
  String? orderName;
  num? amount;
  String? time;
  String? buyerId;
  String? buyerName;
  String? buyerPhone;
  String? buyerAddress;
  String? type;
  int? status;
  String? note;
  num? shippingCost;
  String? lat1;
  String? lon1;
  String? lat2;
  String? lon2;
  String? paymentMethod;
  String? shippingTimeSlot;
  String? xeomId;
  String? code;
  String? xeomApprovalTime;
  String? confirmTime;
  String? xeomGetTime;
  String? system;
  String? shopBank;
  String? shopBankAccountName;
  String? shopBankAccountNumber;
  String? shopPhone;
  String? shopName;
  String? shopAddress;
  String? shippingTimeSlotFrom;
  String? shippingTimeSlotTo;
  int? xeomShipped;
  ShiperOrderDetail(
      {this.id,
      this.shopId,
      this.orderName,
      this.amount,
      this.time,
      this.buyerId,
      this.buyerName,
      this.buyerPhone,
      this.buyerAddress,
      this.type,
      this.status,
      this.note,
      this.shippingCost,
      this.lat1,
      this.lon1,
      this.lat2,
      this.lon2,
      this.paymentMethod,
      this.shippingTimeSlot,
      this.xeomId,
      this.code,
      this.xeomApprovalTime,
      this.confirmTime,
      this.xeomGetTime,
      this.system,
      this.shopBank,
      this.shopBankAccountName,
      this.shopBankAccountNumber,
      this.shopPhone,
      this.shopName,
      this.shopAddress,
      this.shippingTimeSlotFrom,
      this.shippingTimeSlotTo,
      this.xeomShipped});

  ShiperOrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    orderName = json['order_name'];
    amount = json['amount'] == null ? 0 : double.parse(json['amount']);
    time = json['time'];
    buyerId = json['buyer_id'];
    buyerName = json['buyer_name'];
    buyerPhone = json['buyer_phone'];
    buyerAddress = json['buyer_address'];
    type = json['type'];
    status = int.parse(json['status']);
    note = json['note'];
    shippingCost = amount =
        json['shipping_cost'] == null ? 0 : double.parse(json['shipping_cost']);
    lat1 = json['lat1'];
    lon1 = json['lon1'];
    lat2 = json['lat2'];
    lon2 = json['lon2'];
    paymentMethod = json['payment_method'];
    shippingTimeSlot = json['shipping_time_slot'];
    xeomId = json['xeom_id'];
    code = json['code'];
    xeomApprovalTime = json['xeom_approval_time'];
    confirmTime = json['confirm_time'];
    xeomGetTime = json['xeom_get_time'];
    system = json['system'];
    shopBank = json['shop_bank'];
    shopBankAccountName = json['shop_bank_account_name'];
    shopBankAccountNumber = json['shop_bank_account_number'];
    shopPhone = json['shop_phone'];
    shopName = json['shop_name'];
    shopAddress = json['shop_address'];
    shippingTimeSlotFrom = json['shipping_time_slot_from'];
    shippingTimeSlotTo = json['shipping_time_slot_to'];
    xeomShipped = int.parse(json['xeom_shipped']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['order_name'] = orderName;
    data['amount'] = amount;
    data['time'] = time;
    data['buyer_id'] = buyerId;
    data['buyer_name'] = buyerName;
    data['buyer_phone'] = buyerPhone;
    data['buyer_address'] = buyerAddress;
    data['type'] = type;
    data['status'] = status;
    data['note'] = note;
    data['shipping_cost'] = shippingCost;
    data['lat1'] = lat1;
    data['lon1'] = lon1;
    data['lat2'] = lat2;
    data['lon2'] = lon2;
    data['payment_method'] = paymentMethod;
    data['shipping_time_slot'] = shippingTimeSlot;
    data['xeom_id'] = xeomId;
    data['code'] = code;
    data['xeom_approval_time'] = xeomApprovalTime;
    data['confirm_time'] = confirmTime;
    data['xeom_get_time'] = xeomGetTime;
    data['system'] = system;
    data['shop_bank'] = shopBank;
    data['shop_bank_account_name'] = shopBankAccountName;
    data['shop_bank_account_number'] = shopBankAccountNumber;
    data['shop_phone'] = shopPhone;
    data['shop_name'] = shopName;
    data['shop_address'] = shopAddress;
    data['shipping_time_slot_from'] = shippingTimeSlotFrom;
    data['shipping_time_slot_to'] = shippingTimeSlotTo;
    return data;
  }
}

class ShiperOrderItem {
  String? id;
  String? shopId;
  String? orderId;
  String? productId;
  String? productName;
  num? quantity;
  num? price;
  num? amount;
  String? startDate;
  String? endDate;
  String? status;

  ShiperOrderItem(
      {this.id,
      this.shopId,
      this.orderId,
      this.productId,
      this.productName,
      this.quantity,
      this.price,
      this.amount,
      this.startDate,
      this.endDate,
      this.status});

  ShiperOrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    quantity = json['quantity'] == null ? 0 : double.parse(json['quantity']);
    price = json['price'] == null ? 0 : double.parse(json['price']);
    amount = json['amount'] == null ? 0 : double.parse(json['amount']);
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['price'] = price;
    data['amount'] = amount;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    return data;
  }
}

class AppNotification with ChangeNotifier {
  AppNotification({this.id, this.type});
  int? type;
  int? id;
  void increaseNoti() {
    notifyListeners();
  }
}

class BuyerRegisterModel {
  String? name;
  String? phone;
  String? password;
  String? deviceType;
  String? deviceId;
  String? lat;
  String? lon;

  BuyerRegisterModel(
      {this.name,
      this.phone,
      this.password,
      this.deviceType,
      this.deviceId,
      this.lat,
      this.lon});

  BuyerRegisterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    password = json['password'];
    deviceType = json['device_type'];
    deviceId = json['device_id'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['password'] = password;
    data['device_type'] = deviceType;
    data['device_id'] = deviceId;
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }
}

class AddressModel {
  String? id;
  String? tinh;
  String? huyen;
  String? xa;
  String? diachi;
  String? lat;
  String? lon;
  String? latMin;
  String? latMax;
  String? lonMin;
  String? lonMax;

  AddressModel(
      {this.id,
      this.tinh,
      this.huyen,
      this.xa,
      this.diachi,
      this.lat,
      this.lon,
      this.latMin,
      this.latMax,
      this.lonMin,
      this.lonMax});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tinh = json['tinh'];
    huyen = json['huyen'];
    xa = json['xa'];
    lat = json['lat'];
    lon = json['lon'];
    latMin = json['lat-min'];
    latMax = json['lat-max'];
    lonMin = json['lon-min'];
    lonMax = json['lon-max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tinh'] = tinh;
    data['huyen'] = huyen;
    data['xa'] = xa;
    data['lat'] = lat;
    data['lon'] = lon;
    data['lat-min'] = latMin;
    data['lat-max'] = latMax;
    data['lon-min'] = lonMin;
    data['lon-max'] = lonMax;
    return data;
  }

  Map<String, String> toAddressStringJson(int index) {
    String indexString = '';
    if (index > 1) {
      indexString = index.toString();
    }
    final Map<String, String> data = <String, String>{};
    data['location$indexString'] = '$xa, $huyen, $tinh';
    data['address$indexString'] = diachi ?? '';
    data['lat$indexString'] = lat ?? '';
    data['lon$indexString'] = lon ?? '';
    return data;
  }

  static List<AddressModel> fromListJson(Iterable list) {
    return list.map((data) => AddressModel.fromJson(data)).toList();
  }
}

class ProductSuggestion {
  List<Product>? products;

  ProductSuggestion({this.products});

  ProductSuggestion.fromJson(Map<String, dynamic> json) {
    if (json['suggestions'] != null) {
      products = <Product>[];
      json['suggestions'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['suggestions'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String? value;

  Product({this.value});

  Product.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    return data;
  }

  static List<Product> fromListJson(Iterable list) {
    return list.map((data) => Product.fromJson(data)).toList();
  }
}

class ShopSuggestion {
  List<Suggestions>? suggestions;

  ShopSuggestion({this.suggestions});

  ShopSuggestion.fromJson(Map<String, dynamic> json) {
    if (json['suggestions'] != null) {
      suggestions = <Suggestions>[];
      json['suggestions'].forEach((v) {
        suggestions!.add(Suggestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (suggestions != null) {
      data['suggestions'] = suggestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Suggestions {
  String? value;
  String? name;

  Suggestions({this.value, this.name});

  Suggestions.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['name'] = name;
    return data;
  }
}

class SearchResult {
  List<Shops>? shops;
  List<Shops>? shopGps;
  num? a4;
  String? type;
  num? latitude;
  num? longitude;
  String? keyword;

  SearchResult(
      {this.shops,
      this.shopGps,
      this.a4,
      this.type,
      this.latitude,
      this.longitude,
      this.keyword});

  SearchResult.fromJson(Map<String, dynamic> json) {
    if (json['shops'] != null) {
      shops = <Shops>[];
      json['shops'].forEach((v) {
        shops!.add(Shops.fromJson(v));
      });
    }
    if (json['shop_gps'] != null) {
      shopGps = <Shops>[];
      json['shop_gps'].forEach((v) {
        shopGps!.add(Shops.fromJson(v));
      });
    }
    a4 = json['a4'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    keyword = json['keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shops != null) {
      data['shops'] = shops!.map((v) => v.toJson()).toList();
    }
    if (shopGps != null) {
      data['shop_gps'] = shopGps!.map((v) => v.toJson()).toList();
    }
    data['a4'] = a4;
    data['type'] = type;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['keyword'] = keyword;
    return data;
  }
}

class Shops {
  String? id;
  String? name;
  String? type;
  String? address;
  String? lat;
  String? lon;
  String? district;
  String? ward;
  String? state;
  String? linkImg;
  String? distance;
  String? status;
  String? system;
  String? code1;

  Shops(
      {this.id,
      this.name,
      this.type,
      this.address,
      this.lat,
      this.lon,
      this.district,
      this.ward,
      this.state,
      this.linkImg,
      this.distance,
      this.status,
      this.system,
      this.code1});

  Shops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    district = json['district'];
    ward = json['ward'];
    state = json['state'];
    linkImg = json['link_img'];
    distance = json['distance'];
    status = json['status'];
    system = json['system'];
    code1 = json['code1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['district'] = district;
    data['ward'] = ward;
    data['state'] = state;
    data['link_img'] = linkImg;
    data['distance'] = distance;
    data['status'] = status;
    data['system'] = system;
    data['code1'] = code1;
    return data;
  }
}

class ShipperRegisterModel {
  String? xeomName;
  String? xeomPhone;
  String? xeomLocation;
  String? xeomAddress;
  String? xeomEmail;
  String? xeomPassword;
  String? xeomPlate;

  ShipperRegisterModel(
      {this.xeomName,
      this.xeomPhone,
      this.xeomLocation,
      this.xeomAddress,
      this.xeomEmail,
      this.xeomPassword,
      this.xeomPlate});

  ShipperRegisterModel.fromJson(Map<String, dynamic> json) {
    xeomName = json['xeom_name'];
    xeomPhone = json['xeom_phone'];
    xeomLocation = json['xeom_location'];
    xeomAddress = json['xeom_address'];
    xeomEmail = json['xeom_email'];
    xeomPassword = json['xeom_password'];
    xeomPlate = json['xeom_plate'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['xeom_name'] = xeomName ?? '';
    data['xeom_phone'] = xeomPhone ?? '';
    data['xeom_location'] = xeomLocation ?? '';
    data['xeom_address'] = xeomAddress ?? '';
    data['xeom_email'] = xeomEmail ?? '';
    data['xeom_password'] = xeomPassword ?? '';
    data['xeom_plate'] = xeomPlate ?? '';
    return data;
  }
}

class User {
  String? userName;
  String? name;
  String? phone;
  String? address;
  String? quote;
  String? linkImg;
  String? lat;
  String? lon;
  String? adminName;
  String? shopId;

  User({
    this.userName,
    this.name,
    this.phone,
    this.address,
    this.quote,
    this.linkImg,
    this.lat,
    this.lon,
    this.adminName,
    this.shopId,
  });

  User.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    quote = json['quote'];
    linkImg = json['link_img'];
    lat = json['lat'];
    lon = json['lon'];
    adminName = json['admin_name'];
    shopId = json['shop_id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['user_name'] = userName ?? '';
    data['name'] = name ?? '';
    data['phone'] = phone ?? '';
    data['address'] = address ?? '';
    data['quote'] = quote ?? '';
    data['link_img'] = linkImg ?? '';
    data['lat'] = lat ?? '';
    data['lon'] = lon ?? '';
    data['admin_name'] = adminName ?? '';
    data['shop_id'] = shopId ?? '';
    return data;
  }
}

class ShopDetail {
  String? shopId;
  List<ProductGroups>? productGroups;
  Map<String, List<Products>>? groups;
  bool? condistion;
  List<Products>? products;
  int? type;
  String? shopType;
  String? shopName;
  Shop? shop;
  String? shopPhone;
  String? shopAddress;
  String? email;
  String? facebook;
  String? website;
  String? quote;
  String? code1;
  String? bank;
  String? bankAccountName;
  String? bankAccountNumber;
  String? imgPath;
  num? lat1;
  num? lon1;
  String? url;
  String? buyerAddresses;
  int? shopEbillExist;
  int? system;

  ShopDetail(
      {this.shopId,
      this.productGroups,
      this.groups,
      this.condistion,
      this.products,
      this.type,
      this.shopType,
      this.shopName,
      this.shop,
      this.shopPhone,
      this.shopAddress,
      this.email,
      this.facebook,
      this.website,
      this.quote,
      this.code1,
      this.bank,
      this.bankAccountName,
      this.bankAccountNumber,
      this.imgPath,
      this.lat1,
      this.lon1,
      this.url,
      this.buyerAddresses,
      this.shopEbillExist,
      this.system});

  ShopDetail.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    if (json['product_groups'] != null) {
      productGroups = <ProductGroups>[];
      json['product_groups'].forEach((v) {
        productGroups!.add(ProductGroups.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = {};
      if (json['groups'] is List) {
        for (var i = 0; i < json['groups'].length; i++) {
          groups![(i + 1).toString()] =
              Products.fromListJson(json['groups'][i]);
        }
      } else {
        // productGroups = <ProductGroups>[];
        json['groups'].forEach((key, value) {
          groups![key] = Products.fromListJson(value);
        });
      }
    }
    condistion = json['condistion'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    type = json['type'];
    shopType = json['shop_type'];
    shopName = json['shop_name'];
    shop = json['shop'] != null ? Shop.fromJson(json['shop']) : null;
    shopPhone = json['shop_phone'];
    shopAddress = json['shop_address'];
    email = json['email'];
    facebook = json['facebook'];
    website = json['website'];
    quote = json['quote'];
    code1 = json['code1'];
    bank = json['bank'];
    bankAccountName = json['bank_account_name'];
    bankAccountNumber = json['bank_account_number'];
    imgPath = json['img_path'];
    lat1 = json['lat1'];
    lon1 = json['lon1'];
    url = json['url'];
    buyerAddresses = json['buyer_addresses'];
    shopEbillExist = json['shopEbillExist'];
    system = json['system'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   data['shop_id'] = shopId;
  //   if (productGroups != null) {
  //     data['product_groups'] =
  //         productGroups!.map((v) => v.toJson()).toList();
  //   }
  //   data['condistion'] = condistion;
  //   if (products != null) {
  //     data['products'] = products!.map((v) => v.toJson()).toList();
  //   }
  //   data['type'] = type;
  //   data['shop_type'] = shopType;
  //   data['shop_name'] = shopName;
  //   if (shop != null) {
  //     data['shop'] = shop!.toJson();
  //   }
  //   data['shop_phone'] = shopPhone;
  //   data['shop_address'] = shopAddress;
  //   data['email'] = email;
  //   data['facebook'] = facebook;
  //   data['website'] = website;
  //   data['quote'] = quote;
  //   data['code1'] = code1;
  //   data['bank'] = bank;
  //   data['bank_account_name'] = bankAccountName;
  //   data['bank_account_number'] = bankAccountNumber;
  //   data['img_path'] = imgPath;
  //   data['lat1'] = lat1;
  //   data['lon1'] = lon1;
  //   data['url'] = url;
  //   data['buyer_addresses'] = buyerAddresses;
  //   data['shopEbillExist'] = shopEbillExist;
  //   data['system'] = system;
  //   return data;
  // }
}

class ProductGroups {
  String? id;
  String? shopId;
  String? name;
  String? status;
  String? type;
  String? sort;

  ProductGroups(
      {this.id, this.shopId, this.name, this.status, this.type, this.sort});

  ProductGroups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    name = json['name'];
    status = json['status'];
    type = json['type'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['name'] = name;
    data['status'] = status;
    data['type'] = type;
    data['sort'] = sort;
    return data;
  }
}

class Products {
  String? id;
  String? productName;
  String? unitDefault;
  String? imageFile;
  String? listPrice;

  Products(
      {this.id,
      this.productName,
      this.unitDefault,
      this.imageFile,
      this.listPrice});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    unitDefault = json['unit_default'];
    imageFile = json['image_file'];
    listPrice = json['list_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['unit_default'] = unitDefault;
    data['image_file'] = imageFile;
    data['list_price'] = listPrice;
    return data;
  }

  static List<Products> fromListJson(Iterable list) {
    return list.map((data) => Products.fromJson(data)).toList();
  }
}

class Shop {
  String? id;
  String? name;
  String? memberId;
  String? note;
  String? domain;
  String? code;
  String? code1;
  String? country;
  String? state;
  String? district;
  String? ward;
  String? locationId;
  String? address;
  String? phone;
  String? email;
  String? type;
  String? promotionCode;
  String? registered;
  String? expired;
  String? paid;
  String? position;
  String? table;
  String? productGroup;
  String? product;
  String? customer;
  String? parent;
  String? children;
  String? subs;
  String? ip;
  String? session;
  String? gpp;
  String? pharmRepresentative;
  String? pharmRepresentativeId;
  String? pharmType;
  String? pharmResponsible;
  String? pharmResponsibleNo;
  String? pharmResponsibleId;
  String? pharmResponsibleLevel;
  String? pharmResponsiblePhone;
  String? pharmResponsibleEmail;
  String? lastLogin;
  String? last777;
  String? pharmUsr;
  String? pharmPwd;
  String? pharmMonitor;
  String? dealerKey;
  String? status;
  String? negativeStock;
  String? micro;
  String? ebill;
  String? phoneInReceipt;
  String? type1;
  String? note1;
  String? lon;
  String? lat;
  String? quote;
  String? tiem;
  String? muongi;
  String? segment;
  String? bank;
  String? bankAccountName;
  String? bankAccountNumber;
  String? mg;
  String? facebook;
  String? website;
  String? minvoiceUsername;
  String? minvoicePassword;
  String? minvoiceBranchCode;
  String? eBill;
  String? tt40;
  String? nd15;
  String? large;
  String? owner;
  String? taxCode;
  String? periodClosedDate;
  String? precision;
  String? qrcodeBank;
  String? qrcodeShop;
  String? bankID;
  String? bankId;
  String? linkOnline;
  String? linkImg;
  String? promotion;
  String? banner;
  String? brandName;

  Shop(
      {this.id,
      this.name,
      this.memberId,
      this.note,
      this.domain,
      this.code,
      this.code1,
      this.country,
      this.state,
      this.district,
      this.ward,
      this.locationId,
      this.address,
      this.phone,
      this.email,
      this.type,
      this.promotionCode,
      this.registered,
      this.expired,
      this.paid,
      this.position,
      this.table,
      this.productGroup,
      this.product,
      this.customer,
      this.parent,
      this.children,
      this.subs,
      this.ip,
      this.session,
      this.gpp,
      this.pharmRepresentative,
      this.pharmRepresentativeId,
      this.pharmType,
      this.pharmResponsible,
      this.pharmResponsibleNo,
      this.pharmResponsibleId,
      this.pharmResponsibleLevel,
      this.pharmResponsiblePhone,
      this.pharmResponsibleEmail,
      this.lastLogin,
      this.last777,
      this.pharmUsr,
      this.pharmPwd,
      this.pharmMonitor,
      this.dealerKey,
      this.status,
      this.negativeStock,
      this.micro,
      this.ebill,
      this.phoneInReceipt,
      this.type1,
      this.note1,
      this.lon,
      this.lat,
      this.quote,
      this.tiem,
      this.muongi,
      this.segment,
      this.bank,
      this.bankAccountName,
      this.bankAccountNumber,
      this.mg,
      this.facebook,
      this.website,
      this.minvoiceUsername,
      this.minvoicePassword,
      this.minvoiceBranchCode,
      this.eBill,
      this.tt40,
      this.nd15,
      this.large,
      this.owner,
      this.taxCode,
      this.periodClosedDate,
      this.precision,
      this.qrcodeBank,
      this.qrcodeShop,
      this.bankID,
      this.bankId,
      this.linkOnline,
      this.linkImg,
      this.promotion,
      this.banner,
      this.brandName});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    memberId = json['member_id'];
    note = json['note'];
    domain = json['domain'];
    code = json['code'];
    code1 = json['code1'];
    country = json['country'];
    state = json['state'];
    district = json['district'];
    ward = json['ward'];
    locationId = json['location_id'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    type = json['type'];
    promotionCode = json['promotion_code'];
    registered = json['registered'];
    expired = json['expired'];
    paid = json['paid'];
    position = json['position'];
    table = json['table'];
    productGroup = json['product_group'];
    product = json['product'];
    customer = json['customer'];
    parent = json['parent'];
    children = json['children'];
    subs = json['subs'];
    ip = json['ip'];
    session = json['session'];
    gpp = json['gpp'];
    pharmRepresentative = json['pharm_representative'];
    pharmRepresentativeId = json['pharm_representative_id'];
    pharmType = json['pharm_type'];
    pharmResponsible = json['pharm_responsible'];
    pharmResponsibleNo = json['pharm_responsible_no'];
    pharmResponsibleId = json['pharm_responsible_id'];
    pharmResponsibleLevel = json['pharm_responsible_level'];
    pharmResponsiblePhone = json['pharm_responsible_phone'];
    pharmResponsibleEmail = json['pharm_responsible_email'];
    lastLogin = json['last_login'];
    last777 = json['last_777'];
    pharmUsr = json['pharm_usr'];
    pharmPwd = json['pharm_pwd'];
    pharmMonitor = json['pharm_monitor'];
    dealerKey = json['dealer_key'];
    status = json['status'];
    negativeStock = json['negative_stock'];
    micro = json['micro'];
    ebill = json['ebill'];
    phoneInReceipt = json['phone_in_receipt'];
    type1 = json['type1'];
    note1 = json['note1'];
    lon = json['lon'];
    lat = json['lat'];
    quote = json['quote'];
    tiem = json['tiem'];
    muongi = json['muongi'];
    segment = json['segment'];
    bank = json['bank'];
    bankAccountName = json['bank_account_name'];
    bankAccountNumber = json['bank_account_number'];
    mg = json['mg'];
    facebook = json['facebook'];
    website = json['website'];
    minvoiceUsername = json['minvoice_username'];
    minvoicePassword = json['minvoice_password'];
    minvoiceBranchCode = json['minvoice_branch_code'];
    eBill = json['e_bill'];
    tt40 = json['tt40'];
    nd15 = json['nd15'];
    large = json['large'];
    owner = json['owner'];
    taxCode = json['tax_code'];
    periodClosedDate = json['period_closed_date'];
    precision = json['precision'];
    qrcodeBank = json['qrcode_bank'];
    qrcodeShop = json['qrcode_shop'];
    bankID = json['bank_id'];
    bankId = json['bankId'];
    linkOnline = json['link_online'];
    linkImg = json['link_img'];
    promotion = json['promotion'];
    banner = json['banner'];
    brandName = json['brand_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['member_id'] = memberId;
    data['note'] = note;
    data['domain'] = domain;
    data['code'] = code;
    data['code1'] = code1;
    data['country'] = country;
    data['state'] = state;
    data['district'] = district;
    data['ward'] = ward;
    data['location_id'] = locationId;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['type'] = type;
    data['promotion_code'] = promotionCode;
    data['registered'] = registered;
    data['expired'] = expired;
    data['paid'] = paid;
    data['position'] = position;
    data['table'] = table;
    data['product_group'] = productGroup;
    data['product'] = product;
    data['customer'] = customer;
    data['parent'] = parent;
    data['children'] = children;
    data['subs'] = subs;
    data['ip'] = ip;
    data['session'] = session;
    data['gpp'] = gpp;
    data['pharm_representative'] = pharmRepresentative;
    data['pharm_representative_id'] = pharmRepresentativeId;
    data['pharm_type'] = pharmType;
    data['pharm_responsible'] = pharmResponsible;
    data['pharm_responsible_no'] = pharmResponsibleNo;
    data['pharm_responsible_id'] = pharmResponsibleId;
    data['pharm_responsible_level'] = pharmResponsibleLevel;
    data['pharm_responsible_phone'] = pharmResponsiblePhone;
    data['pharm_responsible_email'] = pharmResponsibleEmail;
    data['last_login'] = lastLogin;
    data['last_777'] = last777;
    data['pharm_usr'] = pharmUsr;
    data['pharm_pwd'] = pharmPwd;
    data['pharm_monitor'] = pharmMonitor;
    data['dealer_key'] = dealerKey;
    data['status'] = status;
    data['negative_stock'] = negativeStock;
    data['micro'] = micro;
    data['ebill'] = ebill;
    data['phone_in_receipt'] = phoneInReceipt;
    data['type1'] = type1;
    data['note1'] = note1;
    data['lon'] = lon;
    data['lat'] = lat;
    data['quote'] = quote;
    data['tiem'] = tiem;
    data['muongi'] = muongi;
    data['segment'] = segment;
    data['bank'] = bank;
    data['bank_account_name'] = bankAccountName;
    data['bank_account_number'] = bankAccountNumber;
    data['mg'] = mg;
    data['facebook'] = facebook;
    data['website'] = website;
    data['minvoice_username'] = minvoiceUsername;
    data['minvoice_password'] = minvoicePassword;
    data['minvoice_branch_code'] = minvoiceBranchCode;
    data['e_bill'] = eBill;
    data['tt40'] = tt40;
    data['nd15'] = nd15;
    data['large'] = large;
    data['owner'] = owner;
    data['tax_code'] = taxCode;
    data['period_closed_date'] = periodClosedDate;
    data['precision'] = precision;
    data['qrcode_bank'] = qrcodeBank;
    data['qrcode_shop'] = qrcodeShop;
    data['bank_id'] = bankId;
    data['bankId'] = bankId;
    data['link_online'] = linkOnline;
    data['link_img'] = linkImg;
    data['promotion'] = promotion;
    data['banner'] = banner;
    data['brand_name'] = brandName;
    return data;
  }
}

class CheckoutModel {
  String? name;
  String? note;
  String? buyerName;
  String? buyerPhone;
  String? buyerAddress;
  String? shopName;
  String? shopAddress;
  String? shopPhone;
  String? payment;
  String? lat1;
  String? lon1;
  String? lat2;
  String? lon2;
  String? qrcode;
  int? shippingCost;
  String? shippingTimeSlotFrom;
  String? shippingTimeSlotTo;
  String? shippingTimeSlot;
  String? system;
  List<CartItem> data;
  String? shopId;
  String? bank;
  String? bankId;
  String? bankAccountName;
  String? bankAccountNumber;

  CheckoutModel({
    this.name,
    this.note,
    this.buyerName,
    this.buyerPhone,
    this.buyerAddress,
    this.shopAddress,
    this.shopName,
    this.shopPhone,
    this.payment,
    this.lat1,
    this.lon1,
    this.lat2,
    this.lon2,
    this.qrcode,
    this.shippingCost,
    this.shippingTimeSlotFrom,
    this.shippingTimeSlotTo,
    this.shippingTimeSlot,
    this.system,
    this.bank,
    this.bankId,
    this.bankAccountName,
    this.bankAccountNumber,
    List<CartItem>? data,
    this.shopId,
  }) : data = data ?? [];

  static CheckoutModel fromJson(Map<String, dynamic> json) {
    final model = CheckoutModel();
    model.name = json['name'];
    model.note = json['note'];
    model.buyerName = json['buyer_name'];
    model.buyerPhone = json['buyer_phone'];
    model.buyerAddress = json['buyer_address'];
    model.shopAddress = json['shop_address'];
    model.shopName = json['shop_name'];
    model.shopPhone = json['shop_phone'];
    model.payment = json['payment'];
    model.lat1 = json['lat1'];
    model.lon1 = json['lon1'];
    model.lat2 = json['lat2'];
    model.lon2 = json['lon2'];
    model.qrcode = json['qrcode'];
    model.shippingCost = int.tryParse(json['shipping_cost'] ?? '0') ?? 0;
    model.shippingTimeSlotFrom = json['shipping_time_slot_from'];
    model.shippingTimeSlotTo = json['shipping_time_slot_to'];
    model.shippingTimeSlot = json['shipping_time_slot'];
    model.system = json['system'];
    model.bank = json['bank'];
    model.bankId = json['bankId'];
    model.bankAccountName = json['bank_account_name'];
    model.bankAccountNumber = json['bank_account_number'];
    if (json['data'] != null) {
      final data = jsonDecode(json['data']!);
      model.data = <CartItem>[];
      data.forEach((v) {
        model.data.add(CartItem.fromJson(v));
      });
    }
    model.shopId = json['shop_id'];
    return model;
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['name'] = name ?? '';
    data['note'] = note ?? '';
    data['buyer_name'] = buyerName ?? '';
    data['buyer_phone'] = buyerPhone ?? '';
    data['buyer_address'] = buyerAddress ?? '';
    data['shop_address'] = shopAddress ?? '';
    data['shop_name'] = shopName ?? '';
    data['shop_phone'] = shopPhone ?? '';
    data['payment'] = payment ?? '';
    data['lat1'] = lat1 ?? '';
    data['lon1'] = lon1 ?? '';
    data['lat2'] = lat2 ?? '';
    data['lon2'] = lon2 ?? '';
    data['qrcode'] = qrcode ?? '';
    data['bank'] = bank ?? '';
    data['bankId'] = bankId ?? '';
    data['bank_account_name'] = bankAccountName ?? '';
    data['bank_account_number'] = bankAccountNumber ?? '';
    data['shipping_cost'] = (shippingCost ?? 0.0).toString();
    data['shipping_time_slot_from'] = shippingTimeSlotFrom ?? '';
    data['shipping_time_slot_to'] = shippingTimeSlotTo ?? '';
    data['shipping_time_slot'] = shippingTimeSlot ?? '';
    data['system'] = system ?? '';
    data['data'] = jsonEncode(this.data.map((v) => v.toJson()).toList());
    data['shop_id'] = shopId ?? '';
    return data;
  }
}

class CartItem {
  String? productId;
  String? productName;
  int quantity = 0;
  num? price;
  num? subTotal;
  String? unitDefault;
  String? image;
  CartItem({
    this.productId,
    this.productName,
    this.quantity = 0,
    this.price,
    this.subTotal,
    this.unitDefault,
    this.image,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'].toString();
    productName = json['product_name'];
    image = json['image'];
    quantity = int.parse(json['quantity'] ?? '0');
    price = double.parse(json['price'] ?? '0.0');
    subTotal = double.parse(json['sub_total'] ?? '0.0');
  }

  CartItem.fromCartJson(Map<String, dynamic> json) {
    productId = json['product_id'].toString();
    productName = json['product_name'];
    image = json['image'];
    quantity = json['product_quantity'] ?? 0;
    price = json['list_price'] ?? 0.0;
    subTotal = quantity * price!;
  }

  CartItem.fromCartShopJson(Map<String, dynamic> json) {
    productId = json['id'].toString();
    productName = json['product_name'];
    image = json['image_file'];
    quantity = json['count'] ?? 0;
    price = json['list_price'] ?? 0.0;
    subTotal = quantity * price!;
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['product_id'] = productId ?? '';
    data['product_name'] = productName ?? '';
    data['quantity'] = quantity.toString();
    data['price'] = price.toString();
    data['sub_total'] = subTotal.toString();
    data['image'] = image ?? '';
    return data;
  }

  Map<String, String> toSyncCartJson() {
    final Map<String, String> data = <String, String>{};
    data['id'] = productId ?? '';
    data['quantity'] = quantity.toString();
    return data;
  }

  static List<Map<String, String>> toListSyncCartJson(Iterable<CartItem> list) {
    return list.map((data) => data.toSyncCartJson()).toList();
  }

  static List<CartItem> fromListCartJson(Iterable list) {
    return list.map((data) => CartItem.fromCartJson(data)).toList();
  }

  static List<CartItem> fromListCartShopJson(Iterable list) {
    return list.map((data) => CartItem.fromCartShopJson(data)).toList();
  }
}

class CartModel {
  String? buyerId;
  String? shopId;
  String? shopName;
  List<CartItem> products;

  CartModel({this.buyerId, this.shopId, this.shopName, required this.products});

  static CartModel fromJson(Map<String, dynamic> json) {
    final model = CartModel(products: []);
    model.buyerId = json['buyer_id'];
    model.shopId = json['shop_id'];
    model.shopName = json['shop_name'];
    final stringProducts = json['products'];
    model.products = CartItem.fromListCartJson(jsonDecode(stringProducts));
    return model;
  }

  static List<CartModel> fromListJson(Iterable list) {
    return list.map((data) => CartModel.fromJson(data)).toList();
  }
}

class FindShipper {
  List<Xeoms>? xeoms;

  FindShipper({this.xeoms});

  FindShipper.fromJson(Map<String, dynamic> json) {
    if (json['xeoms'] != null) {
      xeoms = <Xeoms>[];
      json['xeoms'].forEach((v) {
        xeoms!.add(Xeoms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (xeoms != null) {
      data['xeoms'] = xeoms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Xeoms {
  String? id;
  String? name;
  String? cmnd;
  String? phone;
  String? address;
  String? lat;
  String? lon;
  String? countOrder;
  String? distance;
  String? portrait;
  String? linkImg;
  String? plate;

  Xeoms(
      {this.id,
      this.name,
      this.cmnd,
      this.phone,
      this.address,
      this.lat,
      this.lon,
      this.countOrder,
      this.distance,
      this.portrait,
      this.linkImg,
      this.plate});

  Xeoms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cmnd = json['cmnd'];
    phone = json['phone'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    countOrder = json['count_order'];
    distance = json['distance'];
    portrait = json['portrait'];
    linkImg = json['link_img'];
    plate = json['plate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cmnd'] = cmnd;
    data['phone'] = phone;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['count_order'] = countOrder;
    data['distance'] = distance;
    data['portrait'] = portrait;
    data['link_img'] = linkImg;
    data['plate'] = plate;
    return data;
  }
}
