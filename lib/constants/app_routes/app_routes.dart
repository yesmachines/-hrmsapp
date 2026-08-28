import 'package:get/get.dart';
import 'package:yes_hrm/view/authentication/login_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/dashboard/controller/controller.dart';
import '../../main.dart';
import '../../view/authentication/login_screen/view/login_screen.dart';
import '../../view/common_screen/splash_screen/controller/controller.dart';
import '../../view/common_screen/splash_screen/view/splash_screen_view.dart';
import '../../view/employee_screens/assets/asset_details_screen/controller/controller.dart';
import '../../view/employee_screens/assets/asset_details_screen/view/asset_details_view.dart';
import '../../view/employee_screens/assets/assets_listing_screen/controller/controller.dart';
import '../../view/employee_screens/assets/assets_listing_screen/view/assets_view.dart';
import '../../view/employee_screens/assets/create_asset_request_screen/controller/controller.dart';
import '../../view/employee_screens/assets/create_asset_request_screen/view/create_asset_request_view.dart';
import '../../view/employee_screens/contact_information/controller/controller.dart';
import '../../view/employee_screens/contact_information/view/contact_information_view.dart';
import '../../view/employee_screens/dashboard/view/employee_dashboard_view.dart';
import '../../view/employee_screens/document_information/controller/controller.dart';
import '../../view/employee_screens/document_information/view/document_information_view.dart';
import '../../view/employee_screens/education_experience/controller/controller.dart';
import '../../view/employee_screens/education_experience/view/education_experience_view.dart';
import '../../view/employee_screens/emergency_contact/controller/controller.dart';
import '../../view/employee_screens/emergency_contact/view/emergency_contact_view.dart';
import '../../view/employee_screens/employee_details_screen/controller/controller.dart';
import '../../view/employee_screens/employee_details_screen/view/employee_details_view.dart';
import '../../view/employee_screens/employee_directory/controller/controller.dart';
import '../../view/employee_screens/employee_directory/view/employee_directory_view.dart';
import '../../view/employee_screens/employee_documents/controller/controller.dart';
import '../../view/employee_screens/employee_documents/view/employee_documents_view.dart';
import '../../view/employee_screens/employee_personal_documents/controller/controller.dart';
import '../../view/employee_screens/employee_personal_documents/view/employee_personal_documents_view.dart';
import '../../view/employee_screens/employment_information/controller/controller.dart';
import '../../view/employee_screens/employment_information/view/employment_information_view.dart';
import '../../view/employee_screens/help_desk/help_desk_listing_screen/controller/controller.dart';
import '../../view/employee_screens/help_desk/help_desk_listing_screen/view/help_desk_view.dart';
import '../../view/employee_screens/help_desk/raise_ticket_screen/controller/controller.dart';
import '../../view/employee_screens/help_desk/raise_ticket_screen/view/raise_ticket_view.dart';
import '../../view/employee_screens/help_desk/ticket_details_screen/controller/controller.dart';
import '../../view/employee_screens/help_desk/ticket_details_screen/view/ticket_details_view.dart';
import '../../view/employee_screens/hr_documents/controller/controller.dart';
import '../../view/employee_screens/hr_documents/view/hr_documents_view.dart';
import '../../view/employee_screens/ideas/create_idea_screen/controller/controller.dart';
import '../../view/employee_screens/ideas/create_idea_screen/view/create_idea_screen.dart';
import '../../view/employee_screens/ideas/ideas_listing_screen/controller/controller.dart';
import '../../view/employee_screens/ideas/ideas_listing_screen/view/ideas_view.dart';
import '../../view/employee_screens/leave/apply_leave_screen/controller/controller.dart';
import '../../view/employee_screens/leave/apply_leave_screen/view/apply_leave_view.dart';
import '../../view/employee_screens/leave/leave_history_screen/controller/controller.dart';
import '../../view/employee_screens/leave/leave_history_screen/view/leave_history_view.dart';
import '../../view/employee_screens/leave/leave_screen/controller/controller.dart';
import '../../view/employee_screens/leave/leave_screen/view/leave_view.dart';
import '../../view/employee_screens/visits/request_visit_screen/controller/controller.dart';
import '../../view/employee_screens/visits/request_visit_screen/view/request_visit_view.dart';
import '../../view/employee_screens/visits/visit_details_screen/controller/controller.dart';
import '../../view/employee_screens/visits/visit_details_screen/view/visit_details_view.dart';
import '../../view/employee_screens/visits/visits_listing_screen/controller/controller.dart';
import '../../view/employee_screens/visits/visits_listing_screen/view/visits_view.dart';
import '../../view/employee_screens/letter_requests/controller/controller.dart';
import '../../view/employee_screens/letter_requests/view/letter_requests_view.dart';
import '../../view/employee_screens/news/news_details_screen/controller/controller.dart';
import '../../view/employee_screens/news/news_details_screen/view/news_details_view.dart';
import '../../view/employee_screens/news/news_listing_screen/controller/controller.dart';
import '../../view/employee_screens/news/news_listing_screen/view/news_view.dart';
import '../../view/employee_screens/personal_information/controller/controller.dart';
import '../../view/employee_screens/personal_information/view/personal_information_view.dart';

class AppRoutes {
  String splashScreen = "/splashScreen";
  String loginScreen = "/loginScreen";
  String employeeDashboardView = "/employeeDashboardView";
  String personalInformation = "/personalInformation";
  String employmentInformation = "/employmentInformation";
  String contactInformation = "/contactInformation";
  String emergencyContact = "/emergencyContact";
  String educationExperience = "/educationExperience";
  String documentInformation = "/documentInformation";
  String employeePersonalDocuments = "/employeePersonalDocuments";
  String employeeDocuments = "/employeeDocuments";
  String hrDocuments = "/hrDocuments";
  String letterRequests = "/letterRequests";
  String ideas = "/ideas";
  String createIdeaScreen = "/createIdeaScreen";
  String leave = "/leave";
  String leaveHistory = "/leaveHistory";
  String applyLeave = "/applyLeave";
  String employeeDirectory = "/employeeDirectory";
  String employeeDetails = "/employeeDetails";
  String visits = "/visits";
  String requestVisit = "/requestVisit";
  String visitDetails = "/visitDetails";
  String assets = "/assets";
  String createAssetRequest = "/createAssetRequest";
  String assetDetails = "/assetDetails";
  String news = "/news";
  String newsDetails = "/newsDetails";
  String helpDesk = "/helpDesk";
  String ticketDetails = "/ticketDetails";
  String raiseTicket = "/raiseTicket";
}

List<GetPage<dynamic>> routes = [
  GetPage(
    name: appRoutes.splashScreen,
    page: () => const SplashScreenView(),
    binding: SplashScreenController(),
  ),
  GetPage(
    name: appRoutes.loginScreen,
    page: () => const LoginScreen(),
    binding: LoginController(),
  ),
  GetPage(
    name: appRoutes.employeeDashboardView,
    page: () => const EmployeeDashboardView(),
    binding: EmployeeDashboardController(),
  ),
  GetPage(
    name: appRoutes.personalInformation,
    page: () => const PersonalInformationView(),
    binding: PersonalInformationController(),
  ),
  GetPage(
    name: appRoutes.employmentInformation,
    page: () => const EmploymentInformationView(),
    binding: EmploymentInformationController(),
  ),
  GetPage(
    name: appRoutes.contactInformation,
    page: () => const ContactInformationView(),
    binding: ContactInformationController(),
  ),
  GetPage(
    name: appRoutes.emergencyContact,
    page: () => const EmergencyContactView(),
    binding: EmergencyContactController(),
  ),
  GetPage(
    name: appRoutes.educationExperience,
    page: () => const EducationExperienceView(),
    binding: EducationExperienceController(),
  ),
  GetPage(
    name: appRoutes.documentInformation,
    page: () => const DocumentInformationView(),
    binding: DocumentInformationController(),
  ),
  GetPage(
    name: appRoutes.employeePersonalDocuments,
    page: () => const EmployeePersonalDocumentsView(),
    binding: EmployeePersonalDocumentsController(),
  ),
  GetPage(
    name: appRoutes.employeeDocuments,
    page: () => const EmployeeDocumentsView(),
    binding: EmployeeDocumentsController(),
  ),
  GetPage(
    name: appRoutes.hrDocuments,
    page: () => const HrDocumentsView(),
    binding: HrDocumentsController(),
  ),
  GetPage(
    name: appRoutes.letterRequests,
    page: () => const LetterRequestsView(),
    binding: LetterRequestsController(),
  ),
  GetPage(
    name: appRoutes.ideas,
    page: () => const IdeasView(),
    binding: IdeasController(),
  ),
  GetPage(
    name: appRoutes.createIdeaScreen,
    page: () => const CreateIdeaScreen(),
    binding: CreateIdeaController(),
  ),
  GetPage(
    name: appRoutes.leave,
    page: () => const LeaveView(),
    binding: LeaveController(),
  ),
  GetPage(
    name: appRoutes.leaveHistory,
    page: () => const LeaveHistoryView(),
    binding: LeaveHistoryController(),
  ),
  GetPage(
    name: appRoutes.applyLeave,
    page: () => const ApplyLeaveView(),
    binding: ApplyLeaveController(),
  ),
  GetPage(
    name: appRoutes.employeeDirectory,
    page: () => const EmployeeDirectoryView(),
    binding: EmployeeDirectoryController(),
  ),
  GetPage(
    name: appRoutes.employeeDetails,
    page: () => const EmployeeDetailsView(),
    binding: EmployeeDetailsController(),
  ),
  GetPage(
    name: appRoutes.visits,
    page: () => const VisitsView(),
    binding: VisitsController(),
  ),
  GetPage(
    name: appRoutes.requestVisit,
    page: () => const RequestVisitView(),
    binding: RequestVisitController(),
  ),
  GetPage(
    name: appRoutes.visitDetails,
    page: () => const VisitDetailsView(),
    binding: VisitDetailsController(),
  ),
  GetPage(
    name: appRoutes.assets,
    page: () => const AssetsView(),
    binding: AssetsController(),
  ),
  GetPage(
    name: appRoutes.createAssetRequest,
    page: () => const CreateAssetRequestView(),
    binding: CreateAssetRequestController(),
  ),
  GetPage(
    name: appRoutes.assetDetails,
    page: () => const AssetDetailsView(),
    binding: AssetDetailsController(),
  ),
  GetPage(
    name: appRoutes.news,
    page: () => const NewsView(),
    binding: NewsController(),
  ),
  GetPage(
    name: appRoutes.newsDetails,
    page: () => const NewsDetailsView(),
    binding: NewsDetailsController(),
  ),
  GetPage(
    name: appRoutes.helpDesk,
    page: () => const HelpDeskView(),
    binding: HelpDeskController(),
  ),
  GetPage(
    name: appRoutes.ticketDetails,
    page: () => const TicketDetailsView(),
    binding: TicketDetailsController(),
  ),
  GetPage(
    name: appRoutes.raiseTicket,
    page: () => const RaiseTicketView(),
    binding: RaiseTicketController(),
  ),
];
