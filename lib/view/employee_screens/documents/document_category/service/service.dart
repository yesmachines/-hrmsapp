import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';

import 'model/documents_module.dart';

class DocumentService{
  static Future<List<DocumentsModule>> getDocuments() async{
    try{
      Response response = await dioApiCall().get(
        apiRoutes.documents
      );
      if(response.statusCode == 200) {
        List data = response.data["data"];
        return getDocumentsFromJson(data);
      }else{
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