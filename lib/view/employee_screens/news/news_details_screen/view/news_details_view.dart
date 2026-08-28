import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/view/employee_screens/news/news_details_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/news/news_listing_screen/service/model/news_model.dart';

class NewsDetailsView extends GetView<NewsDetailsController> {
  const NewsDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final news = controller.news;

    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "News Details"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            appSize.size16.w,
            appSize.size8.h,
            appSize.size16.w,
            appSize.size24.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TitleCard(news: news, dateLabel: controller.formatDate(news.date)),
              SizedBox(height: appSize.size12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(appSize.size16.w),
                decoration: BoxDecoration(
                  color: appColors.whiteColor,
                  borderRadius: BorderRadius.circular(appSize.radius16),
                  boxShadow: [
                    BoxShadow(
                      color: appColors.blackColor.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  news.body,
                  style: fontStyles.font12LightGrey500.copyWith(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
              if (news.actionItems.isNotEmpty) ...[
                SizedBox(height: appSize.size12.h),
                _ActionRequiredCard(items: news.actionItems),
              ],
              if (news.attachments.isNotEmpty) ...[
                SizedBox(height: appSize.size16.h),
                Text(
                  'ATTACHMENTS',
                  style: fontStyles.font10LightGrey500.copyWith(
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: appSize.size10.h),
                ...news.attachments.map(
                  (file) => _AttachmentCard(
                    file: file,
                    onView: () => controller.onViewAttachment(file),
                    onDownload: () => controller.onDownloadAttachment(file),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleCard extends StatelessWidget {
  const _TitleCard({required this.news, required this.dateLabel});

  final NewsModel news;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size16.w),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.circular(appSize.radius16),
        boxShadow: [
          BoxShadow(
            color: appColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (news.isPinned)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appSize.size8.w,
                    vertical: appSize.size4.h,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.profileIconBlueBg,
                    borderRadius: BorderRadius.circular(appSize.radius8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.push_pin_rounded,
                        size: 12.sp,
                        color: appColors.brandColor,
                      ),
                      SizedBox(width: appSize.size4.w),
                      Text(
                        'PINNED',
                        style: fontStyles.font10LightGrey500.copyWith(
                          color: appColors.brandColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size10.w,
                  vertical: appSize.size4.h,
                ),
                decoration: BoxDecoration(
                  color: news.category.bg,
                  borderRadius: BorderRadius.circular(appSize.radius8),
                ),
                child: Text(
                  news.category.label,
                  style: fontStyles.font10LightGrey500.copyWith(
                    color: news.category.text,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          Text(news.title, style: fontStyles.font20Black700Fixed),
          SizedBox(height: appSize.size12.h),
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 14.sp,
                color: appColors.brandColor,
              ),
              SizedBox(width: appSize.size6.w),
              Expanded(
                child: Text(
                  news.author,
                  style: fontStyles.font12LightGrey500.copyWith(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.calendar_today_outlined,
                size: 12.sp,
                color: appColors.lightGreyColor,
              ),
              SizedBox(width: appSize.size6.w),
              Text(
                dateLabel,
                style: fontStyles.font12LightGrey500.copyWith(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionRequiredCard extends StatelessWidget {
  const _ActionRequiredCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size16.w),
      decoration: BoxDecoration(
        color: appColors.profileIconGreenBg.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(appSize.radius16),
        border: Border.all(
          color: appColors.profileIconGreen.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18.sp,
                color: appColors.profileIconGreen,
              ),
              SizedBox(width: appSize.size8.w),
              Text(
                'Action Required',
                style: fontStyles.font14Black600.copyWith(
                  color: appColors.profileIconGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          ...List.generate(items.length, (index) {
            final item = items[index];
            final isLast = index == items.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : appSize.size8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16.sp,
                    color: appColors.profileIconGreen,
                  ),
                  SizedBox(width: appSize.size8.w),
                  Expanded(
                    child: Text(
                      item,
                      style: fontStyles.font12LightGrey500.copyWith(
                        color: appColors.blackColor,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({
    required this.file,
    required this.onView,
    required this.onDownload,
  });

  final NewsAttachment file;
  final VoidCallback onView;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: appSize.size12.h),
      padding: EdgeInsets.all(appSize.size14.w),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.circular(appSize.radius16),
        boxShadow: [
          BoxShadow(
            color: appColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: appColors.profileIconBlueBg,
                  borderRadius: BorderRadius.circular(appSize.radius12),
                ),
                child: Icon(
                  file.type.icon,
                  color: appColors.brandColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: appSize.size12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(file.name, style: fontStyles.font14Black600),
                    SizedBox(height: 2.h),
                    Text(
                      file.type.label,
                      style: fontStyles.font10LightGrey500.copyWith(
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonName: 'View',
                  onPressed: onView,
                  buttonColor: appColors.whiteColor,
                  borderColor: appColors.brandColor,
                  fontStyle: fontStyles.font14Brand700,
                ),
              ),
              SizedBox(width: appSize.size10.w),
              Expanded(
                child: CustomButton(buttonName: 'Download', onPressed: onDownload),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
