import 'dart:io';

import 'package:estin_losts/features/posts/controllers/add_post.dart';
import 'package:estin_losts/features/user/widgets/vertical_scroller.dart';
import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:estin_losts/shared/models/post.dart';
import 'package:estin_losts/shared/screens/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_filter_ship.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addPostController = Get.put(AddPostController(context));

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            snap: true,
            floating: true,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back_rounded, 
                color: Colors.black,
                size: 30,
              )
            ),
            title: const Text(
              "Add Post",
              style: TextStyle(
                color: CustomColors.black1,
                fontSize: 25,
                fontFamily: Fonts.airbndcereal,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ], 
        body: VerticalScroller(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: addPostController.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20), 
                  GetBuilder<AddPostController>(
                    id: 'post-type',
                    dispose: (_) => Get.delete<AddPostController>(),
                    builder: (_) {
                      final postType = addPostController.postType;
              
                      return Row(
                        children: [
                          CustomFilterShip(
                            label: "Lost", 
                            isSelected: postType == PostType.lost,
                            onTap: () => addPostController.changePostType(PostType.lost),
                          ),
                          const SizedBox(width: 10),
                          CustomFilterShip(
                            label: "Found", 
                            isSelected: postType == PostType.found,
                            onTap: () => addPostController.changePostType(PostType.found),
                          ),
                        ],
                      );
                    }
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Title",
                    hintText: "Enter title",
                    validationTag: ValidationTag.required,
                    controller: addPostController.titleController,
                    validator: addPostController.validateTitle,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Description",
                    hintText: "Enter description",
                    maxLines: 5,
                    validationTag: ValidationTag.optional,
                    controller: addPostController.descriptionController,
                    validator: addPostController.validateDescription,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Localtion description",
                    hintText: "Enter description",
                    maxLines: 2,
                    validationTag: ValidationTag.optional,
                    controller: addPostController.locationController,
                    validator: addPostController.validateLocation,
                  ),
                  const SizedBox(height: 20),
                  GetBuilder<AddPostController>(
                    id: 'images',
                    builder: (_) {
                      return ImagesList(
                        images: addPostController.images,
                        onAddImages: addPostController.pickImages,
                        onRemoveImage: addPostController.removeImage,
                      );
                    }
                  ),
                  const SizedBox(height: 30),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async => await addPostController.addPost(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      child: const Text(
                        "Add Post",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: Fonts.airbndcereal,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        )
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

class ImagesList extends StatelessWidget {
  const ImagesList({
    super.key,
    required this.images,
    required this.onAddImages,
    required this.onRemoveImage
  });

  final List<File> images;
  final VoidCallback onAddImages;
  final Function(int index) onRemoveImage;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'images',
              style: TextStyle(
                color: CustomColors.black1,
                fontSize: 16,
                fontFamily: Fonts.airbndcereal,
                fontWeight: FontWeight.w500
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "*3 at most",
                style: TextStyle(
                  color: CustomColors.red1,
                  fontSize: 12,
                  fontFamily: Fonts.airbndcereal,
                  fontWeight: FontWeight.w400
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(
            images.length + 1, 
            (index) {
              if (index == images.length) {
                return OutlinedButton(
                  onPressed: onAddImages,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    side: BorderSide(
                      color: CustomColors.grey1.withValues(alpha: 0.5),
                      width: 1
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo, 
                        color: CustomColors.red1,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Add Image",
                        style: TextStyle(
                          color: CustomColors.black1,
                          fontSize: 16,
                          fontFamily: Fonts.airbndcereal,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  )
                );
              }
        
              final image = images[index];
        
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageScreen(
                        image: FileImage(image),
                        name: image.path.split('/').last,
                      )
                    )
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    side: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.5),
                      width: 1
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.image, 
                        color: CustomColors.red1,
                        size: 32,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        image.path.split('/').last,
                        style: const TextStyle(
                          color: CustomColors.black1,
                          fontSize: 16,
                          fontFamily: Fonts.airbndcereal,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => onRemoveImage(index),
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: const Icon(
                          Icons.close_rounded, 
                          color: CustomColors.black1,
                          size: 25,
                        ),
                      )
                    ],
                  )
                ),
              );
            }
          )
        ),
      ],
    );
  }
}

enum ValidationTag {
  required,
  optional,
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.label,
    this.maxLines = 1,
    this.validationTag,
    this.controller,
    this.validator
  });

  final String hintText;
  final String? label;
  final int maxLines;
  final ValidationTag? validationTag;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: CustomColors.grey1.withValues(alpha: 0.2),
        width: 1
      )
    );

    var errorBorder = outlineInputBorder.copyWith(
      borderSide: const BorderSide(
        color: CustomColors.red1,
        width: 1
      )
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label!,
              style: const TextStyle(
                color: CustomColors.black1,
                fontSize: 16,
                fontFamily: Fonts.airbndcereal,
                fontWeight: FontWeight.w500
              ),
            ),
            if (validationTag != null) Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                validationTag == ValidationTag.required ? "*Required" : "*Optional",
                style: const TextStyle(
                  color: CustomColors.red1,
                  fontSize: 12,
                  fontFamily: Fonts.airbndcereal,
                  fontWeight: FontWeight.w400
                ),
              ),
            )
          ],
        ),
        if (label != null) const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          cursorColor: CustomColors.primaryBlue,
          validator: validator,
          decoration: InputDecoration(
            hintText: " $hintText",
            hintStyle: const TextStyle(
              color: CustomColors.grey1,
              fontSize: 16,
              fontFamily: Fonts.airbndcereal,
              fontWeight: FontWeight.w300
            ),
            errorStyle: const TextStyle(
              color: CustomColors.red1,
              fontSize: 12,
              fontFamily: Fonts.airbndcereal,
              fontWeight: FontWeight.w500
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            enabledBorder: outlineInputBorder,
            border: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
          ),
          maxLines: maxLines,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}