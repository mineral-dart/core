final class AvatarDecoration {
  final String skuId;
  final String asset;

  AvatarDecoration({ required this.skuId, required this.asset });

  factory AvatarDecoration.fromJson(Map<String, dynamic> json) {
    return AvatarDecoration(skuId: json['sku_id'], asset: json['asset']);
  }
}
