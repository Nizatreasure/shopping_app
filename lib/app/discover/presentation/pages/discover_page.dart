import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/app/discover/data/models/item_preview_model.dart';
import 'package:shopping_app/core/common/widgets/appbar_widget.dart';
import 'package:shopping_app/core/common/widgets/cart_widget.dart';
import 'package:shopping_app/core/routes/router.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import 'package:shopping_app/globals.dart';

part '../widgets/item_preview_widget.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int tabLength = 8;
  @override
  void initState() {
    _tabController = TabController(length: tabLength, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: appbarWidget(
        context,
        title: StringManager.discover,
        largeTitle: true,
        centerTitle: false,
        showBackButton: false,
        toolbarAdditionalHeight: 20,
        titleSpacing: 30.r,
        actions: [const CartWidget()],
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor: ColorManager.transparent,
                dividerColor: ColorManager.transparent,
                labelStyle: themeData.textTheme.headlineMedium!
                    .copyWith(fontSize: 20, height: 30 / 20),
                unselectedLabelColor: ColorManager.primaryLight300,
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                isScrollable: true,
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 30.r - kTabLabelPadding.left),
                tabAlignment: TabAlignment.start,
                tabs: List.generate(
                  tabLength,
                  (index) => Tab(text: StringManager.all),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 30.r, vertical: 15.r),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 225.r,
                    crossAxisSpacing: 15.r,
                    mainAxisSpacing: 30.r,
                  ),
                  itemBuilder: (context, index) {
                    return ItemPreviewWidget(
                      item: ItemPreviewModel.fromJson(
                        {
                          'averageRating': 2.8,
                          'price': 235,
                          'name': 'Jordan 1 Retro High Tie Dye'
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewPadding.bottom,
            child: _buildFilterButton(themeData),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(ThemeData themeData) {
    return Container(
      height: 40.r,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.r),
      decoration: BoxDecoration(
        color: themeData.primaryColor,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              SvgPicture.asset(AppAssetManager.filter),
              PositionedDirectional(
                end: 0,
                child: CircleAvatar(
                  radius: 4.r,
                  backgroundColor: ColorManager.errorDefault500,
                ),
              )
            ],
          ),
          SizedBox(width: 16.r),
          Text(
            StringManager.filter.toUpperCase(),
            style: themeData.textTheme.titleMedium!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorManager.white),
          )
        ],
      ),
    );
  }
}
