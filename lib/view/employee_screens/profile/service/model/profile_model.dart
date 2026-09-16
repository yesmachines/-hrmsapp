class ProfileModel {
  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roles,
    required this.employeeCode,
    required this.designation,
    required this.division,
    required this.employmentStatus,
    required this.joiningDate,
    required this.status,
    required this.departmentId,
    required this.organisationId,
    required this.officeLocationId,
    required this.imageUrl,
  });

  String id;
  String name;
  String email;
  String phone;
  List<String> roles;
  String employeeCode;
  String designation;
  String division;
  String employmentStatus;
  String joiningDate;
  String status;
  String departmentId;
  String organisationId;
  String officeLocationId;
  String imageUrl;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final employee = json["employee"] as Map<String, dynamic>? ?? {};

    return ProfileModel(
      id: json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      phone: employee["phone"]?.toString() ?? "",

      roles: json["roles"] is List
          ? List<String>.from(
        (json["roles"] as List).map(
              (role) => role.toString(),
        ),
      )
          : [],

      employeeCode: employee["employee_code"]?.toString() ?? "",
      designation: employee["designation"]?.toString() ?? "",
      division: employee["division"]?.toString() ?? "",
      employmentStatus:
      employee["employment_status"]?.toString() ?? "",
      joiningDate: employee["joining_date"]?.toString() ?? "",
      status: employee["status"]?.toString() ?? "",

      departmentId: employee["department_id"]?.toString() ?? "",
      organisationId: employee["organisation_id"]?.toString() ?? "",
      officeLocationId:
      employee["office_location_id"]?.toString() ?? "",

      imageUrl: employee["image_url"]?.toString() ?? "",
    );
  }
}