import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/utils/attachment_viewer/attachment_viewer.dart';
import 'package:yes_hrm/view/employee_screens/visits/visit_details_screen/service/service.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class VisitDetailsController extends GetxController with Bindings {
  final Rxn<VisitModel> visit = Rxn(null);
  final RxBool hasError = false.obs;
  late String visitId;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is VisitModel) {
      visitId = args.id;
    } else {
      visitId = args?.toString() ?? '';
    }
    super.onInit();
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  String formatTime(DateTime date) => DateFormat('hh:mm a').format(date);

  String formatDateTime(DateTime date) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(date);

  Future<VisitModel> getVisit() async {
    hasError.value = false;
    return VisitDetailsService.getVisit(id: visitId)
        .then((value) {
          visit.value = value;
          return value;
        })
        .onError((error, stackTrace) {
          if (visit.value == null) {
            hasError.value = true;
          }
          throw Exception("");
        });
  }

  void onViewAttachment(VisitAttachment file) {
    openAttachmentViewer(url: file.url, name: file.name);
  }

  @override
  void dependencies() {
    Get.put(VisitDetailsController());
  }
}
