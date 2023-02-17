import 'package:dio/dio.dart';
import '../utils/fetcher.dart';

Future<Response> fetchUserInfoApi() async {
  final response = await fetcher(
    url: "/api/user",
    shouldValidate: true,
  );

  return response;
}
