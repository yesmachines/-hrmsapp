import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';

class AssetRequestDetailsService {
  static Future<AssetRequestModel> getAssetRequest({required String id}) async {
    try {
      Response response = await dioApiCall().get(
        "${apiRoutes.assetRequests}/$id",
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return AssetRequestModel.fromJson(_requestPayload(response.data));
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

  static Map _requestPayload(dynamic body) {
    if (body is Map) {
      final data = body["data"];
      if (data is Map) {
        return data["request"] is Map ? data["request"] : data;
      }
      if (body["request"] is Map) return body["request"];
      return body;
    }
    return {};
  }
}
