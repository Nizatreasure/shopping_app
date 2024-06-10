import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app/app/discover/data/models/filter_model.dart';
import 'package:shopping_app/app/discover/presentation/blocs/discover_bloc/discover_bloc.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/common/extenstions/sort_by_extension.dart';
import 'package:shopping_app/core/values/string_manager.dart';

import 'app_select_button.dart';

class SortByFilter extends StatefulWidget {
  const SortByFilter({super.key});

  @override
  State<SortByFilter> createState() => _SortByFilterState();
}

class _SortByFilterState extends State<SortByFilter> {
  final List<SortByModel> _sortByFields = const [
    SortByModel(sortBy: SortBy.mostRecent, descending: true),
    SortByModel(sortBy: SortBy.lowestPrice, descending: false),
    SortByModel(sortBy: SortBy.highestReviews, descending: true),
    SortByModel(sortBy: SortBy.gender, descending: false),
    SortByModel(sortBy: SortBy.color, descending: false),
  ];

  final ScrollController _scrollController = ScrollController();

  List<GlobalKey> _itemKeys = [];
  List<double> _tabWidths = [];

  @override
  void initState() {
    _itemKeys = List.generate(_sortByFields.length, (index) => GlobalKey());
    _measureTabWidth();
    super.initState();
  }

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
      SortByModel? sortByModel =
          context.read<DiscoverBloc>().state.filters.sortBy;
      if (sortByModel != null && _scrollController.hasClients) {
        print('got there ');
        int index = _sortByFields
            .indexWhere((element) => element.sortBy == sortByModel.sortBy);
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
            StringManager.sortBy,
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
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsetsDirectional.symmetric(horizontal: 30.r),
                child: Row(
                  children: List.generate(_sortByFields.length, (index) {
                    return AppSelectButton(
                      key: _itemKeys[index],
                      text: _sortByFields[index].sortBy.displayName,
                      selected: _sortByFields[index] == state.filters.sortBy,
                      useLeftPadding: index != 0,
                      onTap: () {
                        context.read<DiscoverBloc>().add(DiscoverSetFilterEvent(
                            state.filters
                                .copyWith(sortBy: _sortByFields[index])));
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
