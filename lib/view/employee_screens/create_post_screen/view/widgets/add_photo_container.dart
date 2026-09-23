import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

class AddPhotoContainer extends StatelessWidget {
  const AddPhotoContainer({super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 220.h,
        decoration: BoxDecoration(
          color: appColors.whiteColor,
          borderRadius: BorderRadius.circular(appSize.size12.r),
          border: Border.all(
            color: Color(0xFFE4E7EC),
          ),
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32.sp,
              color: appColors.brandColor,
            ),

            SizedBox(height: appSize.size6.h),

            Text(
              'Add Photo',
              style: fontStyles.font12White400.copyWith(color: appColors.brandColor)
            ),
          ],
        ),
      ),
    );
  }
}
