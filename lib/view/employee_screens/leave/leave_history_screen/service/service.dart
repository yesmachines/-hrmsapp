import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../../main.dart';
import '../../../../../utils/middleware/api_call_handler/api_call_handler.dart';
import 'model/leave_history_model.dart';

class LeaveHistoryService {
  static Future<LeaveHistoryModel> getLeaves({required int page}) async {
    try {
      Response response = await dioApiCall().get(
        apiRoutes.leaves,
        queryParameters: {"page": page},
      );
      log("the response is ${response.data}");
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
