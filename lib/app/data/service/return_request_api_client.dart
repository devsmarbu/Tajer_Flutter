import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

mixin ReturnRequestApiClient {
  final ApiService _api = ApiService();


  Future<Response> getReturnRequest() async {
    return await _api.dio.get(AppConstants.returnRequestSearch);
  }

  Future<Response> getRequests({
    required String type,
    required String page,
  }) async {
    FormData formData = FormData.fromMap({
      "page": page,
      "type": type,
    });

    return await _api.dio.post(
      AppConstants.requestSearch,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
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

  Future<Response> getCancelRequestDetailApi( String requestId ) async {
    return await _api.dio.get( "${AppConstants.orderCancelRequestDetail}$requestId", );
  }

  Future<Response> getMissingRequestDetailApi( String requestId ) async {
    return await _api.dio.get( "${AppConstants.orderMissingRequestDetail}$requestId", );
  }


  Future<Response> withdrawReturnReqApi( String id ) async {
    return await _api.dio.get( "${AppConstants.withdrawOrderReturnRequest}$id", );
  }

  Future<Response> withdrawMissingReqApi( String id ) async {
    return await _api.dio.get( "${AppConstants.withdrawMissingReturnRequest}$id", );
  }

  Future<Response> getExchangeRequestApi() async {
    return await _api.dio.get(AppConstants.orderReturnRequestSearch);
  }

  Future<Response> orderCancellationRequestApi() async {
    return await _api.dio.get(AppConstants.orderCancellationRequestSearch);
  }

  Future<Response> missingOrdersRequestApi() async {
    return await _api.dio.get(AppConstants.orderMissingRequestSearch);
  }

  Future<Response> orderCancelReasons() async {
    return await _api.dio.get(AppConstants.cancelOrderReason);
  }

  Future<Response> withdrawOrderExchangeReturnReqApi( String id ) async {
    return await _api.dio.get( "${AppConstants.withdrawOrderExchangeReturnRequest}$id", );
  }

  Future<Response> orderExchangeRequestApi({
    File? file,
    required String opId,
    required String oeRQty,
    required String oeRMessage,
    required String? returnReasonId,
  }) async {
    FormData formData = FormData.fromMap({
      "op_id": opId,
      "oerequest_qty": oeRQty,
      "oermsg_msg": oeRMessage,
      "oerequest_returnreason_id": returnReasonId,
    });

    // ✅ add file ONLY if it exists
    if (file != null) {
      final fileName = file.path.split('/').last;
      formData.files.add(
        MapEntry(
          "file",
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        ),
      );
    }

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
    File? file,
    required String opId,
    required String oeRQty,
    required String oeRMessage,
    required String? returnReasonId,
    required String orRequestType,
  }) async {
    FormData formData = FormData.fromMap({
      "op_id": opId,
      "orrequest_qty": oeRQty,
      "orrmsg_msg": oeRMessage,
      "orrequest_type": orRequestType,
      "orrequest_returnreason_id": returnReasonId,
    });

    // ✅ add file ONLY if it exists
    if (file != null) {
      final fileName = file.path.split('/').last;
      formData.files.add(
        MapEntry(
          "file",
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        ),
      );
    }

    return await _api.dio.post(
      AppConstants.orderReturnRequest,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
  }

  Future<Response> orderCancel({
    required String opId,
    required String ocRMessage,
    required String? cancelReasonId,
  }) async {
    FormData formData = FormData.fromMap({
      "op_id": opId,
      "ocrequest_message": ocRMessage,
      "ocrequest_ocreason_id": cancelReasonId,
    });

    return await _api.dio.post(
      AppConstants.cancelOrder,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
  }


  Future<Response> orderMissingRequestApi({
    File? file,
    required String opId,
    required String qty,
    required String msg,
    required String? returnReasonId,
    required String orRequestType,
  }) async {

    final Map<String, dynamic> data = {
      "op_id": opId,
      "orrequest_qty": qty,
      "orrmsg_msg": msg,
      "orrequest_type": orRequestType,
      "orrequest_returnreason_id": returnReasonId,
    };

    // ✅ Add file ONLY if it exists
    if (file != null) {
      data["file"] = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(data);

    return await _api.dio.post(
      AppConstants.setUpOrderMissingRequest,
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
    return await _api.dio.get("${AppConstants.returnRequestReason}$opId");
  }

  Future<Response> getExchangeReasonApi(String opId) async {
    return await _api.dio.get("${AppConstants.exchangeRequestReason}$opId");
  }

  Future<Response> getMissingReasonApi(String opId) async {
    return await _api.dio.get("${AppConstants.missingProductRequestReason}$opId");
  }
}
