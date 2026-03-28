import 'package:brickbuddy/commons/services/appointment_service.dart';
import 'package:brickbuddy/commons/services/login_service.dart';
import 'package:brickbuddy/commons/services/notifications_service.dart';
import 'package:brickbuddy/commons/services/dashboard_service.dart';
import 'package:get/get.dart';
import 'package:brickbuddy/commons/services/contacts_service.dart';

class DependencyInjection {
 static void init() async {
   Get.put<GetConnect>(GetConnect());  
   Get.put<LogInService>(LogInService());
   Get.put<AppointmentService>(AppointmentService());
   Get.put<NotificationsService>(NotificationsService());
   Get.put<DashboardService>(DashboardService());
   Get.put<ContactService>(ContactService());
 }
}
