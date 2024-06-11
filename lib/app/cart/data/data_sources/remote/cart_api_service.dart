import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';

class CartApiService {
  final FirebaseFirestore _firestore;
  const CartApiService(this._firestore);

  CollectionReference get _cartReference => _firestore.collection('cart');
  DocumentReference get _counterReference =>
      _firestore.collection('counters').doc('cart');

  Future<void> addProductToCart(CartModel cartModel) async {
    await _firestore.runTransaction((transaction) async {
      //Get the current maximum assigned ID from the database
      DocumentSnapshot counterSnapshot =
          await transaction.get(_counterReference);

      int currentMaxId =
          (counterSnapshot.data() as Map<String, dynamic>?)?['cart_max_id'] ??
              0;

      //Increment the current max ID
      int newCartItemId = currentMaxId + 1;

      // Update the counter document with the new max ID
      transaction.update(_counterReference, {'cart_max_id': newCartItemId});

      CartModel cartItem = cartModel.copyWith(id: newCartItemId);

      await _cartReference
          .withConverter<CartModel>(
              fromFirestore: (snapshot, _) => CartModel.fromJson(snapshot),
              toFirestore: (cart, _) => cart.toJson())
          .add(cartItem);
    });
  }

  //Using firebase stream so that the cart would be up-to-date with
  //the latest information once a change occurs in the collection
  Stream<List<CartModel>> getCartItems() {
    return _cartReference.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CartModel.fromJson(doc)).toList();
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
}
