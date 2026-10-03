import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/AboutUs/Domain/PeopleCard.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/AboutUsBloc.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/AboutUsEvents.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/AboutUsStates.dart';
import 'package:study_mate/AboutUs/Presentation/Pages/PersonDetailsPage.dart';
import 'package:study_mate/AboutUs/Presentation/Widgets/PersonCardWidget.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: height*0.008,),
            _appBar(height, width, context),
            Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
            Expanded(
              child: BlocBuilder<Aboutusbloc, Aboutusstates>(
                builder: (context, state) {
                  if (state is AboutusInitialState || state is AboutUsLoading) {
                    return Center(child: LoadingLogo());
                  } else if (state is AboutUsLoaded) {
                    List<PersonCard> teachers = state.people.where((p) => p.peopleRole == PeopleRole.teacher).toList();
                    List<PersonCard> developers = state.people.where((p) => p.peopleRole == PeopleRole.developer).toList();
                    List<PersonCard> management = state.people.where((p) => p.peopleRole == PeopleRole.management).toList();

                    return RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<Aboutusbloc>(context).add(AboutusLoadData());
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _heroSection(height, width, context),
                            SizedBox(height: height*0.025,),
                            _offerSection(height, width, context),
                            SizedBox(height: height*0.03,),
                            Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,margin: EdgeInsets.symmetric(horizontal: width*0.05),),
                            SizedBox(height: height*0.03,),
                            _whoWeAreSection(height, width, context),
                            SizedBox(height: height*0.03,),
                            Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,margin: EdgeInsets.symmetric(horizontal: width*0.05),),
                            SizedBox(height: height*0.03,),
                            _teamHeader(height, width, context),
                            SizedBox(height: height*0.02,),
                            _roleSection(height, width, context, "TEACHERS", teachers),
                            _roleSection(height, width, context, "APP DEVELOPER", developers),
                            _roleSection(height, width, context, "MANAGEMENT", management),
                            SizedBox(height: height*0.08,),
                          ],
                        ),
                      ),
                    );
                  }
                  return Center(child: Text("Failed to load about us data", style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _appBar(double height,double width,BuildContext context){
  return Container(
    height: height*0.05,
    margin: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(LucideIcons.chevronLeft400Dir,size: Responsive.icon(context, 25),)),
        SizedBox(width: width*0.05,),
        Expanded(child: Text("About Us",style: TextStyle(color: Colors.black,fontFamily: Fonts.rubik,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),)),

      ],
    ),
  );
}

Widget _heroSection(double height,double width,BuildContext context){
  return Padding(
    padding: EdgeInsets.only(top: height*0.03,left: width*0.05,right: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Learn.",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 35),fontWeight: FontWeight.w600,color: Colors.black,height: 1.1),),
                  Text("Grow.",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 35),fontWeight: FontWeight.w600,color: Colors.green,height: 1.1),),
                  Row(
                    children: [
                      Text("Succeed",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 35),fontWeight: FontWeight.w600,color: Colors.black,height: 1.1),),
                      Text(".",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 35),fontWeight: FontWeight.w600,color: Colors.green,height: 1.1),),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(height: height*0.07,width: height*0.07,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Responsive.icon(context, 10)),color: const Color.fromRGBO(30, 30, 30, 1)),
                child: Icon(LucideIcons.zap,color: Colors.white,size: Responsive.icon(context, 30),)
                ),
                SizedBox(height: height*0.008,),
                Text("StudyMate",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),fontWeight: FontWeight.w600,color: Colors.black),),
              ],
            ),
            SizedBox(width: width*0.07,),
          ],
        ),
        SizedBox(height: height*0.012,),
        Text("StudyMate is an AI-powered platform for JEE and NEET preparation providing mock tests, contests, analytics, practice questions, and experienced teachers.",
        style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 11),color: const Color.fromRGBO(110, 110, 110, 1),height: 1.5),
        ),
      ],
    ),
  );
}

Widget _offerSection(double height,double width,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Wrap(
      spacing: width*0.03,runSpacing: width*0.03,
      children: [
        _offerTile(height, width, LucideIcons.notepadText400Dir, Colors.green, "Mock Tests", context),
        _offerTile(height, width, LucideIcons.swords400Dir, Colors.orange, "Contests", context),
        _offerTile(height, width, LucideIcons.brain400Dir, Colors.blue, "Practice Questions", context),
        _offerTile(height, width, LucideIcons.monitorPlay400Dir, Colors.red, "Lectures", context),
      ],
    ),
  );
}

Widget _offerTile(double height,double width,IconData icon,Color color,String name,BuildContext context){
  return Container(
    width: width*0.435,
    padding: EdgeInsets.symmetric(horizontal: width*0.03,vertical: height*0.012),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
      borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
    ),
    child: Row(
      children: [
        Container(height: height*0.04,width: height*0.04,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Responsive.icon(context, 3)),color: color.withValues(alpha: 0.1)),
        child: Icon(icon,color: color,size: Responsive.icon(context, 18),)
        ),
        SizedBox(width: width*0.025,),
        Expanded(child: Text(name,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 12),fontWeight: FontWeight.w600,color: Colors.black),)),
      ],
    ),
  );
}

Widget _whoWeAreSection(double height,double width,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Who ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 24),color: Colors.black),),
            Text("We ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 24),color: Colors.green),),
            Text("Are",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 24),color: Colors.black),),
            Text(".",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 24),color: Colors.green),),
          ],
        ),
        SizedBox(height: height*0.008,),
        Text("Founded with a mission to democratize quality education, StudyMate combines cutting-edge AI technology with the wisdom of industry-leading educators. We believe every student deserves a personalized roadmap to success.",
        style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 11),color: const Color.fromRGBO(110, 110, 110, 1),height: 1.5),
        ),
      ],
    ),
  );
}

Widget _teamHeader(double height,double width,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Meet ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 24),color: Colors.black),),
            Text("Our ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 24),color: Colors.green),),
            Text("Team",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 24),color: Colors.black),),
            Text(".",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 24),color: Colors.green),),
          ],
        ),
        Text("Learn from the industry's best minds",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 11),color: const Color.fromRGBO(110, 110, 110, 1)),),
      ],
    ),
  );
}

Widget _roleSection(double height,double width,BuildContext context,String title,List<PersonCard> people){
  if(people.isEmpty) return const SizedBox.shrink();

  return Padding(
    padding: EdgeInsets.only(left: width*0.05,right: width*0.05,bottom: height*0.02),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),fontWeight: FontWeight.bold,color: Colors.blueGrey,letterSpacing: 1),)),
            Text(people.length.toString(),style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),fontWeight: FontWeight.bold,color: Colors.green),),
          ],
        ),
        SizedBox(height: height*0.012,),
        ...people.map((personCard) => PersonCardWidget(
          person: personCard,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PersonDetailsPage(personId: personCard.id)));
          },
        )),
      ],
    ),
  );
}
