import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;

import '../../../constants/shared_data_key/shared_data_key.dart';
import '../../../main.dart';
import '../../loading_screen/loading_screen.dart';

final dio = Dio();

void resetDioClient() {
  dio.interceptors.clear();
}

Dio dioApiCall() {
  String userToken = '';
  dio.options.connectTimeout = Duration(seconds: 60);
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
            /// token
            Get.Get.closeAllSnackbars();
            if (userToken == "") {
              userToken == ''
                  ? userToken = await sharedDataHandler.getSharedData(
                      key: SharedDataKey.token,
                    )
                  : null;
              print("the user token is $userToken");
            }
            if (userToken != '') {
              options.headers['Accept'] = 'application/json';
              options.headers['Authorization'] = 'Bearer $userToken';
            }
            return handler.next(options);
          },
      onResponse:
          (Response response, ResponseInterceptorHandler handler) async {
            return handler.next(response);
          },
      onError: (DioException exception, ErrorInterceptorHandler handler) async {
        if (exception.type == DioExceptionType.connectionTimeout) {
          notificationHandler.apiErrorNotificationHandler(
            error: DioException(
              requestOptions: exception.requestOptions,
              message: "Connection timed out. Please check your network.",
            ),
          );
        } else if (exception.response?.statusCode == 401) {
          loadingScreen();
          await sharedDataHandler.clearSharedData();
          Get.Get.back();
          // Get.Get.offAllNamed(appRoutes.login);
          notificationHandler.apiErrorNotificationHandler(
            error: DioException(
              requestOptions: RequestOptions(
                data: {"message": "Unauthorized, please login again"},
              ),
            ),
          );
        }
        return handler.next(exception);
      },
    ),
  );
  return dio;
}
