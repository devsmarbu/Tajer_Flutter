import 'package:dio/dio.dart';
import 'api_service/api_service.dart';
import '../../core/constants/app_constants.dart';

class SplashApiClient {
  final ApiService _api = ApiService();

  // ✅ getStatus API call
  Future<Response> getStatus() async {
    return await _api.dio.get(AppConstants.getStatus);
  }

  // ✅ get Splash Screen Data API call
  Future<Response> getSplashScreenData() async {
    return await _api.dio.get(AppConstants.splashScreenData);
  }

  Future<Response> employeeRegistrationStatusApi(String token) async {
    return await _api.dio.get(token);
  }
}