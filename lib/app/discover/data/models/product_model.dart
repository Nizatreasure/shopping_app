import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/core/common/functions/functions.dart';

//model class for products
class ProductModel {
  final int id;
  final String name;
  final String gender;
  final String brand;
  final String documentID;
  final String description;
  final List<num> sizes;
  final List<String> images;
  final List<ColorModel> colors;
  final DateTime createdAt;
  final PriceModel price;
  final ReviewInfoModel reviewInfo;

  ProductModel({
    required this.id,
    required this.gender,
    required this.createdAt,
    required this.price,
    required this.documentID,
    required this.reviewInfo,
    required this.brand,
    required this.description,
    required this.sizes,
    required this.name,
    required this.images,
    required this.colors,
  });

  factory ProductModel.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: ((data['id'] ?? 0) as num).toInt(),
      documentID: doc.id,
      gender: data['gender'] ?? '',
      createdAt: (data['created_at'] as Timestamp? ?? Timestamp.now()).toDate(),
      price: PriceModel.fromJson(data['price'] ?? {}),
      reviewInfo: ReviewInfoModel.fromJson(data['review_info'] ?? {}),
      brand: data['brand'] ?? '',
      description: data['description'] ?? '',
      sizes: List<num>.from((data['sizes'] as List? ?? []).map((size) => size)),
      name: data['name'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      colors: List<ColorModel>.from((data['colors'] as List? ?? [])
          .map((color) => ColorModel.fromJson(color))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'created_at': Timestamp.fromDate(createdAt),
      'price': price.toJson(),
      'review_info': reviewInfo.toJson(),
      'brand': brand,
      'description': description,
      'sizes': sizes,
      'name': name,
      'images': images,
      'colors': colors.map((color) => color.toJson()).toList(),
    };
  }
}

class PriceModel {
  final double amount;
  final String currency;
  final String symbol;

  PriceModel({
    required this.amount,
    required this.currency,
    required this.symbol,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      amount: ((json['amount'] ?? 0.0) as num).toDouble(),
      currency: json['currency'] ?? '',
      symbol: json['symbol'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'symbol': symbol,
    };
  }
}

class ReviewInfoModel {
  final int totalReviews;
  final double averageRating;

  ReviewInfoModel({
    required this.totalReviews,
    required this.averageRating,
  });

  factory ReviewInfoModel.fromJson(Map<String, dynamic> json) {
    return ReviewInfoModel(
      totalReviews: ((json['total_reviews'] ?? 0) as num).toInt(),
      averageRating: ((json['average_rating'] ?? 0) as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_reviews': totalReviews,
      'average_rating': averageRating,
    };
  }
}

class ColorModel {
  final Color color;
  final String name;

  ColorModel({
    required this.color,
    required this.name,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      color: convertHexToColor(json['hex'] ?? ''),
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hex': '#${color.value.toRadixString(16).substring(2)}',
      'name': name,
    };
  }
}
