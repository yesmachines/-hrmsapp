import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/news/news_listing_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/news/news_listing_screen/service/model/news_model.dart';
import 'package:yes_hrm/view/employee_screens/news/news_listing_screen/view/widgets/news_card.dart';
import 'package:yes_hrm/view/employee_screens/news/news_listing_screen/view/widgets/news_filter_button.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "News"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                appSize.size16.w,
                appSize.size8.h,
                appSize.size16.w,
                0,
              ),
              child: CustomTextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                hintText: 'Search News...',
                maxLines: 1,
                radius: appSize.radius60,
                contentPadding: EdgeInsets.symmetric(
                  vertical: appSize.size14.h,
                ),
                decoration: BoxDecoration(
                  color: appColors.whiteColor,
                  borderRadius: BorderRadius.circular(appSize.radius60),
                  border: Border.all(color: appColors.strokeColor),
                ),
                prefix: Icon(
                  Icons.search_rounded,
                  color: appColors.lightGreyColor,
                  size: appSize.icon20,
                ),
              ),
            ),
            SizedBox(height: appSize.size12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: appSize.size16.w),
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: NewsFilterButton(
                        label: controller.categoryLabel,
                        isActive: controller.selectedCategory.value != null,
                        onTap: _openCategorySheet,
                        onClear: controller.selectedCategory.value == null
                            ? null
                            : () => controller.onCategoryChanged(null),
                      ),
                    ),
                    SizedBox(width: appSize.size12.w),
                    Expanded(
                      child: NewsFilterButton(
                        label: controller.dateRangeLabel,
                        isActive: controller.selectedDateRange.value != null,
                        onTap: controller.pickDateRange,
                        onClear: controller.selectedDateRange.value == null
                            ? null
                            : controller.clearDateRange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                appSize.size16.w,
                appSize.size16.h,
                appSize.size16.w,
                appSize.size8.h,
              ),
              child: Text(
                'LATEST NEWS',
                style: fontStyles.font10LightGrey500.copyWith(
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final items = controller.filteredNews;
                if (items.isEmpty) return const NoDataPage();
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    appSize.size16.w,
                    0,
                    appSize.size16.w,
                    appSize.size24.h,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return NewsCard(news: items[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _openCategorySheet() {
    customBottomSheet(
      title: 'Category',
      child: Column(
        children: [
          _CategoryOption(
            label: 'All',
            isSelected: controller.selectedCategory.value == null,
            onTap: () {
              Get.back();
              controller.onCategoryChanged(null);
            },
          ),
          ...controller.categoryOptions.map(
            (category) => _CategoryOption(
              label: category.label,
              isSelected: controller.selectedCategory.value == category,
              onTap: () {
                Get.back();
                controller.onCategoryChanged(category);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryOption extends StatelessWidget {
  const _CategoryOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
}
