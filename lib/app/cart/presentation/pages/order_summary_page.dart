import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/app/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:shopping_app/app/cart/presentation/widgets/app_list_tile.dart';
import 'package:shopping_app/app/cart/presentation/widgets/order_detail_item.dart';
import 'package:shopping_app/app/cart/presentation/widgets/payment_successful_widget.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/common/widgets/app_snackbar.dart';
import 'package:shopping_app/core/common/widgets/appbar_widget.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import 'package:shopping_app/globals.dart';

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      appBar: appbarWidget(context, title: StringManager.orderSummary),
      body: BlocConsumer<CartBloc, CartState>(
          listenWhen: (previous, current) =>
              previous.paymentStatus != current.paymentStatus,
          listener: (context, state) async {
            //show the error message if an error occurred
            if (state.paymentStatus.state == DataState.failure) {
              showAppMaterialBanner(context,
                  text: state.paymentStatus.exception!.message);
            }
            //show the success modal if the payment was successful
            else if (state.paymentStatus.state == DataState.success) {
              await showPaymentSuccessModal(context);
              //close the summary page when the modal is dismissed
              if (context.mounted) {
                context.pop();
              }
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.all(30.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringManager.information,
                          style: themeData.textTheme.headlineSmall!.copyWith(
                            color: ColorManager.primaryBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            height: 26 / 18,
                          ),
                        ),
                        SizedBox(height: 20.r),
                        AppListTile(
                          title: StringManager.paymentMethod,
                          subtitle: state.paymentMethod,
                        ),
                        Divider(
                          color: ColorManager.primaryLight100,
                          thickness: 1.r,
                          height: 40.r,
                        ),
                        AppListTile(
                          title: StringManager.location,
                          subtitle: state.location,
                        ),
                        SizedBox(height: 30.r),
                        Text(
                          StringManager.orderDetails,
                          style: themeData.textTheme.headlineSmall!.copyWith(
                            color: ColorManager.primaryBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            height: 26 / 18,
                          ),
                        ),
                        SizedBox(height: 20.r),
                        Column(
                          children: List.generate(
                              state.cartItemsCount,
                              (index) => OrderDetailItem(
                                  cartItem: state.cartItems![index])),
                        ),
                        SizedBox(height: 10.r),
                        Text(
                          StringManager.paymentDetails,
                          style: themeData.textTheme.headlineSmall!.copyWith(
                            color: ColorManager.primaryBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            height: 26 / 18,
                          ),
                        ),
                        SizedBox(height: 20.r),
                        _paymentDetailsWidget(
                          themeData,
                          leading: StringManager.subTotal,
                          trailing:
                              '${state.currencySymbol}${Globals.amountFormat.format(state.subTotal)}',
                        ),
                        SizedBox(height: 20.r),
                        _paymentDetailsWidget(
                          themeData,
                          leading: StringManager.shipping,
                          trailing:
                              '${state.currencySymbol}${Globals.amountFormat.format(state.shippingCost)}',
                        ),
                        Divider(
                          color: ColorManager.primaryLight100,
                          thickness: 1.r,
                          height: 40.r,
                        ),
                        _paymentDetailsWidget(
                          themeData,
                          useBoldFont: true,
                          leading: StringManager.totalOrder,
                          trailing:
                              '${state.currencySymbol}${Globals.amountFormat.format(state.grandTotal)}',
                        ),
                      ],
                    ),
                  ),
                ),
                _buildBottomPageWidget(
                    context, themeData, bottomPadding, state),
              ],
            );
          }),
    );
  }

  Widget _paymentDetailsWidget(ThemeData themeData,
      {required String leading,
      required String trailing,
      bool useBoldFont = false}) {
    double fontsize = useBoldFont ? 18 : 16;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leading,
          style: themeData.textTheme.bodyMedium!.copyWith(
            fontSize: 14,
            height: 24 / 14,
            color: ColorManager.secondaryDarkGrey,
          ),
        ),
        Text(
          trailing,
          style: themeData.textTheme.titleLarge!.copyWith(
            color: ColorManager.primaryBlack,
            fontWeight: useBoldFont ? FontWeight.bold : FontWeight.w600,
            fontSize: fontsize,
            height: 26 / fontsize,
          ),
        )
      ],
    );
  }

  Widget _buildBottomPageWidget(BuildContext context, ThemeData themeData,
      double bottomPadding, CartState state) {
    return Container(
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
      padding:
          EdgeInsetsDirectional.symmetric(horizontal: 30.r, vertical: 20.r),
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
                        height: 22 / 12, color: ColorManager.primaryLight300),
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
              text: StringManager.payment.toUpperCase(),
              shrinkToFitChildSize: true,
              padding: EdgeInsetsDirectional.symmetric(horizontal: 31.5.r),
              onTap: () =>
                  context.read<CartBloc>().add(const CartMakePaymentEvent()),
            )
          ],
        ),
      ),
    );
  }
}
