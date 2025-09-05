import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/utils/utils.dart';

class ProgressCardWidget extends StatelessWidget {
  const ProgressCardWidget({
    required this.icon,
    required this.value,
    required this.label,
    super.key,
  });

  final Widget icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: colors.primary[50],
        border: Border.all(
          width: 2,
          color: colors.primary[500]!,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          6.vertical,
          Text(
            value,
            style: GoogleFonts.fredoka(
              color: colors.grey[700],
              fontSize: 27,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: GoogleFonts.lexend(
              color: colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
