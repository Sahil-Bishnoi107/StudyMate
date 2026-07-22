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
  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Text(title, style: const TextStyle(fontFamily: Fonts.outfit, fontWeight: FontWeight.w600)),
          content: Text(content, style: const TextStyle(fontFamily: Fonts.nunito, fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel", style: TextStyle(fontFamily: Fonts.outfit, color: Colors.blueGrey, fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onConfirm();
              },
              child: const Text("Confirm", style: TextStyle(fontFamily: Fonts.outfit, color: Colors.red, fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  Widget _settingsOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
   
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontFamily: Fonts.outfit,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const Spacer(),
            const Icon(LucideIcons.chevronRight300Dir, color: Colors.grey, size: 24),
           
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context, double height, double width) {
    return SizedBox(
      height: height * 0.05,
      child: Row(
        children: [
          SizedBox(width: width * 0.03),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(LucideIcons.chevronLeft300Dir, size: 30),
          ),
          SizedBox(width: width * 0.03),
          const Text(
            "Settings",
            style: TextStyle(
              fontFamily: Fonts.outfit,
              fontWeight: FontWeight.w400,
              fontSize: 21,
            ),
          )
        ],
      ),
    );
  }

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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingPage()),
              (route) => false,
            );
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
                     SizedBox(height: height*0.01,),
                    _appBar(context, height, width),
                    Container(height:1.5, width : width, color: const Color.fromRGBO(220, 220, 220, 0.8),),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            _settingsOption(
                              context: context,
                              icon: LucideIcons.logOut,
                              title: "Logout",
                              color: Colors.black,
                              onTap: () {
                                if (isLoading) return;
                                _showConfirmationDialog(
                                  context,
                                  "Logout",
                                  "Are you sure you want to log out?",
                                  () {
                                    context.read<SettingsBloc>().add(LogoutRequested());
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 5),
                            // Container(height: 1,width: width,color: const Color.fromRGBO(220, 220, 220, 1),),
                            _settingsOption(
                              context: context,
                              icon: LucideIcons.trash2,
                              title: "Delete Account",
                              color: Colors.black,
                              onTap: () {
                                if (isLoading) return;
                                _showConfirmationDialog(
                                  
                                  context,
                                  "Delete Account",
                                  "Are you sure you want to delete your account? This action cannot be undone.",
                                  () {
                                    context.read<SettingsBloc>().add(DeleteAccountRequested());
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}