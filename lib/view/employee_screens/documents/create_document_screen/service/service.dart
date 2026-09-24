import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';

class CreateDocumentService {
  static Future<bool> createDocument({
    required int documentTypeId,
    required String documentTitle,
    String documentNumber = '',
    String issueDate = '',
    String expiryDate = '',
    String remarks = '',
    XFile? file,
  }) async {
    try {
      final data = <String, dynamic>{
        "document_type_id": documentTypeId,
        "document_title": documentTitle,
        "remarks": remarks.trim(),
      };
      if (documentNumber.trim().isNotEmpty) {
        data["document_number"] = documentNumber.trim();
      }
      if (issueDate.trim().isNotEmpty) {
        data["issue_date"] = issueDate.trim();
      }
      if (expiryDate.trim().isNotEmpty) {
        data["expiry_date"] = expiryDate.trim();
      }
      if (file != null && file.path.isNotEmpty) {
        data["file"] = await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        );
      }

      Response response = await dioApiCall().post(
        apiRoutes.createDocument,
        data: FormData.fromMap(data),
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
                  "Failed to create document, please try again.",
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
