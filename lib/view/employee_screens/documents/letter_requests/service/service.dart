import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/documents/letter_requests/service/model/letter_request_model.dart';

class LetterRequestService {
  static Future<List<LetterRequestModel>> getLetterRequests() async {
    try {
      Response response = await dioApiCall().get(apiRoutes.letterRequests);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return getLetterRequestsFromJson(_listPayload(response.data));
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

  static Future<LetterRequestModel> getLetterRequest(int id) async {
    try {
      Response response = await dioApiCall().get(
        "${apiRoutes.letterRequests}/$id",
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        final payload = _itemPayload(response.data);
        if (payload is! Map) {
          throw DioException(
            requestOptions: RequestOptions(
              data: {"message": "Letter request not found"},
            ),
          );
        }
        return LetterRequestModel.fromJson(payload);
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

  static Future<bool> createLetterRequest({
    required int documentTypeId,
    required int documentTemplateId,
    required String purpose,
    required String details,
    required String toAddress,
    String visaDesignation = '',
  }) async {
    try {
      final data = <String, dynamic>{
        "document_type_id": documentTypeId,
        "document_template_id": documentTemplateId,
        "purpose": purpose.trim(),
        "details": details.trim(),
        "to_address": toAddress.trim(),
      };
      if (visaDesignation.trim().isNotEmpty) {
        data["visa_designation"] = visaDesignation.trim();
      }

      Response response = await dioApiCall().post(
        apiRoutes.letterRequests,
        data: data,
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
                  "Failed to create letter request, please try again.",
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
      return data["letters"] ??
          data["letter_requests"] ??
          data["requests"] ??
          data["data"] ??
          [];
    }
    return body["letters"] ?? body["letter_requests"] ?? [];
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
