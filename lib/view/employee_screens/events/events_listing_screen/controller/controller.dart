import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/service/model/event_model.dart';

class EventsController extends GetxController with Bindings {
  final DateTime today = DateTime(2026, 8, 27);

  late final List<EventModel> events = [
    EventModel(
      id: '1',
      type: EventType.meeting,
      title: 'Project Review Meeting',
      date: DateTime(2026, 8, 27),
      time: '09:30 AM',
      venue: 'Conference Room A',
      organizer: 'HR Team',
      meetingLink: 'https://meet.google.com/project-review',
      instructions:
          'Please arrive 10 minutes before the scheduled meeting. Bring your project status reports and any pending action items for review.',
    ),
    EventModel(
      id: '2',
      type: EventType.training,
      title: 'Workplace Safety Training',
      date: DateTime(2026, 8, 27),
      time: '11:30 AM',
      venue: 'Training Room',
      organizer: 'HR Department',
      instructions:
          'Attendance is mandatory. Please bring your employee ID and complete the pre-training checklist before the session starts.',
    ),
    EventModel(
      id: '3',
      type: EventType.companyEvent,
      title: 'Annual Team Building Day',
      date: DateTime(2026, 8, 27),
      time: '02:00 PM',
      venue: 'Main Hall',
      organizer: 'Events Team',
      instructions:
          'Join us for team activities and lunch. Casual dress code. Register your participation with your team lead if you have not already.',
    ),
    EventModel(
      id: '4',
      type: EventType.workshop,
      title: 'Leadership Skills Workshop',
      date: DateTime(2026, 8, 27),
      time: '04:00 PM',
      venue: 'Seminar Hall',
      organizer: 'Learning & Development',
      meetingLink: 'https://meet.google.com/leadership-workshop',
      instructions:
          'Please bring a notebook. This workshop includes group exercises and a short assessment at the end of the session.',
    ),
  ];

  String get todayLabel => DateFormat('EEEE, dd MMMM yyyy').format(today);

  void onViewEvent(EventModel event) {
    Get.toNamed(appRoutes.eventDetails, arguments: event);
  }

  @override
  void dependencies() {
    Get.put(EventsController());
  }
}
