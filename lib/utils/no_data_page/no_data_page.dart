import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';
import '../image_handler/image_handler.dart';

class NoDataPage extends StatelessWidget {
  const NoDataPage({super.key, this.message, this.width, this.height});

  final String? message;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageHandler(
                width: screenUtil.screenWidth / 3,
                boxFit: BoxFit.fitWidth,
                imageType: ImageType.asset,
                imageUrl: imageData.noDataImage,
              ),
              SizedBox(height: appSize.size16.h),
              Text(
                message ?? "No Data",
                textAlign: TextAlign.center,
                style: fontStyles.font20Black700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
