import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/service/model/leave_holiday_model.dart';

class LeaveCalendarService {
  static Future<LeaveHolidaysModel> getHolidays({
    required int month,
    required int year,
  }) async {
    try {
      Response response = await dioApiCall().get(
        apiRoutes.leaveHolidays,
        queryParameters: {"month": month, "year": year},
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return LeaveHolidaysModel.fromJson(_payload(response.data));
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

  static Map _payload(dynamic body) {
    if (body is Map) {
      final data = body["data"];
      if (data is Map) return data;
      return body;
    }
    return {};
  }
}
