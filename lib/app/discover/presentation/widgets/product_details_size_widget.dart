part of '../pages/product_details_page.dart';

class ProductDetailsSizeWidget extends StatelessWidget {
  const ProductDetailsSizeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        buildWhen: (previous, current) =>
            previous.productStatus != current.productStatus ||
            previous.productDetails != current.productDetails ||
            previous.selectedSize != current.selectedSize ||
            previous.reviewStatus != current.reviewStatus,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                loading: state.loading,
                borderRadius: 3,
                margin: EdgeInsetsDirectional.only(end: 60.r),
                child: Text(
                  StringManager.size,
                  style: themeData.textTheme.titleLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 26 / 16),
                ),
              ),
              SizedBox(height: 10.r),
              ShimmerWidget(
                loading: state.loading,
                borderRadius: 3,
                height: 25,
                numberOfShimmer: 5,
                shimmerSpacing: 10,
                child: state.productDetails == null
                    ? const SizedBox()
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: state.productDetails!.sizes
                                .map((size) => _buildSizeWidget(context, size,
                                    state.selectedSize == size, themeData))
                                .toList()),
                      ),
              ),
            ],
          );
        });
  }

  Widget _buildSizeWidget(
      BuildContext context, num size, bool selected, ThemeData themeData) {
    return GestureDetector(
      onTap: () => context
          .read<ProductDetailsBloc>()
          .add(ProductDetailsSetSizeEvent(size)),
      child: Container(
        width: 40.r,
        height: 40.r,
        margin: EdgeInsetsDirectional.only(end: 15.r),
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              selected ? null : Border.all(color: ColorManager.primaryLight200),
          color: selected
              ? ColorManager.primaryDefault500
              : ColorManager.transparent,
        ),
        child: Text(
          NumberFormat().format(size),
          style: themeData.textTheme.titleMedium!.copyWith(
            color: selected ? ColorManager.white : ColorManager.primaryLight300,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
