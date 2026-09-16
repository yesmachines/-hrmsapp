import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/employee_personal_documents/service/model/personal_document_model.dart';

class PersonalDocumentService {
  static Future<List<PersonalDocumentModel>> getPersonalDocument()async{
    try{
      Response response = await dioApiCall().get(
        apiRoutes.documentsType
      );
      if(response.statusCode == 200){
        List data = response.data["data"];
        return getPersonalDocumentFromJson(data);
      }else{
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