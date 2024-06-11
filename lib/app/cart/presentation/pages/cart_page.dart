import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/app/cart/data/models/cart_model.dart';
import 'package:shopping_app/app/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:shopping_app/app/cart/presentation/widgets/delete_confirmation_widget.dart';
import 'package:shopping_app/app/discover/presentation/widgets/shimmer_widget.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/common/widgets/app_snackbar.dart';
import 'package:shopping_app/core/common/widgets/appbar_widget.dart';
import 'package:shopping_app/core/common/widgets/custom_network_image.dart';
import 'package:shopping_app/core/common/widgets/error_widget.dart';
import 'package:shopping_app/core/common/widgets/modify_quantity_button.dart';
import 'package:shopping_app/core/common/widgets/no_product_widget.dart';
import 'package:shopping_app/core/constants/constants.dart';
import 'package:shopping_app/core/routes/router.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import 'package:shopping_app/globals.dart';

part '../widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      appBar: appbarWidget(context, title: StringManager.cart),
      body: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
        return state.loadingError
            ? AppErrorWidget(
                errorMessage: state.status.exception!.message,
                onTap: () {
                  context.read<CartBloc>().add(const CartGetCartItemsEvent());
                },
              )
            : state.cartItems?.isEmpty ?? false
                ? const AppEmptyDataWidget(text: StringManager.noProductInCart)
                : IgnorePointer(
                    ignoring: state.loading,
                    child: Column(
                      children: [
                        Expanded(
                          child: SlidableAutoCloseBehavior(
                            closeWhenTapped: false,
                            child: ListView.builder(
                              padding: EdgeInsetsDirectional.only(
                                top: 20.r,
                                bottom: 20.r,
                              ),
                              itemCount: state.cartItems?.length,
                              itemBuilder: (context, index) {
                                return CartItemWidget(
                                  loading: state.loading,
                                  cartModel: state.cartItems?[index],
                                );
                              },
                            ),
                          ),
                        ),
                        _buildBottomPageWidget(
                            context, themeData, bottomPadding, state),
                      ],
                    ),
                  );
      }),
    );
  }

  Widget _buildBottomPageWidget(BuildContext context, ThemeData themeData,
      double bottomPadding, CartState state) {
    return state.status.state == DataState.success
        ? Container(
            height: 90.r + bottomPadding,
            decoration: BoxDecoration(
              color: ColorManager.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 30.r,
                  spreadRadius: 0,
                  color: ColorManager.lightGrey.withOpacity(0.2),
                  offset: const Offset(0, -20),
                )
              ],
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsetsDirectional.symmetric(
                horizontal: 30.r, vertical: 20.r),
            child: SizedBox(
              height: 57.r,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StringManager.grandTotal,
                          style: themeData.textTheme.bodySmall!.copyWith(
                              height: 22 / 12,
                              color: ColorManager.primaryLight300),
                        ),
                        Text(
                          '${state.currencySymbol}${Globals.amountFormat.format(state.grandTotal)}',
                          style: themeData.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 30 / 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  AppButtonWidget(
                    text: StringManager.checkOut.toUpperCase(),
                    shrinkToFitChildSize: true,
                    padding:
                        EdgeInsetsDirectional.symmetric(horizontal: 31.5.r),
                    onTap: () {
                      context.pushNamed(RouteNames.orderSummary);
                    },
                  )
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
