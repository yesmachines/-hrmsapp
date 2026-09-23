import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

import '../service/model/social_model.dart';
import '../service/service.dart';

class SocialsController extends GetxController implements Bindings {

  final RxList<SocialPostModel> posts =
      <SocialPostModel>[].obs;

  final RxBool isLoading = false.obs;

  final RxBool isCreatingPost = false.obs;

  final TextEditingController postController =
  TextEditingController();

  @override
  void onInit() {
    super.onInit();

    log(
      "SocialsController initialized",
    );

    getSocialPosts();
  }

  Future<void> getSocialPosts() async {
    try {
      isLoading.value = true;

      log(
        "Getting social posts...",
      );

      final response =
      await SocialService.getSocialPosts();

      posts.assignAll(response);

      log(
        "Social posts received: ${posts.length}",
      );
    } catch (e, stackTrace) {
      log(
        "Social posts error: $e",
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPost() async {
    final text =
    postController.text.trim();

    if (text.isEmpty) {
      Get.snackbar(
        'Create Post',
        'Please enter something to post',
        snackPosition:
        SnackPosition.BOTTOM,
      );

      return;
    }

    try {
      isCreatingPost.value = true;

      await Future.delayed(
        const Duration(seconds: 1),
      );

      final newPost = SocialPostModel(
        id: posts.length + 1,
        userName: "You",
        userImage: "",
        postedTime: "Just now",
        description: text,
        postImage: "",
        reactions: const [],
        reactionCount: 0,
        reactionUsers: [],
      );

      posts.insert(
        0,
        newPost,
      );

      postController.clear();

      Get.back();

      Get.snackbar(
        'Success',
        'Post created successfully',
        snackPosition:
        SnackPosition.BOTTOM,
      );
    } catch (e) {
      log(
        "Create post error: $e",
      );
    } finally {
      isCreatingPost.value = false;
    }
  }

  void reactToPost(
      SocialPostModel post,
      String reaction,
      ) {
    final index = posts.indexWhere(
          (item) => item.id == post.id,
    );

    if (index == -1) {
      return;
    }

    final currentPost = posts[index];

    posts[index] = SocialPostModel(
      id: currentPost.id,
      userName: currentPost.userName,
      userImage: currentPost.userImage,
      postedTime: currentPost.postedTime,
      description: currentPost.description,
      postImage: currentPost.postImage,
      reactions: currentPost.reactions,
      reactionCount:
      currentPost.reactionCount + 1,
      reactionUsers: [],
    );
  }

  void onTapCreatePost(){
    Get.toNamed(appRoutes.createPost);
  }



  @override
  void dependencies() {
    Get.put<SocialsController>(
      SocialsController(),
    );
  }

  @override
  void onClose() {
    postController.dispose();

    super.onClose();
  }
}