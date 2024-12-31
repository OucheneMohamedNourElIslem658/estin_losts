import 'package:cached_network_image/cached_network_image.dart';
import 'package:estin_losts/shared/constents/posts_examples.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/constents/colors.dart';
import '../../../shared/constents/fonts.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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
              "Search",
              style: TextStyle(
                color: CustomColors.black1,
                fontSize: 25,
                fontFamily: Fonts.airbndcereal,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ], 
        body: const CustomSearchAnchor()
      )
    );
  }
}

class CustomSearchAnchor extends StatelessWidget {
  const CustomSearchAnchor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.search, 
                  color: CustomColors.blue2,
                  size: 30,
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: TextField(
                    autofocus: true,
                    cursorColor: CustomColors.primaryBlue,
                    cursorWidth: 1,
                    cursorHeight: 28,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: Fonts.airbndcereal,
                      fontWeight: FontWeight.w400
                    ),
                    decoration: InputDecoration(
                      hintText: " Search...",
                      hintStyle: TextStyle(
                        color: CustomColors.grey1,
                        fontSize: 24,
                        fontFamily: Fonts.airbndcereal,
                        fontWeight: FontWeight.w400
                      ),
                      border: InputBorder.none
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const FiltersBottomSheet()
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryBlue,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    )
                  ),
                  child: Row(
                    spacing: 5,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                        ),
                        child: const Icon(
                          Icons.filter_list_rounded, 
                          color: CustomColors.primaryBlue,
                          size: 16,
                        ),  
                      ),
                      const SizedBox(width: 1), 
                      const Text(
                        "Filters",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: Fonts.airbndcereal,
                        ),
                      )
                    ],
                  )
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: List.generate(
              10, 
              (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(
                left: 10,
                right: 20,
                top: 10,
                bottom: 10
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5)
                  )
                ]
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: postImageURL,
                      height: 90,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "1st  May- Sat -2:00 PM",
                          style: TextStyle(
                            color: CustomColors.primaryBlue,
                            fontSize: 14,
                            fontFamily: Fonts.airbndcereal,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "A virtual evening of smooth jazz",
                          style: TextStyle(
                            color: CustomColors.black1,
                            fontSize: 18,
                            fontFamily: Fonts.airbndcereal,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
          )
          )
        ],
      ),
    );
  }
}

class FiltersBottomSheet extends StatelessWidget {
  const FiltersBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Filters",
                style: TextStyle(
                  color: CustomColors.black1,
                  fontSize: 25,
                  fontFamily: Fonts.airbndcereal,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Type",
                style: TextStyle(
                  color: CustomColors.black1,
                  fontSize: 16,
                  fontFamily: Fonts.airbndcereal,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  CustomFilterShip(label: "Lost"),
                  SizedBox(width: 10),
                  CustomFilterShip(label: "Found", isSelected: false)
                ],
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
              OutlinedButton(
                onPressed: (){},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  side: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.5),
                    width: 1
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.clock_fill, 
                      color: CustomColors.primaryBlue,
                      size: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Select Time",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: Fonts.airbndcereal,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios_rounded, 
                      color: CustomColors.primaryBlue,
                      size: 15,
                    ),
                  ],
                )
              ),
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
              OutlinedButton(
                onPressed: (){},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  side: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.5),
                    width: 1
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)
                  )
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: CustomColors.primaryBlue.withValues(alpha: 0.1),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.location_on_outlined, 
                          color: CustomColors.primaryBlue,
                          size: 25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "New Yourk, USA",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontFamily: Fonts.airbndcereal,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_rounded, 
                      color: CustomColors.primaryBlue,
                      size: 15,
                    ),
                  ],
                )
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: (){},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                        side: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.5),
                          width: 1
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        )
                      ),
                      child: const Text(
                        "RESET",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: Fonts.airbndcereal,
                          fontWeight: FontWeight.w300
                        ),
                      )
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        )
                      ),
                      child: const Text(
                        "APPLY",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: Fonts.airbndcereal,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFilterShip extends StatelessWidget {
  const CustomFilterShip({
    super.key,
    required this.label,
    this.isSelected = true,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = !isSelected 
        ? CustomColors.black1 
        : Colors.white;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: foregroundColor,  
          fontSize: 16,
          fontFamily: Fonts.airbndcereal,
          fontWeight: FontWeight.w300
        ),
      ),
      onSelected: (value) {},
      selected: isSelected,
      selectedColor: CustomColors.primaryBlue,
      checkmarkColor: foregroundColor,
    );
  }
}