import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/help_desk/help_desk_listing_screen/service/model/ticket_model.dart';

class TicketDetailsController extends GetxController with Bindings {
  late final TicketModel ticket;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is TicketModel) {
      ticket = args;
    } else {
      ticket = TicketModel(
        id: '0',
        ticketNumber: 'TK-0000',
        category: TicketCategory.it,
        status: TicketStatus.open,
        subject: 'Ticket',
        description: '',
        date: DateTime.now(),
        submittedDate: DateTime.now(),
      );
    }
    super.onInit();
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  String timelineDescription(TicketStatus status) {
    switch (status) {
      case TicketStatus.newTicket:
        return 'Submitted & logged in system.';
      case TicketStatus.open:
        return 'Ticket received and assigned to ${ticket.category.teamLabel}.';
      case TicketStatus.inProgress:
        return 'Currently being handled by support agent.';
      case TicketStatus.resolved:
        return 'Issue resolved & fix verified.';
      case TicketStatus.closed:
        return 'Ticket closed after confirmation.';
    }
  }

  void onViewAttachment(TicketAttachment file) {
    notificationHandler.sendNotification(
      message: 'Opening ${file.name}',
      notificationType: .success,
    );
  }

  @override
  void dependencies() {
    Get.put(TicketDetailsController());
  }
}
