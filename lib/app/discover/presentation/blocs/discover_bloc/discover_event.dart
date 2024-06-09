part of 'discover_bloc.dart';

abstract class DiscoverEvent {
  const DiscoverEvent();
}

class DiscoverGetBrandsEvent extends DiscoverEvent {
  const DiscoverGetBrandsEvent();
}

class DiscoverGetProductListEvent extends DiscoverEvent {
  const DiscoverGetProductListEvent();
}

class DiscoverTabIndexChangedEvent extends DiscoverEvent {
  final int index;
  const DiscoverTabIndexChangedEvent(this.index);
}

class DiscoverGetProductsByBrandEvent extends DiscoverEvent {
  final int brandIndex;
  const DiscoverGetProductsByBrandEvent(this.brandIndex);
}
