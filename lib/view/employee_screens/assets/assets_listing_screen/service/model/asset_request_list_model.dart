import 'package:yes_hrm/common_model/pagination_data_model.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';

class AssetRequestListModel {
  AssetRequestListModel({required this.requests, required this.pagination});

  final List<AssetRequestModel> requests;
  final PaginationData pagination;

  factory AssetRequestListModel.fromJson(Map json) {
    final paginationJson = json["pagination"] is Map
        ? json["pagination"] as Map
        : json;
    return AssetRequestListModel(
      requests: getAssetRequestListFromJson(_requestsJson(json)),
      pagination: PaginationData.fromJson({
        "total": paginationJson["total"] ?? json["total"] ?? 1,
        "current_page":
            paginationJson["current_page"] ?? json["current_page"] ?? 1,
        "last_page": paginationJson["last_page"] ?? json["last_page"] ?? 1,
      }),
    );
  }
}

dynamic _requestsJson(Map json) {
  if (json["requests"] is List) return json["requests"];
  if (json["asset_requests"] is List) return json["asset_requests"];
  if (json["data"] is List) return json["data"];
  if (json["data"] is Map) {
    final nested = json["data"] as Map;
    return nested["requests"] ??
        nested["asset_requests"] ??
        nested["data"] ??
        [];
  }
  return [];
}

List<AssetRequestModel> getAssetRequestListFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json.whereType<Map>().map((e) => AssetRequestModel.fromJson(e)),
  );
}
