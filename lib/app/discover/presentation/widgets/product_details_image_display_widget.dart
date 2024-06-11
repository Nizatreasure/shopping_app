part of '../pages/product_details_page.dart';

class ProductDetailsImageDisplayWidget extends StatefulWidget {
  const ProductDetailsImageDisplayWidget({super.key});

  @override
  State<ProductDetailsImageDisplayWidget> createState() =>
      _ProductDetailsImageDisplayWidgetState();
}

class _ProductDetailsImageDisplayWidgetState
    extends State<ProductDetailsImageDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        buildWhen: (previous, current) =>
            previous.productStatus != current.productStatus ||
            previous.productDetails != current.productDetails ||
            previous.selectedColor != current.selectedColor ||
            previous.imageIndex != current.imageIndex ||
            previous.reviewStatus != current.reviewStatus,
        builder: (context, state) {
          return ShimmerWidget(
            loading: state.loading,
            height: 250.r,
            child: state.productDetails == null
                ? const SizedBox()
                : Stack(
                    children: [
                      _imageBackgroundWidget(themeData),
                      PositionedDirectional(
                        start: 15.r,
                        end: 10.r,
                        bottom: 10.r,
                        child:
                            _indicatorAndColorWidget(context, themeData, state),
                      ),
                      PositionedDirectional(
                        start: 0,
                        end: 0,
                        bottom: 70.r,
                        child: CarouselSlider.builder(
                          itemCount: state.productDetails!.images.length,
                          itemBuilder: (context, index, realIndex) {
                            ImageModel image =
                                state.productDetails!.images[index];
                            return CustomNetworkImage(
                              key: image.imageKey,
                              imageUrl: image.image,
                              onRetry: () {
                                setState(() {
                                  image.copyWith(imageKey: UniqueKey());
                                });
                              },
                            );
                          },
                          options: CarouselOptions(
                            viewportFraction: 1,
                            padEnds: false,
                            onPageChanged: (index, reason) => context
                                .read<ProductDetailsBloc>()
                                .add(
                                    ProductDetailsChangeImageIndexEvent(index)),
                          ),
                        ),
                      )
                    ],
                  ),
          );
        });
  }

  Widget _indicatorAndColorWidget(
      BuildContext context, ThemeData themeData, ProductDetailsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DotsIndicator(
          dotsCount: state.productDetails!.images.length,
          position: state.imageIndex,
          decorator: DotsDecorator(
            spacing: EdgeInsets.symmetric(horizontal: 5.r),
            activeColor: themeData.primaryColor,
            color: ColorManager.primaryLight300,
            size: Size(7.r, 7.r),
            activeSize: Size(7.r, 7.r),
          ),
        ),
        Container(
          padding:
              EdgeInsetsDirectional.symmetric(horizontal: 5.r, vertical: 10.r),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: ColorManager.white),
          child: Row(
            children: state.productDetails!.colors
                .map((color) => _buildColorSelector(context, color,
                    selected: state.selectedColor?.name == color.name))
                .toList(),
          ),
        )
      ],
    );
  }

  Widget _imageBackgroundWidget(ThemeData themeData) {
    return Container(
      height: 315.r,
      margin: EdgeInsetsDirectional.only(top: 10.r),
      decoration: BoxDecoration(
        color: themeData.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }

  Widget _buildColorSelector(BuildContext context, ColorModel color,
      {required bool selected}) {
    bool isWhite = color.color == ColorManager.white;

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 5.r),
      child: GestureDetector(
        onTap: () => context
            .read<ProductDetailsBloc>()
            .add(ProductDetailsSetColorChoiceEvent(color)),
        child: Container(
          width: 20.r,
          height: 20.r,
          decoration: BoxDecoration(
              color: color.color,
              shape: BoxShape.circle,
              border: isWhite
                  ? Border.all(color: ColorManager.primaryLight200)
                  : null),
          child: selected
              ? Icon(
                  Icons.check,
                  color: isWhite
                      ? ColorManager.primaryDefault500
                      : ColorManager.white,
                  size: 14.r,
                )
              : null,
        ),
      ),
    );
  }
}
