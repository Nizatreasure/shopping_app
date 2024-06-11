import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';

class CartModel {
  final int id;
  final String docID;
  final String productName;
  final String brandName;
  final String color;
  final num size;
  final PriceModel price;
  final int quantity;
  final String imageUrl;
  final int productID;
  final String productDocumentID;

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
  });

  factory CartModel.fromProduct(
    ProductModel product, {
    required String color,
    num size = 1,
    int id = 0,
    int quantity = 1,
    String docID = '',
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
    );
  }

  factory CartModel.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CartModel(
      id: ((data['id'] ?? 0) as num).toInt(),
      docID: doc.id,
      productName: data['product_name'] ?? '',
      brandName: data['brand_name'] ?? '',
      color: data['color'] ?? '',
      size: data['size'] ?? 0,
      price: PriceModel.fromJson(data['price'] ?? {}),
      quantity: ((data['quantity'] ?? 0) as num).toInt(),
      imageUrl: data['imageUrl'] ?? '',
      productID: ((data['product_id'] ?? 0) as num).toInt(),
      productDocumentID: data['product_document_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'brand_name': brandName,
      'color': color,
      'size': size,
      'price': price.toJson(),
      'quantity': quantity,
      'image_url': imageUrl,
      'product_id': productID,
      'product_document_id': productDocumentID,
    };
  }

  // copyWith method
  CartModel copyWith({
    String? productName,
    String? brandName,
    String? color,
    num? size,
    PriceModel? price,
    int? quantity,
    String? imageUrl,
    int? productID,
    String? productDocumentID,
    int? id,
    String? docID,
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
    );
  }
}
