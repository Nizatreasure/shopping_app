import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/app/discover/presentation/blocs/discover_bloc/discover_bloc.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/extenstions/gender_extension.dart';
import 'package:shopping_app/core/values/string_manager.dart';

import 'app_select_button.dart';

class GenderFilter extends StatefulWidget {
  const GenderFilter({super.key});

  @override
  State<GenderFilter> createState() => _GenderFilterState();
}

class _GenderFilterState extends State<GenderFilter> {
  final List<Gender> _genderFields = const [
    Gender.man,
    Gender.woman,
    Gender.unisex,
  ];

  final ScrollController _scrollController = ScrollController();

  List<GlobalKey> _itemKeys = [];
  List<double> _tabWidths = [];

  @override
  void initState() {
    _itemKeys = List.generate(_genderFields.length, (index) => GlobalKey());
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
      //if a gender field was previously selected and the filter page (this page)
      //is opened again, scroll the selected item into view
      Gender? gender = context.read<DiscoverBloc>().state.filters.gender;
      if (gender != null && _scrollController.hasClients) {
        int index =
            _genderFields.indexWhere((element) => element.name == gender.name);
        if (index >= 0) {
          _scrollToItem(index);
        }
      }
    });
  }

  //Function that scrolls to the selected item to ensure it is in view
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
            StringManager.gender,
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
                  children: List.generate(_genderFields.length, (index) {
                    return AppSelectButton(
                      key: _itemKeys[index],
                      text: _genderFields[index].displayName,
                      selected: _genderFields[index] == state.filters.gender,
                      useLeftPadding: index != 0,
                      onTap: () {
                        context.read<DiscoverBloc>().add(DiscoverSetFilterEvent(
                            state.filters
                                .copyWith(gender: _genderFields[index])));
                        _scrollToItem(index);
                      },
                    );
                  }),
                ),
              );
            })
      ],
    );
  }
}
