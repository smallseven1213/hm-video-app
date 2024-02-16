class GiftMessageData {
  int gid;
  int quantity;
  int animationLayout;

  GiftMessageData(
      {required this.gid,
      required this.quantity,
      required this.animationLayout});

  factory GiftMessageData.fromJSON(Map<String, dynamic> json) {
    return GiftMessageData(
      gid: json['gid'] as int,
      quantity: json['quantity'] as int,
      animationLayout: json['animation_layout'] as int,
    );
  }
}
