import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/PersonDetailsBloc.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/PersonDetailsEvents.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/PersonDetailsStates.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/AboutUs/Presentation/Widgets/ContactSection.dart';
import 'package:study_mate/AboutUs/Presentation/Widgets/ExperienceSection.dart';
import 'package:study_mate/AboutUs/Presentation/Widgets/PersonHeader.dart';
import 'package:study_mate/AboutUs/Presentation/Widgets/EducationSection.dart';
import 'package:study_mate/LoadingScreen/LoadingAnimations.dart';
import 'package:study_mate/Notifications/Presentation/Pages/NotificationPage.dart';
import 'package:study_mate/fonts.dart';

class PersonDetailsPage extends StatelessWidget {
  final String personId;

  const PersonDetailsPage({super.key, required this.personId});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => PersonDetailsBloc(repo: sl())..add(LoadPersonDetailsEvent(personId: personId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: height*0.008,),
              _appBar(height, width, context),
              Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
              Expanded(
                child: BlocBuilder<PersonDetailsBloc, PersonDetailsStates>(
                  builder: (context, state) {
                    if (state is PersonDetailsLoadingState) {
                      return Center(child: LoadingLogo());
                    }
                    if (state is PersonDetailsErrorState) {
                      return Center(child: Text(state.message, style: TextStyle(color: Colors.red, fontFamily: Fonts.nunito)));
                    }
                    if (state is PersonDetailsLoadedState) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PersonHeader(person: state.person),
                            if (state.person.description.isNotEmpty) ...[
                              _divider(height, width),
                              _aboutSection(height, width, state.person.description, context),
                            ],
                            if (state.person.experience.isNotEmpty) ...[
                              _divider(height, width),
                              ExperienceSection(person: state.person),
                            ],
                            if (state.person.education.isNotEmpty) ...[
                              _divider(height, width),
                              EducationSection(person: state.person),
                            ],
                            if (state.person.email.isNotEmpty || state.person.mobileNumber.isNotEmpty) ...[
                              _divider(height, width),
                              ContactSection(person: state.person),
                            ],
                            SizedBox(height: height*0.08,),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
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
        Expanded(child: Text("Team Member",style: TextStyle(color: Colors.black,fontFamily: Fonts.rubik,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),)),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Notificationpage())),
          child: Icon(Icons.notifications_none_sharp))
      ],
    ),
  );
}

Widget _divider(double height,double width){
  return Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,margin: EdgeInsets.symmetric(horizontal: width*0.05,vertical: height*0.03),);
}

Widget _aboutSection(double height,double width,String description,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.bookOpen400Dir,size: Responsive.icon(context, 20),),
            const SizedBox(width: 8),
            Text("About ",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.green),),
            Text("Me",style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w700,fontSize: Responsive.font(context, 18),color: Colors.black),),
          ],
        ),
        SizedBox(height: height*0.01,),
        Text(description,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 12),color: const Color.fromRGBO(110, 110, 110, 1),height: 1.5),),
      ],
    ),
  );
}
