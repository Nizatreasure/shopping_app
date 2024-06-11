part of '../pages/discover_page.dart';

class ItemPreviewWidget extends StatefulWidget {
  final ProductModel item;
  const ItemPreviewWidget({super.key, required this.item});

  @override
  State<ItemPreviewWidget> createState() => _ItemPreviewWidgetState();
}

class _ItemPreviewWidgetState extends State<ItemPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () => context.pushNamed(RouteNames.productDetails, extra: {
        'document_id': widget.item.documentID,
        'product_id': widget.item.id
      }),
      child: SizedBox(
        height: 225.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: ColorManager.primaryDefault500.withOpacity(0.05),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: CustomNetworkImage(
                        imageUrl: widget.item.images.first.image,
                        onRetry: () {
                          setState(() {
                            widget.item.copyWith(
                              images: widget.item.images
                                ..[0].copyWith(imageKey: UniqueKey()),
                            );
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 15.r,
                    top: 15.r,
                    width: 24.r,
                    height: 24.r,
                    child: SvgPicture.network(
                      widget.item.brand.logo,
                      colorFilter: const ColorFilter.mode(
                          ColorManager.primaryLight300, BlendMode.srcIn),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10.r),
            Text(
              widget.item.name,
              style: themeData.textTheme.bodySmall!.copyWith(
                  height: 22 / themeData.textTheme.bodySmall!.fontSize!),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5.r),
            _buildRatingAndReview(themeData),
            Text(
              '${widget.item.price.symbol}${Globals.amountFormat.format(widget.item.price.amount)}',
              style: themeData.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 24 / 14,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRatingAndReview(ThemeData themeData) {
    return Row(
      children: [
        SvgPicture.asset(AppAssetManager.starFilled, width: 12.r, height: 12.r),
        SizedBox(width: 5.r),
        Text(
          Globals.ratingFormat.format(widget.item.reviewInfo.averageRating),
          style: themeData.textTheme.bodySmall!.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 5.r),
        Text(
          '(${widget.item.reviewInfo.totalReviews} ${StringManager.reviews})',
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
