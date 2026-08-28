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
    this.officeLocation = 'Dubai Head Office',
    this.joinDate = '15 May 2021',
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
}
