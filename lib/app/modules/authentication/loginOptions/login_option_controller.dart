import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';



class LoginOptionController extends GetxController {
  void signInWithGoogle() {

  }

  void signInWithPhone() {
    Get.toNamed(AppRoutes.login, arguments: {"isEmail": false});
  }

  void signInWithEmail() {
    Get.toNamed(AppRoutes.login, arguments: {"isEmail": true});
  }

  void forgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  void registerNow() {
    Get.toNamed(AppRoutes.signUp);
  }
}