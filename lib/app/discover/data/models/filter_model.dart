import 'package:shopping_app/app/discover/data/models/brands_model.dart';
import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/constants/constants.dart';

import 'product_model.dart';

class FilterModel {
  final BrandsModel? brand;
  final PriceRangeModel? priceRange;
  final SortByModel? sortBy;
  final Gender? gender;
  final ColorModel? color;

  const FilterModel({
    this.brand,
    this.priceRange,
    this.sortBy,
    this.gender,
    this.color,
  });

  //True if any of the filter parameters is not null
  bool get canFilter {
    return brand != null ||
        priceRange != null ||
        sortBy != null ||
        gender != null ||
        color != null;
  }

  int get activeFiltersCount {
    int count = 0;
    if (brand != null) count++;
    if (priceRange != null) count++;
    if (sortBy != null) count++;
    if (gender != null) count++;
    if (color != null) count++;
    return count;
  }

  FilterModel copyWith({
    BrandsModel? brand,
    PriceRangeModel? priceRange,
    SortByModel? sortBy,
    Gender? gender,
    ColorModel? color,
    bool setColorToNull = false,
    bool setGenderToNull = false,
    bool setSortByToNull = false,
    bool setPriceRangeToNull = false,
    bool setBrandToNull = false,
  }) {
    return FilterModel(
      brand: setBrandToNull ? null : brand ?? this.brand,
      priceRange: setPriceRangeToNull ? null : priceRange ?? this.priceRange,
      sortBy: setSortByToNull ? null : sortBy ?? this.sortBy,
      gender: setGenderToNull ? null : gender ?? this.gender,
      color: setColorToNull ? null : color ?? this.color,
    );
  }
}

class PriceRangeModel {
  final double minPrice;
  final double maxPrice;

  const PriceRangeModel(
      {this.minPrice = 0, this.maxPrice = AppConstants.maxPrice});
}

class SortByModel {
  final SortBy sortBy;
  final bool descending;

  const SortByModel({required this.sortBy, required this.descending});
}
