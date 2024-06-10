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
          BlocBuilder<DiscoverBloc, DiscoverState>(
              buildWhen: (previous, current) =>
                  previous.filters != current.filters,
              builder: (context, state) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FlutterSlider(
                      rangeSlider: true,
                      minimumDistance: 50,
                      values: [
                        (state.filters.priceRange?.minPrice ?? 0),
                        (state.filters.priceRange?.maxPrice ??
                            AppConstants.maxPrice)
                      ],
                      max: AppConstants.maxPrice,
                      min: 0,
                      tooltip: FlutterSliderTooltip(
                        alwaysShowTooltip: true,
                        custom: (value) => Text(
                          '\$${(value as num).toInt()}',
                          style: themeData.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold, height: 22 / 12),
                        ),
                        positionOffset:
                            FlutterSliderTooltipPositionOffset(top: 40.r),
                      ),
                      handlerHeight: 24.r,
                      handlerWidth: 24.r,
                      handler: _sliderHandler,
                      rightHandler: _sliderHandler,
                      trackBar: _sliderTrackBar,
                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                        context
                            .read<DiscoverBloc>()
                            .add(DiscoverSetFilterEvent(state.filters.copyWith(
                              priceRange: PriceRangeModel(
                                  maxPrice: upperValue, minPrice: lowerValue),
                            )));
                      },
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
                            '\$${AppConstants.maxPrice.toInt()}',
                            style: themeData.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 22 / 12,
                                color: ColorManager.grey),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              })
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
