import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/service/model/event_model.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/service/service.dart';

class EventsController extends GetxController with Bindings {
  final DateTime today = DateTime.now();
  final Rxn<List<EventModel>> events = Rxn(null);
  final RxnBool hasError = RxnBool(false);

  String get todayLabel => DateFormat('EEEE, dd MMMM yyyy').format(today);

  Future<List<EventModel>> getTodayEvents() async {
    hasError.value = false;
    return EventsService.getTodayEvents()
        .then((value) {
          events.value = value;
          return value;
        })
        .onError((error, stackTrace) {
          hasError.value = true;
          notificationHandler.apiErrorNotificationHandler(error: error);
          throw Exception();
        });
  }

  void onViewEvent(EventModel event) {
    Get.toNamed(appRoutes.eventDetails, arguments: event.id);
  }

  @override
  void dependencies() {
    Get.put(EventsController());
  }
}
