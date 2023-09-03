import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:notchai_frontend/utils/app_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.bgColor,
        body: ListView(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const Gap(35),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Morning",
                            style: Styles.headlineStyle3,
                          ),
                          const Gap(5),
                          Text(
                            "Your Health Our Priority",
                            style: Styles.headlineStyle1,
                          ),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/doc1.png"))),
                      )
                    ]),
                const Gap(25),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white70),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Colors.blueGrey,
                      ),
                      Text(
                        "Search",
                        style: Styles.headlineStyle3,
                      )
                    ],
                  ),
                ),
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Health Records",
                      style: Styles.headlineStyle3,
                    ),
                    InkWell(
                      onTap: () {
                        print("you tap view all");
                      },
                      child: Text(
                        "View All",
                        style:
                            Styles.textStyle.copyWith(color: Colors.blueGrey),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Gap(20),
        ]));
  }
}
