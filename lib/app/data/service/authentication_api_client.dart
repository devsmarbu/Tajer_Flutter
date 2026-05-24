import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tajer/utils/pref_store.dart';
import 'api_service/api_service.dart';
import '../../core/constants/app_constants.dart';

class AuthenticationApiClient {
  final ApiService _api = ApiService();

  Future<Response> getSignUpUser(
      String userName,
      // String userUsername,
      String userEmail,
      String userPassword,
      String confirmPassword,
      int newsletterSignup,
      int agree,
      String signUpWithPhone,
      String userPhone,
      String userDialCode,
      String userCountryIso,
      String referralToken,
      ) async {
    return await _api.dio.post(
      AppConstants.signUpApi,
      data: FormData.fromMap({
        'user_name': userName,
        // 'user_username': userUsername,
        'user_email': userEmail,
        'user_password': userPassword,
        'password1': confirmPassword,
        'user_newsletter_signup': newsletterSignup,
        'agree': agree,
        'signUpWithPhone': signUpWithPhone,
        'user_phone': userPhone,
        'user_phone_dcode': userDialCode, // ✅ as per your Java code
        'user_country_iso': userCountryIso,
        'referralToken': referralToken,
      }),
    );
  }

  Future<Response> loginUser(
      String userName,
      String password,
      String userType,
      String dialCode,
      ) async {
    debugPrint('this is our session id saved');
    debugPrint(PrefStore().loadString(AppConstants.sessionId) ?? "");
    return await _api.dio.post(
      AppConstants.loginUser,
      data: FormData.fromMap({
        'username': userName,
        'password': password,
        'userType': userType,
        'username_dcode': dialCode,
      }),
      options: Options(
        headers: {
          'X-APP-SESSION-ID': PrefStore().loadString(AppConstants.sessionId) ?? "",
        },
      ),
    );
  }

  Future<Response> loginUserWithOtp(
      String dcode,
      String username,
      String registerByPhone,
      ) async {
    return await _api.dio.post(
      AppConstants.loginWithOtp,
      data: FormData.fromMap({
        'username_dcode': dcode,
        'username': username,
        'registerByPhone': registerByPhone,
      }),
    );
  }

  Future<Response> saveFirebaseTokenApi(
      String deviceToken,
      String deviceOs,
      String userType,
      ) async {
    return await _api.dio.post(
      AppConstants.saveFirebaseToken,
      data: FormData.fromMap({
        'deviceToken': deviceToken,
        'deviceOs': deviceOs,
        'userType': userType,
      }),
      options: Options(
        headers: {
          'X-TOKEN': PrefStore().loadString(AppConstants.sessionToken), // if needed
        },
      ),
    );
  }

  Future<Response> forgotPassword(
      String userName,
      int withPhone,
      String phoneDcode,
      String userPhone,
      String countryCode,
      ) async {
    return await _api.dio.post(
      AppConstants.forgotPassword,
      data: FormData.fromMap({
        'user_email_username': userName,
        'withPhone': withPhone,
        'user_phone_dcode': phoneDcode,
        'user_phone': userPhone,
        'user_country_iso': countryCode,
      }),
    );
  }

  Future<Response> googleSignIn(
      String token,
      String type,
      String referralToken,
      ) async {
    return await _api.dio.post(
      AppConstants.googleLoginApi,
      data: FormData.fromMap({
        'accessToken': token,
        'type': type,
        'referralToken': referralToken
      }),
    );
  }

  Future<Response> appleLoginApi(
      String token,
      String type,
      String referralToken,
      ) async {
    return await _api.dio.post(
      AppConstants.appleLoginApi,
      data: FormData.fromMap({
        'id_token': token,
        'type': type,
        'referralToken': referralToken
      }),
    );
  }

  Future<Response> verifyOtp(
      String upvOtp,
      String userId,
      int recoverPwd,
      String flag,
      String doLoginFlag,
      ) async {
    return await _api.dio.post(
      "${AppConstants.verifyOtp}$flag}/{$doLoginFlag""}",
      data: FormData.fromMap({
        'upv_otp': upvOtp,
        'user_id': userId,
        'recoverPwd': recoverPwd
      }),
    );
  }

  Future<Response> saveProfilePhoneNumber(
      String phoneDCode,
      String userPhone,
      String phoneOtp,
      ) async {
    return await _api.dio.post(
      AppConstants.saveProfilePhoneNumber,
      data: FormData.fromMap({
        'user_phone_dcode': phoneDCode,
        'user_phone': userPhone,
        'user_phone_otp': phoneOtp
      }),
    );
  }

  Future<Response> resendOtp(
      String userId,
      ) async {
    return await _api.dio.get(
      "${AppConstants.resendOtp}$userId",
    );
  }

  Future<Response> getVerifiedNumbers() async {
    return await _api.dio.get(
      AppConstants.getVerifiedNumbers,
    );
  }

  Future<Response> accountResendOtp(
      String phoneDeCode,
      String userPhone,
      ) async {
    return await _api.dio.post(
      AppConstants.accountResendOtp,
      data: FormData.fromMap({
        'user_phone': userPhone,
        'user_phone_dcode': phoneDeCode
      }),
    );
  }
}