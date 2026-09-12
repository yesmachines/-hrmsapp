import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/model/leave_meta_model.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class RequestVisitService {
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  static Future<List<EmployeeModel>> getEmployees({String? search}) async {
    try {
      final query = <String, dynamic>{"exclude_me": true, "all": true};
      final trimmedSearch = search?.trim() ?? '';
      if (trimmedSearch.isNotEmpty) {
        query['search'] = trimmedSearch;
      }

      Response response = await dioApiCall().get(
        apiRoutes.employees,
        queryParameters: query,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return _employeesFromResponse(response.data);
      } else {
        throw DioException(
          requestOptions: RequestOptions(
            data: {
              "message":
                  response.data["message"] ??
                  "Something went wrong please try again later.",
            },
          ),
        );
      }
    } catch (e) {
      appVariables.errorPrinting(e);
      rethrow;
    }
  }

  static List<EmployeeModel> _employeesFromResponse(dynamic body) {
    dynamic data = body;
    if (body is Map) {
      data = body["data"] ?? body["employees"];
      if (data is Map) {
        data = data["employees"] ?? data["data"] ?? data["items"];
      }
    }
    return getEmployeesFromJson(data);
  }

  static Future<bool> createVisit({
    required List<VisitVisitor> visitors,
    required String company,
    required String contactNo,
    required String email,
    required String purpose,
    required String location,
    required DateTime expectedStartDate,
    required DateTime expectedEndDate,
    List<String> assignedEmployeeIds = const [],
  }) async {
    try {
      final data = <String, dynamic>{
        "total_visitors": visitors.length + 1,
        "visitor_details": visitors.map((visitor) => visitor.toJson()).toList(),
        "company": company,
        "contact_no": contactNo,
        "email": email,
        "purpose": purpose,
        "location": location,
        "expected_start_date": _dateTimeFormat.format(expectedStartDate),
        "expected_end_date": _dateTimeFormat.format(expectedEndDate),
      };
      if (assignedEmployeeIds.isNotEmpty) {
        data["assigned_employee_ids"] = assignedEmployeeIds;
      }

      Response response = await dioApiCall().post(apiRoutes.visits, data: data);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return true;
      } else {
        throw DioException(
          requestOptions: RequestOptions(
            data: {
              "message":
                  response.data["message"] ??
                  "Something went wrong please try again later.",
            },
          ),
        );
      }
    } catch (e) {
      appVariables.errorPrinting(e);
      rethrow;
    }
  }
}
