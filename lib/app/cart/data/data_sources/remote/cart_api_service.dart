import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';
import 'package:shopping_app/app/cart/data/models/order_summary_model.dart';

class CartApiService {
  final FirebaseFirestore _firestore;
  const CartApiService(this._firestore);

  CollectionReference get _cartReference => _firestore.collection('cart');
  DocumentReference get _cartCounterReference =>
      _firestore.doc('counters/cart');
  DocumentReference get _orderHistoryCounterReference =>
      _firestore.doc('counters/order_history');
  CollectionReference get _historyRerence =>
      _firestore.collection('order_history');

  Future<void> addProductToCart(CartModel cartModel) async {
    await _firestore.runTransaction((transaction) async {
      //Get the current maximum assigned ID from the database
      DocumentSnapshot cartCounterSnapshot =
          await transaction.get(_cartCounterReference);

      int currentMaxId = (cartCounterSnapshot.data()
              as Map<String, dynamic>?)?['cart_max_id'] ??
          0;

      //Increment the current max ID
      int newCartItemId = currentMaxId + 1;

      // Update the counter document with the new max ID
      transaction.set(_cartCounterReference, {'cart_max_id': newCartItemId});

      CartModel cartItem = cartModel.copyWith(id: newCartItemId);

      await _cartReference
          .withConverter<CartModel>(
              fromFirestore: (snapshot, _) => CartModel.fromSnapshot(snapshot),
              toFirestore: (cart, _) => cart.toJson())
          .add(cartItem);
    });
  }

  //Using firebase stream so that the cart would be up-to-date with
  //the latest information once a change occurs in the collection
  Stream<List<CartDocumentChangedModel>> getCartItems() {
    //order the cart items to display the latest additions first
    return _cartReference
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docChanges.map((doc) {
        return CartDocumentChangedModel.fromSnapshot(doc);
      }).toList();
    });
  }

  //update the product quantity in the database
  Future<void> updateCartItem(
      {required CartModel cartModel, required String cartDocumentID}) async {
    await _cartReference.doc(cartDocumentID).update(cartModel.toJson());
  }

  //update the product quantity in the database
  Future<void> deleteProductFromCart(String cartDocumentID) async {
    await _cartReference.doc(cartDocumentID).delete();
  }

  //make payment creates a record in the history collection and empties
  //the cart
  Future<void> makePaymentForCart(OrderSummaryModel order) async {
    await _firestore.runTransaction((transaction) async {
      //Get the current maximum assigned ID from the database
      DocumentSnapshot orderHistoryCounterSnapshot =
          await transaction.get(_orderHistoryCounterReference);

      int currentMaxId = (orderHistoryCounterSnapshot.data()
              as Map<String, dynamic>?)?['order_history_count'] ??
          0;

      //Increment the current max ID
      int newOrderID = currentMaxId + 1;

      // Update the counter document with the new max ID
      transaction.set(
          _orderHistoryCounterReference, {'order_history_count': newOrderID});

      OrderSummaryModel orderItem = order.copyWith(orderID: newOrderID);

      await _historyRerence
          .withConverter<OrderSummaryModel>(
              fromFirestore: (snapshot, _) =>
                  OrderSummaryModel.fromSnapshot(snapshot),
              toFirestore: (order, _) => order.toJson())
          .add(orderItem);

      //empty the cart
      QuerySnapshot cartSnapshot = await _cartReference.get();

      for (QueryDocumentSnapshot doc in cartSnapshot.docs) {
        transaction.delete(doc.reference);
      }
    });
  }
}
