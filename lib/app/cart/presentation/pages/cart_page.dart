import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/common/widgets/appbar_widget.dart';
import 'package:shopping_app/core/common/widgets/modify_quantity_button.dart';
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
      body: Column(
        children: [
          Expanded(
            child: SlidableAutoCloseBehavior(
              closeWhenTapped: false,
              child: ListView.builder(
                padding: EdgeInsetsDirectional.only(
                  top: 20.r,
                  bottom: 20.r,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return const CartItemWidget();
                },
              ),
            ),
          ),
          _buildBottomPageWidget(context, themeData, bottomPadding),
        ],
      ),
    );
  }

  Widget _buildBottomPageWidget(
      BuildContext context, ThemeData themeData, double bottomPadding) {
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
                    Globals.currencyFormat.format(235),
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
              padding: EdgeInsetsDirectional.symmetric(horizontal: 31.5.r),
              onTap: () {
                context.pushNamed(RouteNames.orderSummary);
              },
            )
          ],
        ),
      ),
    );
  }
}
