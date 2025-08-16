import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_manager.g.dart';

@riverpod
class NetworkManager extends _$NetworkManager {
  static const _baseUrl = 'https://pokeapi.co/api/v2/';
  static const _connectTimeout = Duration(seconds: 10);
  static const _receiveTimeout = Duration(seconds: 10);

  @override
  Dio build() {
    final dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
    ));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('Error: ${error.response?.statusCode}');
        return handler.next(error);
      },
    ));
    return dio;
  }
}