import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

class CheckInOutRow extends StatelessWidget {
  const CheckInOutRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            title: 'Check In',
            icon: Icons.login_rounded,
            color: appColors.checkInBlue,
          ),
        ),
        SizedBox(width: appSize.size12.w),
        Expanded(
          child: _ActionCard(
            title: 'Check Out',
            icon: Icons.logout_rounded,
            color: appColors.checkOutGreen,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: appSize.size16.w,
        vertical: appSize.size18.h,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(appSize.radius18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: appSize.size36.w,
            height: appSize.size36.w,
            decoration: BoxDecoration(
              color: appColors.whiteColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(appSize.radius12),
            ),
            child: Icon(icon, color: appColors.whiteColor, size: appSize.icon20),
          ),
          SizedBox(width: appSize.size12.w),
          Text(title, style: fontStyles.font14White600),
        ],
      ),
    );
  }
}
