import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopping_app/app/discover/presentation/widgets/product_review_widget.dart';
import 'package:shopping_app/core/common/widgets/appbar_widget.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import 'package:shopping_app/globals.dart';

class ProductReviewPage extends StatefulWidget {
  const ProductReviewPage({super.key});

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage>
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
    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      appBar: appbarWidget(
        context,
        title: '${StringManager.review} (1053)',
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(AppAssetManager.starFilled,
                  width: 20.r, height: 20.r),
              SizedBox(width: 5.r),
              Text(
                Globals.ratingFormat.format(4),
                style: themeData.textTheme.titleLarge!.copyWith(
                  height: 20 / 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 12.r),
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
          SizedBox(height: 20.r),
          Expanded(
            child: ListView.builder(
              itemCount: 30,
              padding:
                  EdgeInsetsDirectional.fromSTEB(30.r, 0, 30.r, bottomPadding),
              itemBuilder: (context, index) {
                return const ProductReviewWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}
