class ItemPreviewModel {
  final String image;
  final String name;
  final double averageRating;
  final int totalReviews;
  final double price;

  ItemPreviewModel({
    required this.image,
    required this.name,
    required this.averageRating,
    required this.totalReviews,
    required this.price,
  });

  factory ItemPreviewModel.fromJson(Map<String, dynamic> json) {
    return ItemPreviewModel(
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      averageRating: ((json['averageRating'] ?? 0) as num).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      price: ((json['price'] ?? 0) as num).toDouble(),
    );
  }
}
