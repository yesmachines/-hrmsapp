import 'package:intl/intl.dart';
import 'package:yes_hrm/constants/api_routes/api_routes.dart';

class EmployeeDirectoryModel {
  const EmployeeDirectoryModel({
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.email,
    required this.phone,
    this.avatarUrl = '',
    this.status = 'Active',
    this.officeLocation = '',
    this.joinDate = '',
  });

  final String id;
  final String name;
  final String designation;
  final String department;
  final String email;
  final String phone;
  final String avatarUrl;
  final String status;
  final String officeLocation;
  final String joinDate;

  String get departmentShort =>
      department.replaceAll(' Department', '').trim();

  bool get isActive => status.toLowerCase() == 'active';

  factory EmployeeDirectoryModel.fromJson(Map json) {
    final department = json["department"];
    final joinDate = json["join_date"] ??
        json["joining_date"] ??
        json["date_of_joining"] ??
        json["joined_at"];
    return EmployeeDirectoryModel(
      id: (json["id"] ?? "").toString(),
      name: _string(json["name"] ?? json["full_name"]),
      designation: _string(
        json["designation"] ?? json["job_title"] ?? json["role"],
      ),
      department: department is Map
          ? _string(department["name"] ?? department["title"])
          : _string(json["department_name"] ?? department),
      email: _string(json["email"]),
      phone: _string(
        json["phone"] ??
            json["mobile"] ??
            json["contact_no"] ??
            json["phone_number"],
      ),
      avatarUrl: _mediaUrl(
        json["image_url"] ?? json["avatar"] ?? json["photo"] ?? json["image"],
      ),
      status: _status(json["status"] ?? json["employee_status"]),
      officeLocation: _string(
        json["office_location"] ??
            json["location"] ??
            json["branch"] ??
            json["office"],
      ),
      joinDate: _joinDate(joinDate),
    );
  }
}

String _string(dynamic value) {
  if (value == null) return '';
  return value.toString().trim();
}

String _status(dynamic value) {
  final status = _string(value);
  if (status.isEmpty) return 'Active';
  return status[0].toUpperCase() + status.substring(1);
}

String _joinDate(dynamic value) {
  if (value == null || value.toString().trim().isEmpty) return '';
  if (value is DateTime) return DateFormat('dd MMM yyyy').format(value);
  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) return value.toString();
  return DateFormat('dd MMM yyyy').format(parsed);
}

String _mediaUrl(dynamic value) {
  final raw = _string(value);
  if (raw.isEmpty) return '';
  if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
  if (raw.startsWith('/')) return '${ApiRoutes.baseUrl}$raw';
  return '${ApiRoutes.baseUrl}/$raw';
}
