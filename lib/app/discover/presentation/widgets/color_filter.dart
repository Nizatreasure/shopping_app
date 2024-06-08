import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';

import 'app_select_button.dart';

class ColorFilter extends StatelessWidget {
  final List<Map> _genderFields = const [
    {StringManager.white: 'FFFFFF'},
    {StringManager.black: '000000'},
    {StringManager.red: 'FF0000'},
  ];
  const ColorFilter({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
          child: Text(
            StringManager.color,
            style: themeData.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600, fontSize: 16, height: 26 / 16),
          ),
        ),
        SizedBox(height: 20.r),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
          child: Row(
            children: _genderFields.map((v) {
              return AppSelectButton(
                selected: v == _genderFields[0],
                useLeftPadding: v != _genderFields[0],
                buttonSelectStyle: AppButtonSelectStyle.border,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _colorDisplayWidget(
                        Color(int.parse('0xff${v.values.first}'))),
                    SizedBox(width: 10.r),
                    Text(
                      v.keys.first,
                      style: themeData.textTheme.titleLarge!.copyWith(
                        fontSize: 16,
                        height: 26 / 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _colorDisplayWidget(Color color) {
    bool hasBorder = color == ColorManager.white;
    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: hasBorder
              ? Border.all(color: ColorManager.primaryLight200)
              : null),
    );
  }
}
