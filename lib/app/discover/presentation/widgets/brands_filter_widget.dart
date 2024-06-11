part of '../pages/product_filter_page.dart';

class BrandsFilterWidget extends StatefulWidget {
  const BrandsFilterWidget({super.key});

  @override
  State<BrandsFilterWidget> createState() => _BrandsFilterWidgetState();
}

class _BrandsFilterWidgetState extends State<BrandsFilterWidget> {
  final ScrollController _scrollController = ScrollController();

  List<GlobalKey> _itemKeys = [];
  List<double> _tabWidths = [];

  @override
  void initState() {
    _itemKeys = List.generate(context.read<DiscoverBloc>().state.brands.length,
        (index) => GlobalKey());
    _measureTabWidth();
    super.initState();
  }

  void _measureTabWidth() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<double> widths = List.generate(_itemKeys.length, (index) => 0);
      for (int i = 0; i < _itemKeys.length; i++) {
        final RenderBox? box =
            _itemKeys[i].currentContext?.findRenderObject() as RenderBox?;
        if (box != null) {
          widths[i] = box.size.width;
        }
      }
      _tabWidths = widths;
      DiscoverState state = context.read<DiscoverBloc>().state;
      BrandsModel? brandModel = state.filters.brand;
      if (brandModel != null && _scrollController.hasClients) {
        int index = state.brands
            .indexWhere((element) => element.name == brandModel.name);
        if (index >= 0) {
          _scrollToItem(index);
        }
      }
    });
  }

  void _scrollToItem(int index) {
    double position = 0.0;
    for (int i = 0; i < index; i++) {
      position += _tabWidths[i];
    }

    position -= MediaQuery.of(context).size.width / 2 - _tabWidths[index] / 2;

    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return BlocBuilder<DiscoverBloc, DiscoverState>(
        buildWhen: (previous, current) =>
            previous.brands != current.brands ||
            previous.filters != current.filters,
        builder: (context, state) {
          //actual brand length is one less than the size of the list
          //because the first brand is all
          int brandLength = state.brands.length - 1;
          return brandLength == 0
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.symmetric(horizontal: 30.r),
                      child: Text(
                        StringManager.brands,
                        style: themeData.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 26 / 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.r),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      physics: const ClampingScrollPhysics(),
                      padding:
                          EdgeInsetsDirectional.symmetric(horizontal: 30.r),
                      child: Row(
                        children: List.generate(
                          brandLength,
                          (index) {
                            BrandsModel brand = state.brands[index + 1];
                            return _buildBrands(
                                context, themeData, brand, state,
                                key: _itemKeys[index], index: index);
                          },
                        ),
                      ),
                    )
                  ],
                );
        });
  }

  Widget _buildBrands(BuildContext context, ThemeData themeData,
      BrandsModel brand, DiscoverState state,
      {required GlobalKey key, required int index}) {
    bool selected = state.filters.brand?.name == brand.name;
    return GestureDetector(
      onTap: () {
        context
            .read<DiscoverBloc>()
            .add(DiscoverSetFilterEvent(state.filters.copyWith(brand: brand)));
        _scrollToItem(index);
      },
      child: Container(
        width: 70.r,
        key: key,
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
                  child: SvgPicture.network(
                    brand.logo,
                    colorFilter: const ColorFilter.mode(
                        ColorManager.primaryDefault500, BlendMode.srcIn),
                  ),
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
              brand.name,
              textAlign: TextAlign.center,
              style: themeData.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.bold, height: 24 / 14),
            ),
            Text(
              '${brand.totalProductCount} items',
              textAlign: TextAlign.center,
              style: themeData.textTheme.bodySmall!
                  .copyWith(fontSize: 11, color: ColorManager.primaryLight300),
            )
          ],
        ),
      ),
    );
  }
}
