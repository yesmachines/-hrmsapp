
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../main.dart';
import '../../../../../utils/middleware/api_call_handler/api_call_handler.dart';

class CreateIdeasService {
  static Future<bool> createIdea({
    required String title,
    required String description,
    List<XFile> ideaFiles = const [],
  }) async {
    try {
      List multipartFiles = <MultipartFile>[];
      for (final file in ideaFiles) {
        multipartFiles.add(
          await MultipartFile.fromFile(file.path, filename: file.name),
        );
      }
      FormData data = FormData.fromMap({
        "title": title,
        "description": description,
      });
      if (multipartFiles.isNotEmpty) {
        for (XFile file in ideaFiles) {
          data.files.add(
            MapEntry(
              "idea_files[${ideaFiles.indexOf(file)}]",
              await MultipartFile.fromFile(file.path, filename: file.name),
            ),
          );
        }
      }
      Response response = await dioApiCall().post(apiRoutes.ideas, data: data);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return true;
      } else {
        throw DioException(
          requestOptions: RequestOptions(
            data: {"message": "Failed to submit idea, please try again"},
          ),
        );
      }
    } catch (e) {
      print("the is $e");
      appVariables.errorPrinting(e);
      rethrow;
    }
  }
}
