import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/service/model/event_model.dart';

class EventsService {
  static Future<List<EventModel>> getTodayEvents() async {
    try {
      Response response = await dioApiCall().get(apiRoutes.todayEvents);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return getEventsFromJson(_listPayload(response.data));
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

  static Future<EventModel> getEvent(int id) async {
    try {
      Response response = await dioApiCall().get("${apiRoutes.events}/$id");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        final payload = _itemPayload(response.data);
        if (payload is! Map) {
          throw DioException(
            requestOptions: RequestOptions(
              data: {"message": "Event not found"},
            ),
          );
        }
        return EventModel.fromJson(payload);
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

  static dynamic _listPayload(dynamic body) {
    if (body is List) return body;
    if (body is! Map) return [];
    final data = body["data"];
    if (data is List) return data;
    if (data is Map) {
      return data["events"] ?? data["data"] ?? [];
    }
    return body["events"] ?? [];
  }

  static dynamic _itemPayload(dynamic body) {
    if (body is Map) {
      final data = body["data"];
      if (data is Map) return data;
      if (data is List && data.isNotEmpty && data.first is Map) {
        return data.first;
      }
      if (body["id"] != null) return body;
    }
    if (body is List && body.isNotEmpty && body.first is Map) {
      return body.first;
    }
    return null;
  }
}
