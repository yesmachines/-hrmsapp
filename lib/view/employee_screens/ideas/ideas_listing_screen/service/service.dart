import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';

import 'model/idea_data_model.dart';

class IdeasService {
  static Future<IdeaDataModel> getIdeas({required int page}) async {
    try {
      Response response = await dioApiCall().get(
        apiRoutes.ideas,
        queryParameters: {"page": page},
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return IdeaDataModel.fromJson(response.data["data"]);
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
