import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/core/common/widgets/appbar_widget.dart';
import 'package:shopping_app/core/common/widgets/cart_widget.dart';
import 'package:shopping_app/core/values/string_manager.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ThemeData themeData = Theme.of(context);
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 30.r),
            child: Text('I am '),
          )
        ],
      ),
    );
  }
}
