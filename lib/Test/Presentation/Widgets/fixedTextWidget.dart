import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class MixedMathText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double mathFontSize;

  const MixedMathText({
    Key? key,
    required this.text,
    this.textStyle,
    this.mathFontSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Regex to match blocks enclosed in $$ ... $$
    final regex = RegExp(r'\$\$(.*?)\$\$', dotAll: true);
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      // If there's no math block, render it as standard text
      return Text(text, style: textStyle);
    }

    List<Widget> inlineWidgets = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      // 1. Extract and add preceding normal text segment
      if (match.start > lastMatchEnd) {
        String normalText = text.substring(lastMatchEnd, match.start);
        inlineWidgets.add(
          Text(
            normalText,
            style: textStyle,
          ),
        );
      }

      // 2. Extract the raw math string inside the $$ delimiters
      String mathFormula = match.group(1)!.trim();

      // 3. Add the Math widget
      inlineWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Math.tex(
            mathFormula,
            textStyle: TextStyle(fontSize: mathFontSize),
            mathStyle: MathStyle.display,
            onErrorFallback: (err) => Text(
              mathFormula, 
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    // 4. Add any remaining trailing text segment
    if (lastMatchEnd < text.length) {
      String trailingText = text.substring(lastMatchEnd);
      inlineWidgets.add(
        Text(
          trailingText,
          style: textStyle,
        ),
      );
    }

    // Wrap allows inline mixing without forcing a vertical block layout
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: inlineWidgets,
    );
  }
}