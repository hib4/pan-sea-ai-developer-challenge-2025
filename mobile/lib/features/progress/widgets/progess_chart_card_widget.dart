import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/progress/progress.dart';

class ProgressChartCardWidget extends StatelessWidget {
  const ProgressChartCardWidget({
    required this.date,
    required this.data,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.chartType,
    super.key,
  });

  final String date;
  final String data;
  final TimePeriod selectedPeriod;
  final ValueChanged<TimePeriod> onPeriodChanged;
  final ProgressChartType chartType;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.neutral[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: GoogleFonts.fredoka(
                        color: colors.grey[300],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      data,
                      style: GoogleFonts.lexend(
                        color: colors.grey[500],
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: TimePeriodSelectorWidget(
                  selectedPeriod: selectedPeriod,
                  onPeriodChanged: onPeriodChanged,
                ),
              ),
            ],
          ),
          // Add the chart below the header
          ProgressLineChartWidget(
            chartType: chartType,
            selectedPeriod: selectedPeriod,
          ),
        ],
      ),
    );
  }
}
