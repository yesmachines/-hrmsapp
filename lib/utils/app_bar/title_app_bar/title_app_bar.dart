import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../image_handler/image_handler.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleAppBar({super.key, this.onBackTap, this.title, this.trailing});

  final Function()? onBackTap;
  final String? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appColors.scaffoldGreyColor,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            appSize.size8.w,
            appSize.size8.h,
            appSize.size16.w,
            appSize.size8.h,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: onBackTap ?? Get.back,
                borderRadius: BorderRadius.circular(appSize.radius60),
                child: SizedBox(
                  width: appSize.size44.w,
                  height: appSize.size44.w,
                  child: Center(
                    child: ImageHandler(
                      imageType: ImageType.svg,
                      imageUrl: iconData.arrowLeftIconSvg,
                      width: appSize.icon20,
                      height: appSize.icon20,
                      svgImageColor: appColors.blackColor,
                    ),
                  ),
                ),
              ),
              Text(title ?? "", style: fontStyles.font20Black700Fixed),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.h);
}
