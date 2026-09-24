import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/service/model/document_file_model.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/service/model/document_type_model.dart';

class DocumentTypesService {
  static Future<List<DocumentTypeModel>> getDocumentTypes({
    String? categoryCode,
  }) async {
    try {
      final query = <String, dynamic>{};
      final trimmedCategoryCode = categoryCode?.trim() ?? '';
      if (trimmedCategoryCode.isNotEmpty) {
        query["category_code"] = trimmedCategoryCode;
      }

      Response response = await dioApiCall().get(
        apiRoutes.documentsType,
        queryParameters: query.isEmpty ? null : query,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        final types = getDocumentTypesFromJson(_typesPayload(response.data));
        if (trimmedCategoryCode.isEmpty) return types;
        return types
            .where(
              (type) =>
                  type.categoryCode.isEmpty ||
                  type.categoryCode == trimmedCategoryCode,
            )
            .toList();
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

  static Future<List<DocumentFileModel>> getDocumentFiles({
    String? categoryCode,
  }) async {
    try {
      final query = <String, dynamic>{};
      final trimmedCategoryCode = categoryCode?.trim() ?? '';
      if (trimmedCategoryCode.isNotEmpty) {
        query["category_code"] = trimmedCategoryCode;
      }

      Response response = await dioApiCall().get(
        apiRoutes.documentsFiles,
        queryParameters: query.isEmpty ? null : query,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        final files = getDocumentFilesFromJson(_typesPayload(response.data));
        if (trimmedCategoryCode.isEmpty) return files;
        return files
            .where(
              (file) =>
                  file.categoryCode.isEmpty ||
                  file.categoryCode == trimmedCategoryCode,
            )
            .toList();
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

  static dynamic _typesPayload(dynamic body) {
    if (body is List) return body;
    if (body is! Map) return [];
    final data = body["data"];
    if (data is List) return data;
    if (data is Map) {
      return data["types"] ??
          data["document_types"] ??
          data["documents"] ??
          data["data"] ??
          [];
    }
    return body["types"] ?? body["document_types"] ?? [];
  }
}
