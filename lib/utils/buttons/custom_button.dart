import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';

class CustomButton extends StatelessWidget {
  final String buttonName;
  final Function() onPressed;
  final double? buttonWidth;
  final double? buttonHeight;
  final bool disableButton;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? fontColor;
  final double? fontSize;
  final TextStyle? fontStyle;
  final double? radius;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final List<BoxShadow>? shadow;

  const CustomButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.buttonWidth,
    this.buttonHeight,
    this.margin,
    this.padding,
    this.disableButton = false,
    this.buttonColor,
    this.fontColor,
    this.fontSize,
    this.fontStyle,
    this.borderColor,
    this.radius,
    this.shadow,
    this.prefixWidget,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(radius ?? appSize.radius12),
        onTap: disableButton ? () {} : onPressed,
        child: Container(
          // margin: margin,
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            color:
                buttonColor ??
                (disableButton == true
                    ? appColors.brandColor.withValues(alpha: 0.6)
                    : appColors.brandColor),
            borderRadius: BorderRadius.circular(radius ?? appSize.radius12),
            border: borderColor != null
                ? Border.all(color: borderColor!)
                : null,
            boxShadow: shadow,
          ),
          child: Padding(
            padding:
                padding ??
                EdgeInsets.symmetric(
                  horizontal: appSize.size12.w,
                  vertical: appSize.size12.h,
                ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                prefixWidget ?? SizedBox.shrink(),
                Text(
                  buttonName,
                  overflow: TextOverflow.ellipsis,
                  style:
                      fontStyle ??
                      fontStyles.font16White700.copyWith(
                        color: fontColor,
                        fontSize: fontSize,
                      ),
                ),
                suffixWidget ?? SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
