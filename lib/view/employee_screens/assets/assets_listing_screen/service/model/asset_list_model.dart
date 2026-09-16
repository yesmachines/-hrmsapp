import 'package:yes_hrm/common_model/pagination_data_model.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';

class AssetListModel {
  AssetListModel({required this.assets, required this.pagination});

  final List<AssetModel> assets;
  final PaginationData pagination;

  factory AssetListModel.fromJson(Map json) {
    final paginationJson = json["pagination"] is Map
        ? json["pagination"] as Map
        : json;
    return AssetListModel(
      assets: getAssetListFromJson(_assetsJson(json)),
      pagination: PaginationData.fromJson({
        "total": paginationJson["total"] ?? json["total"] ?? 1,
        "current_page":
            paginationJson["current_page"] ?? json["current_page"] ?? 1,
        "last_page": paginationJson["last_page"] ?? json["last_page"] ?? 1,
      }),
    );
  }
}

dynamic _assetsJson(Map json) {
  if (json["assets"] is List) return json["assets"];
  if (json["data"] is List) return json["data"];
  if (json["data"] is Map) {
    final nested = json["data"] as Map;
    return nested["assets"] ?? nested["data"] ?? [];
  }
  return [];
}

List<AssetModel> getAssetListFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json.whereType<Map>().map((e) => AssetModel.fromJson(e)),
  );
}
