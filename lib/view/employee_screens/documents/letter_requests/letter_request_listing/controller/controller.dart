import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

import '../service/model/letter_request_model.dart';
import '../service/service.dart';

class LetterRequestsController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rxn<List<LetterRequestModel>> requests = Rxn(null);
  final RxnBool hasError = RxnBool(false);

  Future<List<LetterRequestModel>> getLetterRequests() async {
    hasError.value = false;
    return LetterRequestService.getLetterRequests()
        .then((value) {
          requests.value = value;
          return value;
        })
        .onError((error, stackTrace) {
          hasError.value = true;
          notificationHandler.apiErrorNotificationHandler(error: error);
          throw Exception();
        });
  }

  List<LetterRequestModel> get filteredRequests {
    final items = requests.value ?? [];
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items
        .where(
          (item) =>
              item.displayTitle.toLowerCase().contains(query) ||
              item.purpose.toLowerCase().contains(query) ||
              item.displayStatus.toLowerCase().contains(query),
        )
        .toList();
  }

  Color statusBg(LetterRequestModel request) {
    switch (request.statusColor) {
      case 'green':
        return appColors.activeBadgeBg;
      case 'red':
        return appColors.rejectedBadgeBg;
      case 'blue':
        return appColors.submittedBadgeBg;
      case 'orange':
        return appColors.pendingBadgeBg;
      default:
        switch (request.status.toLowerCase()) {
          case 'approved':
            return appColors.activeBadgeBg;
          case 'rejected':
            return appColors.rejectedBadgeBg;
          default:
            return appColors.pendingBadgeBg;
        }
    }
  }

  Color statusText(LetterRequestModel request) {
    switch (request.statusColor) {
      case 'green':
        return appColors.activeBadgeText;
      case 'red':
        return appColors.rejectedBadgeText;
      case 'blue':
        return appColors.submittedBadgeText;
      case 'orange':
        return appColors.pendingBadgeText;
      default:
        switch (request.status.toLowerCase()) {
          case 'approved':
            return appColors.activeBadgeText;
          case 'rejected':
            return appColors.rejectedBadgeText;
          default:
            return appColors.pendingBadgeText;
        }
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onAddRequest() {
    Get.toNamed(appRoutes.createLetterRequest)?.then((value) {
      if (value == true) {
        requests.value = null;
      }
    });
  }

  void onViewRequest(LetterRequestModel request) {
    Get.toNamed(appRoutes.letterRequestDetails, arguments: request.id);
  }

  @override
  void dependencies() {
    Get.put(LetterRequestsController());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
