import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/news/news_listing_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/news/news_listing_screen/service/model/news_model.dart';

class NewsCard extends GetView<NewsController> {
  const NewsCard({super.key, required this.news});

  final NewsModel news;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: appSize.size12.h),
      child: InkWell(
        onTap: () => controller.onViewNews(news),
        borderRadius: BorderRadius.circular(appSize.radius16),
        child: Container(
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
              if (news.isPinned) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appSize.size8.w,
                    vertical: appSize.size4.h,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.brandColor,
                    borderRadius: BorderRadius.circular(appSize.radius8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.push_pin_rounded,
                        size: 12.sp,
                        color: appColors.whiteColor,
                      ),
                      SizedBox(width: appSize.size4.w),
                      Text(
                        'PINNED',
                        style: fontStyles.font10LightGrey500.copyWith(
                          color: appColors.whiteColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: appSize.size10.h),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(news.title, style: fontStyles.font16Black700),
                  ),
                  SizedBox(width: appSize.size8.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: appColors.lightGreyColor,
                    size: 22.sp,
                  ),
                ],
              ),
              SizedBox(height: appSize.size8.h),
              Text(
                news.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: fontStyles.font12LightGrey500.copyWith(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              SizedBox(height: appSize.size14.h),
              Row(
                children: [
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
                  const Spacer(),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 12.sp,
                    color: appColors.lightGreyColor,
                  ),
                  SizedBox(width: appSize.size6.w),
                  Text(
                    controller.formatDate(news.date),
                    style: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
