import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../main.dart';
import '../../../../../utils/shimmers/custom_shimmer.dart';

class DocumentLoadingWidget extends StatelessWidget {
  const DocumentLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return
      ListView.separated(
        padding: EdgeInsets.fromLTRB(
          appSize.size16.w,
          0,
          appSize.size16.w,
          appSize.size90.h,
        ),
        itemCount: 5,
        separatorBuilder: (_, _) =>
            SizedBox(height: appSize.size12.h),
        itemBuilder: (context, index) {
          return ShimmerEffect.rectangle(
            width: double.infinity,
            height: 148.h,
            // radius: appSize.radius16,
          );
        },
      );
  }
}
