part of '../pages/product_details_page.dart';

class ProductDetailsSizeWidget extends StatelessWidget {
  const ProductDetailsSizeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringManager.size,
          style: themeData.textTheme.titleLarge!.copyWith(
              fontSize: 16, fontWeight: FontWeight.w600, height: 26 / 16),
        ),
        SizedBox(height: 10.r),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSizeWidget(39, true, themeData),
              _buildSizeWidget(39.5, false, themeData),
              _buildSizeWidget(40, false, themeData),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSizeWidget(double size, bool selected, ThemeData themeData) {
    return Container(
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
    );
  }
}
