import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/view/employee_screens/social_screen/view/widgets/social_post_card.dart';

import '../../../../../main.dart';
import '../../../../utils/image_handler/image_handler.dart';
import '../controller/controller.dart';

class SocialsScreen extends GetView<SocialsController> {
  const SocialsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      appColors.scaffoldGreyColor,

      body: SafeArea(
        child: Column(
          children: [
            _SocialAppBar(),

            Expanded(
              child: Obx(
                    () {
                  if (controller.isLoading.value) {
                    return Center(
                      child:
                      CircularProgressIndicator(
                        color:
                        appColors.brandColor,
                      ),
                    );
                  }

                  if (controller.posts.isEmpty) {
                    return _EmptyPosts();
                  }

                  return RefreshIndicator(
                    color:
                    appColors.brandColor,
                    onRefresh:
                    controller.getSocialPosts,
                    child: ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: 10.h,
                        bottom: 20.h,
                      ),
                      itemCount:
                      controller.posts.length,
                      separatorBuilder:
                          (_, _) {
                        return Container(
                          height: 8.h,
                          color: appColors
                              .scaffoldGreyColor,
                        );
                      },
                      itemBuilder:
                          (context, index) {
                        final post =
                        controller.posts[index];

                        return SocialPostCard(
                          post: post,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialAppBar extends GetView<SocialsController> {
  const _SocialAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        appSize.size8.w,
        appSize.size8.h,
        appSize.size16.w,
        appSize.size8.h,
      ),
      color: appColors.scaffoldGreyColor,
      child: Row(
        children: [
          InkWell(
            onTap: Get.back,
            borderRadius: BorderRadius.circular(appSize.radius60),
            child: SizedBox(
              width: appSize.size44.w,
              height: appSize.size44.w,
              child: Center(
                child: ImageHandler(
                  imageType: ImageType.svg,
                  imageUrl: iconData.arrowLeftIconSvg,
                  width: appSize.icon20,
                  height: appSize.icon20,
                  svgImageColor: appColors.blackColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Socials',
              style: fontStyles.font20Black700Fixed,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(),
          InkWell(
            onTap: controller.onTapCreatePost,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size12.w,
                vertical: appSize.size6.h
              ),
              decoration: BoxDecoration(
                border: BoxBorder.all(
                  color: appColors.brandColor
                ),
                borderRadius: BorderRadius.circular(appSize.radius6.r)
              ),
              child: Row(
                children: [
                  Icon(Icons.add,color: appColors.brandColor,size: 12,),
                  SizedBox(width: appSize.size6.w,),
                  Text("Create Post",style: fontStyles.font12Brand600,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}


class _EmptyPosts extends StatelessWidget {
  const _EmptyPosts();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 45.sp,
            color:
            appColors.brandColor,
          ),

          SizedBox(height: 10.h),

          Text(
            'No posts yet',
            style: fontStyles
                .font14Black600
                .copyWith(
              color:
              appColors.brandColor,
            ),
          ),
        ],
      ),
    );
  }
}