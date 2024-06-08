part of '../pages/product_filter_page.dart';

class PriceRangeFilterWidget extends StatelessWidget {
  PriceRangeFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringManager.priceRange,
            style: themeData.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600, fontSize: 16, height: 26 / 16),
          ),
          SizedBox(height: 20.r),
          Stack(
            clipBehavior: Clip.none,
            children: [
              FlutterSlider(
                rangeSlider: true,
                values: [0, 1500],
                max: 1500,
                min: 0,
                tooltip: FlutterSliderTooltip(
                  alwaysShowTooltip: true,
                  custom: (value) => Text(
                    '\$${(value as num).toInt()}',
                    style: themeData.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold, height: 22 / 12),
                  ),
                  positionOffset: FlutterSliderTooltipPositionOffset(top: 40.r),
                ),
                handlerHeight: 24.r,
                handlerWidth: 24.r,
                handler: _sliderHandler,
                rightHandler: _sliderHandler,
                trackBar: _sliderTrackBar,
              ),
              Positioned(
                top: -10.r,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$0',
                      style: themeData.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 22 / 12,
                          color: ColorManager.grey),
                    ),
                    Text(
                      '\$1500',
                      style: themeData.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 22 / 12,
                          color: ColorManager.grey),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  final FlutterSliderTrackBar _sliderTrackBar = FlutterSliderTrackBar(
    activeTrackBarHeight: 3.r,
    inactiveTrackBarHeight: 3.r,
    activeTrackBar: const BoxDecoration(color: ColorManager.primaryDefault500),
    inactiveTrackBar: const BoxDecoration(color: ColorManager.primaryLight100),
  );

  final FlutterSliderHandler _sliderHandler = FlutterSliderHandler(
    child: CircleAvatar(
      radius: 12.r,
      backgroundColor: ColorManager.primaryDefault500,
      child: CircleAvatar(radius: 6.r, backgroundColor: ColorManager.white),
    ),
  );
}
