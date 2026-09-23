import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.image,
    required this.name,
  });

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: appSize.size40.w,
      height: appSize.size40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: appColors.brandColor,
        image: image.isNotEmpty
            ? DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        )
            : null,
      ),
      alignment: Alignment.center,
      child: image.isEmpty
          ? Text(
        name.isNotEmpty
            ? name[0].toUpperCase()
            : '?',
        style: fontStyles.font14White600
      )
          : null,
    );
  }
}
