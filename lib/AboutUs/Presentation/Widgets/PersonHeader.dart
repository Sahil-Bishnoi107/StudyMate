import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/AboutUs/Domain/Person.dart';
import 'package:study_mate/fonts.dart';

class PersonHeader extends StatelessWidget {
  final Person person;

  const PersonHeader({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.7)),
            borderRadius: BorderRadius.circular(100)
          ),
          child: ClipOval(
            child: person.photoUrl.isNotEmpty
                ? Image.network(
                    person.photoUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                         Icon(Icons.person, color: Colors.grey, size: Responsive.icon(context, 120)),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(LucideIcons.zap,color: Color.fromRGBO(158, 158, 158, 0.8),),
                        ),
                      );
                    },
                  )
                : Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[200],
                    child:  Icon(Icons.person, color: Colors.grey, size: Responsive.icon(context, 80)),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          person.name,
          style: TextStyle(
            fontFamily: Fonts.outfit,
            fontSize: Responsive.font(context, 24),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          person.roleTitle,
          style: TextStyle(
            fontFamily: Fonts.nunito,
            fontSize: Responsive.font(context, 16),
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
