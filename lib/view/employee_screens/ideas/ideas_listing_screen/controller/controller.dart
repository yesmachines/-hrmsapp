import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

import '../service/model/idea_data_model.dart';
import '../service/model/idea_status_enum.dart';
import '../service/service.dart';
import '../view/widgets/idea_details_bottom_sheet.dart';

class IdeasController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final Rxn<List<IdeaItem>> ideas = Rxn(null);

  ScrollController scrollController = ScrollController();

  int currentPage = 1;
  int lastPage = 1;

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.extentAfter == 0 &&
          currentPage <= lastPage) {
        if (currentPage != lastPage) {
          currentPage++;
          getIdeas();
        }
      }
    });
    super.onInit();
  }

  String statusLabel(IdeaStatus status) {
    switch (status) {
      case IdeaStatus.approved:
        return 'Approved';
      case IdeaStatus.submitted:
        return 'Submitted';
      case IdeaStatus.accepted:
        return 'Accepted';
      case IdeaStatus.rejected:
        return 'Rejected';
    }
  }

  Color statusBg(IdeaStatus status) {
    switch (status) {
      case IdeaStatus.approved:
        return appColors.activeBadgeBg;
      case IdeaStatus.submitted:
        return appColors.submittedBadgeBg;
      case IdeaStatus.accepted:
        return appColors.acceptedBadgeBg;
      case IdeaStatus.rejected:
        return appColors.rejectedBadgeBg;
    }
  }

  Color statusText(IdeaStatus status) {
    switch (status) {
      case IdeaStatus.approved:
        return appColors.activeBadgeText;
      case IdeaStatus.submitted:
        return appColors.submittedBadgeText;
      case IdeaStatus.accepted:
        return appColors.acceptedBadgeText;
      case IdeaStatus.rejected:
        return appColors.rejectedBadgeText;
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onAddIdea() {
    Get.toNamed(appRoutes.createIdeaScreen)?.then((value) {
      if (value == true) {
        onRefresh();
      }
    });
  }

  void onViewDetails(IdeaItem idea) {
    showIdeaDetailsBottomSheet(idea: idea);
  }

  void onAcknowledgeReview() {
    Get.back();
  }

  Future<void> onRefresh() async {
    ideas.value = null;
    currentPage = 1;
    lastPage = 1;
  }

  Future<List<IdeaItem>> getIdeas() async {
    return IdeasService.getIdeas(page: currentPage)
        .then((value) {
          currentPage = value.paginationData.currentPage;
          lastPage = value.paginationData.lastPage;
          if (ideas.value == null) {
            ideas.value = value.ideas;
          } else {
            ideas.value = ideas.value! + value.ideas;
          }
          return value.ideas;
        })
        .onError((error, stackTrace) {
          if (ideas.value == null) {
            ideas.value = [];
          }
          throw Exception("");
        });
  }

  @override
  void dependencies() {
    Get.put(IdeasController());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
