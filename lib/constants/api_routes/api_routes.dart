import 'package:yes_hrm/main.dart';

class ApiRoutes {
  static const baseUrl = "https://ymhrms.girafdev.com";

  static const String _baseUrl = "$baseUrl/api/v1";

  String login = "$_baseUrl/login";
  String logout = "$_baseUrl/logout";
  String ideas = "$_baseUrl/ideas";
  String leaves = "$_baseUrl/leaves";
  String leaveHolidays = "$_baseUrl/leaves/holidays";
  String employees = "$_baseUrl/employees";
  String departments = "$_baseUrl/departments";
  String visits = "$_baseUrl/visits";
  String assets = "$_baseUrl/assets";
  String assetRequests = "$_baseUrl/assets/requests";
  String assetCategories = "$_baseUrl/assets/categories";
  String assetMyAssigned = "$_baseUrl/assets/my-assigned";
  String profile = "$_baseUrl/me";
  String documents = "$_baseUrl/documents/categories";
  String createDocument = "$_baseUrl/documents";
  String documentsFiles = "$_baseUrl/documents";
  String documentsType = "$_baseUrl/documents/types";
  String letterRequests = "$_baseUrl/documents/letters";
  String hrDocuments = "$_baseUrl/documents/policies";
  String events = "$_baseUrl/events";
  String todayEvents = "$_baseUrl/events/today";
}
