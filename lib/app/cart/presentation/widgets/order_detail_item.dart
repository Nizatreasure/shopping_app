import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/globals.dart';

class OrderDetailItem extends StatelessWidget {
  const OrderDetailItem({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jordan 1 Retro High Tie Dye',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: themeData.textTheme.titleLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 26 / 16,
            ),
          ),
          SizedBox(height: 10.r),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Nike . Red Grey . 40 . Qty 1',
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    height: 24 / 14,
                    color: ColorManager.secondaryDarkGrey,
                  ),
                ),
              ),
              Text(
                Globals.currencyFormat.format(235),
                style: themeData.textTheme.titleMedium!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 24 / 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
