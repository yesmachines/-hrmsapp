import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';

class UploadDocumentOption {
  const UploadDocumentOption({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;
}

Future<dynamic> showUploadDocumentBottomSheet({
  void Function(UploadDocumentOption option)? onOptionTap,
}) {
  const options = [
    UploadDocumentOption(title: 'Passport', icon: Icons.menu_book_outlined),
    UploadDocumentOption(title: 'Emirates ID', icon: Icons.badge_outlined),
    UploadDocumentOption(
      title: 'Visa',
      icon: Icons.airplane_ticket_outlined,
    ),
    UploadDocumentOption(
      title: 'Insurance',
      icon: Icons.health_and_safety_outlined,
    ),
    UploadDocumentOption(
      title: 'Driving Licence',
      icon: Icons.directions_car_outlined,
    ),
  ];

  return customBottomSheet(
    title: 'Upload New Document',
    subTitle: 'Select the type of document you want to upload.',
    child: Column(
      children: options
          .map(
            (option) => Padding(
              padding: EdgeInsets.only(bottom: appSize.size10.h),
              child: _UploadDocumentTile(
                option: option,
                onTap: () {
                  Get.back();
                  onOptionTap?.call(option);
                },
              ),
            ),
          )
          .toList(),
    ),
  );
}

class _UploadDocumentTile extends StatelessWidget {
  const _UploadDocumentTile({
    required this.option,
    required this.onTap,
  });

  final UploadDocumentOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size12.w,
          vertical: appSize.size12.h,
        ),
        decoration: BoxDecoration(
          color: appColors.scaffoldGreyColor,
          borderRadius: BorderRadius.circular(appSize.radius12),
        ),
        child: Row(
          children: [
            Container(
              width: appSize.size40.w,
              height: appSize.size40.w,
              decoration: BoxDecoration(
                color: appColors.profileIconBlueBg,
                borderRadius: BorderRadius.circular(appSize.radius8),
              ),
              child: Icon(
                option.icon,
                color: appColors.brandColor,
                size: appSize.icon20,
              ),
            ),
            SizedBox(width: appSize.size12.w),
            Expanded(
              child: Text(option.title, style: fontStyles.font14Black600),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: appColors.lightGreyColor,
              size: appSize.icon24,
            ),
          ],
        ),
      ),
    );
  }
}
