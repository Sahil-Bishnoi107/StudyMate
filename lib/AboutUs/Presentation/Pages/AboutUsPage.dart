import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/AboutUs/Domain/PeopleCard.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/AboutUsBloc.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/AboutUsEvents.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/AboutUsStates.dart';
import 'package:study_mate/AboutUs/Presentation/Pages/PersonDetailsPage.dart';
import 'package:study_mate/AboutUs/Presentation/Widgets/PersonCardWidget.dart';
import 'package:study_mate/Home/Presentation/Widgets/drawer.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/Notifications/Presentation/Pages/NotificationPage.dart';
import 'package:study_mate/fonts.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<Aboutusbloc>(context).add(AboutusLoadData());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: mainDrawer(height, width, context),
      body: Column(
        children: [
          SizedBox(height: height * 0.05),
          _appBar(height, width),
          Container(
            color: const Color.fromRGBO(220, 220, 220, 0.8),
            height: 1,
            width: width,
          ),
          Expanded(
            child: BlocBuilder<Aboutusbloc, Aboutusstates>(
              builder: (context, state) {
                if (state is AboutusInitialState || state is AboutUsLoading) {
                  return const Center(child: LoadingLogo());
                } else if (state is AboutUsLoaded) {
                  return _buildContent(context, state.people, width);
                } else if (state is AboutUsError) {
                  return Center(
                    child: Text(
                      "Failed to load about us data",
                      style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar(double height, double width) {
  return Container(
    height: height * 0.05,
    margin: EdgeInsets.symmetric(horizontal: width * 0.05),
    child: Row(
      children: [
        Builder(
          builder: (context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Icon(
                Icons.menu_sharp,
                size: 30,
              ),
            );
          },
        ),

        SizedBox(width: width * 0.25),

        SizedBox(
          width: width * 0.5,
          child: Text(
            "About Us",
            style: TextStyle(
              color: Colors.black,
              fontFamily: Fonts.outfit,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            textAlign: TextAlign.start,
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const Notificationpage(),
              ),
            );
          },
          child: const Icon(
            Icons.notifications_none_sharp,
          ),
        ),
      ],
    ),
  );
}
  Widget _buildContent(BuildContext context, List<PersonCard> people, double width) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<Aboutusbloc>(context).add(AboutusLoadData());
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroText(),
            const SizedBox(height: 16),
            Text(
              "StudyMate is an AI-powered platform for JEE and NEET preparation providing mock tests, contests, analytics, practice questions, and experienced teachers.",
              style: TextStyle(
                fontFamily: Fonts.outfit,
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            _buildWhoWeAreSection(),
            const SizedBox(height: 32),
            _buildTeamHeader(),
            const SizedBox(height: 24),
            _buildRoleSection(context, "Teachers", people.where((p) => p.peopleRole == PeopleRole.teacher).toList()),
            _buildRoleSection(context, "App Developer", people.where((p) => p.peopleRole == PeopleRole.developer).toList()),
            _buildRoleSection(context, "Management", people.where((p) => p.peopleRole == PeopleRole.management).toList()),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroText() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: Fonts.outfit,
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
        children: const [
          TextSpan(text: "Learn. ",style: TextStyle(fontFamily: Fonts.lobster,fontSize: 40)),
          TextSpan(text: "Grow. ", style: TextStyle(color: Colors.green,fontFamily: Fonts.lobster,fontSize: 40)),
          TextSpan(text: "Succeed.",style: TextStyle(fontFamily: Fonts.lobster,fontSize: 40)),
        ],
      ),
    );
  }

  Widget _buildWhoWeAreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Who  ",style: TextStyle(fontFamily: Fonts.lobsterTwo,fontSize: 25,fontWeight: FontWeight.bold, color: Colors.black, ), ),
            Text("We  ",style: TextStyle(fontFamily: Fonts.lobsterTwo,fontSize: 25,fontWeight: FontWeight.bold, color: Colors.green, ), ),
            Text("Are",style: TextStyle(fontFamily: Fonts.lobsterTwo,fontSize: 25,fontWeight: FontWeight.bold, color: Colors.black, ), ),
          ],
        ),
        
        const SizedBox(height: 16),
        Text(
          "Founded with a mission to democratize quality education, StudyMate combines cutting-edge AI technology with the wisdom of industry-leading educators. We believe every student deserves a personalized roadmap to success.",
          style: TextStyle(
            fontFamily: Fonts.outfit,
            fontSize: 12,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Meet ",style: TextStyle(fontFamily: Fonts.lobster,fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green), ),
            Text("Our ",style: TextStyle(fontFamily: Fonts.lobster,fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black), ),
            Text("Team",style: TextStyle(fontFamily: Fonts.lobster,fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green), ),
          ],
        ),
        const SizedBox(height: 4),
        Text( "Learn from the industry's best minds",style: TextStyle( fontFamily: Fonts.outfit,fontSize: 12,color: Colors.grey[600],),
        ),
      ],
    );
  }

  Widget _buildRoleSection(BuildContext context, String title, List<PersonCard> rolePeople) {
    if (rolePeople.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: Fonts.outfit,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        
        const SizedBox(height: 16),
        ...rolePeople.map((personCard) => PersonCardWidget(
          person: personCard,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonDetailsPage(personId: personCard.id),
              ),
            );
          },
        )).toList(),
        const SizedBox(height: 24),
      ],
    );
  }
}
