import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/AboutUsBloc.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_bloc.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/regirster_bloc.dart';
import 'package:study_mate/Authentication/Presentation/Pages/AutoLoginPage.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestBloc.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/Home/Presentation/Bloc/HomeBloc.dart';
import 'package:study_mate/Notifications/Presentation/Bloc/NotificationBloc.dart';
import 'package:study_mate/Profile/Presentation/Bloc/ProfileBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/MyQuestionsBloc/MyQuestionsBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsBloc.dart';

import 'package:study_mate/QuestionsSection/Presentation/FiltersBloc/FilterBloc.dart';
import 'package:study_mate/TestsPage/Presentation/Bloc/TestBloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestPage/ContestPageBloc.dart';
import 'package:study_mate/Settings/Presentation/Bloc/SettingsBloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/LecturesPage/LecturesPageBloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<Homebloc>()),
        BlocProvider(create: (context) => sl<RegisterBloc>()),
        BlocProvider(create: (context) => sl<TestPageBloc>()),
        BlocProvider(create: (context) => sl<FilterBloc>()),
        BlocProvider(create: (context) => sl<MyQuestionsBloc>()),
        BlocProvider(create: (context) => sl<ContestPageBloc>()),
        BlocProvider(create: (context) => sl<Profilebloc>()),
        BlocProvider(create: (context) => sl<MyContestBloc>()),
        BlocProvider(create: (context) => sl<SettingsBloc>()),
        BlocProvider(create: (context) => sl<LecturesPageBloc>()),
        BlocProvider(create: (context) => sl<NotificationBloc>()),
        BlocProvider(create: (context) => sl<Aboutusbloc>()),
        BlocProvider(create: (context) => sl<Questionsbloc>())
         
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Autologinpage(),
      ),
    );
  }
}