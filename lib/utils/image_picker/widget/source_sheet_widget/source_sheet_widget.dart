import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../main.dart';
import 'source_option_widget.dart';

class SourceSheetWidget extends StatelessWidget {
  const SourceSheetWidget({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  final Function() onGalleryTap;
  final Function() onCameraTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SourceOption(
          icon: Icons.photo_library_outlined,
          label: "Gallery",
          onTap: onGalleryTap,
        ),
        SizedBox(height: appSize.size12.h),
        SourceOption(
          icon: Icons.photo_camera_outlined,
          label: "Camera",
          onTap: onCameraTap,
        ),
      ],
    );
  }
}
