import 'package:dio/dio.dart';

import '../../../../../main.dart';
import '../../../../../utils/middleware/api_call_handler/api_call_handler.dart';
import '../../apply_leave_screen/service/model/leave_meta_model.dart';
import 'model/leave_history_model.dart';

class LeaveHistoryService {

  static Future<List<LeaveTypeModel>> getLeaveTypes() async {
    try {
      Response response = await dioApiCall().get("${apiRoutes.leaves}/meta");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return getLeaveTypeFromJson(response.data["data"]["leave_types"]);
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

  static Future<LeaveHistoryModel> getLeaves({
    required int page,
    Map<String, dynamic>? filters,
  }) async {
    try {
      Response response = await dioApiCall().get(
        apiRoutes.leaves,
        queryParameters: {"page": page, ...?filters},
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return LeaveHistoryModel.fromJson(response.data["data"]);
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
