import '../../core/constants/app_constants.dart';
import '../../data/service/api_service/api_service.dart';
import 'package:dio/dio.dart';

mixin WalletApiClient{
  final ApiService _api = ApiService();

  Future<Response> getCreditSearchApi(String page,int creditType) async {
    return await _api.dio.post(
        AppConstants.creditSearch,
        data: FormData.fromMap({
          "page": page,
          "debit_credit_type": creditType
        })

    );
  }

  Future<Response> redeemGiftCardApi(String code) async {
    return await _api.dio.post(
        AppConstants.redeemGiftCard,
        data: FormData.fromMap({
          "giftcard_code": code,
        })

    );
  }

  Future<Response> setUpRequestWithdrawalApi(
      String withdrawalAmount,
      String ubBankName,
      String ubIfscSwiftCode,
      String ubAccountHolderName,
      String ubAccountNumber,
      String ubBankAddress,
      String withdrawalComments,
      ) async {
    return await _api.dio.post(
        AppConstants.setUpRequestWithdrawal,
        data: FormData.fromMap({
          "withdrawal_amount": withdrawalAmount,
          "ub_bank_name": ubBankName,
          "ub_ifsc_swift_code": ubIfscSwiftCode,
          "ub_account_holder_name": ubAccountHolderName,
          "ub_account_number": ubAccountNumber,
          "ub_bank_address": ubBankAddress,
          "withdrawal_comments": withdrawalComments,
        })
    );
  }

  Future<Response> paypalPayoutSetUpApi(
      String amount,
      String email,
      String paypalId,
      ) async {
    return await _api.dio.post(
        AppConstants.paypalPayoutSetUp,
        data: FormData.fromMap({
          "amount": amount,
          "email": email,
          "paypal_id": paypalId,
        })
    );
  }

  Future<Response> payoutsApi() async {
    return await _api.dio.get(AppConstants.payouts);
  }
}