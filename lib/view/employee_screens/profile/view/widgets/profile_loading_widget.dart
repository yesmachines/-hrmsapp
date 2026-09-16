import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/shimmers/custom_shimmer.dart';

class ProfileLoadingWidget extends StatelessWidget {
  const ProfileLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerEffect.rectangle(
          width: double.infinity,
          height: 148.h,
          // radius: appSize.radius16,
        ),
      ],
    );
  }
}
