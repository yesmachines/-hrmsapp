import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';

class EmployeeUploadDocOption {
  const EmployeeUploadDocOption({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;
}

Future<dynamic> showUploadEmployeeDocumentBottomSheet({
  void Function(EmployeeUploadDocOption option)? onOptionTap,
}) {
  const options = [
    EmployeeUploadDocOption(
      title: 'Offer Letter',
      icon: Icons.description_outlined,
    ),
    EmployeeUploadDocOption(
      title: 'Contract',
      icon: Icons.insert_chart_outlined,
    ),
    EmployeeUploadDocOption(
      title: 'Confirmation',
      icon: Icons.check_circle_outline,
    ),
    EmployeeUploadDocOption(
      title: 'Labour Card',
      icon: Icons.credit_card_outlined,
    ),
    EmployeeUploadDocOption(
      title: 'Apprasial',
      icon: Icons.show_chart_rounded,
    ),
    EmployeeUploadDocOption(
      title: 'Appreciation',
      icon: Icons.celebration_outlined,
    ),
    EmployeeUploadDocOption(
      title: 'Warning',
      icon: Icons.warning_amber_rounded,
    ),
    EmployeeUploadDocOption(
      title: 'Termination',
      icon: Icons.person_off_outlined,
    ),
    EmployeeUploadDocOption(
      title: 'Memmo',
      icon: Icons.title_rounded,
    ),
  ];

  return customBottomSheet(
    title: 'Upload New Document',
    subTitle: 'Select the type of document you want to upload',
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: appSize.size12.h,
        crossAxisSpacing: appSize.size12.w,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        return _UploadGridTile(
          option: option,
          onTap: () {
            Get.back();
            onOptionTap?.call(option);
          },
        );
      },
    ),
  );
}

class _UploadGridTile extends StatelessWidget {
  const _UploadGridTile({
    required this.option,
    required this.onTap,
  });

  final EmployeeUploadDocOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: appSize.size64.w,
            height: appSize.size64.w,
            decoration: BoxDecoration(
              color: appColors.profileIconBlueBg,
              borderRadius: BorderRadius.circular(appSize.radius16),
            ),
            child: Icon(
              option.icon,
              color: appColors.brandColor,
              size: appSize.icon32,
            ),
          ),
          SizedBox(height: appSize.size8.h),
          Text(
            option.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: fontStyles.font12LightGrey500.copyWith(
              color: appColors.blackColor,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
