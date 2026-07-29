import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:study_mate/Authentication/Data/AuthRepo.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/auth_bloc.dart';
import 'package:study_mate/Authentication/Presentation/Bloc/regirster_bloc.dart';
import 'package:study_mate/Contest/Presentation/Bloc/MyContest/MyContestBloc.dart';
import 'package:study_mate/Home/Data/HomeData.dart';
import 'package:study_mate/Home/Presentation/Bloc/HomeBloc.dart';
import 'package:study_mate/Networking/dio_client.dart';
import 'package:study_mate/Notifications/Data/NotificationData.dart';
import 'package:study_mate/Notifications/Presentation/Bloc/NotificationBloc.dart';
import 'package:study_mate/Profile/Data/ProfileRepo.dart';
import 'package:study_mate/Profile/Presentation/Bloc/ProfileBloc.dart';
import 'package:study_mate/QuestionsSection/Data/QuestionsRepo.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/MyQuestionsBloc/MyQuestionsBloc.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/QuestionsBloc.dart';
import 'package:study_mate/Test/Data/test_repo.dart';
import 'package:study_mate/Test/Presentation/Bloc/test_bloc.dart';
import 'package:study_mate/TestsPage/Data/testdata.dart';
import 'package:study_mate/TestsPage/Presentation/Bloc/TestBloc.dart';
import 'package:study_mate/secure_storage.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestPage/ContestPageBloc.dart';
import 'package:study_mate/Settings/Data/SettingsRepo.dart';
import 'package:study_mate/Settings/Presentation/Bloc/SettingsBloc.dart';

final sl = GetIt.instance;

Future<void> setup()async {
  sl.registerLazySingleton<Dio>(() => DioClient().dio);


  sl.registerLazySingleton<SecureTokens>(() => SecureTokens());

  sl.registerLazySingleton<AuthRepo>(() => AuthRepo(sl<Dio>()));
  sl.registerLazySingleton<Homedata>(() => Homedata(sl<Dio>()));
  sl.registerLazySingleton<TestPageData>(() => TestPageData(sl<Dio>()));
  sl.registerLazySingleton<TestRepo>(() => TestRepo(sl<Dio>()));
  sl.registerLazySingleton<QuestionsRepo>(() => QuestionsRepo(sl<Dio>()));
  sl.registerLazySingleton<ContestRepo>(() => ContestRepo(sl<Dio>()));
  sl.registerLazySingleton<ProfileRepo>(() => ProfileRepo(sl<Dio>()));
  sl.registerLazySingleton<SettingsRepo>(() => SettingsRepo(sl<Dio>()));
  sl.registerCachedFactory<Notificationdata>(() => Notificationdata(sl<Dio>()));
  // what this means is that whenevr someone asks for the object in <object> give them the object () => object, so whenever we need AuthBloc it recivers the bloc created from here and so on

  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl<AuthRepo>()));
  sl.registerLazySingleton<RegisterBloc>(() => RegisterBloc(sl<AuthRepo>()));
  sl.registerLazySingleton<Homebloc>(() => Homebloc(sl<Homedata>()));
  sl.registerLazySingleton<TestPageBloc>(() => TestPageBloc(sl<TestPageData>()));
  sl.registerLazySingleton<TestBloc>(() => TestBloc(sl<TestRepo>()));
  sl.registerLazySingleton<Questionsbloc>(() => Questionsbloc(sl<QuestionsRepo>()));
  sl.registerLazySingleton<MyQuestionsBloc>(() => MyQuestionsBloc(sl<QuestionsRepo>()));
  sl.registerLazySingleton<ContestPageBloc>(() => ContestPageBloc(sl<ContestRepo>()));
  sl.registerLazySingleton<Profilebloc>(() => Profilebloc(sl<ProfileRepo>())); 
  sl.registerLazySingleton<MyContestBloc>(() => MyContestBloc(sl<ContestRepo>()));
  sl.registerLazySingleton<SettingsBloc>(() => SettingsBloc(sl<SettingsRepo>()));
  sl.registerLazySingleton<NotificationBloc>(() => NotificationBloc(sl<Notificationdata>()));
}