part of '../pages/product_details_page.dart';

class ProductDetailsImageDisplayWidget extends StatelessWidget {
  const ProductDetailsImageDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Stack(
      children: [
        Container(
          height: 315.r,
          margin: EdgeInsetsDirectional.only(top: 10.r),
          decoration: BoxDecoration(
            color: themeData.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        PositionedDirectional(
          start: 15.r,
          end: 10.r,
          bottom: 10.r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DotsIndicator(
                dotsCount: 4,
                decorator: DotsDecorator(
                  spacing: EdgeInsets.symmetric(horizontal: 5.r),
                  activeColor: themeData.primaryColor,
                  color: ColorManager.primaryLight300,
                  size: Size(7.r, 7.r),
                  activeSize: Size(7.r, 7.r),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 5.r, vertical: 10.r),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: ColorManager.white),
                child: Row(
                  children: [
                    _buildColorSelector(Colors.green, selected: false),
                    _buildColorSelector(Colors.red, selected: false),
                    _buildColorSelector(Colors.black, selected: true),
                    _buildColorSelector(Colors.blue, selected: false),
                  ],
                ),
              )
            ],
          ),
        ),
        PositionedDirectional(
          start: 0,
          end: 0,
          bottom: 70.r,
          child: CarouselSlider.builder(
            itemCount: 4,
            itemBuilder: (context, index, realIndex) {
              return Image.asset(AppAssetManager.preview);
            },
            options: CarouselOptions(
              viewportFraction: 1,
              padEnds: false,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildColorSelector(Color color,
      {Color iconColor = ColorManager.white, required bool selected}) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 5.r),
      child: CircleAvatar(
        radius: 10.r,
        backgroundColor: color,
        child: selected
            ? Icon(
                Icons.check,
                color: iconColor,
                size: 14,
              )
            : null,
      ),
    );
  }
}
