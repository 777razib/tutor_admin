import 'package:get/get.dart';

import '../home/controller/home_controller.dart';
import '../home/controller/notification_controller.dart';
import '../request_screen/controller/request_screen_controller.dart';

class GetXDependenciesInjection extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(HomeController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(TutorRequestController(), permanent: true);
  }
}


