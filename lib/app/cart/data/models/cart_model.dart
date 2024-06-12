import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';

class CartModel {
  final int id;
  final String docID;
  final String productName;
  final String brandName;
  final ColorModel color;
  final num size;
  final PriceModel price;
  final int quantity;
  final String imageUrl;
  final int productID;
  final String productDocumentID;
  final Key imageKey;
  final DateTime createdAt;
  final GlobalKey itemKey;

  //used to track when a cart object is updating
  final bool loading;

  double get totalPrice => price.amount * quantity;

  CartModel({
    required this.id,
    required this.docID,
    required this.productName,
    required this.brandName,
    required this.color,
    required this.size,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.productID,
    required this.productDocumentID,
    required this.imageKey,
    this.loading = false,
    required this.createdAt,
    required this.itemKey,
  });

  factory CartModel.fromProduct(
    ProductModel product, {
    required ColorModel color,
    num size = 1,
    int id = 0,
    int quantity = 1,
    String docID = '',
    DateTime? createdAt,
  }) {
    return CartModel(
      id: id,
      docID: docID,
      productName: product.name,
      brandName: product.brand.name,
      color: color,
      size: size,
      price: product.price,
      quantity: quantity,
      imageUrl: product.images.first.image,
      productID: product.id,
      productDocumentID: product.documentID,
      imageKey: UniqueKey(),
      itemKey: GlobalKey(),
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  factory CartModel.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CartModel(
      id: ((data['id'] ?? 0) as num).toInt(),
      createdAt:
          ((data['created_at'] ?? Timestamp.now()) as Timestamp).toDate(),
      docID: doc.id,
      productName: data['product_name'] ?? '',
      brandName: data['brand_name'] ?? '',
      color: ColorModel.fromJson(data['color'] ?? {}),
      size: data['size'] ?? 0,
      price: PriceModel.fromJson(data['price'] ?? {}),
      quantity: ((data['quantity'] ?? 0) as num).toInt(),
      imageUrl: data['image_url'] ?? '',
      productID: ((data['product_id'] ?? 0) as num).toInt(),
      productDocumentID: data['product_document_id'] ?? '',
      imageKey: UniqueKey(),
      itemKey: GlobalKey(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'brand_name': brandName,
      'color': color.toJson(),
      'size': size,
      'price': price.toJson(),
      'quantity': quantity,
      'image_url': imageUrl,
      'product_id': productID,
      'product_document_id': productDocumentID,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  // copyWith method
  CartModel copyWith({
    String? productName,
    String? brandName,
    ColorModel? color,
    num? size,
    PriceModel? price,
    int? quantity,
    String? imageUrl,
    int? productID,
    String? productDocumentID,
    int? id,
    String? docID,
    Key? imageKey,
    bool? loading,
    DateTime? createdAt,
    GlobalKey? itemKey,
  }) {
    return CartModel(
      id: id ?? this.id,
      docID: docID ?? this.docID,
      productName: productName ?? this.productName,
      brandName: brandName ?? this.brandName,
      color: color ?? this.color,
      size: size ?? this.size,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      productID: productID ?? this.productID,
      productDocumentID: productDocumentID ?? this.productDocumentID,
      imageKey: imageKey ?? this.imageKey,
      loading: loading ?? this.loading,
      createdAt: createdAt ?? this.createdAt,
      itemKey: itemKey ?? this.itemKey,
    );
  }
}

class CartDocumentChangedModel {
  final CartModel cartModel;
  final DocumentChangeType type;
  final int oldIndex;
  final int newIndex;
  const CartDocumentChangedModel(
      {required this.cartModel,
      required this.type,
      required this.oldIndex,
      required this.newIndex});

  factory CartDocumentChangedModel.fromJson(DocumentChange doc) {
    return CartDocumentChangedModel(
      cartModel: CartModel.fromJson(doc.doc),
      type: doc.type,
      oldIndex: doc.oldIndex,
      newIndex: doc.newIndex,
    );
  }
}
