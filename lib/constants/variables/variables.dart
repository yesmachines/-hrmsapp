
import 'package:dio/dio.dart';

class AppVariables {

  errorPrinting(e) {
    print("the e is $e");
    if (e is DioException) {
      print("the response is ${e.response?.data}");
    }
    ;
  }
}
