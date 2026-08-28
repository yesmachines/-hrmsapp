import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/service/model/event_model.dart';

class EventDetailsController extends GetxController with Bindings {
  late final EventModel event;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is EventModel) {
      event = args;
    } else {
      event = EventModel(
        id: '0',
        type: EventType.meeting,
        title: 'Event',
        date: DateTime.now(),
        time: '-',
        venue: '-',
      );
    }
    super.onInit();
  }

  String get dateHeadline {
    return 'Today • ${DateFormat('dd MMMM yyyy').format(event.date)}';
  }

  void onJoinMeeting() {
    notificationHandler.sendNotification(
      message: event.meetingLink == null
          ? 'No meeting link available'
          : 'Opening meeting link',
      notificationType: event.meetingLink == null ? .warning : .success,
    );
  }

  @override
  void dependencies() {
    Get.put(EventDetailsController());
  }
}
