import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../main.dart';
import '../../../../utils/middleware/api_call_handler/api_call_handler.dart';
import 'model/login_model.dart';

class LoginService {
  static Future<LoginModel> signIn({
    required String email,
    required String password,
    required String device,
  }) async {
    try {
      Map<String, dynamic> data = {
        "email": email,
        "password": password,
        "device_name": device,
      };
      Response response = await dioApiCall().post(
        apiRoutes.login,
        data: FormData.fromMap(data),
      );
      log("the response is ${response.data}");
      if (response.statusCode == 200) {
        LoginModel loginModel = LoginModel.fromJson(response.data["data"]);
        return loginModel;
      } else {
        throw DioException(
          requestOptions: RequestOptions(
            data: {"message": "Failed to sign in please try again"},
          ),
        );
      }
    } catch (e) {
      appVariables.errorPrinting(e);
      rethrow;
    }
  }

  static Future<bool> logout() async {
    try {
      Response response = await dioApiCall().post(apiRoutes.logout);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return true;
      } else {
        throw DioException(
          requestOptions: RequestOptions(
            data: {"message": "Failed to logout, please try again"},
          ),
        );
      }
    } catch (e) {
      appVariables.errorPrinting(e);
      rethrow;
    }
  }
}
