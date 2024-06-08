import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopping_app/core/values/asset_manager.dart';
import 'package:shopping_app/core/values/color_manager.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  const AppListTile({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: themeData.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 24 / 14,
                ),
              ),
              SizedBox(height: 5.r),
              Text(
                subtitle,
                style: themeData.textTheme.bodyMedium!.copyWith(
                  color: ColorManager.secondaryDarkGrey,
                  fontSize: 14,
                  height: 24 / 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20.r),
        SvgPicture.asset(AppAssetManager.arrowRight)
      ],
    );
  }
}
