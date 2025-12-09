import 'dart:io';

import 'package:dio/dio.dart';
import 'api_service/api_service.dart';
import '../../core/constants/app_constants.dart';

mixin AccountApiClient{
  final ApiService _api = ApiService();


  Future<Response> getProfileInfoApi(
      String token
      ) async {
    return await _api.dio.post(
      AppConstants.getProfileInfo,
      data: FormData.fromMap({
        '_token': token,
      }),
    );
  }

  Future<Response> getAgreementUrlApi() async {
    return await _api.dio.get(AppConstants.signUpAgreementUrl);
  }

  Future<Response> getCurrencyApi() async {
    return await _api.dio.get(AppConstants.getCurrency);
  }

  Future<Response> getLanguagesApi() async {
    return await _api.dio.get(AppConstants.getLanguage);
  }

  Future<Response> logoutUserApi(
      String fcmToken,
      String userType,
      ) async {
    return await _api.dio.post(
      AppConstants.logoutUser,
      data: FormData.fromMap({
        'fcmToken': fcmToken,
        'userType': userType,
      }),
    );
  }

  Future<Response> updateBankInfoApi(
      String bankName,
      String accountHolderName,
      String accountNumber,
      String ifscCode,
      String bankAddress,
      ) async {
    return await _api.dio.post(
      AppConstants.updateBankInfo,
      data: FormData.fromMap({
        'ub_bank_name': bankName,
        'ub_account_holder_name': accountHolderName,
        'ub_account_number': accountNumber,
        'ub_ifsc_swift_code': ifscCode,
        'ub_bank_address': bankAddress,
      }),
    );
  }

  Future<Response> setUpRequestDataApi(
      String userName,
      String email,
      String purpose
      ) async {
    return await _api.dio.post(
      AppConstants.setUpRequestData,
      data: FormData.fromMap({
        'user_name': userName,
        'credential_email': email,
        'ureq_purpose': purpose,
      }),
    );
  }

  Future<Response> changeEmailApi(
      String email,
      String confNewEmail,
      String currentPassword
      ) async {
    return await _api.dio.post(
      AppConstants.changeEmail,
      data: FormData.fromMap({
        'new_email': email,
        'conf_new_email': confNewEmail,
        'current_password': currentPassword,
      }),
    );
  }

  Future<Response> updatePasswordApi(
      String currentPassword,
      String newPassword,
      String conNewPassword
      ) async {
    return await _api.dio.post(
      AppConstants.updatePassword,
      data: FormData.fromMap({
        'current_password': currentPassword,
        'new_password': newPassword,
        'conf_new_password': conNewPassword,
      }),
    );
  }

  Future<Response> getOtpApi(
      String flag,
      String userPhone,
      String phoneDCode,
      String userFor
      ) async {
    return await _api.dio.post(
      "${AppConstants.getOtp}$flag}",
      data: FormData.fromMap({
        'user_phone': userPhone,
        'user_phone_dcode': phoneDCode,
        'use_for': userFor,
      }),
    );
  }

  Future<Response> verifyOtpAccount(
      String upvOtp,
      String userId,
      int recoverPwd,
      String flag
      ) async {
    return await _api.dio.post(
      "${AppConstants.verifyOtp}$flag}",
      data: FormData.fromMap({
        'upv_otp': upvOtp,
        'user_id': userId,
        'recoverPwd': recoverPwd
      }),
    );
  }


  Future<Response> updateProfileApi(
      String userCountryId,
      String userStateId,
      String userName,
      String userPhone,
      String userCity,
      String userCompany,
      String userProfileInfo,
      String userProductsServices,
      String userDob,
      String userPhoneDCode,
      ) async {
    return await _api.dio.post(
      AppConstants.updateProfileInfo,
      data: FormData.fromMap({
        'user_country_id': userCountryId,
        'user_state_id': userStateId,
        'user_name': userName,
        'user_phone': userPhone,
        'user_city': userCity,
        'user_company': userCompany,
        'user_profile_info': userProfileInfo,
        'user_products_services': userProductsServices,
        'user_dob': userDob,
        'user_phone_dcode': userPhoneDCode,
      }),
    );
  }

  Future<Response> uploadProfilePic({
    required File file,
    required String token
  }) async {
    final fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      "_token": token,
      "action": "avatar",
      "file": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    return await _api.dio.post(
      AppConstants.uploadProfileImage,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        },
      ),
    );
  }

  Future<Response> removeProfilePic() async {
    return await _api.dio.get(AppConstants.removeProfileImage);
  }

  Future<Response> contactUsApi(
      String name,
      String email,
      String phone,
      String dCode,
      String message,
      String agree,
      ) async {
    return await _api.dio.post(
      AppConstants.contactSubmit,
      data: FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'phone_dcode': dCode,
        'message': message,
        'agree': agree,
      }),
    );
  }

}