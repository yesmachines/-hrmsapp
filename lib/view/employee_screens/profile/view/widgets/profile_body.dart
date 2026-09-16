import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../main.dart';
import '../../service/model/profile_model.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key, required this.profileData});

  final ProfileModel profileData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileAvatar(profileData: profileData),

        SizedBox(height: appSize.size16.h),

        Text(
          profileData.name,
          style: fontStyles.font20ProfileName700,
        ),

        SizedBox(height: appSize.size6.h),

        Text(
          profileData.designation,
          style: fontStyles.font14Brand500,
        ),

        SizedBox(height: appSize.size4.h),

        Text(
          profileData.division,
          style: fontStyles.font14LightGrey400,
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.profileData,
  });

  final ProfileModel profileData;

  @override
  Widget build(BuildContext context) {
    final url = profileData.imageUrl;

    return Container(
      width: appSize.size100.w,
      height: appSize.size100.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: appColors.profileIconBlueBg,
        border: Border.all(
          color: appColors.whiteColor,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: appColors.blackColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        image: url.isNotEmpty
            ? DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: url.isEmpty
          ? Icon(
        Icons.person_rounded,
        size: appSize.icon32 * 1.5,
        color: appColors.brandColor,
      )
          : null,
    );
  }
}

