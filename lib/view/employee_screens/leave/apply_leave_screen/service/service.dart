import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/model/leave_meta_model.dart';

import '../../../../../main.dart';
import '../../../../../utils/middleware/api_call_handler/api_call_handler.dart';

class ApplyLeaveService {
  static Future<LeaveMetaModel> getLeaveMeta({int? year}) async {
    try {
      Response response = await dioApiCall().get(
        "${apiRoutes.leaves}/meta",
        queryParameters: year == null ? null : {"year": year},
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return LeaveMetaModel.fromJson(response.data["data"]);
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

  static Future<List<EmployeeModel>> getEmployees({String? search}) async {
    try {
      final query = <String, dynamic>{"exclude_me": true};
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

  static Future<bool> applyLeave({
    required Map<String, dynamic> data,
    XFile? certificate,
  }) async {
    try {
      final payload = Map<String, dynamic>.from(data);
      if (certificate != null) {
        payload["certificate"] = await MultipartFile.fromFile(
          certificate.path,
          filename: certificate.name,
        );
      }

      Response response = await dioApiCall().post(
        apiRoutes.leaves,
        data: FormData.fromMap(payload),
      );
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

  static Future<bool> updateLeave({
    required String id,
    required Map<String, dynamic> data,
    XFile? certificate,
  }) async {
    try {
      final payload = Map<String, dynamic>.from(data);
      payload["_method"] = "PUT";
      if (certificate != null) {
        payload["certificate"] = await MultipartFile.fromFile(
          certificate.path,
          filename: certificate.name,
        );
      }

      Response response = await dioApiCall().post(
        "${apiRoutes.leaves}/$id",
        data: FormData.fromMap(payload),
      );
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
