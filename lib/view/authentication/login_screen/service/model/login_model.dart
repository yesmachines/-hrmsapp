import 'dart:developer';

class LoginModel {
  final String token;

  LoginModel({required this.token});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    log("the response is $json");
    return LoginModel(token: json['access_token']);
  }
}
