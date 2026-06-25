import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_bloc.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/regirster_bloc.dart';
import 'package:study_mate/Authentication/Presentation/Pages/AutoLoginPage.dart';
import 'package:study_mate/Home/Presentation/Bloc/HomeBloc.dart';
import 'package:study_mate/Home/Presentation/Bloc/homeEvents.dart';
import 'package:study_mate/Test/Presentation/Bloc/test_bloc.dart';
import 'package:study_mate/TestsPage/Presentation/Bloc/TestBloc.dart';
import 'package:study_mate/TestsPage/Presentation/Bloc/TestEvents.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(       
          create: (context) => Homebloc()..add(HomeProfileRequested())),
        BlocProvider(create: (context) => RegisterBloc()),
        BlocProvider(create: (context) => TestPageBloc()..add(TestsDataLoaded())),
         
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Autologinpage(),
      ),
    );
  }
}