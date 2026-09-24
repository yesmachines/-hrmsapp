import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';

import 'model/hr_document_model.dart';

class HrDocumentService {
  static Future<List<HrDocumentModel>> getHrDocument() async{
    try{
      Response response = await dioApiCall().get(
        apiRoutes.hrDocuments
      );
      log("hrDocuments---${response.data}");
      if(response.statusCode == 200){
        List data = response.data["data"];
        return getHrDocumentFromJson(data);
      } else {
        throw DioException(
            requestOptions: RequestOptions(
              data: {
                "message": response.data["message"] ?? "Something went wrong"
              }
            ));
      }
    }catch(e){
      log("the e is $e");
      throw Exception(e);
    }
  }
}