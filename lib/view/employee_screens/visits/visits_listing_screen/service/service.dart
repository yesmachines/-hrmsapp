import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_list_model.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class VisitsService {
  static Future<VisitListModel> getVisits({
    required int page,
    required VisitTab dateFilter,
    String? search,
    VisitStatus? status,
  }) async {
    try {
      Response response = await dioApiCall().get(
        apiRoutes.visits,
        queryParameters: {
          "page": page,
          // "date_filter": dateFilter.apiValue,
          "search": search,
          "status": status?.apiValue,
        },
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return VisitListModel.fromJson(
          _visitsPayload(response.data),
          tab: dateFilter,
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

  static Map _visitsPayload(dynamic body) {
    if (body is List) {
      return {"visits": body};
    }
    if (body is! Map) {
      return {};
    }
    final data = body["data"];
    if (data is List) {
      return {"visits": data, "pagination": body["pagination"] ?? body};
    }
    if (data is Map) {
      return data;
    }
    return body;
  }
}
