import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_list_model.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_request_list_model.dart';

class AssetsService {
  static Future<AssetListModel> getAssets({
    required int page,
    String? search,
    AssetStatus? status,
  }) async {
    try {
      final query = <String, dynamic>{"page": page};
      final trimmedSearch = search?.trim() ?? '';
      if (trimmedSearch.isNotEmpty) {
        query["search"] = trimmedSearch;
      }
      if (status != null) {
        query["status"] = status.apiValue;
      }

      Response response = await dioApiCall().get(
        apiRoutes.assets,
        queryParameters: query,
      );
      log("the response is ${response.data}");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return AssetListModel.fromJson(_assetsPayload(response.data));
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

  static Map _assetsPayload(dynamic body) {
    if (body is List) {
      return {"assets": body};
    }
    if (body is! Map) {
      return {};
    }
    final data = body["data"];
    if (data is List) {
      return {"assets": data, "pagination": body["pagination"] ?? body};
    }
    if (data is Map) {
      return data;
    }
    return body;
  }

  static Future<AssetRequestListModel> getAssetRequests({
    required int page,
    String? search,
    AssetRequestStatus? status,
  }) async {
    try {
      final query = <String, dynamic>{"page": page};
      final trimmedSearch = search?.trim() ?? '';
      if (trimmedSearch.isNotEmpty) {
        query["search"] = trimmedSearch;
      }
      if (status != null) {
        query["status"] = status.apiValue;
      }

      Response response = await dioApiCall().get(
        apiRoutes.assetRequests,
        queryParameters: query,
      );
      log("theresponse is ${response.data}");
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return AssetRequestListModel.fromJson(_requestsPayload(response.data));
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

  static Future<bool> createAssetRequest({
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await dioApiCall().post(
        apiRoutes.assetRequests,
        data: data,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return true;
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

  static Map _requestsPayload(dynamic body) {
    if (body is List) {
      return {"requests": body};
    }
    if (body is! Map) {
      return {};
    }
    final data = body["data"];
    if (data is List) {
      return {"requests": data, "pagination": body["pagination"] ?? body};
    }
    if (data is Map) {
      return data;
    }
    return body;
  }

  static Future<List<AssetModel>> getMyAssignedAssets() async {
    try {
      Response response = await dioApiCall().get(apiRoutes.assetMyAssigned);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        log("the response is ${response.data}");
        return getAssetListFromJson(_assignedAssetsPayload(response.data));
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

  static dynamic _assignedAssetsPayload(dynamic body) {
    final list = _firstAssetList(body);
    if (list is! List) return [];
    return [
      for (final item in list)
        if (item is Map) _unwrapAssignedAsset(item),
    ];
  }

  static Map _unwrapAssignedAsset(Map json) {
    final nested = json["asset"];
    if (nested is! Map) return json;
    return {
      ...nested,
      "id": nested["id"] ?? json["asset_id"] ?? json["id"],
      "asset_id":
          nested["asset_id"] ??
          nested["asset_code"] ??
          nested["code"] ??
          json["asset_id"],
    };
  }

  static dynamic _firstAssetList(dynamic body) {
    if (body is List) return body;
    if (body is! Map) return [];
    const keys = [
      "assets",
      "assigned_assets",
      "my_assigned",
      "assigned",
      "items",
      "records",
      "data",
    ];
    for (final key in keys) {
      final value = body[key];
      if (value is List) return value;
    }
    for (final key in keys) {
      final value = body[key];
      if (value is Map) {
        final nested = _firstAssetList(value);
        if (nested is List) return nested;
      }
    }
    return [];
  }

  static Future<List<AssetCategoryModel>> getAssetCategories() async {
    try {
      Response response = await dioApiCall().get(apiRoutes.assetCategories);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 300) {
        return getAssetCategoriesFromJson(_categoriesPayload(response.data));
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

  static dynamic _categoriesPayload(dynamic body) {
    if (body is List) return body;
    if (body is! Map) return [];
    final data = body["data"];
    if (data is List) return data;
    if (data is Map) {
      return data["categories"] ??
          data["asset_categories"] ??
          data["data"] ??
          [];
    }
    return body["categories"] ?? body["asset_categories"] ?? [];
  }
}
