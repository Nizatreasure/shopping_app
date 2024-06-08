part of '../pages/cart_page.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({super.key});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget>
    with SingleTickerProviderStateMixin {
  late final SlidableController _slidableController;

  @override
  void initState() {
    _slidableController = SlidableController(this);
    super.initState();
  }

  @override
  void dispose() {
    _slidableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return LayoutBuilder(builder: (context, constraint) {
      return Padding(
        padding: EdgeInsetsDirectional.only(bottom: 30.r),
        child: Slidable(
            controller: _slidableController,
            groupTag: '0',
            endActionPane: ActionPane(
              motion: const BehindMotion(),
              extentRatio: 0.2,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 0.2 * constraint.maxWidth,
                    decoration: BoxDecoration(
                      color: ColorManager.errorDefault500,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        bottomLeft: Radius.circular(20.r),
                      ),
                    ),
                    alignment: AlignmentDirectional.center,
                    child: SvgPicture.asset(AppAssetManager.delete),
                  ),
                ),
              ],
            ),
            child: _buildCartItem(themeData)),
      );
    });
  }

  //builds the display of a single cart item
  Widget _buildCartItem(ThemeData themeData) {
    return GestureDetector(
      onLongPress: () => _slidableController.openEndActionPane(),
      onTap: () => _slidableController.close(),
      child: Container(
        margin: EdgeInsetsDirectional.only(start: 30.r, end: 30.r),
        color: ColorManager.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItemImage(),
            SizedBox(width: 15.r),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 7.r),
                  _buildItemName(themeData),
                  SizedBox(height: 10.r),
                  Text(
                    'Nike . Red Grey . 40',
                    style: themeData.textTheme.bodySmall!.copyWith(
                      color: ColorManager.secondaryDarkGrey,
                      fontSize: 12,
                      height: 22 / 12,
                    ),
                  ),
                  SizedBox(height: 10.r),
                  _buildPriceAndButtons(themeData),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage() {
    return Container(
      width: 88.r,
      height: 88.r,
      padding: EdgeInsetsDirectional.all(10.r),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: ColorManager.primaryDefault500.withOpacity(0.05),
      ),
      child: Image.asset(AppAssetManager.preview),
    );
  }

  Widget _buildItemName(ThemeData themeData) {
    return Text(
      'Jordan 1 Retro High Tie Dye',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: themeData.textTheme.titleLarge!
          .copyWith(fontSize: 16, fontWeight: FontWeight.w600, height: 16 / 20),
    );
  }

  Widget _buildPriceAndButtons(ThemeData themeData) {
    return Row(
      children: [
        Expanded(
          child: Text(
            Globals.currencyFormat.format(235),
            style: themeData.textTheme.titleMedium!.copyWith(
                fontSize: 14, fontWeight: FontWeight.bold, height: 24 / 14),
          ),
        ),
        ModifyQuantityButton(
          buttonType: ModifyQuantityButtonType.minus,
          enabled: false,
          onTap: () {},
        ),
        SizedBox(width: 10.r),
        Text(
          '1',
          style: themeData.textTheme.bodyLarge!.copyWith(
              fontSize: 14, fontWeight: FontWeight.bold, height: 24 / 14),
        ),
        SizedBox(width: 10.r),
        ModifyQuantityButton(
          buttonType: ModifyQuantityButtonType.add,
          enabled: true,
          onTap: () {},
        ),
      ],
    );
  }
}
