//model class for brands
class BrandsModel {
  final String name;
  final String logo;
  final int totalProductCount;

  const BrandsModel(
      {required this.name,
      required this.logo,
      required this.totalProductCount});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
      'total_product_count': totalProductCount,
    };
  }

  factory BrandsModel.fromJson(Map<String, dynamic> json) {
    return BrandsModel(
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      totalProductCount: json['total_product_count'] ?? 0,
    );
  }
  BrandsModel copyWith({String? name, String? logo, int? totalProductCount}) {
    return BrandsModel(
        name: name ?? this.name,
        logo: logo ?? this.logo,
        totalProductCount: totalProductCount ?? this.totalProductCount);
  }
}
