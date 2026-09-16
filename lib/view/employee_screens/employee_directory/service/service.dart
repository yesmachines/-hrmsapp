import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/model/employee_directory_list_model.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/model/employee_directory_model.dart';

class EmployeeDirectoryService {
  static Future<EmployeeDirectoryListModel> getEmployees({
    required int page,
    String? search,
    String? department,
  }) async {
    try {
      final query = <String, dynamic>{"page": page};
      final trimmedSearch = search?.trim() ?? '';
      if (trimmedSearch.isNotEmpty) {
        query["search"] = trimmedSearch;
      }
      final trimmedDepartment = department?.trim() ?? '';
      if (trimmedDepartment.isNotEmpty) {
        query["department"] = trimmedDepartment;
      }

      Response response = await dioApiCall().get(
        apiRoutes.employees,
        queryParameters: query,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return EmployeeDirectoryListModel.fromJson(
          _employeesPayload(response.data),
        );
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

  static Future<EmployeeDirectoryModel> getEmployee({required String id}) async {
    try {
      Response response = await dioApiCall().get("${apiRoutes.employees}/$id");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return EmployeeDirectoryModel.fromJson(_employeePayload(response.data));
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

  static Map _employeePayload(dynamic body) {
    if (body is Map) {
      final data = body["data"];
      if (data is Map) {
        return data["employee"] is Map ? data["employee"] : data;
      }
      if (body["employee"] is Map) return body["employee"];
      return body;
    }
    return {};
  }

  static Map _employeesPayload(dynamic body) {
    if (body is List) {
      return {"employees": body};
    }
    if (body is! Map) {
      return {};
    }
    final data = body["data"];
    if (data is List) {
      return {
        "employees": data,
        "pagination": body["pagination"] ?? body,
      };
    }
    if (data is Map) {
      return data;
    }
    return body;
  }
}
