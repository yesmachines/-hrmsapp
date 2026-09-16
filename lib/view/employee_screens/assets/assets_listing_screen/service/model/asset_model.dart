import 'package:flutter/material.dart';

enum AssetsTab { assets, requests }

enum AssetStatus { active, returnItem, underMaintenance }

enum AssetRequestType { newAsset, repair }

enum AssetRequestStatus { pending, approved, completed, rejected }

enum AssetRequestPriority { normal, high }

extension AssetStatusX on AssetStatus {
  String get label {
    switch (this) {
      case AssetStatus.active:
        return 'ACTIVE';
      case AssetStatus.returnItem:
        return 'RETURN';
      case AssetStatus.underMaintenance:
        return 'UNDER MAINTENANCE';
    }
  }

  String get apiValue {
    switch (this) {
      case AssetStatus.active:
        return 'active';
      case AssetStatus.returnItem:
        return 'return';
      case AssetStatus.underMaintenance:
        return 'under_maintenance';
    }
  }

  static AssetStatus fromString(dynamic value) {
    switch (value?.toString().trim().toLowerCase().replaceAll(' ', '_')) {
      case 'return':
      case 'returned':
      case 'return_item':
        return AssetStatus.returnItem;
      case 'under_maintenance':
      case 'maintenance':
        return AssetStatus.underMaintenance;
      case 'active':
      default:
        return AssetStatus.active;
    }
  }
}

extension AssetRequestTypeX on AssetRequestType {
  String get label {
    switch (this) {
      case AssetRequestType.newAsset:
        return 'New Asset';
      case AssetRequestType.repair:
        return 'Repair';
    }
  }

  String get apiValue {
    switch (this) {
      case AssetRequestType.newAsset:
        return 'New';
      case AssetRequestType.repair:
        return 'Repair';
    }
  }

  static AssetRequestType fromString(dynamic value) {
    final raw = value?.toString().trim().toLowerCase() ?? '';
    if (raw.contains('repair') || raw.contains('maintenance')) {
      return AssetRequestType.repair;
    }
    return AssetRequestType.newAsset;
  }
}

extension AssetRequestPriorityX on AssetRequestPriority {
  String get label {
    switch (this) {
      case AssetRequestPriority.normal:
        return 'Normal';
      case AssetRequestPriority.high:
        return 'High';
    }
  }

  String get apiValue => label;

  static AssetRequestPriority fromString(dynamic value) {
    switch (value?.toString().trim().toLowerCase()) {
      case 'high':
        return AssetRequestPriority.high;
      case 'normal':
      default:
        return AssetRequestPriority.normal;
    }
  }
}

extension AssetRequestStatusX on AssetRequestStatus {
  String get label {
    switch (this) {
      case AssetRequestStatus.pending:
        return 'Pending';
      case AssetRequestStatus.approved:
        return 'Approved';
      case AssetRequestStatus.completed:
        return 'Completed';
      case AssetRequestStatus.rejected:
        return 'Rejected';
    }
  }

  String get apiValue => name;

  static AssetRequestStatus fromString(dynamic value) {
    switch (value?.toString().trim().toLowerCase()) {
      case 'approved':
        return AssetRequestStatus.approved;
      case 'completed':
        return AssetRequestStatus.completed;
      case 'rejected':
        return AssetRequestStatus.rejected;
      case 'pending':
      case 'requested':
      default:
        return AssetRequestStatus.pending;
    }
  }
}

class AssetHistoryItem {
  const AssetHistoryItem({
    required this.title,
    required this.subtitle,
    this.isPrimary = false,
  });

  final String title;
  final String subtitle;
  final bool isPrimary;

  factory AssetHistoryItem.fromJson(Map json) {
    return AssetHistoryItem(
      title: (json["title"] ?? json["status"] ?? json["action"] ?? "").toString(),
      subtitle: (json["subtitle"] ?? json["description"] ?? json["note"] ?? "")
          .toString(),
      isPrimary: json["is_primary"] == true || json["current"] == true,
    );
  }
}

class AssetModel {
  const AssetModel({
    required this.id,
    required this.name,
    required this.series,
    required this.assetId,
    required this.category,
    required this.assignedDate,
    required this.condition,
    required this.status,
    required this.icon,
    this.acknowledgmentName = 'Asset_Acknowledgment.pdf',
    this.acknowledgmentSize = '340 KB',
    this.history = const [],
  });

  final String id;
  final String name;
  final String series;
  final String assetId;
  final String category;
  final DateTime assignedDate;
  final String condition;
  final AssetStatus status;
  final IconData icon;
  final String acknowledgmentName;
  final String acknowledgmentSize;
  final List<AssetHistoryItem> history;

  factory AssetModel.fromJson(Map json) {
    final category = json["category"] is Map
        ? (json["category"]["category"] ??
                  json["category"]["name"] ??
                  json["category"]["title"] ??
                  "")
            .toString()
        : (json["category"] ?? json["asset_category"] ?? "").toString();
    final acknowledgment = json["acknowledgment"] ?? json["acknowledgement"];
    return AssetModel(
      id: (json["id"] ?? "").toString(),
      name: (json["name"] ??
              json["asset_name"] ??
              json["title"] ??
              json["asset_code"] ??
              json["code"] ??
              "")
          .toString(),
      series: (json["series"] ?? json["model"] ?? json["brand"] ?? "")
          .toString(),
      assetId: (json["asset_id"] ??
              json["asset_code"] ??
              json["code"] ??
              json["id"] ??
              "")
          .toString(),
      category: category,
      assignedDate:
          _tryParseDate(
            json["assigned_date"] ?? json["assigned_at"] ?? json["created_at"],
          ) ??
          DateTime.now(),
      condition: (json["condition"] ?? "").toString(),
      status: AssetStatusX.fromString(json["status"]),
      icon: _iconFor(category),
      acknowledgmentName: acknowledgment is Map
          ? (acknowledgment["name"] ?? acknowledgment["file_name"] ?? "")
                .toString()
          : (json["acknowledgment_name"] ?? "Asset_Acknowledgment.pdf")
                .toString(),
      acknowledgmentSize: acknowledgment is Map
          ? (acknowledgment["size"] ?? "").toString()
          : (json["acknowledgment_size"] ?? "").toString(),
      history: _historyFromJson(json["history"] ?? json["asset_history"]),
    );
  }
}

List<AssetHistoryItem> _historyFromJson(dynamic json) {
  if (json is! List) return const [];
  return List.from(
    json.whereType<Map>().map((e) => AssetHistoryItem.fromJson(e)),
  );
}

DateTime? _tryParseDate(dynamic value) {
  if (value == null || value.toString().trim().isEmpty) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

IconData _iconFor(String category) {
  final raw = category.toLowerCase();
  if (raw.contains('laptop') || raw.contains('computer')) {
    return Icons.laptop_mac_rounded;
  }
  if (raw.contains('mobile') || raw.contains('phone')) {
    return Icons.smartphone_rounded;
  }
  if (raw.contains('headphone') || raw.contains('headset')) {
    return Icons.headphones_rounded;
  }
  if (raw.contains('monitor') || raw.contains('display')) {
    return Icons.desktop_windows_rounded;
  }
  if (raw.contains('card') || raw.contains('access')) {
    return Icons.badge_outlined;
  }
  return Icons.devices_other_rounded;
}

class AssetCategoryModel {
  const AssetCategoryModel({required this.id, required this.name});

  final String id;
  final String name;

  int get numericId => int.tryParse(id) ?? 0;

  factory AssetCategoryModel.fromJson(Map json) {
    return AssetCategoryModel(
      id: (json["id"] ?? "").toString(),
      name: (json["name"] ?? json["title"] ?? json["category"] ?? "").toString(),
    );
  }
}

List<AssetCategoryModel> getAssetCategoriesFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json.whereType<Map>().map((e) => AssetCategoryModel.fromJson(e)),
  );
}

class AssetRequestModel {
  const AssetRequestModel({
    required this.id,
    required this.type,
    required this.status,
    required this.requestedItem,
    required this.requestDate,
    required this.ticketId,
    this.priority = AssetRequestPriority.normal,
    this.description = '',
    this.categoryId = '',
    this.assetId = '',
    this.assetName = '',
    this.requesterName = '',
    this.requesterDesignation = '',
    this.approverName = '',
    this.approvedAt,
    this.rejectionReason = '',
    this.adminNotes = '',
  });

  final String id;
  final AssetRequestType type;
  final AssetRequestStatus status;
  final String requestedItem;
  final DateTime requestDate;
  final String ticketId;
  final AssetRequestPriority priority;
  final String description;
  final String categoryId;
  final String assetId;
  final String assetName;
  final String requesterName;
  final String requesterDesignation;
  final String approverName;
  final DateTime? approvedAt;
  final String rejectionReason;
  final String adminNotes;

  factory AssetRequestModel.fromJson(Map json) {
    final categoryName = _nestedName(
      json["category"],
      keys: const ["category", "name", "title"],
    );
    final asset = json["asset"];
    final requester = json["requester"];
    final requesterUser = requester is Map ? requester["user"] : null;
    return AssetRequestModel(
      id: (json["id"] ?? "").toString(),
      type: AssetRequestTypeX.fromString(
        json["request_type"] ?? json["type"],
      ),
      status: AssetRequestStatusX.fromString(json["status"]),
      requestedItem: categoryName.isNotEmpty
          ? categoryName
          : (json["requested_item"] ?? json["item"] ?? "").toString(),
      requestDate:
          _tryParseDate(
            json["requested_date"] ??
                json["request_date"] ??
                json["created_at"] ??
                json["date"],
          ) ??
          DateTime.now(),
      ticketId: (json["request_no"] ??
              json["ticket_id"] ??
              json["code"] ??
              json["id"] ??
              "")
          .toString(),
      priority: AssetRequestPriorityX.fromString(json["priority"]),
      description: (json["description"] ?? "").toString(),
      categoryId: (json["category_id"] ??
              (json["category"] is Map ? json["category"]["id"] : "") ??
              "")
          .toString(),
      assetId: (json["asset_id"] ??
              (asset is Map ? asset["id"] : "") ??
              "")
          .toString(),
      assetName: _nestedName(
        asset,
        keys: const ["name", "asset_name", "title"],
      ),
      requesterName: _nestedName(
        requesterUser ?? requester,
        keys: const ["name"],
      ),
      requesterDesignation: requester is Map
          ? (requester["designation"] ?? "").toString()
          : "",
      approverName: _nestedName(json["approver"], keys: const ["name"]),
      approvedAt: _tryParseDate(json["approved_at"]),
      rejectionReason: (json["rejection_reason"] ?? "").toString(),
      adminNotes: (json["admin_notes"] ?? "").toString(),
    );
  }
}

String _nestedName(dynamic value, {required List<String> keys}) {
  if (value is! Map) {
    return value == null ? "" : value.toString();
  }
  for (final key in keys) {
    final field = value[key];
    if (field != null && field.toString().trim().isNotEmpty) {
      return field.toString();
    }
  }
  return "";
}
