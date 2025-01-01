import 'package:estin_losts/features/posts/widgets/location_button.dart';
import 'package:estin_losts/features/posts/widgets/select_time_button.dart';
import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_filter_ship.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            snap: true,
            floating: true,
            leading: IconButton(
              onPressed: () {},
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
            actions: [
              IconButton(
                onPressed: () {}, 
                icon: const Icon(
                  Icons.close_rounded, 
                  color: Colors.black,
                  size: 30,
                )
              ),
            ],
          )
        ], 
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), 
                const Row(
                  children: [
                    CustomFilterShip(label: "Lost", isSelected: true),
                    SizedBox(width: 10),
                    CustomFilterShip(label: "Found", isSelected: false),
                  ],
                ),
                const SizedBox(height: 20),
                const CustomTextField(
                  label: "Title",
                  hintText: "Enter title",
                ),
                const SizedBox(height: 20),
                const CustomTextField(
                  label: "Description",
                  hintText: "Enter description",
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Time",
                  style: TextStyle(
                    color: CustomColors.black1,
                    fontSize: 16,
                    fontFamily: Fonts.airbndcereal,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 10),
                const SelectTimeButton(),
                const SizedBox(height: 20),
                const Text(
                  "Location",
                  style: TextStyle(
                    color: CustomColors.black1,
                    fontSize: 16,
                    fontFamily: Fonts.airbndcereal,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 10),
                const LocationButton(),
                const SizedBox(height: 10),
                const CustomTextField(
                  hintText: "Add Location Description",
                ),
                const SizedBox(height: 20),
                const Text(
                  "Images",
                  style: TextStyle(
                    color: CustomColors.black1,
                    fontSize: 16,
                    fontFamily: Fonts.airbndcereal,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 10),
                const ImagesList(),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){},
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
        )
      ),
    );
  }
}

class ImagesList extends StatelessWidget {
  const ImagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      "mohamed.png",
      "flour.jpg",
      "hat.jpg",
      "floating head.jpeg",
      "ouchene.png",
      "charger.jpg",
      "ring.jpg",
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(
        images.length, 
        (index) => OutlinedButton(
          onPressed: (){},
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
                images[index],
                style: const TextStyle(
                  color: CustomColors.black1,
                  fontSize: 16,
                  fontFamily: Fonts.airbndcereal,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: (){},
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
        )
      )
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.label,
    this.maxLines = 1,
  });

  final String hintText;
  final String? label;
  final int maxLines;

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
        if (label != null) Text(
          label!,
          style: const TextStyle(
            color: CustomColors.black1,
            fontSize: 16,
            fontFamily: Fonts.airbndcereal,
            fontWeight: FontWeight.w500
          ),
        ),
        if (label != null) const SizedBox(height: 10),
        TextFormField(
          cursorColor: CustomColors.primaryBlue,
          decoration: InputDecoration(
            hintText: " $hintText",
            hintStyle: const TextStyle(
              color: CustomColors.grey1,
              fontSize: 16,
              fontFamily: Fonts.airbndcereal,
              fontWeight: FontWeight.w300
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