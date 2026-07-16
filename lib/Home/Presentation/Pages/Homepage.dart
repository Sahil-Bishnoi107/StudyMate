import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Home/Presentation/Widgets/drawer.dart';
import 'package:study_mate/QuestionsSection/Presentation/Pages/FiltersPage.dart';
import 'package:study_mate/fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Contest/Presentation/Pages/ContestPage.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsBloc.dart';
import 'package:study_mate/QuestionsSection/Data/QuestionsRepo.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestPageBloc.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      drawer: mainDrawer(height, width, context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 40),
            _buildActionCards(context),
            const SizedBox(height: 30),
            _buildPremiumCard(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello! 👋",
          style: TextStyle(
            fontFamily: Fonts.nunito,
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: Fonts.outfit,
              fontSize: 36,
              height: 1.2,
              color: Colors.black87,
            ),
            children: [
              const TextSpan(
                text: "Master your ",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              const TextSpan(
                text: "Concepts.\n",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: "Conquer the ",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              TextSpan(
                text: "Exams.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Consistency is what transforms average into excellence.",
          style: TextStyle(
            fontFamily: Fonts.nunito,
            fontSize: 14,
            color: Colors.grey[500],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCards(BuildContext context) {
    return Column(
      children: [
        _buildNavCard(
          context: context,
          title: "Start Practicing",
          subtitle: "Sharpen your skills question by question",
          icon: Bootstrap.journal_code,
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<Questionsbloc>(
                  create: (context) => Questionsbloc(sl<QuestionsRepo>()),
                  child: const FiltersPage(),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        _buildNavCard(
          context: context,
          title: "Join Contests",
          subtitle: "Compete with peers and check your rank",
          icon: Bootstrap.trophy,
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<ContestPageBloc>(
                  create: (context) => ContestPageBloc(sl<ContestRepo>()),
                  child: const ContestPage(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNavCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required MaterialColor color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: Fonts.outfit,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: Fonts.nunito,
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.green[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Bootstrap.stars, color: Colors.yellowAccent, size: 24),
              const SizedBox(width: 10),
              Text(
                "Upgrade to Premium",
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Unlock advanced analytics, unlimited practice, AI insights and much more.",
            style: TextStyle(
              fontFamily: Fonts.nunito,
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: const Text(
              "Coming Soon",
              style: TextStyle(
                fontFamily: Fonts.outfit,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}