part of '../pages/discover_page.dart';

class ItemPreviewWidget extends StatelessWidget {
  final ItemPreviewModel item;
  const ItemPreviewWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return SizedBox(
      height: 225.r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: ColorManager.primaryDefault500.withOpacity(0.05),
                  ),
                ),
                Positioned(
                  left: 15.r,
                  right: 15.r,
                  bottom: 22.r,
                  child: Image.asset(AppAssetManager.preview),
                ),
                Positioned(
                  left: 15.r,
                  top: 15.r,
                  width: 24.r,
                  height: 24.r,
                  child: SvgPicture.asset(
                    AppAssetManager.adidas,
                    colorFilter: const ColorFilter.mode(
                        ColorManager.primaryLight300, BlendMode.srcIn),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10.r),
          Text(
            item.name,
            style: themeData.textTheme.bodySmall!.copyWith(
                height: 22 / themeData.textTheme.bodySmall!.fontSize!),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5.r),
          _buildRatingAndReview(themeData),
          Text(
            Globals.currencyFormat.format(item.price),
            style: themeData.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              height: 24 / 14,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRatingAndReview(ThemeData themeData) {
    return Row(
      children: [
        SvgPicture.asset(AppAssetManager.starFilled, width: 12.r, height: 12.r),
        SizedBox(width: 5.r),
        Text(
          Globals.ratingFormat.format(item.averageRating),
          style: themeData.textTheme.bodySmall!.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 5.r),
        Text(
          '(${item.totalReviews} ${StringManager.reviews})',
          style: themeData.textTheme.bodySmall!.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.normal,
            color: ColorManager.primaryLight300,
          ),
        )
      ],
    );
  }
}
