import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/respository/product_list_repository.dart';
import 'package:tajer/app/modules/productList/controllers/product_controller.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/app/modules/authentication/registrationSuccess/employee_success_screen.dart';
import 'package:tajer/app/modules/authentication/registrationSuccess/registration_success_screen.dart';
import 'package:tajer/app/modules/categories/brands_list/brands_list_view.dart';
import 'package:tajer/app/modules/contactUs/contact_us_screen.dart';
import 'package:tajer/app/modules/home/reel_page_view/reel_page_controller.dart';
import 'package:tajer/app/modules/home/reel_page_view/reel_page_view.dart';
import 'package:tajer/app/modules/payment/paymentMethods/view/payment_method_screen.dart';
import 'package:tajer/app/modules/payment/view/payment_screen.dart';
import 'package:tajer/app/modules/return/return_order/view/return_order_screen.dart';
import 'package:tajer/app/modules/review/rating/view/rating_screen.dart';
import 'package:tajer/app/modules/webView/view/webview_view.dart';
import '../../modules/Account/account_screen.dart';
import '../../modules/Cart/MainCartView.dart';
import '../../modules/Cart/order_success_page/order_success_page.dart';
import '../../modules/address/addAddress/view/add_new_address_screen.dart';
import '../../modules/address/addressList/view/address_list_screen.dart';
import '../../modules/authentication/forgotPassword/forgot_password_screen.dart';
import '../../modules/authentication/loginsignup/login_signup_screen.dart';
import '../../modules/authentication/register/registraion_screen.dart';
import '../../modules/changeEmail/view/change_emil_screen.dart';
import '../../modules/change_language/change_language_popover.dart';
import '../../modules/change_password/change_password.dart';
import '../../modules/change_phone_number/change_phone_number.dart';
import '../../modules/edit_profile/edit_profile.dart';
import '../../modules/filter/views/filter_screen.dart';
import '../../modules/giftCard/addGiftCard/view/add_gift_card_screen.dart';
import '../../modules/giftCard/giftCardList/view/gift_card_list_screen.dart';
import '../../modules/message/chatScreen/view/chat_screen.dart';
import '../../modules/message/messagesList/view/message_list_screen.dart';
import '../../modules/myOffer/view/my_offer_screen.dart';
import '../../modules/navigation/bottom_navigation.dart';
import '../../modules/product_detail/ask_question_view/ask_question_view.dart';
import '../../modules/product_detail/product_detail_view.dart';
import '../../modules/productList/views/product_list_page.dart';
import '../../modules/product_detail/search_view/search_view.dart';
import '../../modules/product_detail/shop_detail_view/shop_detail_view.dart';
import '../../modules/request_my_data/view/request_my_data.dart';
import '../../modules/return/returnRequest/view/return_request_screen.dart';
import '../../modules/return/returnRequestDetail/view/return_request_detail_screen.dart';
import '../../modules/review/review/view/write_review_screen.dart';
import '../../modules/wallet/addMoney/view/add_money_screen.dart';
import '../../modules/wallet/withdraw/view/withdraw_request_screen.dart';
import '../../modules/webView/view/webview_binding.dart';
import '../../modules/wish_list/wish_list_items_view/wish_list_items_view.dart';
import '../../modules/orders/myOrders/view/my_order_view.dart';
import '../../modules/orders/orderDetail/view/order_details_screen.dart';
import '../../modules/rewards/view/my_rewards_screen.dart';
import '../../modules/authentication/login/login_screen.dart';
import '../../modules/authentication/loginOptions/login_option_screen.dart';
import '../../modules/authentication/splash/view/splash_view.dart';
import '../../modules/home/home_view.dart';
import '../../modules/otp_verification_screen/view/otp_verification_screen.dart';
import '../../modules/wallet/myWallet/view/wallet_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String loginSignUp = '/login-signup';
  static const String login = '/login';
  static const String loginOption = '/login-option';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String bottomNavigation = '/bottom-navigation';
  static const String account = '/account';
  static const String orderSuccess = '/order-success';
  static const String productDetail = '/product-detail';
  static const String productListPage = '/product-list-page';
  static const String filterPage = '/filter-page';
  static const String wishListItemsView = '/wish-list-items-view';
  static const String askAQuestionView = '/ask-a-question-view';
  static const String shopDetailView = '/shop-detail-view';
  static const String searchView = '/search-view';
  static const String cartPage = '/cart-page-view';
  static const String myOrders = '/my-orders';
  static const String shippingAddress = '/shipping-address';
  static const String addNewAddress = '/add-new-address';
  static const String changeEmail = '/change-email';
  static const String returnRequest = '/return-request';
  static const String returnRequestDetail = '/return-request-detail';
  static const String myRewards = '/my-rewards';
  static const String walletScreen = '/wallet-screen';
  static const String giftCardsList = '/gift-cards-list';
  static const String addGiftCard = '/add-gift-cards';
  static const String messageListScreen = '/message-list-screen';
  static const String chatScreen = '/chat-screen';
  static const String myOfferScreen = '/my-offer-screen';
  static const String requestMyDataScreen = '/request-my-data-screen';
  static const String changePassword = '/change-password';
  static const String editProfile = '/edit-profile';
  static const String addMoneyScreen = '/add-money-screen';
  static const String withdrawRequestScreen = '/withdraw-request-screen';
  static const String updatePhoneNumber = '/update_phone_number';
  static const String otpVerification = '/otp_verification';
  static const String language = '/language';
  static const String contactUsScreen = '/contactUs';
  static const String brandsListView = '/brandsListView';
  static const String shopsListView = '/shopsListView';
  static const String paymentScreen = '/paymentScreen';
  static const String webViewScreen = '/webViewScreen';
  static const String returnOrderScreen = '/returnOrderScreen';
  static const String ratingScreen = '/ratingScreen';
  static const String reviewScreen = '/reviewScreen';
  static const String paymentMethods = '/paymentMethods';
  static const String registrationSuccessScreen = '/registrationSuccessScreen';
  static const String employeeSuccessScreen = '/employeeSuccessScreen';

  static final routes = [
    GetPage(name: splash, page: () => SplashView()),
    GetPage(name: home, page: () => HomeView()),
    GetPage(name: loginSignUp, page: () => LoginSignupScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: loginOption, page: () => LoginOptionScreen()),
    GetPage(name: signUp, page: () => RegistraionScreen()),
    GetPage(name: forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: bottomNavigation, page: () => BottomNavigation()),
    GetPage(name: account, page: () => AccountScreen()),
    GetPage(name: orderSuccess, page: () => OrderSuccessPage()),
    GetPage(name: productDetail, page: () => ProductDetailView()),
    GetPage(name: productListPage, page: () => ProductListPage()),
    GetPage(name: filterPage, page: () => FilterScreen()),
    GetPage(name: wishListItemsView, page: () => WishListItemsView()),
    GetPage(name: askAQuestionView, page: () => AskQuestionPageView()),
    GetPage(name: shopDetailView, page: () => ShopDetailPage()),
    GetPage(name: searchView, page: () => SearchView()),
    GetPage(name: cartPage, page: () => MainCartView()),
    GetPage(name: myOrders, page: () => MyOrdersView()),
    GetPage(name: shippingAddress, page: () => AddressListScreen(),binding: AddressBinding()),
    GetPage(name: addNewAddress, page: () => AddNewAddressScreen(),binding: AddAddressBinding()),
    GetPage(name: changeEmail, page: () => ChangeEmailScreen()),
    GetPage(name: returnRequest, page: () => ReturnRequestsScreen()),
    GetPage(name: returnRequestDetail, page: () => ReturnRequestDetailScreen()),
    GetPage(name: myRewards, page: () => MyRewardsScreen()),
    GetPage(name: walletScreen, page: () => WalletScreen()),
    GetPage(name: giftCardsList, page: () => GiftCardListScreen()),
    GetPage(name: messageListScreen, page: () => MessageListScreen()),
    GetPage(name: addGiftCard, page: () => AddGiftCardScreen()),
    GetPage(
      name: chatScreen,
      page: () => ChatScreen(),
    ),
    GetPage(name: chatScreen, page: () => ChatScreen()),
    GetPage(name: myOfferScreen, page: () => MyOfferScreen()),
    GetPage(name: requestMyDataScreen, page: () => RequestMyData()),
    GetPage(name: changePassword, page: () => ChangePasswordScreen()),
    GetPage(name: editProfile, page: () => EditProfileView()),
    GetPage(name: addMoneyScreen, page: () => AddMoneyScreen()),
    GetPage(name: withdrawRequestScreen, page: () => WithdrawRequestScreen()),
    GetPage(name: updatePhoneNumber, page: () => UpdatePhoneNumberView()),
    GetPage(name: returnOrderScreen, page: () => ReturnOrderScreen()),
    GetPage(name: webViewScreen, page: () => WebviewView(),binding: WebviewBinding(),),
    GetPage(
      name: otpVerification,
      page: () =>
          ConfirmPhoneOtpView(dCode:"",phoneNumber: "", userId: "",isUpdate: false,),
    ),
    // GetPage(name: language, page: () => ChangeLanguagePopover()),
    GetPage(name: contactUsScreen, page: () => ContactUsScreen()),
    GetPage(
      name: brandsListView,
      page: () => BrandsListView(index: "3", title: "Our Favorite Brands"),
    ),
    GetPage(
      name: shopsListView,
      page: () => BrandsListView(index: "4", title: "Our Shops"),
    ),
    GetPage(name: paymentScreen, page: () => PaymentScreen()),
    GetPage(name: ratingScreen, page: () => RatingScreen()),
    GetPage(name: reviewScreen, page: () => WriteReviewScreen()),
    GetPage(name: paymentMethods, page: () => PaymentMethodsScreen()),
    GetPage(name: registrationSuccessScreen, page: () => RegistrationSuccessScreen()),
    GetPage(name: employeeSuccessScreen, page: () => EmployeeSuccessScreen()),
  ];

  static Future<void> goToProductListPage({
    required String brandId,
    required String prodCatId,
    required String productVideoAvailable,
    required String titleHeader,
    String? image,
    String? condition,
    String? imagePath,
    String? keyword,
  }) async {
    final context = Get.context;
    if (context != null) {
      AppLoader.showLoaderStatic(context);
    }

    final uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> baseParams = {};
    if (prodCatId.isNotEmpty) {
      baseParams["prodcat"] = prodCatId;
    }
    baseParams["keyword"] = (keyword == "null" || keyword == null) ? "" : keyword;
    baseParams["brand"] = brandId;
    baseParams["image"] = image ?? '';
    baseParams["productVideoAvailable"] = productVideoAvailable;
    if (condition != null && condition.isNotEmpty) {
      baseParams["condition"] = [condition];
    }

    if (productVideoAvailable == "1") {
      baseParams["productIds"] = [];
      baseParams["pageSize"] = "5";
    }

    baseParams["page"] = 1;

    try {
      final data = await ProductListRepository().fetchPaginatedProducts(baseParams);
      if (data != null) {
        ProductController.preloadedDataMap[uniqueId] = data;
      }
    } catch (e) {
      debugPrint("Preloading product list error: $e");
    } finally {
      final currentContext = Get.context;
      if (currentContext != null) {
        AppLoader.hideLoaderStatic(currentContext);
      }
    }

    Get.toNamed(
      productListPage,
      parameters: {
        "brandId": brandId,
        "prodCatId": prodCatId,
        "productVideoAvailable": productVideoAvailable,
        "titleHeader": titleHeader,
        "keyword": keyword.toString(),
        "condition": condition ?? '',
        "image": image ?? '',
        "imagePath": imagePath ?? '',
        "uniqueId": uniqueId,
      },
    );
  }

  static void goToBrandsListViewPage({String? collectionId,String? title}) {
    Get.toNamed(
      brandsListView,
      parameters: {"collectionId": collectionId ?? "",'title':title??''},
    );
  }

  static void goToShopListViewPage({String? collectionId}) {
    Get.toNamed(
      shopsListView,
      parameters: {"collectionId": collectionId ?? ""},
    );
  }

  static void goToAddressScreen({required String comeFromCart}) {
    Get.toNamed(
      shippingAddress,
      parameters: {"comeFromCart": comeFromCart},
    );
  }
}
