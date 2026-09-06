import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:study_mate/fonts.dart';

class MixedMathText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double mathFontSize;

  const MixedMathText({
    super.key,
    required this.text,
    this.textStyle,
    this.mathFontSize = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = textStyle ?? TextStyle(fontFamily: Fonts.outfit);
    final regex = RegExp(r'\$\$(.*?)\$\$', dotAll: true);
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return Text(text, style: effectiveStyle);
    }

    // Gives every math span a real, bounded max-width to lay out against
    // instead of the infinite width Math.tex would otherwise claim.
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        final List<InlineSpan> spans = [];
        int lastMatchEnd = 0;

        for (final match in matches) {
          if (match.start > lastMatchEnd) {
            spans.add(
              TextSpan(
                text: text.substring(lastMatchEnd, match.start),
                style: effectiveStyle,
              ),
            );
          }

          final mathFormula = match.group(1)!.trim();
          spans.add(_buildMathSpan(mathFormula, effectiveStyle, availableWidth));

          lastMatchEnd = match.end;
        }

        if (lastMatchEnd < text.length) {
          spans.add(
            TextSpan(
              text: text.substring(lastMatchEnd),
              style: effectiveStyle,
            ),
          );
        }

        return Text.rich(
          TextSpan(style: effectiveStyle, children: spans),
          softWrap: true,
          overflow: TextOverflow.visible,
        );
      },
    );
  }

  InlineSpan _buildMathSpan(
    String formula,
    TextStyle effectiveStyle,
    double availableWidth,
  ) {
    try {
      return WidgetSpan(
        alignment: PlaceholderAlignment.middle, // NOT .baseline — see explanation
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: ConstrainedBox(
            // Hard ceiling on every math span, inline or not. Short
            // formulas never hit this cap, so visually nothing changes
            // for them. Long ones now can never exceed the line width.
            constraints: BoxConstraints(maxWidth: availableWidth),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Math.tex(
                formula,
                mathStyle: MathStyle.text, // inline size, not display/block size
                textStyle: TextStyle(
                  fontSize: mathFontSize,
                  color: effectiveStyle.color,
                  fontWeight: effectiveStyle.fontWeight,
                ),
                onErrorFallback: (err) => Text(
                  formula,
                  style: effectiveStyle.copyWith(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (_) {
      // Guards against synchronous parse-time exceptions Math.tex
      // doesn't route through onErrorFallback.
      return TextSpan(
        text: formula,
        style: effectiveStyle.copyWith(color: Colors.red),
      );
    }
  }
}