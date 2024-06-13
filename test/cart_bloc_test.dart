import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';
import 'package:shopping_app/app/cart/data/models/order_summary_model.dart';
import 'package:shopping_app/app/cart/domain/usecases/usecases.dart';
import 'package:shopping_app/app/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/core/common/network/data_failure_model.dart';
import 'package:shopping_app/core/common/network/data_status.dart';

class MockGetCartItemsUsecase extends Mock implements GetCartItemsUsecase {}

class MockUpdateCartItemUsecase extends Mock implements UpdateCartItemUsecase {}

class MockDeleteProductFromCartUsecase extends Mock
    implements DeleteProductFromCartUsecase {}

class MockMakePaymentForCartUsecase extends Mock
    implements MakePaymentForCartUsecase {}

void main() {
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
    loading: false,
  );

  OrderSummaryModel orderSummary = OrderSummaryModel(
    orderID: 0,
    subTotal: 100.0,
    shippingCost: 10.0,
    location: 'Test Location',
    paymentMethod: 'Test Payment',
    orderDetails: [testCartModel],
    createdAt: DateTime.now(),
    docID: 'docID',
  );
  setUpAll(() {
    registerFallbackValue(orderSummary);
    registerFallbackValue(testCartModel);
  });
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CartBloc', () {
    late MockGetCartItemsUsecase getCartItemsUsecase;
    late MockUpdateCartItemUsecase updateCartItemUsecase;
    late MockDeleteProductFromCartUsecase deleteProductFromCartUsecase;
    late MockMakePaymentForCartUsecase makePaymentForCartUsecase;

    late CartBloc cartBloc;

    setUp(() {
      getCartItemsUsecase = MockGetCartItemsUsecase();
      updateCartItemUsecase = MockUpdateCartItemUsecase();
      deleteProductFromCartUsecase = MockDeleteProductFromCartUsecase();
      makePaymentForCartUsecase = MockMakePaymentForCartUsecase();

      cartBloc = CartBloc(
        getCartItemsUsecase,
        updateCartItemUsecase,
        deleteProductFromCartUsecase,
        makePaymentForCartUsecase,
      );
    });

    tearDown(() {
      cartBloc.close();
    });

    blocTest<CartBloc, CartState>(
      'emits loading and success when GetCartItemsEvent is added successfully but the returned data is empty',
      build: () {
        final cartStream =
            Stream<List<CartDocumentChangedModel>>.fromIterable([[]]);
        when(() => getCartItemsUsecase.execute(params: null)).thenAnswer(
            (_) async =>
                Right<DataFailure, Stream<List<CartDocumentChangedModel>>>(
                    cartStream));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const CartGetCartItemsEvent()),
      expect: () => [
        CartState(cartStatus: DataStatus.loading()),
        CartState(cartItems: const [], cartStatus: DataStatus.success()),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits loading and success when GetCartItemsEvent is added successfully and data returned is not empty',
      build: () {
        final cartStream = Stream<List<CartDocumentChangedModel>>.fromIterable([
          [
            CartDocumentChangedModel(
              type: DocumentChangeType.added,
              newIndex: 0,
              cartModel: testCartModel,
              oldIndex: 0,
            )
          ]
        ]);
        when(() => getCartItemsUsecase.execute(params: null)).thenAnswer(
            (_) async =>
                Right<DataFailure, Stream<List<CartDocumentChangedModel>>>(
                    cartStream));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const CartGetCartItemsEvent()),
      expect: () => [
        CartState(cartStatus: DataStatus.loading()),
        CartState(cartItems: const [], cartStatus: DataStatus.success()),
        CartState(cartItems: [testCartModel], cartStatus: DataStatus.success()),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits loading and failure when GetCartItemsEvent fails',
      build: () {
        when(() => getCartItemsUsecase.execute(params: null)).thenAnswer(
            (_) async =>
                Left<DataFailure, Stream<List<CartDocumentChangedModel>>>(
                    DataFailure()));
        return cartBloc;
      },
      act: (bloc) => bloc.add(const CartGetCartItemsEvent()),
      expect: () => [
        CartState(cartStatus: DataStatus.loading()),
        CartState(
          cartStatus: DataStatus.failure(exception: DataFailure()),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits updated state when UpdateCartItemsEvent is added',
      build: () => cartBloc,
      act: (bloc) => bloc.add(
        CartUpdateCartItemsEvent(
          CartDocumentChangedModel(
            type: DocumentChangeType.added,
            newIndex: 0,
            cartModel: testCartModel,
            oldIndex: 0,
          ),
        ),
      ),
      expect: () => [
        CartState(cartItems: [testCartModel]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits updated state when DeleteProductEvent is added',
      build: () {
        when(() => deleteProductFromCartUsecase.execute(
                params: any(named: 'params')))
            .thenAnswer((_) async => const Right(null));
        return cartBloc;
      },
      seed: () => CartState(cartItems: [testCartModel]),
      act: (bloc) {
        bloc.add(CartDeleteProductEvent(testCartModel, Completer<bool>()));
      },
      expect: () => [],
    );

    blocTest<CartBloc, CartState>(
      'emits loading and success when MakePaymentEvent is added successfully',
      build: () {
        when(() =>
                makePaymentForCartUsecase.execute(params: any(named: 'params')))
            .thenAnswer((_) async => const Right(null));
        return cartBloc;
      },
      seed: () => CartState(cartItems: [testCartModel]),
      act: (bloc) => bloc.add(const CartMakePaymentEvent()),
      expect: () => [
        CartState(
            cartItems: [testCartModel], paymentStatus: DataStatus.loading()),
        CartState(
            cartItems: [testCartModel], paymentStatus: DataStatus.success()),
        CartState(
            cartItems: [testCartModel], paymentStatus: DataStatus.initial()),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits loading and success when MakePaymentEvent fails',
      build: () {
        when(() =>
                makePaymentForCartUsecase.execute(params: any(named: 'params')))
            .thenAnswer((_) async => Left(DataFailure()));
        return cartBloc;
      },
      seed: () => CartState(cartItems: [testCartModel]),
      act: (bloc) => bloc.add(const CartMakePaymentEvent()),
      expect: () => [
        CartState(
            cartItems: [testCartModel], paymentStatus: DataStatus.loading()),
        CartState(
            cartItems: [testCartModel],
            paymentStatus: DataStatus.failure(exception: DataFailure())),
        CartState(
            cartItems: [testCartModel], paymentStatus: DataStatus.initial()),
      ],
    );
  });
}
