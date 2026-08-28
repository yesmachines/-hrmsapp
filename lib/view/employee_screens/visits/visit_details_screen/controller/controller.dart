import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class VisitDetailsController extends GetxController with Bindings {
  late final VisitModel visit;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is VisitModel) {
      visit = args;
    } else {
      visit = VisitModel(
        id: '0',
        type: VisitType.customerMeeting,
        status: VisitStatus.approved,
        title: 'Customer Meeting',
        date: DateTime.now(),
        time: '-',
        location: '-',
        purpose: '-',
        assignedTask: '-',
        tab: VisitTab.today,
      );
    }
    super.onInit();
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  void onViewAttachment(String name) {
    notificationHandler.sendNotification(
      message: 'Opening $name',
      notificationType: .success,
    );
  }

  @override
  void dependencies() {
    Get.put(VisitDetailsController());
  }
}
