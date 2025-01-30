// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:estin_losts/services/posts.dart';
import 'package:estin_losts/shared/models/post.dart';
import 'package:estin_losts/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddPostController extends GetxController {
  final BuildContext context;

  AddPostController(this.context);

  late TextEditingController titleController, descriptionController, locationController;
  late GlobalKey<FormState> formKey;

  void initControllers() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    locationController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title cannot be empty';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value != null && value.isNotEmpty && value.trim().isEmpty) {
      return 'Description cannot be empty';
    }
    return null;
  }

  String? validateLocation(String? value) {
    if (value != null && value.isNotEmpty && value.trim().isEmpty) {
      return 'Location cannot be empty';
    }
    return null;
  }

  var postType = PostType.lost;

  void changePostType(PostType type) {
    postType = type;
    update(['post-type']);
  }

  List<File> images = [];

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage(imageQuality: 50);
      
    images.addAll(pickedFiles.map((file) => File(file.path)).toList());

    if (images.length > 3) {
      images = images.sublist(0, 3);
    }

    update(['images']);
  }

  void removeImage(int index) {
    images.removeAt(index);
    update(["images"]);
  }

  Future<void> addPost(BuildContext context) async {
    try {
      if (formKey.currentState!.validate()) {
        await Posts.addPost(
          context, 
          title: titleController.text, 
          type: postType,
          description: descriptionController.text,
          locationDescription: locationController.text,
          images: images
        );
        context.pop();
        Utils.showSnackBar(context, 'Post added successfully', type: SnackBarType.success);
      }
    } catch (e) {
      Utils.showSnackBar(context, e.toString(), type: SnackBarType.error);
    }
  }

  @override
  void onInit() {
    initControllers();
    super.onInit();
  }
}