import 'package:dio/dio.dart';

class client {
  static final dio =
      Dio(BaseOptions(baseUrl: "https://coded-pets-api-auth.herokuapp.com"));
}
