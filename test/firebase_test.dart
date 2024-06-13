import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:shopping_app/app/cart/data/data_sources/remote/cart_api_service.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';
import 'package:shopping_app/app/cart/data/models/order_summary_model.dart';
import 'package:shopping_app/app/discover/data/data_sources/remote/api_service.dart';
import 'package:shopping_app/app/discover/data/models/brands_model.dart';
import 'package:shopping_app/app/discover/data/models/filter_model.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/data/models/product_review_model.dart';
import 'package:shopping_app/core/common/enums/enums.dart';

void main() {
  group('CartApiService', () {
    late FakeFirebaseFirestore fakeFirestore;
    late CartApiService cartApiService;

    CartModel testCartModel = CartModel(
      id: 1,
      docID: 'docID',
      productName: 'Test product',
      brandName: 'Test brand',
      color: const ColorModel(color: Colors.white, name: 'White'),
      size: 41,
      price: PriceModel(amount: 100, currency: 'USD', symbol: r'$'),
      quantity: 4,
      imageUrl: 'imageUrl',
      productID: 1,
      productDocumentID: 'productDocumentID',
      imageKey: UniqueKey(),
      createdAt: DateTime.now(),
      itemKey: UniqueKey(),
    );

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      cartApiService = CartApiService(fakeFirestore);
    });

    test('addProductToCart adds item to Firestore', () async {
      final cartItem = testCartModel;

      //add the product to cart
      await cartApiService.addProductToCart(cartItem);

      //get the product from cart
      final snapshot = await fakeFirestore
          .collection('cart')
          .withConverter<CartModel>(
              fromFirestore: (snapshot, _) => CartModel.fromSnapshot(snapshot),
              toFirestore: (cart, _) => cart.toJson())
          .get();
      final items = snapshot.docs.map((doc) => doc.data()).toList();

      expect(items.length, 1);
      expect(items.first.productName, 'Test product');
      expect(items.first.brandName, 'Test brand');

      // Check if the cart id count is updated
      final cartCounterSnapshot =
          await fakeFirestore.doc('counters/cart').get();
      final cartIdCount =
          (cartCounterSnapshot.data() as Map<String, dynamic>)['cart_max_id'];
      expect(cartIdCount, 1);
    });

    test('deleteProductFromCart removes item from Firestore', () async {
      await cartApiService.addProductToCart(testCartModel);

      final snapshotBeforeDelete = await fakeFirestore.collection('cart').get();
      expect(snapshotBeforeDelete.docs.length, 1);

      final docId = snapshotBeforeDelete.docs.first.id;
      await cartApiService.deleteProductFromCart(docId);

      final snapshotAfterDelete = await fakeFirestore.collection('cart').get();
      expect(snapshotAfterDelete.docs.length, 0);
    });

    test('getCartItems returns stream of cart items', () async {
      final cartItem1 = testCartModel;
      final cartItem2 = testCartModel.copyWith(
          productName: 'Test product 2', brandName: 'Test brand 2');
      await cartApiService.addProductToCart(cartItem1);
      await cartApiService.addProductToCart(cartItem2);

      final cartStream = cartApiService.getCartItems();

      cartStream.listen(expectAsync1((items) {
        expect(items.length, 2);
        expect(items.first.cartModel.productName, 'Test product');
        expect(items.last.cartModel.productName, 'Test product 2');
        expect(items.first.cartModel.brandName, 'Test brand');
        expect(items.last.cartModel.brandName, 'Test brand 2');
      }));
    });

    test('updateCartItem updates item in Firestore', () async {
      final cartItem = testCartModel;
      final docRef =
          await fakeFirestore.collection('cart').add(cartItem.toJson());

      final updatedCartItem = testCartModel.copyWith(
          productName: 'Updated test product', brandName: 'Updated test brand');

      await cartApiService.updateCartItem(
          cartModel: updatedCartItem, cartDocumentID: docRef.id);

      final snapshot = await docRef
          .withConverter<CartModel>(
              fromFirestore: (snapshot, _) => CartModel.fromSnapshot(snapshot),
              toFirestore: (cart, _) => cart.toJson())
          .get();

      final updatedItem = snapshot.data()!;

      expect(updatedItem.productName, 'Updated test product');
      expect(updatedItem.brandName, 'Updated test brand');
    });

    test('makePaymentForCart processes payment and clears cart', () async {
      final cartItem1 = testCartModel;
      final cartItem2 = testCartModel.copyWith(
          brandName: 'Another test brand', productName: 'Another test product');
      await fakeFirestore.collection('cart').add(cartItem1.toJson());
      await fakeFirestore.collection('cart').add(cartItem2.toJson());

      final order = OrderSummaryModel(
        orderID: 0,
        subTotal: 100.0,
        shippingCost: 10.0,
        location: 'Test Location',
        paymentMethod: 'Test Payment',
        orderDetails: [cartItem1, cartItem2],
        createdAt: DateTime.now(),
        docID: 'docID',
      );

      await cartApiService.makePaymentForCart(order);

      // Check if the order is added to history with updated orderID
      final historySnapshot = await fakeFirestore
          .collection('order_history')
          .withConverter<OrderSummaryModel>(
              fromFirestore: (snapshot, _) =>
                  OrderSummaryModel.fromSnapshot(snapshot),
              toFirestore: (order, _) => order.toJson())
          .get();

      expect(historySnapshot.docs.length, 1);
      final orderInHistory = historySnapshot.docs.first.data();
      expect(orderInHistory.orderID, 1);

      // Check if the cart is cleared
      final cartSnapshot = await fakeFirestore.collection('cart').get();
      expect(cartSnapshot.docs.length, 0);

      // Check if the order history count is updated
      final orderCounterSnapshot =
          await fakeFirestore.doc('counters/order_history').get();
      final orderHistoryCount = (orderCounterSnapshot.data()
          as Map<String, dynamic>)['order_history_count'];
      expect(orderHistoryCount, 1);
    });
  });

  group(DiscoverApiService, () {
    late FakeFirebaseFirestore fakeFirestore;
    late DiscoverApiService discoverApiService;

    BrandsModel testBrand = const BrandsModel(
        name: 'Test brand', logo: 'logo', totalProductCount: 3);

    ProductReviewModel testProductReview = ProductReviewModel(
      createdAt: DateTime.now(),
      image: 'image',
      name: 'Test product',
      productID: 2,
      rating: 3,
      review: 'Nice. I love it',
      documentID: 'documentID',
      imageKey: UniqueKey(),
    );

    ProductModel testProduct = ProductModel(
      id: 1,
      gender: 'Man',
      createdAt: DateTime.now(),
      price: PriceModel(amount: 100, currency: 'USD', symbol: r'$'),
      documentID: 'documentID',
      reviewInfo: ReviewInfoModel(totalReviews: 1, averageRating: 4),
      brand: testBrand,
      description: 'description',
      sizes: [37, 38, 40],
      name: 'Test product',
      images: [ImageModel(image: 'image', imageKey: UniqueKey())],
      colors: const [ColorModel(color: Colors.white, name: 'White')],
    );

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      discoverApiService = DiscoverApiService(fakeFirestore);
    });

    test('getAllBrands returns all product brands', () async {
      final brand1 = testBrand;
      final brand2 =
          testBrand.copyWith(name: 'Test brand 2', totalProductCount: 5);
      await fakeFirestore.collection('brands').add(brand1.toJson());
      await fakeFirestore.collection('brands').add(brand2.toJson());

      final result = await discoverApiService.getAllBrands();

      expect(result.docs.length, 2);
      expect(result.docs[0].data().name, 'Test brand');
      expect(result.docs[1].data().name, 'Test brand 2');
      expect(result.docs[0].data().totalProductCount, 3);
      expect(result.docs[1].data().totalProductCount, 5);
    });

    test('getProductList returns all products or the products for a brand',
        () async {
      final product1 = testProduct;
      final product2 = testProduct.copyWith(
          name: 'Test product 2',
          brand:
              testBrand.copyWith(name: 'Test brand 2', totalProductCount: 10));
      await fakeFirestore.collection('products').add(product1.toJson());
      await fakeFirestore.collection('products').add(product2.toJson());

      //get all products
      final result = await discoverApiService.getProductList('');

      expect(result.docs.length, 2);
      expect(result.docs[0].data().name, 'Test product');
      expect(result.docs[1].data().name, 'Test product 2');

      //get products for a brand
      final result2 = await discoverApiService.getProductList('Test brand 2');
      expect(result2.docs.length, 1);
      expect(result2.docs[0].data().brand.name, 'Test brand 2');
    });

    test('getProductReviews returns reviews by product ID and rating',
        () async {
      final review1 = testProductReview;
      final review2 =
          testProductReview.copyWith(review: 'Great product!', rating: 5);
      await fakeFirestore.collection('reviews').add(review1.toJson());
      await fakeFirestore.collection('reviews').add(review2.toJson());

      //get all reviews
      final result = await discoverApiService.getProductReviews(2, null);

      expect(result.docs.length, 2);
      expect(result.docs[0].data().review, 'Nice. I love it');
      expect(result.docs[1].data().review, 'Great product!');

      //get review by rating
      final result2 = await discoverApiService.getProductReviews(2, 5);

      expect(result2.docs.length, 1);
      expect(result2.docs[0].data().review, 'Great product!');
      expect(result2.docs[0].data().rating, 5);
    });

    test('getFilteredProductList returns filtered products', () async {
      final product1 = testProduct;
      final product2 = testProduct.copyWith(
          brand: testBrand.copyWith(name: 'Test brand 2'),
          colors: const [ColorModel(color: Colors.red, name: 'Red')],
          gender: 'Woman');

      await fakeFirestore.collection('products').add(product1.toJson());
      await fakeFirestore.collection('products').add(product2.toJson());

      final filter = FilterModel(
        priceRange: const PriceRangeModel(minPrice: 50, maxPrice: 150),
        brand: testBrand,
        gender: Gender.man,
        sortBy:
            const SortByModel(sortBy: SortBy.highestReviews, descending: true),
      );

      final result = await discoverApiService.getFilteredProductList(filter);

      expect(result.docs.length, 1);
      expect(result.docs[0].data().name, 'Test product');
    });

    test('getTopThreeReviews returns top three reviews by product ID',
        () async {
      final review1 = testProductReview;
      final review2 = testProductReview.copyWith(
          productID: 2,
          rating: 5,
          review: 'Good product',
          createdAt: DateTime.now().subtract(const Duration(days: 1)));
      final review3 = testProductReview.copyWith(
          productID: 2,
          rating: 4,
          review: 'Average product',
          createdAt: DateTime.now().subtract(const Duration(days: 2)));
      final review4 = testProductReview.copyWith(
          productID: 2,
          rating: 2,
          review: 'Bad product',
          createdAt: DateTime.now().subtract(const Duration(days: 3)));

      await fakeFirestore.collection('reviews').add(review1.toJson());
      await fakeFirestore.collection('reviews').add(review2.toJson());
      await fakeFirestore.collection('reviews').add(review3.toJson());
      await fakeFirestore.collection('reviews').add(review4.toJson());

      final result = await discoverApiService.getTopThreeReviews(2);

      expect(result.docs.length, 3);
      expect(result.docs[0].data().review, 'Good product');
      expect(result.docs[1].data().review, 'Average product');
      expect(result.docs[2].data().review, 'Nice. I love it');
    });
  });
}
