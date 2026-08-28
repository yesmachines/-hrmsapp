import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/model/employee_directory_model.dart';

class EmployeeDetailsController extends GetxController with Bindings {
  late final EmployeeDirectoryModel employee;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is EmployeeDirectoryModel) {
      employee = args;
    } else {
      employee = const EmployeeDirectoryModel(
        id: '0',
        name: 'Unknown',
        designation: '-',
        department: '-',
        email: '-',
        phone: '-',
      );
    }
    super.onInit();
  }

  void onViewFullChart() {
    notificationHandler.sendNotification(
      message: 'Org chart coming soon',
      notificationType: .warning,
    );
  }

  @override
  void dependencies() {
    Get.put(EmployeeDetailsController());
  }
}
