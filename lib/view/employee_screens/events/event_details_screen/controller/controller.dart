import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/service/model/event_model.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/service/service.dart';

class EventDetailsController extends GetxController with Bindings {
  final Rxn<EventModel> event = Rxn(null);
  final RxnBool hasError = RxnBool(false);
  late final int eventId;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is EventModel) {
      eventId = int.tryParse(args.id) ?? 0;
    } else {
      eventId = int.tryParse(args?.toString() ?? '') ?? 0;
    }
    super.onInit();
  }

  Future<EventModel> getEvent() async {
    hasError.value = false;
    return EventsService.getEvent(eventId)
        .then((value) {
          event.value = value;
          return value;
        })
        .onError((error, stackTrace) {
          hasError.value = true;
          notificationHandler.apiErrorNotificationHandler(error: error);
          throw Exception();
        });
  }

  String dateHeadline(EventModel event) {
    final dateLabel = DateFormat('dd MMMM yyyy').format(event.date);
    final now = DateTime.now();
    final isToday =
        event.date.year == now.year &&
        event.date.month == now.month &&
        event.date.day == now.day;
    return isToday ? 'Today • $dateLabel' : dateLabel;
  }

  void onJoinMeeting() {
    final link = event.value?.meetingLink;
    notificationHandler.sendNotification(
      message: link == null
          ? 'No meeting link available'
          : 'Opening meeting link',
      notificationType: link == null ? .warning : .success,
    );
  }

  @override
  void dependencies() {
    Get.put(EventDetailsController());
  }
}
