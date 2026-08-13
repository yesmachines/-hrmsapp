import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/api_routes/api_routes.dart';
import '../../main.dart';

class ImageHandler extends StatelessWidget {
  const ImageHandler({
    super.key,
    required this.imageType,
    this.imageName,
    this.imageUrl,
    this.width,
    this.boxFit,
    this.height,
    this.radius,
    this.loaderColor,
    this.svgImageColor,
    this.errorImageWidth,
    this.errorImageHeight,
    this.errorPadding,
    this.errorWidget,
  });

  final ImageType imageType;
  final String? imageName;
  final String? imageUrl;
  final double? width;
  final double? height;
  final double? errorImageWidth;
  final double? errorImageHeight;
  final EdgeInsets? errorPadding;
  final Widget? errorWidget;
  final double? radius;
  final BoxFit? boxFit;
  final Color? loaderColor;
  final Color? svgImageColor;

  @override
  Widget build(BuildContext context) {
    switch (imageType) {
      case ImageType.network:
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 0),
          child: Image.network(
            width: width,
            height: height,
            fit: BoxFit.fill,
            imageUrl != null && imageUrl != ""
                ? imageUrl!.contains("https://") ||
                          imageUrl!.contains("http://")
                      ? imageUrl!
                      : imageUrl![0] == "/"
                      ? "${ApiRoutes.baseUrl}$imageUrl"
                      : "${ApiRoutes.baseUrl}/$imageUrl"
                : "",
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress?.cumulativeBytesLoaded !=
                  loadingProgress?.expectedTotalBytes) {
                return SizedBox(
                  height: height,
                  width: width,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: loaderColor ?? appColors.brandColor,
                    ),
                  ),
                );
              } else {
                return child;
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return errorWidget ??
                  Container(
                    height: errorImageHeight ?? height ?? 200.h,
                    width: errorImageWidth ?? width ?? 200.w,
                    margin: EdgeInsets.all(1.sp),
                    padding: errorPadding ?? EdgeInsets.all(appSize.size8.sp),
                    decoration: BoxDecoration(
                      color: appColors.whiteColor,
                      borderRadius: BorderRadius.circular(
                        radius ?? appSize.radius22,
                      ),
                    ),
                    child: ImageHandler(
                      imageType: ImageType.svg,
                      radius: radius,
                      imageUrl: imageData.noDataImage,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  );
            },
          ),
        );
      case ImageType.file:
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 0),
          child: Image.file(
            width: width,
            height: width,
            fit: BoxFit.fill,
            File(imageUrl ?? ""),
            errorBuilder: (context, error, stackTrace) {
              return errorWidget ??
                  Container(
                    height: errorImageHeight ?? 96.h,
                    width: errorImageWidth ?? 146.w,
                    margin: EdgeInsets.all(1.sp),
                    decoration: BoxDecoration(
                      color: appColors.whiteColor,
                      borderRadius: BorderRadius.circular(
                        radius ?? appSize.radius4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          // color: appColors.black000000.withValues(alpha: 0.2),
                          blurRadius: appSize.radius16,
                          spreadRadius: 1.r,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(appSize.size24.sp),
                    child: ImageHandler(
                      imageType: ImageType.svg,
                      imageUrl: imageData.noDataImage,
                    ),
                  );
            },
          ),
        );
      case ImageType.asset:
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 0),
          child: Image(
            image: AssetImage(imageUrl ?? ""),
            fit: boxFit,
            height: height,
            width: width,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) {
                return SizedBox(
                  height: height,
                  width: width,
                  child: Center(
                    child: CircularProgressIndicator(
                      // color: loaderColor ?? appColors.whiteFFFFFF,
                    ),
                  ),
                );
              } else {
                return child;
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return errorWidget ??
                  Container(
                    height: errorImageHeight ?? 96.h,
                    width: errorImageWidth ?? 146.w,
                    margin: EdgeInsets.all(1.sp),
                    decoration: BoxDecoration(
                      color: appColors.whiteColor,
                      borderRadius: BorderRadius.circular(
                        radius ?? appSize.radius4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          // color: appColors.black000000.withValues(alpha: 0.2),
                          blurRadius: appSize.radius16,
                          spreadRadius: 1.r,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(appSize.size24.sp),
                    child: ImageHandler(
                      imageType: ImageType.svg,
                      imageUrl: imageData.noDataImage,
                    ),
                  );
            },
          ),
        );
      case ImageType.svg:
        return SvgPicture.asset(
          imageUrl ?? "",
          height: height,
          width: width,
          color: svgImageColor,
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ??
                Container(
                  height: errorImageHeight ?? 96.h,
                  width: errorImageWidth ?? 146.w,
                  margin: EdgeInsets.all(1.sp),
                  decoration: BoxDecoration(
                    color: appColors.whiteColor,
                    borderRadius: BorderRadius.circular(
                      radius ?? appSize.radius4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: appColors.black000000.withValues(alpha: 0.2),
                        blurRadius: appSize.radius16,
                        spreadRadius: 1.r,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(appSize.size24.sp),
                  child: ImageHandler(
                    imageType: ImageType.svg,
                    imageUrl: imageData.noDataImage,
                  ),
                );
          },
          placeholderBuilder: (context) {
            return SizedBox(
              height: height,
              width: width,
              child: Center(
                child: CircularProgressIndicator(
                  // color: loaderColor ?? appColors.whiteFFFFFF,
                ),
              ),
            );
          },
        );
    }
  }
}

enum ImageType { network, file, asset, svg }
