import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/core/common/widgets/app_button_widget.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';

class DeleteConfirmationWidget extends StatelessWidget {
  const DeleteConfirmationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(30.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 20.r),
            child: Text(
              StringManager.deleteConfirmation,
              style: themeData.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40.r),
          Row(
            children: [
              Expanded(
                child: AppButtonWidget(
                  text: StringManager.no.toUpperCase(),
                  borderColor: ColorManager.primaryLight200,
                  backgroundColor: ColorManager.transparent,
                  textColor: ColorManager.primaryDefault500,
                  onTap: () => context.pop(false),
                ),
              ),
              SizedBox(width: 15.r),
              Expanded(
                child: AppButtonWidget(
                  text: StringManager.yes.toUpperCase(),
                  onTap: () => context.pop(true),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
