import 'package:shopping_app/core/common/enums/enums.dart';
import 'package:shopping_app/core/values/string_manager.dart';

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.man:
        return StringManager.man;
      case Gender.woman:
        return StringManager.woman;
      case Gender.unisex:
        return StringManager.unisex;
    }
  }
}
