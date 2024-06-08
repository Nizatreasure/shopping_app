part of '../pages/product_filter_page.dart';

class BrandsFilterWidget extends StatelessWidget {
  const BrandsFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
          child: Text(
            StringManager.brands,
            style: themeData.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600, fontSize: 16, height: 26 / 16),
          ),
        ),
        SizedBox(height: 20.r),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
          child: Row(
            children: List.generate(
              6,
              (index) {
                return _buildBrands(themeData, index == 0);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBrands(ThemeData themeData, bool selected) {
    return Container(
      width: 70.r,
      padding: EdgeInsetsDirectional.only(end: 10.r),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 50.r,
                height: 50.r,
                alignment: AlignmentDirectional.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.primaryLight100,
                ),
                child: SvgPicture.asset(AppAssetManager.adidas),
              ),
              if (selected)
                PositionedDirectional(
                  bottom: -4.r,
                  end: -3.r,
                  child: SvgPicture.asset(AppAssetManager.tickCircle),
                )
            ],
          ),
          SizedBox(height: 10.r),
          Text(
            'Adidas',
            textAlign: TextAlign.center,
            style: themeData.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.bold, height: 24 / 14),
          ),
          Text(
            '1001 items',
            textAlign: TextAlign.center,
            style: themeData.textTheme.bodySmall!
                .copyWith(fontSize: 11, color: ColorManager.primaryLight300),
          )
        ],
      ),
    );
  }
}
