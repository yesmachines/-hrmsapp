import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/view/widgets/visit_card.dart';

class VisitsView extends GetView<VisitsController> {
  const VisitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Visits"),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onAddVisit,
        backgroundColor: appColors.brandColor,
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: appColors.whiteColor,
          size: appSize.icon26,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                appSize.size16.w,
                appSize.size8.h,
                appSize.size16.w,
                appSize.size12.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                      hintText: 'Search Visits...',
                      maxLines: 1,
                      radius: appSize.radius12,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: appSize.size14.h,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.whiteColor,
                        borderRadius: BorderRadius.circular(appSize.radius12),
                        border: Border.all(color: appColors.strokeColor),
                      ),
                      prefix: Icon(
                        Icons.search_rounded,
                        color: appColors.lightGreyColor,
                        size: appSize.icon20,
                      ),
                    ),
                  ),
                  SizedBox(width: appSize.size10.w),
                  InkWell(
                    onTap: controller.onFilterTap,
                    borderRadius: BorderRadius.circular(appSize.radius12),
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: appColors.whiteColor,
                        borderRadius: BorderRadius.circular(appSize.radius12),
                        border: Border.all(color: appColors.strokeColor),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: appColors.blackColor,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: appSize.size16.w),
              child: Obx(() {
                final selected = controller.selectedTab.value;
                return Container(
                  padding: EdgeInsets.all(appSize.size4.w),
                  decoration: BoxDecoration(
                    color: appColors.whiteColor,
                    borderRadius: BorderRadius.circular(appSize.radius60),
                    border: Border.all(color: appColors.strokeColor),
                  ),
                  child: Row(
                    children: VisitTab.values.map((tab) {
                      final isSelected = selected == tab;
                      return Expanded(
                        child: InkWell(
                          onTap: () => controller.onTabChanged(tab),
                          borderRadius: BorderRadius.circular(appSize.radius60),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: appSize.size10.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? appColors.brandColor
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(appSize.radius60),
                            ),
                            child: Text(
                              tab.name[0].toUpperCase() + tab.name.substring(1),
                              textAlign: TextAlign.center,
                              style: fontStyles.font12LightGrey500.copyWith(
                                color: isSelected
                                    ? appColors.whiteColor
                                    : appColors.mediumGreyColor,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ),
            SizedBox(height: appSize.size12.h),
            Expanded(
              child: Obx(() {
                final visits = controller.filteredVisits;
                if (visits.isEmpty) return const NoDataPage();
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    appSize.size16.w,
                    0,
                    appSize.size16.w,
                    90.h,
                  ),
                  itemCount: visits.length,
                  itemBuilder: (context, index) {
                    return VisitCard(visit: visits[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
