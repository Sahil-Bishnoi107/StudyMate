import 'package:flutter/material.dart';
import 'package:study_mate/AboutUs/Domain/PeopleCard.dart';
import 'package:study_mate/fonts.dart';

class PersonCardWidget extends StatelessWidget {
  final PersonCard person;
  final VoidCallback onTap;

  const PersonCardWidget({
    Key? key,
    required this.person,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color.fromRGBO(240, 240, 240, 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipOval(
              child: person.photoUrl.isNotEmpty
                  ? Image.network(
                      person.photoUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                           Icon(Icons.person, color: Colors.grey, size: Responsive.icon(context, 60)),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child:  Icon(Icons.person, color: Colors.grey, size: Responsive.icon(context, 40)),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name,
                    style: TextStyle(
                      fontFamily: Fonts.outfit,
                      fontSize: Responsive.font(context, 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    person.roleTitle,
                    style: TextStyle(
                      fontFamily: Fonts.nunito,
                      fontSize: Responsive.font(context, 13),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
