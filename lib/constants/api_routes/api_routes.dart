class ApiRoutes {
  static const baseUrl = "https://ymhrms.girafdev.com";

  static const String _baseUrl = "$baseUrl/api/v1";

  String login = "$_baseUrl/login";
  String logout = "$_baseUrl/logout";
  String ideas = "$_baseUrl/ideas";
  String leaves = "$_baseUrl/leaves";
  String employees = "$_baseUrl/employees";
  String visits = "$_baseUrl/visits";
  String profile = "$_baseUrl/me";
  String documents = "$_baseUrl/documents/categories";
  String documentsType = "$_baseUrl/documents/types";
}
