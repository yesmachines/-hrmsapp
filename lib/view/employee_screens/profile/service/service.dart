import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/profile/service/model/profile_model.dart';

class ProfileService{
  static Future<ProfileModel> getProfile() async {
    try {
      Response response = await dioApiCall().get(
        apiRoutes.profile
      );
      log("profile-----${response.data}");
      if(response.statusCode == 200){
        return ProfileModel.fromJson(response.data["data"]);
      }else {
        throw DioException(
            requestOptions: RequestOptions(
              data: {
                "message": response.data["message"] ?? "Something went wrong",
              }
            ));
      }
    }catch (e){
      appVariables.errorPrinting(e);
      throw Exception(e);
    }
  }
}