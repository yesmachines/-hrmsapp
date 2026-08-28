import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/help_desk/help_desk_listing_screen/service/model/ticket_model.dart';

class HelpDeskController extends GetxController with Bindings {
  final RxList<TicketModel> tickets = <TicketModel>[
    TicketModel(
      id: '1',
      ticketNumber: 'TK-8489',
      category: TicketCategory.payroll,
      status: TicketStatus.inProgress,
      subject: 'Payroll Issue',
      description:
          'My August salary appears lower than expected. Overtime for the first week was not included. Please review the payroll breakdown and confirm the correction timeline.',
      date: DateTime(2026, 8, 20),
      submittedDate: DateTime(2026, 8, 18),
      comments: const [
        TicketComment(
          author: 'Support Team',
          avatarLabel: 'HR',
          authorType: TicketAuthorType.support,
          message:
              'Your payroll ticket has been received and assigned to the payroll specialist.',
        ),
        TicketComment(
          author: 'You',
          avatarLabel: 'ME',
          authorType: TicketAuthorType.employee,
          message:
              'Thank you. I have attached the overtime sheet from my manager.',
        ),
      ],
    ),
    TicketModel(
      id: '2',
      ticketNumber: 'TK-8491',
      category: TicketCategory.hr,
      status: TicketStatus.resolved,
      subject: 'Leave Balance Issue',
      description:
          'My annual leave balance does not match the days I have taken this year. Please recheck the leave ledger and update the available balance.',
      date: DateTime(2026, 8, 20),
      submittedDate: DateTime(2026, 8, 12),
      comments: const [
        TicketComment(
          author: 'Support Team',
          avatarLabel: 'HR',
          authorType: TicketAuthorType.support,
          message:
              'We reviewed your leave ledger. Two approved days were not posted. The balance has been corrected.',
        ),
      ],
    ),
    TicketModel(
      id: '3',
      ticketNumber: 'TK-8492',
      category: TicketCategory.it,
      status: TicketStatus.open,
      subject: 'Laptop Not Working',
      description:
          'My MacBook Pro shut down suddenly and is no longer powering on. I attempted an SMC reset without success. Please arrange diagnostic support.',
      date: DateTime(2026, 8, 20),
      submittedDate: DateTime(2026, 8, 18),
      attachments: const [
        TicketAttachment(
          name: 'laptop_issue_screenshot.png',
          type: TicketAttachmentType.image,
          size: '245 KB',
        ),
        TicketAttachment(
          name: 'error_report.pdf',
          type: TicketAttachmentType.pdf,
          size: '1.2 MB',
        ),
      ],
      comments: const [
        TicketComment(
          author: 'Support Team',
          avatarLabel: 'IT',
          authorType: TicketAuthorType.support,
          message:
              'Your ticket has been assigned to a senior hardware specialist. We will begin diagnostics shortly.',
        ),
        TicketComment(
          author: 'You',
          avatarLabel: 'ME',
          authorType: TicketAuthorType.employee,
          message:
              'Thank you. The device is available for collection at my desk anytime today.',
        ),
        TicketComment(
          author: 'Support Team',
          avatarLabel: 'IT',
          authorType: TicketAuthorType.support,
          message:
              'Motherboard diagnostics are currently underway. We will update you once we have results.',
        ),
      ],
    ),
  ].obs;

  void onAddTicket() {
    Get.toNamed(appRoutes.raiseTicket)?.then((value) {
      if (value is TicketModel) {
        tickets.insert(0, value);
      }
    });
  }

  void onViewTicket(TicketModel ticket) {
    Get.toNamed(appRoutes.ticketDetails, arguments: ticket);
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  @override
  void dependencies() {
    Get.put(HelpDeskController());
  }
}
