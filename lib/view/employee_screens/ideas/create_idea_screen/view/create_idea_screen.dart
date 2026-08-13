import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/image_picker/custom_image_picker.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/ideas/create_idea_screen/controller/controller.dart';

import '../../../../../main.dart';

class CreateIdeaScreen extends GetView<CreateIdeaController> {
  const CreateIdeaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(title: "Create Idea"),
      backgroundColor: appColors.scaffoldGreyColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: appSize.size16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: appSize.size12.h,
            children: [
              SizedBox(height: appSize.size8.h),
              CustomTextField(
                title: "Title",
                controller: controller.titleController,
                hintText: "Enter your idea title.",
                maxLength: 200,
              ),
              CustomTextField(
                controller: controller.descriptionController,
                title: "Description",
                hintText: "Enter your idea in detail.",
                radius: appSize.radius16,
                minLines: 5,
                maxLines: 10,
                maxLength: 1000,
              ),
              Obx(
                () => CustomImagePicker(
                  images: controller.attachedImages.toList(),
                  onChanged: controller.onAttachmentsChanged,
                  maxAttachments: CreateIdeaController.maxAttachments,
                ),
              ),
              SizedBox(height: 90.h),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(
        margin: EdgeInsets.symmetric(horizontal: appSize.size16.w),
        buttonWidth: double.infinity,
        buttonName: "Submit Idea",
        onPressed: controller.createIdea,
      ),
    );
  }
}
