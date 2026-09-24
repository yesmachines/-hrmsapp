import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';

import 'model/personal_document_model.dart';

class PersonalDocumentService {
  static Future<List<PersonalDocumentModel>> getPersonalDocument({
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
      if (response.statusCode == 200) {
        final raw = response.data["data"];
        final List data = raw is List ? raw : [];
        final types = getPersonalDocumentFromJson(data);
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
                "message": response.data["message"] ?? "Something went wrong"
              }
            ));
      }
    }catch(e){
      throw Exception(e);
    }
  }
}