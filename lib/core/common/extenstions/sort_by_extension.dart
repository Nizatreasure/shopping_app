import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/values/string_manager.dart';

extension SortByExtension on SortBy {
  String get displayName {
    switch (this) {
      case SortBy.mostRecent:
        return StringManager.mostRecent;
      case SortBy.lowestPrice:
        return StringManager.lowestPrice;
      case SortBy.highestReviews:
        return StringManager.highestReviews;
      case SortBy.gender:
        return StringManager.gender;
      case SortBy.color:
        return StringManager.color;
    }
  }

  String get sortingField {
    switch (this) {
      case SortBy.mostRecent:
        return 'created_at';
      case SortBy.lowestPrice:
        return 'price.amount';
      case SortBy.highestReviews:
        return 'review_info.average_rating';
      case SortBy.gender:
        return 'gender';
      case SortBy.color:
        return 'colors';
    }
  }
}
