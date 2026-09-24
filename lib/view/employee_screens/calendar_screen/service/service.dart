import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';

import 'model/event_calender_model.dart';

class EventCalenderService {
  static Future<EventCalenderModel> getEvents({
    required int month,
    required int year,
  }) async {
    try {
      Response response = await dioApiCall().get(apiRoutes.events);
      log("the response is ${response.data}");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return EventCalenderModel.fromJson(response.data["data"]);
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
