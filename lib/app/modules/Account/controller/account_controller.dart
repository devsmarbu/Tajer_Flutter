// account_controller.dart

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/data/service/account_api_client.dart';
import 'package:tajer/app/modules/Account/models/currency_response.dart';
import 'package:tajer/app/modules/Account/models/language.dart';
import 'package:tajer/app/modules/Account/models/language_response.dart';
import 'package:tajer/app/modules/Account/models/profile_data.dart';
import 'package:tajer/app/modules/categories/category_controller.dart';
import 'package:tajer/app/modules/home/home_controller.dart';
import 'package:tajer/app/modules/authentication/splash/controller/splash_controller.dart';
import 'package:tajer/common/functions/app_function.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/common_data.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../translations/localization_service.dart';
import '../../../../utils/app_dialog.dart';
import '../../../../utils/app_params.dart';
import '../../../../utils/base_response.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/routes/app_routes.dart';
import '../../authentication/login/login_data.dart';
import '../../authentication/splash/controller/splash_controller.dart';
import '../../change_language/change_language_popover.dart';
import '../../../../../utils/app_colors.dart';
import '../../navigation/bottom_navigation.dart';
import '../../share_and_earn/share_and_earn.dart';
import '../models/section.dart';
import '../models/section_item.dart';

class AccountController extends GetxController with AccountApiClient, AppLoader, WidgetsBindingObserver {
  var isLogin = true.obs;
  var emailId = ''.obs;
  var userName = ''.obs;
  var returnReqCount = ''.obs;
  var userWishListCount = ''.obs;
  var userBalance = ''.obs;
  var userDialCode = ''.obs;
  var userPhoneNumber = ''.obs;
  final pref = PrefStore();
  ProfileData? profileDataa;

  String privacyPolicyLink='';
  String termsAndConditionsLink='';
  String warrantyExchangeLink='';
  String userAggrementLink='';
  String isUserAggrementLink='';
  String suggestionLink='';
  String faqLink='';
  String token='';

  @override
  void onInit() {
    super.onInit();
    token = pref.loadString(AppConstants.sessionToken) ?? "";
    isLogin.value = token.isNotEmpty;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  /// 🔄 Called when app/page comes to foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshAccount();
    }
  }

  /// 🔁 Central refresh method
  void refreshAccount() {
    token = pref.loadString(AppConstants.sessionToken) ?? "";
    isLogin.value = token.isNotEmpty;

    if (isLogin.value) {
      getProfileInfoApi(token);
    } else {
      getAgreementUrlApi();
    }
  }

    @override
  void onReady() {
    super.onReady();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLogin.value) {
        getProfileInfoApi(token);
      } else {
        getAgreementUrlApi();
      }
    });
  }

  List<Section> get currentSections => isLogin.value
      ? [

    Section(
      title: "",
      children: [
        SectionItem(icon: "assets/icons/ic_shipping_address.svg", key: AppStrings.appSippingAddress),
        SectionItem(icon: "assets/icons/ic_return_request.svg", key: AppStrings.appExchangeRequest),
        SectionItem(icon: "assets/icons/ic_cancel.svg", key: AppStrings.appCancellationRequest),
   //     SectionItem(icon: "assets/icons/ic_invoice_download.svg", key: AppStrings.appInvoiceDownloads),
        SectionItem(icon: "assets/icons/ic_message.svg", key: AppStrings.appMessage),

      ]
    ),
    Section(
      title: 'APP_MEMBER_EXCLUSIVE'.tr,
      children: [
        SectionItem(icon: "assets/icons/ic_offers.svg", key: AppStrings.appMyOffers),
        SectionItem(icon: "assets/icons/ic_reward.svg", key: AppStrings.appMyRewards),
        SectionItem(icon: "assets/icons/ic_share.svg", key: 'APP_SHARE_EARN'),
        SectionItem(icon: "assets/icons/ic_gift_card.svg", key: 'APP_GIFT_CARD'),
        SectionItem(icon: "assets/icons/ic_suggestion.svg", key: 'APP_MAKE_SUGGESTION'),
      ],
    ),
    Section(
      title: 'APP_SETTINGS'.tr,
      children: [
        SectionItem(icon: "assets/icons/ic_currency.svg", key: 'APP_CURRENCY'),
        SectionItem(icon: "assets/icons/ic_language.svg", key: 'APP_LANGUAGE'),
        SectionItem(icon: "assets/icons/ic_email.svg", key: 'APP_CHANGE_EMAIL'),
        // ✅ Correct conditional widget
        if (userDialCode.value.toString().isEmpty)
          SectionItem(
            icon: "assets/icons/ic_update_phone.svg",
            key: 'APP_UPDATE_PHONE',
          )
        else
          SectionItem(
            icon: "assets/icons/ic_update_phone.svg",
            key: 'APP_CHANGE_PHONE',
          ),

        SectionItem(icon: "assets/icons/ic_change_password.svg", key: 'APP_CHANGE_PASSWORD'),

        if(pref.loadString(AppConstants.confEnableWithdrawals)=="1")
        SectionItem(icon: "assets/icons/ic_bank_info.svg", key: 'APP_BANK_INFO'),
        SectionItem(icon: "assets/icons/ic_request_data.svg", key: 'APP_REQUEST_MY_DATA'),
        SectionItem(icon: "assets/icons/ic_delete.svg", key: 'APP_ACCOUNT_DELETE'),
      ],
    ),
  ]
      : [
    Section(
      title: 'APP_SETTINGS'.tr,
      children: [
        SectionItem(icon: "assets/icons/ic_currency.svg", key: 'APP_CURRENCY'),
        SectionItem(icon: "assets/icons/ic_language.svg", key: 'APP_LANGUAGE'),
      ],
    ),
    Section(
      title: 'APP_MEMBER_EXCLUSIVE'.tr,
      children: [
        SectionItem(icon: "assets/icons/ic_suggestion.svg", key: 'APP_MAKE_SUGGESTION'),
      ],
    ),
  ];

  void goToEditProfile() {
    Get.toNamed(AppRoutes.editProfile,arguments:profileDataa);
  }

  void login() => Get.toNamed(AppRoutes.login);
  void logout() => isLogin.value = false;


  void showDeleteAccountDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text(
            "Tajer - تاجر",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "Nunito",
            ),
          ),
          content:  Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'APP_WANT_TO_DELETEACCOUNT'.tr,
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
                fontFamily: "Nunito",
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                // Handle delete action here
                deleteAccount();
                debugPrint("Account Deletion");
              },
              textStyle: const TextStyle(
                color: AppColors.redColor1, // Red text for OK
                fontWeight: FontWeight.bold,
              ),
              child: Text(AppStrings.appOk.toUpperCase().tr),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              textStyle: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
              child: Text(AppStrings.appCancel.toUpperCase().tr),
            ),
          ],
        );
      },
    );
  }

  void showLogoutDialog(BuildContext context) async {
    final result = await AppDialogs.showConfirmationDialog(
      context,
      message: AppStrings.appWantToLogout.toUpperCase().tr,
    );

    if (result == true) {
      logoutUser();
    }
  }


  void openShareAndEarnBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ShareAndEarnBottomSheet(),
    );
  }

  // language bottom sheet
  void openChangeLanguageBottomSheet(BuildContext context, List<Language> languages) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ChangeLanguagePopover(languages: languages),
    );
  }


  void showCurrencyBottomSheet(BuildContext context, List<Currency> currencies) {


    String selectedCurrency = currencies[0].currencyCode;

    for (var currency in currencies) {
      if (currency.currencyId == pref.loadString(AppConstants.currencyId)) {
        selectedCurrency = currency.currencyCode;
        break;
      }
    }


    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    AppStrings.app_change_currency.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currencies.length,
                      itemBuilder: (context, index) {
                        final currency = currencies[index].currencyCode;
                        return RadioListTile<String>(
                          title: Text(currency),
                          value: currency,
                          groupValue: selectedCurrency,
                          activeColor: AppColors.black1,
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (value) {
                            setState(() {
                              pref.saveString(AppConstants.currencyId, currencies[index].currencyId);
                              pref.saveString(AppConstants.currencySymbol, currencies[index].currencyCode);
                              selectedCurrency = value!;
                              Get.back();
                              PrefStore().saveBoolean(AppParams.refreshHome, true);
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> logoutUser() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        showLoader(Get.context!);

        final response = await logoutUserApi(
            pref.loadString(AppConstants.sessionToken) ?? "",
            AppConstants.buyerUserType
        );


        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final common = BaseResponse<LoginData>.fromJson(
          body,
          fromJsonT: (data) => LoginData.fromJson(data),
        );

        if (common.responseCode == "200") {
          if (common.status == AppConstants.SUCCESS) {
            pref.saveString(AppConstants.sessionToken, "");
            pref.saveString(AppConstants.fcmToken, "");
            pref.saveString(AppConstants.userPhone, "");
            pref.saveString(AppConstants.userEmail, "");
            pref.saveBoolean(AppConstants.skipForNow, false);
            Get.deleteAll(force: true);     // delete everything
            Get.put(SplashController());    // restore required
            Get.put(BottomNavController());
            Get.put(LocalizationService());
            Future.delayed(const Duration(milliseconds: 30), () {
              Get.offAllNamed(AppRoutes.login);
            });
          } else {
            AppDialog.showMessage(common.msg);
          }
        } else {
          AppDialog.showMessage(common.msg);
        }
      } catch (e) {
        print('❌ Exception in logout user: $e');
        // errorMessage.value = e.toString();
      } finally {
        hideLoader(Get.context!);
      }
    }
  }

  Future<void> deleteAccount() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        showLoader(Get.context!);

        final response = await accountDeletionApi();


        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final common = BaseResponse<LoginData>.fromJson(
          body,
          fromJsonT: (data) => LoginData.fromJson(data),
        );

        if (common.responseCode == "200") {
          if (common.status == AppConstants.SUCCESS) {
            pref.saveString(AppConstants.sessionToken, "");
            pref.saveString(AppConstants.fcmToken, "");
            pref.saveString(AppConstants.userPhone, "");
            pref.saveString(AppConstants.userEmail, "");
            pref.saveBoolean(AppConstants.skipForNow, false);
            Get.deleteAll(force: true);     // delete everything
            Get.put(SplashController());    // restore required
            Get.put(BottomNavController());
            Get.put(LocalizationService());
            Future.delayed(const Duration(milliseconds: 30), () {
              Get.offAllNamed(AppRoutes.login);
            });
          } else {
            hideLoader(Get.context!);
            AppDialog.showMessage(common.msg);
          }
        } else {
          hideLoader(Get.context!);
          AppDialog.showMessage(common.msg);
        }
      } catch (e) {
        print('❌ Exception in delete account: $e');
        // errorMessage.value = e.toString();
      } finally {
        hideLoader(Get.context!);
      }
    }
  }




  Future<void> getProfileInfo() async {

    if(await AppFunction.isInternetAvailable()){
      try {
        // showLoader(Get.context!);

        final response =await getProfileInfoApi(token);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final profileData = BaseResponse<ProfileData>.fromJson(
          body,
          fromJsonT: (data) => ProfileData.fromJson(data),
        );

        if(profileData.responseCode=="200"){
          if(profileData.status==AppConstants.SUCCESS){

          setProfileData(profileData.data);

          }else{
            AppDialog.showMessage(profileData.msg);
          }
        }else{
          AppDialog.showMessage(profileData.msg);
        }


      } catch (e) {
        print('❌ Exception in get profile: $e');
        // errorMessage.value = e.toString();
      }
    }

  }



  void setProfileData(ProfileData? profileData) async {
    this.profileDataa = profileData;
    PrefStore.saveProfile(profileData);
    debugPrint("this is usrname");
    debugPrint(profileDataa?.personalInfo?.userName);
    if(isLogin.value){
      emailId.value = profileData?.personalInfo?.credentialEmail??"";
      userName.value = profileData?.personalInfo?.userName??"";

      returnReqCount.value = "${profileData?.personalInfo?.userOrderReturnRequestCount} ${'APP_ACTIVE_REQUESTS'.tr}";
      userWishListCount.value="${profileData?.personalInfo?.userWishlistCount} ${"APP_SAVED_ITEMS".tr}";
      userBalance.value=profileData?.personalInfo?.userBallance.toString()??"";

    }

    privacyPolicyLink = profileData?.privacyPolicyLink??"";
    termsAndConditionsLink = profileData?.termsAndConditionsLink??"";
    warrantyExchangeLink = profileData?.warrantyExchangeLink??"";
    userAggrementLink = profileData?.userAggrementLink??"";
    isUserAggrementLink = profileData?.isUserAggrementLink??"";
    suggestionLink = profileData?.suggestionLink??"";
    faqLink = profileData?.faqLink??"";

    await pref.saveString(AppConstants.currencySymbol, profileData?.currencySymbol??"");

  }

  Future<void> getAgreementUrl() async {

    if(await AppFunction.isInternetAvailable()){
      try {
        showLoader(Get.context!);

        final response =await getAgreementUrlApi();

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final profileData = BaseResponse<ProfileData>.fromJson(
          body,
          fromJsonT: (data) => ProfileData.fromJson(data),
        );

        if(profileData.responseCode=="200"){
          if(profileData.status==AppConstants.SUCCESS){

            setProfileData(profileData.data);
          }else{
            AppDialog.showMessage(profileData.msg);
          }
        }else{
          AppDialog.showMessage(profileData.msg);
        }


      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
        // errorMessage.value = e.toString();
      } finally {
        hideLoader(Get.context!);
      }
    }

  }

  Future<void> getCurrency() async {

    if(await AppFunction.isInternetAvailable()){
      try {

        showLoader(Get.context!);
        final response =await getCurrencyApi();

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final currencyResponse = BaseResponse<CurrencyResponse>.fromJson(
          body,
          fromJsonT: (data) => CurrencyResponse.fromJson(data),
        );

        if(currencyResponse.responseCode=="200"){
          hideLoader(Get.context!);
          if(currencyResponse.status==AppConstants.SUCCESS){

            showCurrencyBottomSheet(Get.context!,currencyResponse.data!.currencies);

          }else{
            AppDialog.showMessage(currencyResponse.msg);
          }
        }else{
          AppDialog.showMessage(currencyResponse.msg);
        }


      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
        // errorMessage.value = e.toString();
      } finally {
        hideLoader(Get.context!);
      }
    }

  }

  Future<void> getLanguage() async {

    if(await AppFunction.isInternetAvailable()){
      try {
        showLoader(Get.context!);

        final response =await getLanguagesApi();

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final languageResponse = BaseResponse<LanguageResponse>.fromJson(
          body,
          fromJsonT: (data) => LanguageResponse.fromJson(data),
        );

        if(languageResponse.responseCode=="200"){
          hideLoader(Get.context!);
          if(languageResponse.status==AppConstants.SUCCESS){

            print("get language success");
            openChangeLanguageBottomSheet(Get.context!,languageResponse.data!.languages);
//            showCurrencyBottomSheet(Get.context!,currencyResponse.data!.currencies);

          }else{
            AppDialog.showMessage(languageResponse.msg);
          }
        }else{
          AppDialog.showMessage(languageResponse.msg);
        }


      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
        // errorMessage.value = e.toString();
      } finally {
        hideLoader(Get.context!);
      }
    }

  }

  void navigateToWebView(String title, String url) {
    Get.toNamed(AppRoutes.webViewScreen, arguments: {
      AppParams.title: title,
      AppParams.webViewUrl: url,
    });
  }

}
