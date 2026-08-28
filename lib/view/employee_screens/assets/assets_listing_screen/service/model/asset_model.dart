import 'package:flutter/material.dart';

enum AssetsTab { assets, requests }

enum AssetStatus { active, returnItem, underMaintenance }

enum AssetRequestType {
  newAsset,
  replacement,
  repairMaintenance,
  reportLostDamaged,
}

enum AssetRequestStatus { pending, approved, completed, rejected }

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
}

extension AssetRequestTypeX on AssetRequestType {
  String get label {
    switch (this) {
      case AssetRequestType.newAsset:
        return 'New Asset Request';
      case AssetRequestType.replacement:
        return 'Asset Replacement';
      case AssetRequestType.repairMaintenance:
        return 'Repair / Maintenance';
      case AssetRequestType.reportLostDamaged:
        return 'Report Lost / Damaged';
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
}

class AssetRequestModel {
  const AssetRequestModel({
    required this.id,
    required this.type,
    required this.status,
    required this.requestedItem,
    required this.requestDate,
    required this.ticketId,
  });

  final String id;
  final AssetRequestType type;
  final AssetRequestStatus status;
  final String requestedItem;
  final DateTime requestDate;
  final String ticketId;
}
