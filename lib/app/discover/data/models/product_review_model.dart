import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/network/data_status.dart';

class ProductReviewModel {
  final DateTime createdAt;
  final String image;
  final String name;
  final int productID;
  final int rating;
  final String review;
  final String documentID;
  final Key imageKey;

  ProductReviewModel({
    required this.createdAt,
    required this.image,
    required this.name,
    required this.productID,
    required this.rating,
    required this.review,
    required this.documentID,
    required this.imageKey,
  });

  factory ProductReviewModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductReviewModel(
      createdAt: (data['created_at'] as Timestamp? ?? Timestamp.now()).toDate(),
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      productID: ((data['product_id'] ?? 0) as num).toInt(),
      rating: ((data['rating'] ?? 0) as num).toInt(),
      review: data['review'] ?? '',
      documentID: doc.id,
      imageKey: UniqueKey(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': Timestamp.fromDate(createdAt),
      'image': image,
      'name': name,
      'product_id': productID,
      'rating': rating,
      'review': review,
    };
  }

  ProductReviewModel copyWith({
    DateTime? createdAt,
    String? image,
    String? name,
    int? productID,
    int? rating,
    String? review,
    String? documentID,
    Key? imageKey,
  }) {
    return ProductReviewModel(
      createdAt: createdAt ?? this.createdAt,
      image: image ?? this.image,
      name: name ?? this.name,
      productID: productID ?? this.productID,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      documentID: documentID ?? this.documentID,
      imageKey: imageKey ?? this.imageKey,
    );
  }
}

class ProductReviewTabModel {
  final List<ProductReviewModel>? reviews;
  final DataStatus status;
  final String tabTitle;
  final int? stars;

  bool get loading =>
      status.state == DataState.initial || status.state == DataState.loading;

  bool get loadingError => status.state == DataState.failure;

  const ProductReviewTabModel({
    this.reviews,
    this.status = const DataStatus(state: DataState.initial),
    required this.tabTitle,
    required this.stars,
  });

  ProductReviewTabModel copyWith(
      {List<ProductReviewModel>? reviews, DataStatus? status}) {
    return ProductReviewTabModel(
      reviews: reviews ?? this.reviews,
      status: status ?? this.status,
      tabTitle: tabTitle,
      stars: stars,
    );
  }
}
