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
  var profileImageUrl = ''.obs;
  final pref = PrefStore();
  ProfileData? profileDataa;
  Rxn<MembershipInfo> memberShipInfo = Rxn<MembershipInfo>();

  String privacyPolicyLink='';
  String termsAndConditionsLink='';
  String warrantyExchangeLink='';
  String userAggrementLink='';
  String isUserAggrementLink='';
  String suggestionLink='';
  String faqLink='';
  String token='';

  RxDouble membershipProgress = 0.0.obs;

  RxString membershipUsed = ''.obs;
  RxString membershipTotal = ''.obs;

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
      if (!deepLinkURL.contains('/guest-user/user-check-email-verification')) {
        getAgreementUrlApi();
      }
    }
  }

    @override
  void onReady() {
    super.onReady();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLogin.value) {
        getProfileInfoApi(token);
      } else {
        if (!deepLinkURL.contains('/guest-user/user-check-email-verification')) {
          getAgreementUrlApi();
        }
      }
    });
  }

  List<Section> get currentSections => isLogin.value
      ? [

    Section(
      title: "",
      children: [
        SectionItem(icon: "assets/icons/ic_shipping_address.svg", key: AppStrings.appSippingAddress),
        // SectionItem(icon: "assets/icons/ic_return_request.svg", key: AppStrings.appExchangeRequest),
        // SectionItem(icon: "assets/icons/ic_cancel.svg", key: AppStrings.appCancellationRequest),
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
       // SectionItem(icon: "assets/icons/ic_email.svg", key: 'APP_CHANGE_EMAIL'),
        // ✅ Correct conditional widget
        // if (PrefStore().loadString(AppConstants.phoneSectionEnabled) == '1')
        //   userDialCode.value.toString().isEmpty
        //       ? SectionItem(
        //     icon: "assets/icons/ic_update_phone.svg",
        //     key: 'APP_UPDATE_PHONE',
        //   )
        //       : SectionItem(
        //     icon: "assets/icons/ic_update_phone.svg",
        //     key: 'APP_CHANGE_PHONE',
        //   ),
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

  void goToEditProfile() async {
    final result = await Get.toNamed(
      AppRoutes.editProfile,
      arguments: profileDataa,
    );

    if (result != null) {
      Get.snackbar(
        AppConstants.appName,
        result.toString(), // ✅ API message here
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );

      refreshAccount();
    }
  }
  void login() => Get.toNamed(AppRoutes.login);
  void logout() => isLogin.value = false;


  void showDeleteAccountDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Semantics(
          label: "delete_account_dialog",
          child: CupertinoAlertDialog(
            key: const ValueKey("delete_account_dialog"),
            title: const Text(
              key: const ValueKey("delete_dialog_title"),
              "Tajer - تاجر",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Nunito",
              ),
            ),
            content:  Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                key: const ValueKey("delete_dialog_message"),
                'APP_WANT_TO_DELETEACCOUNT'.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.systemGrey,
                  fontFamily: "Nunito",
                ),
              ),
            ),
            actions: [
              Semantics(
                label: "btn_confirm_delete_account",
                button: true,
                child: CupertinoDialogAction(
                  key: const ValueKey("btn_confirm_delete_account"),
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
                  child: Text(AppStrings.appOk.toUpperCase().tr,key: const ValueKey("text_confirm_delete"),),
                ),
              ),
              Semantics(
                label: "btn_cancel_delete_account",
                button: true,
                child: CupertinoDialogAction(
                  key: const ValueKey("btn_cancel_delete_account"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textStyle: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  child: Text(AppStrings.appCancel.toUpperCase().tr,key: const ValueKey("text_cancel_delete"),),
                ),
              ),
            ],
          ),
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
            return Semantics(
              label: "change_currency_bottom_sheet",
              child: Padding(
                key: const ValueKey("currency_sheet_container"),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                       key: const ValueKey("text_currency_title"),
                      AppStrings.app_change_currency.tr,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        key: const ValueKey("currency_list"),
                        itemCount: currencies.length,
                        itemBuilder: (context, index) {
                          final currency = currencies[index].currencyCode;
                          return Semantics(
                            label: "currency_$currency",
                            button: true,
                            child: RadioListTile<String>(
                              key: ValueKey("radio_currency_$currency"),
                              title: Text(currency,key: ValueKey("text_currency_$currency"),),
                              value: currency,
                              groupValue: selectedCurrency,
                              activeColor: AppColors.black1,
                              controlAffinity: ListTileControlAffinity.trailing,
                              onChanged: (value) {
                                setState(() async {
                                  pref.saveString(AppConstants.currencyId, currencies[index].currencyId);
                                  pref.saveString(AppConstants.currencySymbol, currencies[index].currencyCode);
                                  selectedCurrency = value!;
                                  Get.back();
                                  await PrefStore().saveBoolean(AppParams.refreshHome, true);
                                          
                                  if (Get.isRegistered<HomeController>()) {
                                    Get.find<HomeController>().reloadHomeData();
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
            pref.clearAll();
            Get.deleteAll(force: true);     // delete everything
            Get.put(SplashController());    // restore required
            Get.put(BottomNavController());
            Get.put(LocalizationService());
            final splash = Get.find<SplashController>();

            splash.allowNavigation.value = false;
            Future.delayed(const Duration(milliseconds: 30), () {
              Get.offAllNamed(AppRoutes.bottomNavigation);
              Future.microtask(() {
                Get.toNamed(AppRoutes.login);
              });
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
        showGlobalLoader();
        final response =await getProfileInfoApi(token);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final profileData = BaseResponse<ProfileData>.fromJson(
          body,
          fromJsonT: (data) => ProfileData.fromJson(data),
        );

        if(profileData.responseCode=="200"){
          hideGlobalLoader();
          if(profileData.status==AppConstants.SUCCESS){
          setProfileData(profileData.data);

          }else{
            AppDialog.showMessage(profileData.msg);
          }
        }else{
          hideGlobalLoader();
          AppDialog.showMessage(profileData.msg);
        }


      } catch (e) {
        hideGlobalLoader();
        print('❌ Exception in get profile: $e');
        // errorMessage.value = e.toString();
      }
    }
  }

  void showGlobalLoader() {
    if (GlobalLoader.disable) return; // 🚫 skip on Splash
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.black)),
      barrierDismissible: false,
      useSafeArea: false,
    );
  }

  void hideGlobalLoader() {
    if (GlobalLoader.disable) return;
    if (Get.isDialogOpen == true) {
      Navigator.of(Get.context!, rootNavigator: true).pop();
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
      profileImageUrl.value = profileData?.personalInfo?.userImage ?? "";

      returnReqCount.value = "${profileData?.personalInfo?.userOrderReturnRequestCount}";
      userWishListCount.value="${profileData?.personalInfo?.userWishlistCount}";
      userBalance.value=profileData?.personalInfo?.userBallance.toString()??"";

    }

    memberShipInfo.value = profileData?.membershipInfo;

    calculateMembershipProgress();
    privacyPolicyLink = profileData?.privacyPolicyLink??"";
    termsAndConditionsLink = profileData?.termsAndConditionsLink??"";
    warrantyExchangeLink = profileData?.warrantyExchangeLink??"";
    userAggrementLink = profileData?.userAggrementLink??"";
    isUserAggrementLink = profileData?.isUserAggrementLink??"";
    suggestionLink = profileData?.suggestionLink??"";
    faqLink = profileData?.faqLink??"";
    await pref.saveString(AppConstants.currencySymbol, profileData?.currencySymbol??"");
    await pref.saveString(AppConstants.privacyPolicy, profileData?.privacyPolicyLink??"");
    await pref.saveString(AppConstants.termsConditionLink, profileData?.termsAndConditionsLink??"");
    await pref.saveString(AppConstants.phoneSectionEnabled, profileData?.personalInfo?.phone_section_enabled ??"0");
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

  void calculateMembershipProgress() {
    final m = memberShipInfo.value;

    if (m == null) {
      membershipProgress.value = 0.0;
      membershipUsed.value = '';
      membershipTotal.value = '';
      return;
    }

    /// Remove QR and parse numeric values
    final totalString =
    m.discountLimit.replaceAll(RegExp(r'[^0-9.]'), '');

    final usedString =
    m.discountUsed.replaceAll(RegExp(r'[^0-9.]'), '');

    final total =
        double.tryParse(totalString) ?? 0;

    final used =
        double.tryParse(usedString) ?? 0;

    membershipUsed.value = m.discountUsed;
    membershipTotal.value = m.discountLimit;

    if (total <= 0) {
      membershipProgress.value = 0.0;
      return;
    }

    membershipProgress.value =
        (used / total).clamp(0.0, 1.0);
  }

}
