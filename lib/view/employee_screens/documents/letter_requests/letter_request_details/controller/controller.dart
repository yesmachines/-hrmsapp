import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/attachment_viewer/attachment_viewer.dart';
import 'package:yes_hrm/view/employee_screens/documents/letter_requests/service/model/letter_request_model.dart';
import 'package:yes_hrm/view/employee_screens/documents/letter_requests/service/service.dart';

class LetterRequestDetailsController extends GetxController with Bindings {
  final Rxn<LetterRequestModel> request = Rxn(null);
  final RxnBool hasError = RxnBool(false);
  late final int requestId;

  @override
  void onInit() {
    final args = Get.arguments;
    requestId = int.tryParse(args?.toString() ?? '') ?? 0;
    super.onInit();
  }

  Future<LetterRequestModel> getLetterRequest() async {
    hasError.value = false;
    return LetterRequestService.getLetterRequest(requestId)
        .then((value) {
          request.value = value;
          return value;
        })
        .onError((error, stackTrace) {
          hasError.value = true;
          notificationHandler.apiErrorNotificationHandler(error: error);
          throw Exception();
        });
  }

  void onViewFile() {
    final fileUrl = request.value?.fileUrl.trim() ?? '';
    if (fileUrl.isEmpty) {
      notificationHandler.sendNotification(
        message: 'File not available',
        notificationType: .warning,
      );
      return;
    }
    openAttachmentViewer(
      url: fileUrl,
      name: request.value?.displayTitle ?? 'Letter',
    );
  }

  @override
  void dependencies() {
    Get.put(LetterRequestDetailsController());
  }
}
