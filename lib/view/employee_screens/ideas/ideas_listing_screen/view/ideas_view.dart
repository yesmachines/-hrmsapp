import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';

import '../controller/controller.dart';
import '../service/model/idea_data_model.dart';
import 'widgets/idea_card.dart';

class IdeasView extends GetView<IdeasController> {
  const IdeasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(title: "Ideas"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: appSize.size16.w),
              child: CustomTextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                hintText: 'Search.....',
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
            SizedBox(height: appSize.size12.h),
            Expanded(
              child: Obx(() {
                print("the obx rebuild${controller.ideas.value}");
                return FutureBuilder(
                  future: controller.ideas.value == null
                      ? controller.getIdeas()
                      : null,
                  builder: (context, snapshot) {
                    if (controller.ideas.value == null) {
                      return LoadingScreen();
                    } else if (controller.ideas.value!.isNotEmpty) {
                      return RefreshIndicator(
                        onRefresh: controller.onRefresh,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: appSize.size16.w,
                            vertical: appSize.size12.w,
                          ),
                          itemCount: controller.ideas.value?.length,
                          itemBuilder: (context, index) {
                            return IdeaCard(
                              idea: controller.ideas.value![index],
                            );
                          },
                        ),
                      );
                    } else {
                      return NoDataPage();
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onAddIdea,
        backgroundColor: appColors.brandColor,
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: appColors.whiteColor,
          size: appSize.icon26,
        ),
      ),
    );
  }
}
