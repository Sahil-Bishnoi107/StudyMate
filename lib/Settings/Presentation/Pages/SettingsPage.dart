import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Authentication/Presentation/Pages/onboarding_page.dart';
import 'package:study_mate/DependancyInjections.dart/service_locator.dart';
import 'package:study_mate/Settings/Presentation/Bloc/SettingsBloc.dart';
import 'package:study_mate/Settings/Presentation/Bloc/SettingsEvent.dart';
import 'package:study_mate/Settings/Presentation/Bloc/SettingsState.dart';
import 'package:study_mate/fonts.dart';
import 'package:study_mate/secure_storage.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) async {
        if (state is SettingsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error, style: const TextStyle(fontFamily: Fonts.outfit))),
          );
        } else if (state is SettingsSuccess) {
          await sl<SecureTokens>().clearTokens();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const OnboardingPage()), (route) => false);
          }
        }
      },
      builder: (context, state) {
        bool isLoading = state is SettingsLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: height*0.008,),
                    _appBar(height, width, context),
                    Container(color: const Color.fromRGBO(220, 220, 220, 0.8),height: 1,width: width,),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _headerSection(height, width, context),
                            SizedBox(height: height*0.03,),
                            _sectionLabel(height, width, "ACCOUNT", context),
                            SizedBox(height: height*0.012,),
                            InkWell(
                              onTap: () {
                                if (isLoading) return;
                                _showConfirmationDialog(context, "Logout", "Are you sure you want to log out?", "Logout", () {
                                  context.read<SettingsBloc>().add(LogoutRequested());
                                });
                              },
                              child: _settingsOption(height, width, LucideIcons.logOut400Dir, Colors.orange, "Logout", "Sign out of your account on this device", context),
                            ),
                            InkWell(
                              onTap: () {
                                if (isLoading) return;
                                _showConfirmationDialog(context, "Delete Account", "Are you sure you want to delete your account? This action cannot be undone.", "Delete", () {
                                  context.read<SettingsBloc>().add(DeleteAccountRequested());
                                });
                              },
                              child: _settingsOption(height, width, LucideIcons.trash2400Dir, Colors.red, "Delete Account", "Permanently remove your account and its data", context),
                            ),
                            SizedBox(height: height*0.05,),
                            _footer(height, width, context),
                            SizedBox(height: height*0.05,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  Container(
                    color: const Color.fromRGBO(255, 255, 255, 0.7),
                    child: const Center(child: CircularProgressIndicator(color: Colors.green,strokeWidth: 3,)),
                  ),
              ],
            ),
          ),
        );
      },
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
        Expanded(child: Text("Settings",style: TextStyle(color: Colors.black,fontFamily: Fonts.rubik,fontWeight: FontWeight.w600,fontSize: Responsive.font(context, 20)),)),
      ],
    ),
  );
}

Widget _headerSection(double height,double width,BuildContext context){
  return Padding(
    padding: EdgeInsets.only(top: height*0.015,left: width*0.05,right: width*0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Manage",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.black),),
            Text(" Your",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.green),),
            Text(" Account",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.black),),
            Text(".",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 26),fontWeight: FontWeight.w600,color: Colors.green),),
          ],
        ),
        Text("Control how you are signed in to StudyMate",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(110, 110, 110, 1)),),
      ],
    ),
  );
}

Widget _sectionLabel(double height,double width,String label,BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width*0.05),
    child: Text(label,style: TextStyle(fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 11),fontWeight: FontWeight.bold,color: Colors.blueGrey,letterSpacing: 1),),
  );
}

Widget _settingsOption(double height,double width,IconData icon,Color color,String title,String des,BuildContext context){
  return Container(
    margin: EdgeInsets.only(bottom: height*0.012,left: width*0.05,right: width*0.05),
    padding: EdgeInsets.symmetric(horizontal: width*0.04,vertical: height*0.012),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
      borderRadius: BorderRadius.circular(Responsive.icon(context, 3))
    ),
    child: Row(
      children: [
        Container(height: height*0.045,width: height*0.045,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Responsive.icon(context, 3)),color: color.withValues(alpha: 0.1)),
        child: Icon(icon,color: color,size: Responsive.icon(context, 20),)
        ),
        SizedBox(width: width*0.035,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),fontWeight: FontWeight.w600,color: Colors.black),),
              Text(des,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(110, 110, 110, 1)),)
            ],
          ),
        ),
        Icon(LucideIcons.chevronRight400Dir,size: Responsive.icon(context, 18),color: const Color.fromRGBO(120, 120, 120, 1),),
      ],
    ),
  );
}

Widget _footer(double height,double width,BuildContext context){
  return SizedBox(
    width: width,
    child: Column(
      children: [
        Container(height: height*0.05,width: height*0.05,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Responsive.icon(context, 10)),color: const Color.fromRGBO(30, 30, 30, 1)),
        child: Icon(LucideIcons.zap,color: Colors.white,size: Responsive.icon(context, 22),)
        ),
        SizedBox(height: height*0.008,),
        Text("StudyMate",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 14),fontWeight: FontWeight.w600,color: Colors.black),),
        Text("Smarter Learning, One test at a time",style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 10),color: const Color.fromRGBO(110, 110, 110, 1)),),
      ],
    ),
  );
}

void _showConfirmationDialog(BuildContext context,String title,String content,String confirmText,VoidCallback onConfirm){
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.icon(context, 3))),
        child: Padding(
          padding: EdgeInsets.all(width*0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 18),fontWeight: FontWeight.w600,color: Colors.black),),
              SizedBox(height: height*0.006,),
              Text(content,style: TextStyle(fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 12),color: const Color.fromRGBO(110, 110, 110, 1),height: 1.4),),
              SizedBox(height: height*0.025,),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        height: height*0.045,
                        decoration: BoxDecoration(color: Colors.white,border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),borderRadius: BorderRadius.circular(Responsive.icon(context, 3))),
                        child: Center(child: Text("Cancel",style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,color: Colors.black,fontSize: Responsive.font(context, 13)),)),
                      ),
                    ),
                  ),
                  SizedBox(width: width*0.03,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        onConfirm();
                      },
                      child: Container(
                        height: height*0.045,
                        decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(Responsive.icon(context, 3))),
                        child: Center(child: Text(confirmText,style: TextStyle(fontFamily: Fonts.nunito,fontWeight: FontWeight.bold,color: Colors.white,fontSize: Responsive.font(context, 13)),)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
