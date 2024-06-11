part of 'discover_bloc.dart';

@immutable
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

class DiscoverSetFilterEvent extends DiscoverEvent {
  final FilterModel filters;
  const DiscoverSetFilterEvent(this.filters);
}

class DiscoverClearFilterEvent extends DiscoverEvent {
  const DiscoverClearFilterEvent();
}

class DiscoverApplyFilterEvent extends DiscoverEvent {
  const DiscoverApplyFilterEvent();
}
