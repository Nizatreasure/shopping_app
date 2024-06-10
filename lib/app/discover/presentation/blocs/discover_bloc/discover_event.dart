part of 'discover_bloc.dart';

abstract class DiscoverEvent {
  const DiscoverEvent();
}

class DiscoverGetBrandsEvent extends DiscoverEvent {
  const DiscoverGetBrandsEvent();
}

class DiscoverGetProductListEvent extends DiscoverEvent {
  final int index;
  const DiscoverGetProductListEvent(this.index);
}

class DiscoverTabIndexChangedEvent extends DiscoverEvent {
  final int index;
  const DiscoverTabIndexChangedEvent(this.index);
}
