import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/presentation/blocs/discover_bloc/discover_bloc.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/values/color_manager.dart';
import 'package:shopping_app/core/values/string_manager.dart';

import 'app_select_button.dart';

class AppColorFilter extends StatefulWidget {
  const AppColorFilter({super.key});

  @override
  State<AppColorFilter> createState() => _AppColorFilterState();
}

class _AppColorFilterState extends State<AppColorFilter> {
  final List<ColorModel> _colorFields = const [
    ColorModel(color: Color(0xffFFFFFF), name: StringManager.white),
    ColorModel(color: Color(0xff000000), name: StringManager.black),
    ColorModel(color: Color(0xffFF0000), name: StringManager.red),
    ColorModel(color: Color(0xff00FF00), name: StringManager.green),
    ColorModel(color: Color(0xffA52A2A), name: StringManager.brown),
  ];

  final ScrollController _scrollController = ScrollController();

  List<GlobalKey> _itemKeys = [];
  List<double> _tabWidths = [];

  @override
  void initState() {
    _itemKeys = List.generate(_colorFields.length, (index) => GlobalKey());
    _measureTabWidth();
    super.initState();
  }

  //Calculate the width of each item in the row so that
  //the scroll controller can accurately move there when the
  //item is selected
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
      //if a color field was previously selected and the filter page (this page)
      //is opened again, scroll the selected item into view
      ColorModel? colorModel = context.read<DiscoverBloc>().state.filters.color;
      if (colorModel != null && _scrollController.hasClients) {
        int index = _colorFields
            .indexWhere((element) => element.name == colorModel.name);
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
        BlocBuilder<DiscoverBloc, DiscoverState>(
            buildWhen: (previous, current) =>
                previous.filters != current.filters,
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
                child: Row(
                  children: List.generate(_colorFields.length, (index) {
                    Color color = _colorFields[index].color;
                    return AppSelectButton(
                      key: _itemKeys[index],
                      selected: color == state.filters.color?.color,
                      useLeftPadding: index != 0,
                      buttonSelectStyle: AppButtonSelectStyle.border,
                      onTap: () {
                        context.read<DiscoverBloc>().add(DiscoverSetFilterEvent(
                            state.filters
                                .copyWith(color: _colorFields[index])));
                        _scrollToItem(index);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _colorDisplayWidget(color),
                          SizedBox(width: 10.r),
                          Text(
                            _colorFields[index].name,
                            style: themeData.textTheme.titleLarge!.copyWith(
                              fontSize: 16,
                              height: 26 / 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ),
              );
            })
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
