import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';

class AssetsController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<AssetsTab> selectedTab = AssetsTab.assets.obs;

  final categories = const [
    'Laptop',
    'Mobile Devices',
    'Headphone',
    'Access Card',
    'Monitor',
  ];

  late final List<AssetModel> assets = [
    AssetModel(
      id: '1',
      name: 'Dell Latitude 5440',
      series: 'Latitude Series',
      assetId: 'AST-1024',
      category: 'Laptop',
      assignedDate: DateTime(2026, 8, 12),
      condition: 'Excellent',
      status: AssetStatus.active,
      icon: Icons.laptop_mac_rounded,
      history: const [
        AssetHistoryItem(
          title: 'Assigned',
          subtitle: '12 Aug 2026 — Condition: Excellent',
          isPrimary: true,
        ),
        AssetHistoryItem(
          title: 'Returned',
          subtitle: '05 Jan 2026 — Scheduled Handover',
        ),
        AssetHistoryItem(
          title: 'Previous Assigned',
          subtitle: '10 Sep 2025 — Condition: Good',
          isPrimary: true,
        ),
      ],
    ),
    AssetModel(
      id: '2',
      name: 'iPhone 15',
      series: 'Mobile Devices',
      assetId: 'AST-1031',
      category: 'Mobile Devices',
      assignedDate: DateTime(2026, 8, 5),
      condition: 'Good',
      status: AssetStatus.active,
      icon: Icons.smartphone_rounded,
      history: const [
        AssetHistoryItem(
          title: 'Assigned',
          subtitle: '05 Aug 2026 — Condition: Good',
          isPrimary: true,
        ),
      ],
    ),
    AssetModel(
      id: '3',
      name: 'Marshall Major IV Wireless Bluetooth',
      series: 'Headphone',
      assetId: 'AST-1042',
      category: 'Headphone',
      assignedDate: DateTime(2026, 8, 5),
      condition: 'Excellent',
      status: AssetStatus.underMaintenance,
      icon: Icons.headphones_rounded,
      history: const [
        AssetHistoryItem(
          title: 'Under Maintenance',
          subtitle: '05 Aug 2026 — Service requested',
        ),
        AssetHistoryItem(
          title: 'Assigned',
          subtitle: '01 Mar 2026 — Condition: Excellent',
          isPrimary: true,
        ),
      ],
    ),
  ];

  late final List<AssetRequestModel> requests = [
    AssetRequestModel(
      id: 'r1',
      type: AssetRequestType.newAsset,
      status: AssetRequestStatus.pending,
      requestedItem: 'Laptop',
      requestDate: DateTime(2026, 8, 12),
      ticketId: 'REQ-3889',
    ),
    AssetRequestModel(
      id: 'r2',
      type: AssetRequestType.replacement,
      status: AssetRequestStatus.approved,
      requestedItem: 'Mobile Phone',
      requestDate: DateTime(2026, 8, 5),
      ticketId: 'REQ-3889',
    ),
    AssetRequestModel(
      id: 'r3',
      type: AssetRequestType.repairMaintenance,
      status: AssetRequestStatus.completed,
      requestedItem: 'Laptop',
      requestDate: DateTime(2026, 8, 5),
      ticketId: 'REQ-3889',
    ),
    AssetRequestModel(
      id: 'r4',
      type: AssetRequestType.reportLostDamaged,
      status: AssetRequestStatus.rejected,
      requestedItem: 'Access Card',
      requestDate: DateTime(2026, 8, 1),
      ticketId: 'REQ-3889',
    ),
  ];

  List<AssetModel> get filteredAssets {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return assets;
    return assets
        .where(
          (asset) =>
              asset.name.toLowerCase().contains(query) ||
              asset.assetId.toLowerCase().contains(query) ||
              asset.category.toLowerCase().contains(query) ||
              asset.series.toLowerCase().contains(query),
        )
        .toList();
  }

  List<AssetRequestModel> get filteredRequests {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return requests;
    return requests
        .where(
          (request) =>
              request.type.label.toLowerCase().contains(query) ||
              request.requestedItem.toLowerCase().contains(query) ||
              request.ticketId.toLowerCase().contains(query),
        )
        .toList();
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void onTabChanged(AssetsTab tab) {
    selectedTab.value = tab;
    searchController.clear();
    searchQuery.value = '';
  }

  void onFilterTap() {
    notificationHandler.sendNotification(
      message: 'Asset filters coming soon',
      notificationType: .warning,
    );
  }

  void onAddRequest() => Get.toNamed(appRoutes.createAssetRequest);

  void onViewAsset(AssetModel asset) {
    Get.toNamed(appRoutes.assetDetails, arguments: asset);
  }

  void onViewRequest(AssetRequestModel request) {
    notificationHandler.sendNotification(
      message: '${request.type.label} details coming soon',
      notificationType: .warning,
    );
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  Color assetStatusBg(AssetStatus status) {
    switch (status) {
      case AssetStatus.active:
        return appColors.activeBadgeBg;
      case AssetStatus.returnItem:
        return appColors.scaffoldGreyColor;
      case AssetStatus.underMaintenance:
        return appColors.expiringBadgeBg;
    }
  }

  Color assetStatusText(AssetStatus status) {
    switch (status) {
      case AssetStatus.active:
        return appColors.activeBadgeText;
      case AssetStatus.returnItem:
        return appColors.mediumGreyColor;
      case AssetStatus.underMaintenance:
        return appColors.expiringBadgeText;
    }
  }

  Color requestStatusBg(AssetRequestStatus status) {
    switch (status) {
      case AssetRequestStatus.pending:
        return appColors.pendingBadgeBg;
      case AssetRequestStatus.approved:
        return appColors.activeBadgeBg;
      case AssetRequestStatus.completed:
        return appColors.submittedBadgeBg;
      case AssetRequestStatus.rejected:
        return appColors.rejectedBadgeBg;
    }
  }

  Color requestStatusText(AssetRequestStatus status) {
    switch (status) {
      case AssetRequestStatus.pending:
        return appColors.pendingBadgeText;
      case AssetRequestStatus.approved:
        return appColors.activeBadgeText;
      case AssetRequestStatus.completed:
        return appColors.submittedBadgeText;
      case AssetRequestStatus.rejected:
        return appColors.rejectedBadgeText;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(AssetsController());
  }
}
