class BuyerMessages {
  String? id;
  String? shopId;
  String? buyerId;
  String? type;
  String? orderId;
  String? subject;
  String? content;
  String? time;
  String? parent;
  String? auxId;
  String? status;
  String? messageType;

  BuyerMessages(
      {this.id,
      this.shopId,
      this.buyerId,
      this.type,
      this.orderId,
      this.subject,
      this.content,
      this.time,
      this.parent,
      this.auxId,
      this.status,
      this.messageType});

  BuyerMessages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    buyerId = json['buyer_id'];
    type = json['type'];
    orderId = json['order_id'];
    subject = json['subject'];
    content = json['content'];
    time = json['time'];
    parent = json['parent'];
    auxId = json['aux_id'];
    status = json['status'];
    messageType = json['message_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['buyer_id'] = buyerId;
    data['type'] = type;
    data['order_id'] = orderId;
    data['subject'] = subject;
    data['content'] = content;
    data['time'] = time;
    data['parent'] = parent;
    data['aux_id'] = auxId;
    data['status'] = status;
    data['message_type'] = messageType;
    return data;
  }
}
