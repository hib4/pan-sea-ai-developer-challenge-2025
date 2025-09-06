import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/l10n/l10n.dart';

enum TimePeriod { day, week, month }

class TimePeriodSelectorWidget extends StatelessWidget {
  const TimePeriodSelectorWidget({
    required this.selectedPeriod,
    required this.onPeriodChanged,
    super.key,
  });

  final TimePeriod selectedPeriod;
  final ValueChanged<TimePeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: colors.primary[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildPeriodButton(
            context: context,
            period: TimePeriod.day,
            label: l10n.progressTimePeriodDay,
            isSelected: selectedPeriod == TimePeriod.day,
          ),
          _buildPeriodButton(
            context: context,
            period: TimePeriod.week,
            label: l10n.progressTimePeriodWeek,
            isSelected: selectedPeriod == TimePeriod.week,
          ),
          _buildPeriodButton(
            context: context,
            period: TimePeriod.month,
            label: l10n.progressTimePeriodMonth,
            isSelected: selectedPeriod == TimePeriod.month,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton({
    required BuildContext context,
    required TimePeriod period,
    required String label,
    required bool isSelected,
  }) {
    final colors = context.colors;

    return Expanded(
      child: GestureDetector(
        onTap: () => onPeriodChanged(period),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 68,
            minHeight: 40,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary[500] : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.lexend(
                color: isSelected ? colors.primary[50] : colors.primary[800],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
