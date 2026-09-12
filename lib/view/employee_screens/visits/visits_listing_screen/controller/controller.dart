import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/service.dart';

class VisitsController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxString searchQuery = ''.obs;
  final Rx<VisitTab> selectedTab = VisitTab.today.obs;
  final Rxn<VisitStatus> selectedStatus = Rxn();
  final Rxn<List<VisitModel>> visits = Rxn(null);

  int currentPage = 1;
  int lastPage = 1;
  int _fetchId = 0;
  final RxInt filterVersion = 0.obs;
  Timer? _searchDebounce;

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.extentAfter == 0 &&
          currentPage <= lastPage) {
        if (currentPage != lastPage) {
          currentPage++;
          getVisits();
        }
      }
    });
    super.onInit();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), applyFilters);
  }

  void onTabChanged(VisitTab tab) {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;
    applyFilters();
  }

  void applyFilters() {
    onRefresh();
  }

  void onAddVisit() {
    Get.toNamed(appRoutes.requestVisit)?.then((value) {
      if (value == true) onRefresh();
    });
  }

  void onViewVisit(VisitModel visit) {
    Get.toNamed(appRoutes.visitDetails, arguments: visit.id);
  }

  void onFilterTap() {
    customBottomSheet(
      title: 'Status',
      child: Column(
        children: [
          _statusOption(
            label: 'All',
            isSelected: selectedStatus.value == null,
            onTap: () {
              selectedStatus.value = null;
              Get.back();
              applyFilters();
            },
          ),
          ...VisitStatus.values.map((status) {
            return _statusOption(
              label: status.label,
              isSelected: selectedStatus.value == status,
              onTap: () {
                selectedStatus.value = status;
                Get.back();
                applyFilters();
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _statusOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius12),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: appSize.size8.h),
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size14.w,
          vertical: appSize.size14.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? appColors.submittedBadgeBg
              : appColors.scaffoldGreyColor,
          borderRadius: BorderRadius.circular(appSize.radius12),
          border: Border.all(
            color: isSelected
                ? appColors.brandColor.withValues(alpha: 0.35)
                : appColors.strokeColor,
          ),
        ),
        child: Text(
          label,
          style: fontStyles.font14Black600.copyWith(
            color: isSelected ? appColors.brandColor : appColors.blackColor,
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  Color statusBg(VisitStatus status) {
    switch (status) {
      case VisitStatus.approved:
        return appColors.activeBadgeBg;
      case VisitStatus.completed:
        return appColors.submittedBadgeBg;
      case VisitStatus.rejected:
        return appColors.rejectedBadgeBg;
      case VisitStatus.requested:
        return appColors.pendingBadgeBg;
    }
  }

  Color statusText(VisitStatus status) {
    switch (status) {
      case VisitStatus.approved:
        return appColors.activeBadgeText;
      case VisitStatus.completed:
        return appColors.submittedBadgeText;
      case VisitStatus.rejected:
        return appColors.rejectedBadgeText;
      case VisitStatus.requested:
        return appColors.pendingBadgeText;
    }
  }

  Future<void> onRefresh() async {
    currentPage = 1;
    lastPage = 1;
    visits.value = null;
    filterVersion.value++;
  }

  Future<List<VisitModel>> getVisits() async {
    final fetchId = ++_fetchId;
    return VisitsService.getVisits(
          page: currentPage,
          dateFilter: selectedTab.value,
          search: searchQuery.value,
          status: selectedStatus.value,
        )
        .then((value) {
          if (fetchId != _fetchId) return value.visits;
          currentPage = value.pagination.currentPage;
          lastPage = value.pagination.lastPage;
          if (visits.value == null) {
            visits.value = value.visits;
          } else {
            visits.value = [...visits.value!, ...value.visits];
          }
          return value.visits;
        })
        .onError((error, stackTrace) {
          if (fetchId != _fetchId) throw Exception("");
          if (visits.value == null) {
            visits.value = [];
          }
          throw Exception("");
        });
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(VisitsController());
  }
}
