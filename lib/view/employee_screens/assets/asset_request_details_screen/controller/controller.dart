import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/assets/asset_request_details_screen/service/service.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';

class AssetRequestDetailsController extends GetxController with Bindings {
  final Rxn<AssetRequestModel> request = Rxn(null);
  final RxBool hasError = false.obs;
  late String requestId;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is AssetRequestModel) {
      requestId = args.id;
    } else {
      requestId = args?.toString() ?? '';
    }
    super.onInit();
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  String formatDateTime(DateTime date) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(date);

  Color statusText(AssetRequestStatus status) {
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

  List<Color> statusGradient(AssetRequestStatus status) {
    switch (status) {
      case AssetRequestStatus.pending:
        return [appColors.orangeColor, appColors.lightOrangeColor];
      case AssetRequestStatus.approved:
        return [appColors.profileIconGreen, appColors.checkOutGreen];
      case AssetRequestStatus.completed:
        return [appColors.brandColor, appColors.travelBlue];
      case AssetRequestStatus.rejected:
        return [appColors.expiredBadgeText, appColors.tileRed];
    }
  }

  IconData statusIcon(AssetRequestStatus status) {
    switch (status) {
      case AssetRequestStatus.pending:
        return Icons.hourglass_top_rounded;
      case AssetRequestStatus.approved:
      case AssetRequestStatus.completed:
        return Icons.check_rounded;
      case AssetRequestStatus.rejected:
        return Icons.close_rounded;
    }
  }

  Future<AssetRequestModel> getAssetRequest() async {
    hasError.value = false;
    return AssetRequestDetailsService.getAssetRequest(id: requestId)
        .then((value) {
          request.value = value;
          return value;
        })
        .onError((error, stackTrace) {
          if (request.value == null) {
            hasError.value = true;
          }
          throw Exception("");
        });
  }

  @override
  void dependencies() {
    Get.put(AssetRequestDetailsController());
  }
}
