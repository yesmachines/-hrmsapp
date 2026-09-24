import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/documents/create_document_screen/controller/controller.dart';

class CreateDocumentView extends GetView<CreateDocumentController> {
  const CreateDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Create Document"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(
        margin: EdgeInsets.symmetric(horizontal: appSize.size16.w),
        buttonWidth: double.infinity,
        buttonName: 'Submit Document',
        onPressed: controller.submitDocument,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            appSize.size16.w,
            appSize.size8.h,
            appSize.size16.w,
            100.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Document Type', style: fontStyles.font14Black600),
              SizedBox(height: appSize.size8.h),
              Obx(
                () => _SelectField(
                  value: controller.typeLabel,
                  isPlaceholder: controller.selectedType.value == null,
                  onTap: controller.onTypeTap,
                ),
              ),
              SizedBox(height: appSize.size16.h),
              CustomTextField(
                title: 'Document Title',
                controller: controller.titleController,
                hintText: 'Passport Copy',
                maxLines: 1,
                maxLength: 120,
              ),
              Obx(() {
                if (!controller.requiresNumber) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    SizedBox(height: appSize.size16.h),
                    CustomTextField(
                      title: 'Document Number',
                      controller: controller.numberController,
                      hintText: 'A98765432',
                      maxLines: 1,
                      maxLength: 60,
                    ),
                  ],
                );
              }),
              SizedBox(height: appSize.size16.h),
              Text('Issue Date', style: fontStyles.font14Black600),
              SizedBox(height: appSize.size8.h),
              Obx(
                () => _SelectField(
                  value: controller.issueDateLabel,
                  isPlaceholder: controller.issueDate.value == null,
                  icon: Icons.calendar_today_outlined,
                  onTap: controller.onIssueDateTap,
                ),
              ),
              Obx(() {
                if (!controller.requiresExpiry) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: appSize.size16.h),
                    Text('Expiry Date', style: fontStyles.font14Black600),
                    SizedBox(height: appSize.size8.h),
                    _SelectField(
                      value: controller.expiryDateLabel,
                      isPlaceholder: controller.expiryDate.value == null,
                      icon: Icons.event_outlined,
                      onTap: controller.onExpiryDateTap,
                    ),
                  ],
                );
              }),
              Obx(() {
                if (!controller.requiresAttachments) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: appSize.size16.h),
                    Text('Attachment', style: fontStyles.font14Black600),
                    SizedBox(height: appSize.size8.h),
                    _AttachmentField(
                      fileName: controller.attachmentLabel,
                      hasFile: controller.attachment.value != null,
                      onTap: controller.pickAttachment,
                      onRemove: controller.removeAttachment,
                    ),
                  ],
                );
              }),
              SizedBox(height: appSize.size16.h),
              CustomTextField(
                title: 'Remarks',
                controller: controller.remarksController,
                hintText: 'Renewed passport copy',
                radius: appSize.radius12,
                minLines: 4,
                maxLines: 6,
                maxLength: 500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.value,
    required this.onTap,
    this.isPlaceholder = false,
    this.icon = Icons.keyboard_arrow_down_rounded,
  });

  final String value;
  final VoidCallback onTap;
  final bool isPlaceholder;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size14.w,
          vertical: appSize.size14.h,
        ),
        decoration: BoxDecoration(
          color: appColors.whiteColor,
          borderRadius: BorderRadius.circular(appSize.radius12),
          border: Border.all(color: appColors.strokeColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: isPlaceholder
                    ? fontStyles.font14LightGrey400
                    : fontStyles.font14Black600,
              ),
            ),
            Icon(icon, color: appColors.lightGreyColor, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

class _AttachmentField extends StatelessWidget {
  const _AttachmentField({
    required this.fileName,
    required this.hasFile,
    required this.onTap,
    required this.onRemove,
  });

  final String fileName;
  final bool hasFile;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size14.w,
          vertical: appSize.size14.h,
        ),
        decoration: BoxDecoration(
          color: appColors.whiteColor,
          borderRadius: BorderRadius.circular(appSize.radius12),
          border: Border.all(color: appColors.strokeColor),
        ),
        child: Row(
          children: [
            Icon(
              Icons.attach_file_rounded,
              color: appColors.brandColor,
              size: 20.sp,
            ),
            SizedBox(width: appSize.size8.w),
            Expanded(
              child: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: hasFile
                    ? fontStyles.font14Black600
                    : fontStyles.font14LightGrey400,
              ),
            ),
            if (hasFile)
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close_rounded,
                  color: appColors.lightGreyColor,
                  size: 20.sp,
                ),
              )
            else
              Icon(
                Icons.add_circle_outline_rounded,
                color: appColors.lightGreyColor,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
