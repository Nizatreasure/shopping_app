import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/app/discover/presentation/blocs/product_details_bloc/product_details_bloc.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/common/widgets/app_snackbar.dart';
import 'package:shopping_app/core/common/widgets/modify_quantity_button.dart';
import 'package:shopping_app/core/constants/constants.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import 'package:shopping_app/globals.dart';

class AddToCartModal extends StatelessWidget {
  final ProductDetailsBloc bloc;
  const AddToCartModal({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    double viewInsets = MediaQuery.of(context).viewInsets.bottom;
    double viewPadding = MediaQuery.of(context).viewPadding.bottom;
    return BlocProvider.value(
      value: bloc,
      child: AnimatedContainer(
        width: double.infinity,
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsetsDirectional.only(
          start: 30.r,
          end: 20.r,
          bottom: (viewInsets > 50 ? 0 : viewPadding) + 20.r,
        ),
        margin: EdgeInsetsDirectional.only(bottom: viewInsets),
        child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
            builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandler(),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            StringManager.addToCart,
                            style: themeData.textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 30 / 20,
                              fontSize: 20,
                            ),
                          ),
                          _buildCloseButton(context)
                        ],
                      ),
                      SizedBox(height: 30.r),
                      Text(
                        StringManager.quantity,
                        style: themeData.textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 24 / 14),
                      ),
                      SizedBox(height: 10.r),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _buildTextInput(context, themeData),
                          ),
                          _buildQuantityButtons(context, state),
                        ],
                      ),
                      SizedBox(height: 20.r),
                      Divider(
                        color: ColorManager.primaryDefault500,
                        height: 0,
                        thickness: 1.r,
                      ),
                      SizedBox(height: 30.r),
                      _buildPriceAndButton(context, themeData, state),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTextInput(BuildContext context, ThemeData themeData) {
    return SizedBox(
      height: 24.r,
      child: TextFormField(
        controller: context.read<ProductDetailsBloc>().quantityController,
        textAlignVertical: TextAlignVertical.center,
        onChanged: (value) {
          int quantity = int.tryParse(value) ?? 0;
          context
              .read<ProductDetailsBloc>()
              .add(ProductDetailsChangeQuantityEvent(quantity));
        },
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          contentPadding: EdgeInsetsDirectional.zero,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
        ),
        style: themeData.textTheme.bodyMedium!.copyWith(height: 24 / 14),
      ),
    );
  }

  Widget _buildPriceAndButton(
      BuildContext context, ThemeData themeData, ProductDetailsState state) {
    return SizedBox(
      height: 57.r,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringManager.totalPrice,
                  style: themeData.textTheme.bodySmall!.copyWith(
                      height: 22 / 12, color: ColorManager.primaryLight300),
                ),
                Text(
                  '${state.productDetails!.price.symbol}${Globals.amountFormat.format(state.totalPrice)}',
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
            text: StringManager.addToCart.toUpperCase(),
            shrinkToFitChildSize: true,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 31.5.r),
            onTap: () async {
              if (state.quantity < 1) {
                showAppMaterialBanner(context,
                    text: 'Quantity must not be less than 1');
                return;
              }
              context.pop(true);
            },
          )
        ],
      ),
    );
  }

  Widget _buildQuantityButtons(
      BuildContext context, ProductDetailsState state) {
    return Row(
      children: [
        ModifyQuantityButton(
          buttonType: ModifyQuantityButtonType.minus,
          enabled: state.quantity > 1,
          onTap: () {
            context
                .read<ProductDetailsBloc>()
                .add(ProductDetailsChangeQuantityEvent(state.quantity - 1));
          },
        ),
        SizedBox(width: 20.r),
        ModifyQuantityButton(
          buttonType: ModifyQuantityButtonType.add,
          enabled: state.quantity < AppConstants.maxQuantityForProduct,
          onTap: () {
            context
                .read<ProductDetailsBloc>()
                .add(ProductDetailsChangeQuantityEvent(state.quantity + 1));
          },
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(false),
      child: Container(
        color: Colors.transparent,
        height: 30.r,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 10.r),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          AppAssetManager.close,
          width: 18.r,
          height: 18.r,
        ),
      ),
    );
  }

  Widget _buildDragHandler() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsetsDirectional.only(top: 10.r, bottom: 26.r),
        height: 4.r,
        width: 44.r,
        decoration: BoxDecoration(
          color: ColorManager.primaryLight200,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
