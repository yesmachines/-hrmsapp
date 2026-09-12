import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../../main.dart';
import '../../../../../utils/middleware/api_call_handler/api_call_handler.dart';
import '../../model/leave_model.dart';

class LeaveViewService {
  static Future<LeaveModel> getLeave({required String id}) async {
    try {
      Response response = await dioApiCall().get("${apiRoutes.leaves}/$id");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return LeaveModel.fromJson(_leavePayload(response.data));
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

  static Map _leavePayload(dynamic body) {
    if (body is Map) {
      final data = body["data"];
      if (data is Map) {
        return data["leave"] is Map ? data["leave"] : data;
      }
      if (body["leave"] is Map) return body["leave"];
      return body;
    }
    return {};
  }
}
