import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../../common/functions/app_function.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';

class ApiService {
  late final Dio _dio;
  final PrefStore pref = PrefStore();

  // api
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
           'X-TOKEN': pref.loadString(AppConstants.sessionToken) ?? "",
          'X-APP-SESSION-ID': pref.loadString(AppConstants.sessionId) ?? "",
          'X-USER-TYPE': '1',
          'Cache-Control': 'no-cache',
          'X-IP-COUNTRY-ID': '173',
          'X-NEW-APP-VERSION': '1',
          'Cookie': '',
          'X-Affiliate-Code' : pref.loadString("affiliate_referral_id")

      },
      ),
    );

    // Interceptors
    _dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final hasInternet = await NetworkChecker.hasInternet();
          if (!hasInternet) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: 'No Internet Connection',
              ),
            );
          }
          // ✅ Update dynamic headers before every request
          final session = pref.loadString("PHPSESSID");

          if (session != null && session.isNotEmpty) {
            options.headers['Cookie'] = "PHPSESSID=$session";
          }
          options.headers['X-LANGUAGE-ID'] =
              pref.loadString(AppConstants.languageId) ?? "1";
          options.headers['X-YK-COUNTRY-CODE'] =
              pref.loadString(AppConstants.languageCountryCode) ?? "US";
          options.headers['X-IP-COUNTRY-CODE'] =
              pref.loadString(AppConstants.countryCode) ?? "QA";
          options.headers['X-IP-COUNTRY-ID'] =
              pref.loadString(AppConstants.countryId) ?? "173";
          options.headers['X-CURRENCY-ID'] =
              pref.loadString(AppConstants.currencyId) ?? "";
          options.headers['X-Affiliate-Code'] =
              pref.loadString("affiliate_referral_id");

          log('🌐 [REQUEST] ${options.method} ${options.uri}');
          log('🔸 Headers: ${options.headers}');
          if (options.data != null) log('📤 Body: ${options.data}');
           return handler.next(options);
        },
        // onResponse: (response, handler) {
        //   log('✅ [RESPONSE] [${response.statusCode}] ${response.requestOptions.uri}');
        //   if (response.data != null) log('📥 Data: ${response.data}');
        //   return handler.next(response);
        // },
        onResponse: (response, handler) async {
          final cookies = response.headers['set-cookie'];

          if (cookies != null) {
            for (var cookie in cookies) {
              if (cookie.contains("PHPSESSID")) {
                final session = cookie.split(';').first;
                final value = session.split('=').last;
                pref.saveString("PHPSESSID", value);
              }
            }
          }

          log(
            '✅ [RESPONSE] [${response.statusCode}] ${response.requestOptions.uri}',
          );
          if (response.data != null) log('📥 Data: ${response.data}');

          // ✅ Check session expiry
          if (response.data is Map && response.data['displayLoginForm'] == 1) {
            log('⚠️ Session Expired - Redirecting to Login');
            await pref.saveString("PHPSESSID", "");
            // Clear session if needed
            // await pref.clearAll();
            await pref.saveString(AppConstants.sessionToken,'');

            // Navigate to login (using GetX)
            final currentRoute = Get.currentRoute;

            debugPrint('cyyyrent baseurl is${response.realUri.path}');
            if (!response.realUri.path.contains(AppConstants.paymentSummaryWithShippingSelection)) {
              Future.microtask(() {
                // Get.offAllNamed(AppRoutes.login);
                Get.toNamed(AppRoutes.login);
              });
              return; // stop further processing
            }
          }

          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log('❌ [ERROR] ${e.type}');
          log('❌ Message: ${e.message}');
          if (e.response != null) {
            log('❌ Response Data: ${e.response?.data}');
            log('❌ Status Code: ${e.response?.statusCode}');
          }
          return handler.next(e);
        },
      ),
    ]);
  }

  Dio get dio => _dio;
}
