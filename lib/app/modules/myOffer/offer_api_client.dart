import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../data/service/api_service/api_service.dart';

mixin OfferApiClient{
  final ApiService _api = ApiService();


  Future<Response> getSearchOffersApi() async {
    return await _api.dio.get(AppConstants.searchOffers);
  }
}