import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';

class OrderSummaryModel {
  final int orderID;
  final double subTotal;
  final double shippingCost;
  final String location;
  final String paymentMethod;
  final List<CartModel> orderDetails;
  final DateTime createdAt;
  final String docID;

  OrderSummaryModel({
    required this.orderID,
    required this.subTotal,
    required this.shippingCost,
    required this.location,
    required this.paymentMethod,
    required this.orderDetails,
    required this.createdAt,
    required this.docID,
  });

  double get grandTotal => subTotal + shippingCost;

  OrderSummaryModel copyWith({
    double? subTotal,
    double? shippingCost,
    String? location,
    String? paymentMethod,
    List<CartModel>? orderDetails,
    DateTime? createdAt,
    String? docID,
    int? orderID,
  }) {
    return OrderSummaryModel(
      subTotal: subTotal ?? this.subTotal,
      shippingCost: shippingCost ?? this.shippingCost,
      location: location ?? this.location,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderDetails: orderDetails ?? this.orderDetails,
      createdAt: createdAt ?? this.createdAt,
      docID: docID ?? this.docID,
      orderID: orderID ?? this.orderID,
    );
  }

  factory OrderSummaryModel.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderSummaryModel(
      orderID: ((data['order_id'] ?? 0) as num).toInt(),
      docID: doc.id,
      subTotal: ((data['sub_total'] ?? 0) as num).toDouble(),
      shippingCost: ((data['shipping_cost'] ?? 0) as num).toDouble(),
      location: data['location'] ?? '',
      paymentMethod: data['payment_method'] ?? '',
      orderDetails: ((data['order_details'] ?? []) as List)
          .map((item) => CartModel.fromJson(item))
          .toList(),
      createdAt:
          ((data['created_at'] ?? Timestamp.now()) as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderID,
      'sub_total': subTotal,
      'shipping_cost': shippingCost,
      'location': location,
      'payment_method': paymentMethod,
      'order_details': orderDetails.map((item) => item.toJson()).toList(),
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
