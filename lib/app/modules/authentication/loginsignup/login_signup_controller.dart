import 'package:get/get.dart';

import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../navigation/bottom_navigation.dart';

class LoginSignupController extends GetxController {

  final pref = PrefStore();

  void skipClick() async {
    await pref.saveBoolean(AppConstants.skipForNow, true);
    if(Get.currentRoute != AppRoutes.bottomNavigation) {
      Get.offAllNamed(AppRoutes.bottomNavigation);
    }
  }

  void signInClick() {
    if(Get.currentRoute != AppRoutes.loginOption) {
      Get.toNamed(AppRoutes.loginOption);
    }
  }

  void signUpClick() {
    if(Get.currentRoute != AppRoutes.signUp) {
      Get.toNamed(AppRoutes.signUp);
    }
  }
}
