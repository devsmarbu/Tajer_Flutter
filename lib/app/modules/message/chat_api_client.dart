import '../../core/constants/app_constants.dart';
import '../../data/service/api_service/api_service.dart';
import 'package:dio/dio.dart';

mixin ChatApiClient{
  final ApiService _api = ApiService();

  Future<Response> getChatList(int page) async {
    return await _api.dio.post(
        AppConstants.messageSearch,
        data: FormData.fromMap({
          "page": page,
        })

    );
  }

  Future<Response> getMessageList(String threadId,int page) async {
    return await _api.dio.post(
        AppConstants.threadMessageSearch,
        data: FormData.fromMap({
          "thread_id": threadId,
          "page": page,
        })

    );
  }

  Future<Response> orderReturnRequestMessageSearchApi(String requestId,int page) async {
    return await _api.dio.post(
        AppConstants.orderReturnRequestMessageSearch,
        data: FormData.fromMap({
          "orrequest_id": requestId,
          "page": page,
        })

    );
  }

  Future<Response> orderExchangeRequestMessageSearchApi(String requestId,int page) async {
    return await _api.dio.post(
        AppConstants.orderExchangeRequestMessageSearch,
        data: FormData.fromMap({
          "oerequest_id": requestId,
          "page": page,
        })

    );
  }

  Future<Response> sendMessageApi(String message,String messageThreadId,String messageId) async {
    return await _api.dio.post(
        AppConstants.sendMessage,
        data: FormData.fromMap({
          "message_text": message,
          "message_thread_id": messageThreadId,
          "message_id": messageId,
        })

    );
  }

  Future<Response> sendMessageReturnOrderApi(String message,String orRequestId) async {
    return await _api.dio.post(
        AppConstants.sendMessageReturnOrder,
        data: FormData.fromMap({
          "orrmsg_msg": message,
          "orrmsg_orrequest_id": orRequestId,
        })

    );
  }

  Future<Response> sendMessageExchangeOrderApi(String message,String orRequestId) async {
    return await _api.dio.post(
        AppConstants.sendMessageExchangeOrder,
        data: FormData.fromMap({
          "oermsg_msg": message,
          "oermsg_oerequest_id": orRequestId,
        })

    );
  }
}