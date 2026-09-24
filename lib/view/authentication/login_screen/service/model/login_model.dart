import 'dart:developer';

class LoginModel {
  final String userId;
  final String token;

  LoginModel({required this.token, required this.userId});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    log("the response is $json");
    return LoginModel(
      token: json['access_token'],
      userId: json["id"].toString(),
    );
  }
}
