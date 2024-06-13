part of '../pages/cart_page.dart';

class CartItemWidget extends StatefulWidget {
  final CartModel? cartModel;
  final bool loading;
  final Animation<double>? animation;

  const CartItemWidget({
    super.key,
    this.cartModel,
    required this.loading,
    required this.animation,
  });

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
    return widget.animation == null
        ? _buildBody(themeData)
        : SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(widget.animation!),
            child: _buildBody(themeData),
          );
  }

  Widget _buildBody(ThemeData themeData) {
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
                onTap: () async {
                  if (widget.cartModel == null) return;
                  bool? delete = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useRootNavigator: true,
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).viewPadding.top -
                            20.r),
                    builder: (context) {
                      return const DeleteConfirmationWidget();
                    },
                  );
                  _slidableController.close();
                  if (delete != true || !context.mounted) return;
                  Completer<bool> completer = Completer<bool>();
                  context.read<CartBloc>().add(
                      CartDeleteProductEvent(widget.cartModel!, completer));
                  bool success = await completer.future;
                  if (!success && context.mounted) {
                    showAppMaterialBanner(context,
                        text: StringManager.removeFromCartFailed);
                  }
                },
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
          child: _buildCartItem(themeData),
        ),
      );
    });
  }

  //builds the display of a single cart item
  Widget _buildCartItem(ThemeData themeData) {
    return GestureDetector(
      onLongPress: () => _slidableController.openEndActionPane(),
      onTap: () {
        //if a slidable is open, close it
        if (_slidableController.isOpen) {
          _slidableController.close();
          return;
        }

        //if it is not open, go to the product details page
        context.goNamed(RouteNames.productDetails, extra: {
          'product_id': widget.cartModel?.productID,
          'document_id': widget.cartModel?.productDocumentID
        });
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(start: 30.r, end: 30.r),
        color: ColorManager.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItemImage(widget.cartModel),
            SizedBox(width: 15.r),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 7.r),
                  _buildItemName(themeData, widget.cartModel),
                  SizedBox(height: 10.r),
                  _buildBrandColorAndSize(themeData, widget.cartModel),
                  SizedBox(height: 10.r),
                  _buildPriceAndButtons(context, themeData, widget.cartModel),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBrandColorAndSize(ThemeData themeData, CartModel? cartModel) {
    return ShimmerWidget(
      loading: widget.loading,
      height: 13,
      margin: EdgeInsetsDirectional.only(end: 50.r),
      borderRadius: 3,
      child: cartModel == null
          ? const SizedBox()
          : Text(
              '${cartModel.brandName} . ${cartModel.color.name} . ${cartModel.size}',
              style: themeData.textTheme.bodySmall!.copyWith(
                color: ColorManager.secondaryDarkGrey,
                fontSize: 12,
                height: 22 / 12,
              ),
            ),
    );
  }

  Widget _buildItemImage(CartModel? cartModel) {
    return ShimmerWidget(
      loading: widget.loading,
      width: 88.r,
      height: 88.r,
      child: cartModel == null
          ? const SizedBox()
          : Container(
              width: 88.r,
              height: 88.r,
              padding: EdgeInsetsDirectional.all(10.r),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: ColorManager.primaryDefault500.withOpacity(0.05),
              ),
              child: CustomNetworkImage(
                imageUrl: cartModel.imageUrl,
                key: cartModel.imageKey,
                fit: BoxFit.cover,
                onRetry: () {
                  setState(() {
                    cartModel.copyWith(imageKey: UniqueKey());
                  });
                },
              ),
            ),
    );
  }

  Widget _buildItemName(ThemeData themeData, CartModel? cartModel) {
    return ShimmerWidget(
      loading: widget.loading,
      height: 20,
      borderRadius: 3,
      margin: EdgeInsetsDirectional.only(end: 30.r),
      child: cartModel == null
          ? const SizedBox()
          : Text(
              cartModel.productName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: themeData.textTheme.titleLarge!.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w600, height: 16 / 20),
            ),
    );
  }

  Widget _buildPriceAndButtons(
      BuildContext context, ThemeData themeData, CartModel? cartModel) {
    return ShimmerWidget(
      loading: widget.loading,
      borderRadius: 3,
      child: cartModel == null
          ? const SizedBox()
          : Row(
              children: [
                Expanded(
                  child: Text(
                    '${cartModel.price.symbol}${Globals.amountFormat.format(cartModel.price.amount)}',
                    style: themeData.textTheme.titleMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 24 / 14),
                  ),
                ),
                ModifyQuantityButton(
                  buttonType: ModifyQuantityButtonType.minus,
                  enabled: cartModel.quantity > 1 && !cartModel.loading,
                  onTap: () {
                    context.read<CartBloc>().add(
                        CartUpdateQuantityEvent(cartModel, increase: false));
                  },
                ),
                SizedBox(width: 10.r),
                Builder(builder: (context) {
                  return cartModel.loading
                      ? SizedBox(
                          height: 10.r,
                          width: 10.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.r,
                            color: ColorManager.primaryBlack600,
                          ),
                        )
                      : Text(
                          cartModel.quantity.toString(),
                          style: themeData.textTheme.bodyLarge!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 24 / 14),
                        );
                }),
                SizedBox(width: 10.r),
                ModifyQuantityButton(
                  buttonType: ModifyQuantityButtonType.add,
                  enabled:
                      cartModel.quantity < AppConstants.maxQuantityForProduct &&
                          !cartModel.loading,
                  onTap: () {
                    context
                        .read<CartBloc>()
                        .add(CartUpdateQuantityEvent(cartModel));
                  },
                ),
              ],
            ),
    );
  }
}
