import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/model/employee_directory_model.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/service.dart';

class EmployeeDetailsController extends GetxController with Bindings {
  final Rxn<EmployeeDirectoryModel> employee = Rxn(null);
  final RxBool hasError = false.obs;
  late String employeeId;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is EmployeeDirectoryModel) {
      employeeId = args.id;
    } else {
      employeeId = args?.toString() ?? '';
    }
    super.onInit();
  }

  Future<EmployeeDirectoryModel> getEmployee() async {
    hasError.value = false;
    return EmployeeDirectoryService.getEmployee(id: employeeId)
        .then((value) {
          employee.value = value;
          return value;
        })
        .onError((error, stackTrace) {
          if (employee.value == null) {
            hasError.value = true;
          }
          throw Exception("");
        });
  }

  void onViewFullChart() {
    final record = employee.value;
    if (record == null) return;
    Get.toNamed(appRoutes.organizationChart, arguments: record);
  }

  @override
  void dependencies() {
    Get.put(EmployeeDetailsController());
  }
}
