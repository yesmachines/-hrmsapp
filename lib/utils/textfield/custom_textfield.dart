import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.prefix,
    this.suffix,
    this.suffixPadding,
    this.style,
    this.hintStyle,
    this.controller,
    this.onChanged,
    this.readOnly = false,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
    this.isDense,
    this.onTap,
    this.contentPadding,
    this.decoration,
    this.hintText,
    this.errorText,
    this.minLines,
    this.isObscure = false,
    this.maxLines,
    this.radius,
    this.focusNode,
    this.onSubmitted,
    this.padding,
    this.title,
  });

  final Widget? prefix;
  final String? title;
  final Widget? suffix;
  final EdgeInsets? suffixPadding;
  final double? radius;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final String? hintText;
  final String? errorText;
  final bool isObscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function(String text)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final Function()? onSubmitted;
  final bool? isDense;
  final EdgeInsets? contentPadding;
  final EdgeInsets? padding;
  final bool readOnly;
  final BoxDecoration? decoration;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.only(bottom: appSize.size8.h),
              child: Text(title!, style: fontStyles.font14Black600),
            ),
          Container(
            padding:
                padding ??
                EdgeInsets.symmetric(
                  horizontal: appSize.size16.w,
                  vertical: appSize.size4.h,
                ),
            decoration:
                decoration ??
                BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    radius ?? appSize.radius8,
                  ),
                  border: Border.all(
                    width: 1.sp,
                    color: errorText != null
                        ? appColors.errorColor
                        : appColors.strokeColor,
                  ),
                ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                prefix != null
                    ? Padding(
                        padding: EdgeInsets.only(right: appSize.size16.w),
                        child: prefix,
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: InkWell(
                    onTap: onTap,
                    child: TextField(
                      controller: controller,
                      minLines: minLines,
                      maxLines: maxLines,
                      onChanged: onChanged,
                      onTap: onTap,
                      readOnly: readOnly,
                      maxLength: maxLength,
                      focusNode: focusNode,
                      onSubmitted: (value) => onSubmitted,
                      inputFormatters: inputFormatters,
                      keyboardType: keyboardType,
                      obscureText: isObscure,
                      style:
                          style ??
                          fontStyles.font16MediumGrey400.copyWith(
                            color: errorText != null
                                ? appColors.errorColor
                                : null,
                          ),
                      cursorColor: appColors.brandColor,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle:
                            hintStyle ??
                            fontStyles.font14LightGrey400.copyWith(
                              color: errorText != null
                                  ? appColors.errorColor
                                  : appColors.mediumGreyColor.withValues(
                                      alpha: 0.5,
                                    ),
                            ),
                        isDense: isDense,
                        contentPadding: contentPadding ?? EdgeInsets.zero,
                        border: InputBorder.none,
                        counterText: "",
                      ),
                    ),
                  ),
                ),
                suffix != null
                    ? Padding(
                        padding:
                            suffixPadding ??
                            EdgeInsets.only(left: appSize.size16.w),
                        child: suffix,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          errorText != null
              ? Padding(
                  padding: EdgeInsets.only(
                    right: appSize.size16.w,
                    left: appSize.size16.w,
                    top: appSize.size4.h,
                  ),
                  child: Text(errorText!, style: fontStyles.font10Error400),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
