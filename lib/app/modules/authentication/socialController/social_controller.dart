import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../common/functions/app_function.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/base_response.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/service/authentication_api_client.dart';
import '../../Account/controller/account_controller.dart';
import '../../categories/category_controller.dart';
import '../../home/home_controller.dart';
import '../../navigation/bottom_navigation.dart';
import '../login/login_data.dart';

class SocialController extends GetxController{

  final isLoading = false.obs;
  final _apiClient = AuthenticationApiClient();
  final pref = PrefStore();

  void loginWithGoogle() async {
    try {
      isLoading.value = true;

      print("🔹 Starting Google Sign-In...");

      // Step 1: Trigger Google Sign-In
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("⚠️ User canceled Google Sign-In");
        AppDialog.showMessage("Google Sign-In was canceled.");
        isLoading.value = false;
        return;
      }

      print("✅ Google user selected: ${googleUser.email}");

      // Step 2: Get authentication details
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      print("🔹 Received ID token: ${idToken != null ? 'Yes' : 'No'}");
      print("🔹 Received Access token: ${accessToken != null ? 'Yes' : 'No'}");

      if (idToken == null || idToken.isEmpty) {
        print("❌ Missing Google ID token");
        AppDialog.showMessage("Failed to get Google token.");
        isLoading.value = false;
        return;
      }

      // Step 3: Optionally sign out to reset the session
      // await GoogleSignIn().signOut();

      print("🚀 Proceeding to backend API call...");
      await loginUserGoogleApi(accessToken ?? "", "", true);

    } on PlatformException catch (e) {
      print("❌ [PlatformException]");
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      print("Details: ${e.details}");
      AppDialog.showMessage("Platform error: ${e.message}");

    } on FirebaseAuthException catch (e) {
      print("❌ [FirebaseAuthException]");
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      AppDialog.showMessage("Firebase Auth error: ${e.message}");

    } on SocketException catch (e) {
      print("🌐 [Network Error]");
      print("Message: ${e.message}");
      AppDialog.showMessage("No Internet connection. Please try again.");

    } on TimeoutException catch (e) {
      print("⏰ [TimeoutException]");
      print("Message: ${e.message}");
      AppDialog.showMessage("Request timed out. Please try again.");

    } on FormatException catch (e) {
      print("⚙️ [FormatException]");
      print("Message: ${e.message}");
      AppDialog.showMessage("Invalid data format received.");

    } catch (e, stack) {
      print("💥 [Unexpected Error]");
      print("Error: $e");
      print("Stack trace: $stack");
      AppDialog.showMessage("Something went wrong: $e");

    } finally {
      print("🔚 Google Sign-In process ended.");
      isLoading.value = false;
    }
  }

  void loginWithApple() async {
    try {
      isLoading.value = true;

      // Step 1: Request Apple ID credential
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Step 2: Extract identityToken (JWT) and authorizationCode
      final String? identityToken = credential.identityToken;
      final String? authorizationCode = credential.authorizationCode;

      print("🍎 Apple Identity Token: $identityToken");
      print("🍎 Apple Authorization Code: $authorizationCode");
      print("🍎 Apple User Identifier: ${credential.userIdentifier}");

      // Step 3: Validate identity token before API call
      if (identityToken != null && identityToken.isNotEmpty) {
        // Call your backend API — same as Swift appleSignInApi(token:)
        await loginUserGoogleApi(identityToken, "", false);
      } else {
        AppDialog.showMessage("Failed to retrieve Apple identity token");
      }

    } on SignInWithAppleAuthorizationException catch (e) {
      print("❌ Apple Sign-In Authorization Error: ${e.code} - ${e.message}");
      if (e.code == AuthorizationErrorCode.canceled) {
        AppDialog.showMessage("Apple Sign-In canceled by user");
      } else {
        AppDialog.showMessage("Apple Sign-In failed: ${e.message}");
      }
    } catch (e) {
      print("❌ Apple Sign-In error: $e");
      AppDialog.showMessage("Apple Sign-In failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUserGoogleApi(String token,String referralToken,bool isGoogle) async {
    try {
      isLoading.value = true;

      final response = isGoogle ? await _apiClient.googleSignIn(
          token,
          AppConstants.buyerUserType,
          referralToken
      ) :
      await _apiClient.appleLoginApi(
          token,
          AppConstants.buyerUserType,
          referralToken
      );


      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final common = BaseResponse<LoginData>.fromJson(
        body,
        fromJsonT: (data) => LoginData.fromJson(data),
      );

      if(common.responseCode=="200"){
        if(common.status==AppConstants.SUCCESS){
          await saveLoginData(common.data);
        }
        // else if (common.status == AppConstants.WARNING && common.notVerified != null) {
        //
        // }
        else{
          // errorMessage.value = common.msg;
          AppDialog.showMessage(common.msg);
        }

      }else{
        // errorMessage.value = common.msg;
        AppDialog.showMessage(common.msg);
      }


    } catch (e) {
      print('❌ Exception in fetchSplashScreenData: $e');
      // errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveFcmTokenApi(String fcmToken) async {
    if(await AppFunction.isInternetAvailable()){
      try {
        isLoading.value = true;
        String deviceType = Platform.isAndroid ? "1":"0";

        final response = await _apiClient.saveFirebaseTokenApi(fcmToken,deviceType,AppConstants.buyerUserType);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final common = BaseResponse<LoginData>.fromJson(
          body,
          fromJsonT: (data) => LoginData.fromJson(data),
        );

        if(common.responseCode=="200"){
          if (common.status == AppConstants.SUCCESS) {

            // ❌ Remove existing tab controllers
            Get.delete<HomeController>(force: true);
            Get.delete<CategoryController>(force: true);
            Get.delete<AccountController>(force: true);
            Get.delete<BottomNavController>(force: true);

            // ✅ Recreate BottomNav with index 0

            // ✅ Reset navigation stack
            Get.offAllNamed(AppRoutes.bottomNavigation);
          }
          // else if (common.status == AppConstants.WARNING && common.notVerified != null) {
          //
          // }
          else{
            AppDialog.showMessage(common.msg);
          }

        }else{
          AppDialog.showMessage(common.msg);
        }


      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
        // errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }

  }


  Future<void> saveLoginData(LoginData? data) async {
     await pref.saveString(AppConstants.sessionToken, data?.token ?? "");
    await pref.saveString(AppConstants.userId, data?.userId ?? "");
    await pref.saveString(AppConstants.userName, data?.userName ?? "");
    await pref.saveString(AppConstants.userEmail, data?.credentialEmail ?? "");
    await pref.saveString(AppConstants.userPhone, data?.userPhone ?? "");
    await pref.saveString(AppConstants.userDialCode, data?.userPhoneDcode ?? "");
    await pref.saveString(AppConstants.userImage, data?.userImage ?? "");
    // await pref.saveString(AppConstants.currencySymbol, data.currencySymbol ?? "");
    // await pref.saveInt(AppConstants.cartCount, data.cartItemsCount ?? 0);
    // await pref.saveInt(AppConstants.unreadNotification, data.totalUnreadNotificationCount ?? 0);
    // await pref.saveInt(AppConstants.unreadMessage, data.totalUnreadMessageCount ?? 0);

    // optional: store entire object as JSON string

     debugPrint("THIS IS SAVED TOKEN: ${pref.loadString(AppConstants.sessionToken)})");

    await pref.saveString(
      AppConstants.loginData,
      jsonEncode(data?.toJson()),
    );

    String fcmToken=await pref.loadString(AppConstants.fcmToken)??"";
    if(fcmToken==""){
      fcmToken= await AppFunction.saveFcmToken(pref);
    }
   // print("saveFcmTokenApi $fcmToken");
    saveFcmTokenApi(fcmToken);

  }
}