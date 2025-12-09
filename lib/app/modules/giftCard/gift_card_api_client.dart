import '../../core/constants/app_constants.dart';
import '../../data/service/api_service/api_service.dart';
import 'package:dio/dio.dart';

mixin GiftCardApiClient{

  final ApiService _api = ApiService();


  Future<Response> setUpGiftCardApi(String amount,String receiverName,String receiverEmail) async {
    return await _api.dio.post(
        AppConstants.setUpGiftCard,
        data: FormData.fromMap({
          "order_total_amount": amount,
          "ogcards_receiver_name": receiverName,
          "ogcards_receiver_email": receiverEmail
        })

    );
  }

  Future<Response> searchGiftCardsApi(String keyword,int page,String ogCardsStatus,String orderPaymentStatus) async {
    return await _api.dio.post(
        AppConstants.searchGiftCards,
        data: FormData.fromMap({
          "keyword": keyword,
          "page": page,
          "ogcards_status": ogCardsStatus,
          "order_payment_status": orderPaymentStatus,
        })

    );
  }

}