import '../../core/constants/app_constants.dart';
import '../../data/service/api_service/api_service.dart';
import 'package:dio/dio.dart';

mixin PaymentApiClient{
  final ApiService _api = ApiService();

  Future<Response> setUpWalletRechargeApi(String amount) async {
    return await _api.dio.post(
        AppConstants.setUpWalletRecharge,
        data: FormData.fromMap({
          "amount": amount,
        })

    );
  }

  Future<Response> walletGiftSelectionApi(String payFromWallet,String orderId) async {
    return await _api.dio.post(
        AppConstants.walletGiftSelection,
        data: FormData.fromMap({
          "payFromWallet": payFromWallet,
          "order_id": orderId,
        })

    );
  }
}