import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';

import '../../../../main.dart';
import '../../profile/view/widgets/profile_loading_widget.dart';
import '../controller/controller.dart';
import 'widget/check_in_out_row.dart';
import 'widget/home_screen_header.dart';
import 'widget/home_screen_tile.dart';
import 'widget/recognition_board.dart';
import 'widget/travel_card.dart';

class EmployeeHomeScreenView extends GetView<HomeScreenController> {
  const EmployeeHomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            appSize.size16.w,
            appSize.size16.h,
            appSize.size16.w,
            160.h,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Obx(
                () => FutureBuilder(
                  future: controller.profileData.value == null
                      ? controller.getProfile()
                      : null,
                  builder: (context, snapshot) {
                    if (controller.profileData.value == null &&
                        !controller.hasError.value) {
                      return const ProfileLoadingWidget();
                    } else if (controller.profileData.value != null) {
                      return HomeScreenHeader(
                        profile: controller.profileData.value!,);
                    } else {
                      return NoDataPage();
                    }
                  }
                ),
              ),
              SizedBox(height: appSize.size20.h),
              const TravelCard(),
              SizedBox(height: appSize.size16.h),
              const RecognitionBoard(),
              SizedBox(height: appSize.size16.h),
              const CheckInOutRow(),
              SizedBox(height: appSize.size16.h),
              LayoutBuilder(
                builder: (context, constraints) {
                  final spacing = appSize.size12.w;
                  final tileWidth = (constraints.maxWidth - spacing) / 2;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: controller.tiles
                        .map(
                          (tile) => IntrinsicHeight(
                            child: SizedBox(
                              width: tileWidth,
                              child: HomeScreenTile(
                                data: tile,
                                onTap: () => controller.onTileTap(tile),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
