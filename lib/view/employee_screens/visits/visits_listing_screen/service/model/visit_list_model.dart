import 'package:yes_hrm/common_model/pagination_data_model.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class VisitListModel {
  VisitListModel({required this.visits, required this.pagination});

  final List<VisitModel> visits;
  final PaginationData pagination;

  factory VisitListModel.fromJson(Map json, {VisitTab tab = VisitTab.today}) {
    final paginationJson = json["pagination"] is Map
        ? json["pagination"] as Map
        : json;
    return VisitListModel(
      visits: getVisitListFromJson(_visitsJson(json), tab: tab),
      pagination: PaginationData.fromJson({
        "total": paginationJson["total"] ?? json["total"] ?? 1,
        "current_page":
            paginationJson["current_page"] ?? json["current_page"] ?? 1,
        "last_page": paginationJson["last_page"] ?? json["last_page"] ?? 1,
      }),
    );
  }
}

dynamic _visitsJson(Map json) {
  if (json["visits"] is List) return json["visits"];
  if (json["data"] is List) return json["data"];
  if (json["data"] is Map) {
    final nested = json["data"] as Map;
    return nested["visits"] ?? nested["data"] ?? [];
  }
  return [];
}

List<VisitModel> getVisitListFromJson(dynamic json, {VisitTab tab = VisitTab.today}) {
  if (json is! List) return [];
  return List.from(
    json.whereType<Map>().map((e) => VisitModel.fromJson(e, tab: tab)),
  );
}
