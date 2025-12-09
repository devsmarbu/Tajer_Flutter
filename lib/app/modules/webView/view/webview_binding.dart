import 'package:get/get.dart';

import '../controller/wevview_controller.dart';

class WebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WebviewController());
  }
}
