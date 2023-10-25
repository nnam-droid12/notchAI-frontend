import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:notchai_frontend/screens/ai_chat_screen.dart';
import 'package:notchai_frontend/pages/doctor_home.dart';
import 'package:notchai_frontend/utils/app_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: ListView(
        children: [
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
                          image: AssetImage("assets/images/doc1.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(25),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white70,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Colors.blueGrey,
                      ),
                      Text(
                        "Search",
                        style: Styles.headlineStyle3,
                      ),
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
                        // ignore: avoid_print
                        print("you tap view all");
                      },
                      child: Text(
                        "View All",
                        style:
                            Styles.textStyle.copyWith(color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(20),

          // New Section 1: Appointment Categories
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Appointment Categories",
                      style: Styles.headlineStyle3,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Redirect to another page for appointment categories
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DoctorHomePage(),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF097969),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("View All"),
                    ),
                  ],
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategoryItem("General", "assets/images/gene1.jpg"),
                    _buildCategoryItem("Pediatrics", "assets/images/gene2.jpg"),
                    _buildCategoryItem("Dentistry", "assets/images/doc1.png"),
                  ],
                ),
                const Gap(20),
              ],
            ),
          ),

          // New Section 2: AI Recommendations
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "AI Recommendations",
                      style: Styles.headlineStyle3,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AiChatScreen(),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF097969),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "View All",
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRecommendationItem(
                        "Skin Issue", "assets/images/gene1.jpg"),
                    _buildRecommendationItem(
                        "Eye Checkup", "assets/images/gene2.jpg"),
                  ],
                ),
                const Gap(20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create category items
  Widget _buildCategoryItem(String title, String imagePath) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blueGrey, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Gap(8),
        Text(
          title,
          style: Styles.textStyle.copyWith(color: Colors.blueGrey),
        ),
      ],
    );
  }

  // Helper method to create recommendation items
  Widget _buildRecommendationItem(String title, String imagePath) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blueGrey, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Gap(8),
        Text(
          title,
          style: Styles.textStyle.copyWith(color: Colors.blueGrey),
        ),
      ],
    );
  }
}

class AppointmentCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment Categories"),
      ),
      body: const Center(
        child: Text("This is the Appointment Categories page."),
      ),
    );
  }
}

class AIRecommendationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Recommendations"),
      ),
      body: const Center(
        child: Text("This is the AI Recommendations page."),
      ),
    );
  }
}
