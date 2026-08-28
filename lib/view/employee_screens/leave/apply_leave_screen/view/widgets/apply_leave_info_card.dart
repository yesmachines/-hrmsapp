import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

class ApplyLeaveInfoCard extends StatelessWidget {
  const ApplyLeaveInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
    required this.background,
    required this.children,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final Color background;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(appSize.radius16),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(appSize.radius16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(appSize.size14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: accent, size: 18.sp),
                        SizedBox(width: appSize.size8.w),
                        Text(
                          title,
                          style: fontStyles.font14Black600.copyWith(
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: appSize.size10.h),
                    ...children,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApplyLeaveBullet extends StatelessWidget {
  const ApplyLeaveBullet({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: appSize.size6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
          SizedBox(width: appSize.size8.w),
          Expanded(
            child: Text(
              text,
              style: fontStyles.font12LightGrey500.copyWith(
                color: appColors.mediumGreyColor,
                letterSpacing: 0,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
