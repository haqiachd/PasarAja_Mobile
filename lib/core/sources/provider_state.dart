import 'package:dio/dio.dart';

abstract class ProviderState<T> {
  final T? data;
  final String? message;
  final DioException? dioException;
  
  const ProviderState({
    this.data,
    this.message,
    this.dioException,
  });
}

class OnInitState extends ProviderState {
  const OnInitState() : super();
}

class OnLoadingState extends ProviderState {
  const OnLoadingState() : super();
}

class OnSuccessState<T> extends ProviderState {
  const OnSuccessState({T? data}) : super(data: data);
}

class OnFailureState<T> extends ProviderState {
  const OnFailureState({
    String? message,
    DioException? dioException,
  }) : super(
          message: message,
          dioException: dioException,
        );
}
