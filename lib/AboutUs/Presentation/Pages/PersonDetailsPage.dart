import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/AboutUs/Domain/Person.dart';
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

  const PersonDetailsPage({Key? key, required this.personId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonDetailsBloc(repo: sl())..add(LoadPersonDetailsEvent(personId: personId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Container(
                color: const Color.fromRGBO(220, 220, 220, 0.8),
                height: 1,
              ),
              Expanded(
                child: BlocBuilder<PersonDetailsBloc, PersonDetailsStates>(
                  builder: (context, state) {
                    if (state is PersonDetailsLoadingState) {
                      return  Center(child: LoadingLogo());
                    }
                    if (state is PersonDetailsErrorState) {
                      return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
                    }
                    if (state is PersonDetailsLoadedState) {
                      return _buildContent(state.person,context);
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child:  Icon(Icons.arrow_back_ios_new, size: Responsive.icon(context, 24), color: Colors.black),
          ),
          Text(
            "Teacher Details",
            style: TextStyle(
              color: Colors.black,
              fontFamily: Fonts.outfit,
              fontWeight: FontWeight.w600,
              fontSize: Responsive.font(context, 18),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Notificationpage())),
            child:  Icon(Icons.notifications_none_sharp, size: Responsive.icon(context, 24), color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Person person,BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PersonHeader(person: person),
          const SizedBox(height: 32),
          if (person.experience.isNotEmpty || person.yearsExperience > 0)
            ExperienceSection(person: person),
          if (person.experience.isNotEmpty || person.yearsExperience > 0)
            const SizedBox(height: 24),
          if (person.education.isNotEmpty)
            EducationSection(person: person),
          if (person.education.isNotEmpty)
            const SizedBox(height: 24),
          if (person.description.isNotEmpty) ...[
            _buildDescriptionSection(person.description,context),
            const SizedBox(height: 24),
          ],
          if (person.email.isNotEmpty || person.mobileNumber.isNotEmpty)
            ContactSection(person: person),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(String description,BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromRGBO(240, 240, 240, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child:  Icon(Icons.menu_book, color: Colors.green, size: Responsive.icon(context, 20)),
              ),
              const SizedBox(width: 12),
              Text(
                "About",
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontSize: Responsive.font(context, 18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontFamily: Fonts.nunito,
              fontSize: Responsive.font(context, 14),
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
