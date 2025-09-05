import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/utils/utils.dart';

class MoralValuesCardWidget extends StatelessWidget {
  const MoralValuesCardWidget({
    required this.level,
    required this.values,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    super.key,
  });

  final String level;
  final String values;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.primary[50],
        border: Border.all(
          width: 2,
          color: colors.primary[500]!,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            level,
            style: GoogleFonts.fredoka(
              color: colors.secondary[900],
              fontSize: 21,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          4.vertical,
          Text(
            values,
            style: GoogleFonts.lexend(
              color: colors.secondary[800],
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
