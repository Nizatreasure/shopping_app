import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/core/values/string_manager.dart';

import 'app_select_button.dart';

class GenderFilter extends StatelessWidget {
  final List<String> _genderFields = const [
    StringManager.man,
    StringManager.woman,
    StringManager.unisex,
  ];
  const GenderFilter({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
          child: Text(
            StringManager.gender,
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
                text: v,
                selected: v == _genderFields[0],
                useLeftPadding: v != _genderFields[0],
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
