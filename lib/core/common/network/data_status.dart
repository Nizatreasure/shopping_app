import '../enums/enums.dart';
import 'data_failure_model.dart';

//Used to determine and monitor the state of a request to the server
class DataStatus<Input> {
  final Input? data;
  final DataFailure? exception;
  final DataState state;
  const DataStatus({
    this.data,
    required this.state,
    this.exception,
  });

  factory DataStatus.initial() {
    return const DataStatus(data: null, state: DataState.initial);
  }

  factory DataStatus.loading({Input? data}) {
    return DataStatus(state: DataState.loading, data: data);
  }

  factory DataStatus.success({Input? data}) {
    return DataStatus(state: DataState.success, data: data);
  }

  factory DataStatus.failure({required DataFailure exception}) {
    return DataStatus(state: DataState.failure, exception: exception);
  }
}
