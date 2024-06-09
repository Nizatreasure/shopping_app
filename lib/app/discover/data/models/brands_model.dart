//model class for brands
class BrandsModel {
  final String name;
  final String logo;

  BrandsModel({required this.name, required this.logo});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
    };
  }

  factory BrandsModel.fromJson(Map<String, dynamic> json) {
    return BrandsModel(
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}
