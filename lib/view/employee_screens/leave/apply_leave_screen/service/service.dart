import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/model/leave_meta_model.dart';

import '../../../../../main.dart';
import '../../../../../utils/middleware/api_call_handler/api_call_handler.dart';

class ApplyLeaveService {
  static Future<LeaveMetaModel> getLeaveMeta() async {
    try {
      Response response = await dioApiCall().get("${apiRoutes.leaves}/meta");
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

  static Future applyLeave({required Map<String, dynamic> data}) async {
    try {
      Response response = await dioApiCall().post(apiRoutes.leaves, data: data);
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
      rethrow;
    }
  }
}
