import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';

import '../../controller/controller.dart';
import '../../service/model/idea_data_model.dart';

Future<dynamic> showIdeaDetailsBottomSheet({required IdeaItem idea}) {
  final controller = Get.find<IdeasController>();
  return Get.bottomSheet(
    Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: 0.88.sh),
      padding: EdgeInsets.fromLTRB(
        appSize.size16.w,
        appSize.size10.h,
        appSize.size16.w,
        appSize.size16.h,
      ),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(appSize.radius24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: appSize.size40.w,
              height: appSize.size4.h,
              decoration: BoxDecoration(
                color: appColors.strokeColor,
                borderRadius: BorderRadius.circular(appSize.radius60),
              ),
            ),
            SizedBox(height: appSize.size14.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: appSize.size10.w,
                            vertical: appSize.size4.h,
                          ),
                          decoration: BoxDecoration(
                            color: controller.statusBg(idea.status),
                            borderRadius: BorderRadius.circular(
                              appSize.radius8,
                            ),
                          ),
                          child: Text(
                            controller.statusLabel(idea.status),
                            style: fontStyles.font10LightGrey500.copyWith(
                              color: controller.statusText(idea.status),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: Get.back,
                          borderRadius: BorderRadius.circular(appSize.radius60),
                          child: ImageHandler(
                            imageType: ImageType.svg,
                            imageUrl: iconData.closeRoundedSvg,
                            width: appSize.icon24,
                            height: appSize.icon24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: appSize.size12.h),
                    Text(idea.title, style: fontStyles.font20Black700Fixed),
                    SizedBox(height: appSize.size6.h),
                    Text(
                      'Submitted on ${idea.date}',
                      style: fontStyles.font14LightGrey400,
                    ),
                    SizedBox(height: appSize.size14.h),
                    Divider(
                      height: 1,
                      color: appColors.strokeColor.withValues(alpha: 0.7),
                    ),
                    SizedBox(height: appSize.size16.h),
                    Text(
                      'PROPOSAL DETAILS',
                      style: fontStyles.font10LightGrey500,
                    ),
                    SizedBox(height: appSize.size8.h),
                    Text(
                      idea.description,
                      style: fontStyles.font14LightGrey400.copyWith(
                        color: appColors.mediumGreyColor,
                        height: 1.45,
                      ),
                    ),
                    SizedBox(height: appSize.size16.h),
                    if(idea.ideaFiles.isNotEmpty)Text(
                      'ATTACHED REFERENCE PHOTOS',
                      style: fontStyles.font10LightGrey500,
                    ),
                    if(idea.ideaFiles.isNotEmpty)SizedBox(height: appSize.size10.h),
                    if(idea.ideaFiles.isNotEmpty)GridView.builder(
                      itemCount: idea.ideaFiles.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(appSize.radius12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: appColors.blackColor.withValues(
                                  alpha: 0.04,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 12),
                              ),
                              BoxShadow(
                                color: appColors.blackColor.withValues(
                                  alpha: 0.04,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, -6),
                              ),
                            ],
                            border: Border.all(
                              color: appColors.brandColor.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: ImageHandler(
                            height: appSize.size90.h,
                            width: double.infinity,
                            radius: appSize.radius12,
                            imageType: .network,
                            imageUrl: idea.ideaFiles[index],
                          ),
                        );
                      },
                    ),
                    if(idea.ideaFiles.isNotEmpty)SizedBox(height: appSize.size16.h),
                    Divider(
                      height: 1,
                      color: appColors.strokeColor.withValues(alpha: 0.7),
                    ),
                    SizedBox(height: appSize.size16.h),
                    if (idea.reviewer != null)
                      Text(
                        'REVIEW COMMENT',
                        style: fontStyles.font10LightGrey500,
                      ),
                    if (idea.reviewer != null)
                      SizedBox(height: appSize.size10.h),
                    if (idea.reviewer != null)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(appSize.size12.w),
                        decoration: BoxDecoration(
                          color: appColors.scaffoldGreyColor,
                          borderRadius: BorderRadius.circular(appSize.radius12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: appSize.size18.r,
                                  backgroundColor: appColors.profileIconBlueBg,
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: appColors.brandColor,
                                    size: appSize.icon18,
                                  ),
                                ),
                                SizedBox(width: appSize.size10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        idea.reviewer!.reviewerName,
                                        style: fontStyles.font14Black600,
                                      ),
                                      SizedBox(height: appSize.size2.h),
                                      Text(
                                        '${idea.reviewer?.reviewerRole} · ${idea.reviewer?.reviewDate}',
                                        style: fontStyles.font12LightGrey500
                                            .copyWith(
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: appSize.size10.h),
                            Text(
                              idea.reviewer!.reviewComment,
                              style: fontStyles.font14LightGrey400.copyWith(
                                color: appColors.mediumGreyColor,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (idea.reviewer != null)
                      SizedBox(height: appSize.size20.h),
                  ],
                ),
              ),
            ),
            CustomButton(
              buttonName: 'Acknowledge Review',
              onPressed: controller.onAcknowledgeReview,
              buttonWidth: double.infinity,
              radius: appSize.radius12,
              padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: appColors.blackColor.withValues(alpha: 0.45),
  );
}
