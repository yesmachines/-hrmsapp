import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/shimmers/custom_shimmer.dart';

class EventLoadingWidget extends StatelessWidget {
  const EventLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        appSize.size16.w,
        0,
        appSize.size16.w,
        appSize.size24.h,
      ),
      itemCount: 4,
      separatorBuilder: (_, _) => SizedBox(height: appSize.size12.h),
      itemBuilder: (context, index) {
        return ShimmerEffect.rectangle(
          width: double.infinity,
          height: 148.h,
        );
      },
    );
  }
}
