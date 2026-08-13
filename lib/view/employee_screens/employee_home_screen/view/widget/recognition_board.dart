import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

class RecognitionBoard extends StatelessWidget {
  const RecognitionBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(appSize.radius20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColors.recognitionPurple,
            appColors.recognitionPurpleDark,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🏆', style: TextStyle(fontSize: appSize.font20)),
              SizedBox(width: appSize.size8.w),
              Text('Recognition Board', style: fontStyles.font16White600),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          Text('Past Week Top Runners', style: fontStyles.font12White500),
          SizedBox(height: appSize.size12.h),
          Row(
            children: [
              Expanded(
                child: _RunnerChip(
                  label: 'Sales: Shibbu Philip',
                  badge: '150%',
                ),
              ),
              SizedBox(width: appSize.size10.w),
              Expanded(
                child: _RunnerChip(
                  label: 'Service: Arjun',
                  badge: '98%',
                ),
              ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          Row(
            children: [
              Expanded(
                child: _AwardCard(
                  title: 'Star of the Quarter',
                  name: 'Kanth',
                  action: 'View',
                ),
              ),
              SizedBox(width: appSize.size10.w),
              Expanded(
                child: _AwardCard(
                  title: 'Extra Mile Award',
                  name: 'Indhu',
                  action: 'View more',
                  showAvatars: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RunnerChip extends StatelessWidget {
  const _RunnerChip({required this.label, required this.badge});

  final String label;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(appSize.size10.w),
      decoration: BoxDecoration(
        color: appColors.whiteColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(appSize.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: fontStyles.font10White400,
          ),
          SizedBox(height: appSize.size6.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: appSize.size8.w,
              vertical: appSize.size2.h,
            ),
            decoration: BoxDecoration(
              color: appColors.brandColor,
              borderRadius: BorderRadius.circular(appSize.radius8),
            ),
            child: Text(badge, style: fontStyles.font10White400),
          ),
        ],
      ),
    );
  }
}

class _AwardCard extends StatelessWidget {
  const _AwardCard({
    required this.title,
    required this.name,
    required this.action,
    this.showAvatars = false,
  });

  final String title;
  final String name;
  final String action;
  final bool showAvatars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(appSize.size12.w),
      decoration: BoxDecoration(
        color: appColors.blackColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(appSize.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.emoji_events_outlined,
              color: appColors.whiteColor, size: appSize.icon20),
          SizedBox(height: appSize.size8.h),
          Text(title, style: fontStyles.font12White500),
          SizedBox(height: appSize.size4.h),
          Text(name, style: fontStyles.font10White400),
          SizedBox(height: appSize.size8.h),
          if (showAvatars)
            Row(
              children: [
                _AvatarDot(),
                Transform.translate(
                  offset: Offset(-6.w, 0),
                  child: _AvatarDot(color: appColors.lightBrandColor),
                ),
                const Spacer(),
                Text(action, style: fontStyles.font10White400),
              ],
            )
          else
            Align(
              alignment: Alignment.centerRight,
              child: Text(action, style: fontStyles.font10White400),
            ),
        ],
      ),
    );
  }
}

class _AvatarDot extends StatelessWidget {
  const _AvatarDot({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: appSize.size20.w,
      height: appSize.size20.w,
      decoration: BoxDecoration(
        color: color ?? appColors.whiteColor.withValues(alpha: 0.7),
        shape: BoxShape.circle,
        border: Border.all(color: appColors.whiteColor, width: 1),
      ),
    );
  }
}
