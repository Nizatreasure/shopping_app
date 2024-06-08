import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/tooltip/tooltip_position_offset.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/common/widgets/appbar_widget.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';
import '../widgets/color_filter.dart';

import '../widgets/gender_filter.dart';
import '../widgets/sort_by_filter.dart';

part '../widgets/brands_filter_widget.dart';
part '../widgets/price_range_filter_widget.dart';

class ProductFilterPage extends StatelessWidget {
  const ProductFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      appBar: appbarWidget(context, title: StringManager.filter),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(bottom: 30.r, top: 20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandsFilterWidget(),
                  SizedBox(height: 30.r),
                  PriceRangeFilterWidget(),
                  SizedBox(height: 30.r),
                  const SortByFilter(),
                  SizedBox(height: 30.r),
                  const GenderFilter(),
                  SizedBox(height: 30.r),
                  const ColorFilter(),
                ],
              ),
            ),
          ),
          _buildBottomPageWidget(themeData, bottomPadding),
        ],
      ),
    );
  }

  Widget _buildBottomPageWidget(ThemeData themeData, double bottomPadding) {
    return Container(
      height: 90.r + bottomPadding,
      decoration: BoxDecoration(
        color: ColorManager.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 30.r,
            spreadRadius: 0,
            color: ColorManager.lightGrey.withOpacity(0.2),
            offset: const Offset(0, -20),
          )
        ],
      ),
      alignment: Alignment.topCenter,
      padding:
          EdgeInsetsDirectional.symmetric(horizontal: 30.r, vertical: 20.r),
      child: Row(
        children: [
          Expanded(
            child: AppButtonWidget(
              text: '${StringManager.reset.toUpperCase()} (4)',
              borderColor: ColorManager.primaryLight200,
              backgroundColor: ColorManager.transparent,
              textColor: ColorManager.primaryDefault500,
              onTap: () {},
            ),
          ),
          SizedBox(width: 15.r),
          Expanded(
            child: AppButtonWidget(
              text: StringManager.apply.toUpperCase(),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
