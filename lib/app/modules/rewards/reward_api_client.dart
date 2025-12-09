import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../data/service/api_service/api_service.dart';

mixin RewardApiClient{

  final ApiService _api = ApiService();

  Future<Response> rewardPointsSearchApi(int page) async {
    return await _api.dio.post(
        AppConstants.rewardPointsSearch,
        data: FormData.fromMap({
          "page": page,
        })

    );
  }
}