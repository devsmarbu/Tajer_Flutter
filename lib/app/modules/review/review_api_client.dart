import '../../core/constants/app_constants.dart';
import '../../data/service/api_service/api_service.dart';
import 'package:dio/dio.dart';

mixin ReviewApiClient{
  final ApiService _api = ApiService();

  Future<Response> orderFeedback(String opId) async {
    return await _api.dio.get("${AppConstants.orderFeedback}$opId");
  }


  Future<Response> orderFeedbackApiRequest(
      Map<String, dynamic> fields,
      List<String> filePaths,
      ) async {
    FormData formData = FormData();

    /// ✔ Convert text data (PartMap)
    fields.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    /// ✔ Convert files (ArrayList<MultipartBody.Part>)
    for (String path in filePaths) {
      formData.files.add(
        MapEntry(
          "files[]",
          await MultipartFile.fromFile(path),
        ),
      );
    }

    return await _api.dio.post(
      AppConstants.setUpOrderFeedback,
      data: formData,
    );
  }
}