import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/constents/colors.dart';
import '../../../shared/constents/fonts.dart';
import '../widgets/custom_filter_ship.dart';
import '../widgets/location_button.dart';
import '../widgets/select_time_button.dart';

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
          // Column(
          //   children: List.generate(
          //     10, 
          //     (index) => const PostTile(),
          //   )
          // )
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