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

class DiscoverGetProductDetailsEvent extends DiscoverEvent {
  final String documentID;
  const DiscoverGetProductDetailsEvent(this.documentID);
}
