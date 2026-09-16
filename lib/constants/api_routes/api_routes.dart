class ApiRoutes {
  static const baseUrl = "https://ymhrms.girafdev.com";

  static const String _baseUrl = "$baseUrl/api/v1";

  String login = "$_baseUrl/login";
  String logout = "$_baseUrl/logout";
  String ideas = "$_baseUrl/ideas";
  String leaves = "$_baseUrl/leaves";
  String employees = "$_baseUrl/employees";
  String visits = "$_baseUrl/visits";
  String assets = "$_baseUrl/assets";
  String assetRequests = "$_baseUrl/assets/requests";
  String assetCategories = "$_baseUrl/assets/categories";
  String assetMyAssigned = "$_baseUrl/assets/my-assigned";
}
