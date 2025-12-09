import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

mixin ReturnRequestApiClient {
  final ApiService _api = ApiService();


  Future<Response> getReturnRequest() async {
    return await _api.dio.get(AppConstants.returnRequestSearch);
  }

  Future<Response> getTempTokenApi() async {
    return await _api.dio.get(AppConstants.getTempToken);
  }

  Future<Response> getRequestDetailApi( String requestId ) async {
    return await _api.dio.get( "${AppConstants.returnRequestDetail}$requestId", );
  }

  Future<Response> getExchangeRequestDetailApi( String requestId ) async {
    return await _api.dio.get( "${AppConstants.exchangeRequestDetail}$requestId", );
  }

  Future<Response> withdrawReturnReqApi( String id ) async {
    return await _api.dio.get( "${AppConstants.withdrawOrderReturnRequest}$id", );
  }

  Future<Response> getExchangeRequestApi() async {
    return await _api.dio.get(AppConstants.orderReturnRequestSearch);
  }

  Future<Response> orderCancellationRequestApi() async {
    return await _api.dio.get(AppConstants.orderCancellationRequestSearch);
  }

  Future<Response> withdrawOrderExchangeReturnReqApi( String id ) async {
    return await _api.dio.get( "${AppConstants.withdrawOrderExchangeReturnRequest}$id", );
  }

  Future<Response> orderExchangeRequestApi({
    required File file,
    required String opId,
    required String oeRQty,
    required String oeRMessage,
    required String returnReasonId,
  }) async {
    final fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      "op_id": opId,
      "oerequest_qty": oeRQty,
      "oermsg_msg": oeRMessage,
      "oerequest_returnreason_id": returnReasonId,
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    return await _api.dio.post(
      AppConstants.orderExchangeRequest,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
  }

  Future<Response> orderRequestRequestApi({
    required File file,
    required String opId,
    required String oeRQty,
    required String oeRMessage,
    required String returnReasonId,
    required String orRequestType,
  }) async {
    final fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      "op_id": opId,
      "oerequest_qty": oeRQty,
      "oermsg_msg": oeRMessage,
      "orrequest_type": orRequestType,
      "oerequest_returnreason_id": returnReasonId,
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    return await _api.dio.post(
      AppConstants.orderExchangeRequest,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
  }

  Future<Response> getReturnReasonApi(String opId) async {
    return await _api.dio.get("${AppConstants.returnRequestReason}$opId}");
  }

  Future<Response> getExchangeReasonApi(String opId) async {
    return await _api.dio.get("${AppConstants.exchangeRequestReason}$opId}");
  }
}
