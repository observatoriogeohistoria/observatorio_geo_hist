import 'package:equatable/equatable.dart';

abstract class GeneralState<T> extends Equatable {
  @override
  List<Object> get props => [];

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    R Function()? noConnection,
    required R Function(String message) error,
    R Function()? success,
    R Function(T data)? successWithData,
  }) {
    print(this);

    if (this is GeneralInitialState<T>) {
      return initial();
    } else if (this is GeneralLoadingState<T>) {
      return loading();
    } else if (this is GeneralNoConnectionState<T>) {
      if (noConnection == null) throw Exception('No connection state not handled');
      return noConnection();
    } else if (this is GeneralErrorState<T>) {
      return error((this as GeneralErrorState<T>).message);
    } else if (this is GeneralSuccessState<T>) {
      if (success == null) throw Exception('Success state not handled');
      return success();
    } else if (this is GeneralSuccessWithDataState<T>) {
      if (successWithData == null) throw Exception('Success with data state not handled');
      return successWithData((this as GeneralSuccessWithDataState<T>).data);
    }
    throw Exception('Unknown state: $this');
  }
}

abstract class GeneralInitialState<T> extends GeneralState<T> {}

abstract class GeneralLoadingState<T> extends GeneralState<T> {}

abstract class GeneralNoConnectionState<T> extends GeneralState<T> {}

abstract class GeneralErrorState<T> extends GeneralState<T> {
  final String message;
  GeneralErrorState(this.message);
}

abstract class GeneralSuccessState<T> extends GeneralState<T> {}

abstract class GeneralSuccessWithDataState<T> extends GeneralState<T> {
  final T data;
  GeneralSuccessWithDataState(this.data);
}
