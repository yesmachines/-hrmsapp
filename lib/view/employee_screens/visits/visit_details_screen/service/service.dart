import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class VisitDetailsService {
  static Future<VisitModel> getVisit({required String id}) async {
    try {
      Response response = await dioApiCall().get("${apiRoutes.visits}/$id");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return VisitModel.fromJson(_visitPayload(response.data));
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

  static Map _visitPayload(dynamic body) {
    if (body is Map) {
      final data = body["data"];
      if (data is Map) {
        return data["visit"] is Map ? data["visit"] : data;
      }
      if (body["visit"] is Map) return body["visit"];
      return body;
    }
    return {};
  }
}
