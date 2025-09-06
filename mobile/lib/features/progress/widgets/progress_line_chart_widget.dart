import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/progress/progress.dart';
import 'package:kanca/l10n/l10n.dart';

class ProgressLineChartWidget extends StatefulWidget {
  const ProgressLineChartWidget({
    required this.chartType,
    required this.selectedPeriod,
    super.key,
  });

  final ProgressChartType chartType;
  final TimePeriod selectedPeriod;

  @override
  State<ProgressLineChartWidget> createState() =>
      _ProgressLineChartWidgetState();
}

class _ProgressLineChartWidgetState extends State<ProgressLineChartWidget> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: LineChart(
          _mainData(),
        ),
      ),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    final colors = context.colors;
    final style = GoogleFonts.lexend(
      color: colors.grey[300],
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    Widget text = const SizedBox.shrink();

    // Get labels based on period and chart type
    final labels = _getBottomLabels();
    final index = value.toInt();

    if (index >= 0 && index < labels.length) {
      final intervals = _getBottomLabelIntervals();
      if (intervals.contains(index)) {
        text = Text(labels[index], style: style);
      }
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    final colors = context.colors;
    final style = GoogleFonts.lexend(
      color: colors.grey[300],
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    String text = '';
    final maxValue = _getMaxYValue();
    final interval = maxValue / 5;

    if (widget.chartType == ProgressChartType.playingMinutes) {
      // For playing minutes, show time values
      if (value == interval)
        text = widget.selectedPeriod == TimePeriod.day
            ? '10m'
            : widget.selectedPeriod == TimePeriod.week
            ? '1h'
            : '5h';
      else if (value == interval * 2)
        text = widget.selectedPeriod == TimePeriod.day
            ? '20m'
            : widget.selectedPeriod == TimePeriod.week
            ? '2h'
            : '10h';
      else if (value == interval * 3)
        text = widget.selectedPeriod == TimePeriod.day
            ? '30m'
            : widget.selectedPeriod == TimePeriod.week
            ? '3h'
            : '15h';
      else if (value == interval * 4)
        text = widget.selectedPeriod == TimePeriod.day
            ? '40m'
            : widget.selectedPeriod == TimePeriod.week
            ? '4h'
            : '20h';
      else if (value == maxValue)
        text = widget.selectedPeriod == TimePeriod.day
            ? '50m'
            : widget.selectedPeriod == TimePeriod.week
            ? '5h'
            : '25h';
    } else {
      // For success rate, show percentage
      if (value == interval)
        text = '20%';
      else if (value == interval * 2)
        text = '40%';
      else if (value == interval * 3)
        text = '60%';
      else if (value == interval * 4)
        text = '80%';
      else if (value == maxValue)
        text = '100%';
    }

    if (text.isEmpty) return const SizedBox.shrink();

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData _mainData() {
    final colors = context.colors;
    final gradientColors = [
      colors.primary[400]!,
      colors.primary[600]!,
    ];

    return LineChartData(
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: _bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _getMaxYValue() / 5,
            getTitlesWidget: _leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(
          color: colors.grey[300]!,
          width: 1,
        ),
      ),
      minX: 0,
      maxX: _getMaxXValue(),
      minY: 0,
      maxY: _getMaxYValue(),
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          spots: _getDataSpots(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                  radius: 4,
                  color: colors.primary[500]!,
                  strokeWidth: 2,
                  strokeColor: colors.neutral[500]!,
                ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.15))
                  .toList(),
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          aboveBarData: BarAreaData(show: false),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) =>
              colors.primary[500]!.withOpacity(0.9),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final value = touchedSpot.y;
              final label = widget.chartType == ProgressChartType.playingMinutes
                  ? _formatMinutesTooltip(value)
                  : '${value.toInt()}%';

              return LineTooltipItem(
                label,
                GoogleFonts.lexend(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
    );
  }

  List<FlSpot> _getDataSpots() {
    switch (widget.selectedPeriod) {
      case TimePeriod.day:
        return _getDayData();
      case TimePeriod.week:
        return _getWeekData();
      case TimePeriod.month:
        return _getMonthData();
    }
  }

  List<FlSpot> _getDayData() {
    if (widget.chartType == ProgressChartType.playingMinutes) {
      // Daily playing minutes data aggregated by day of week
      return const [
        FlSpot(0, 35), // Monday - 35 minutes
        FlSpot(1, 42), // Tuesday - 42 minutes
        FlSpot(2, 28), // Wednesday - 28 minutes
        FlSpot(3, 45), // Thursday - 45 minutes
        FlSpot(4, 30), // Friday - 30 minutes (current)
        FlSpot(5, 38), // Saturday - 38 minutes
        FlSpot(6, 25), // Sunday - 25 minutes
      ];
    } else {
      // Daily success rate data by day of week
      return const [
        FlSpot(0, 92), // Monday - 92%
        FlSpot(1, 88), // Tuesday - 88%
        FlSpot(2, 95), // Wednesday - 95%
        FlSpot(3, 87), // Thursday - 87%
        FlSpot(4, 90), // Friday - 90% (current)
        FlSpot(5, 85), // Saturday - 85%
        FlSpot(6, 93), // Sunday - 93%
      ];
    }
  }

  List<FlSpot> _getWeekData() {
    if (widget.chartType == ProgressChartType.playingMinutes) {
      // Weekly playing minutes data (converted to minutes for consistency)
      return const [
        FlSpot(0, 45), // Monday - 45 minutes
        FlSpot(1, 65), // Tuesday - 1h 5m = 65 minutes
        FlSpot(2, 90), // Wednesday - 1h 30m = 90 minutes
        FlSpot(3, 120), // Thursday - 2h = 120 minutes
        FlSpot(4, 105), // Friday - 1h 45m = 105 minutes
        FlSpot(5, 135), // Saturday - 2h 15m = 135 minutes
        FlSpot(6, 180), // Sunday - 3h = 180 minutes
      ];
    } else {
      // Weekly success rate data
      return const [
        FlSpot(0, 88), // Monday - 88%
        FlSpot(1, 92), // Tuesday - 92%
        FlSpot(2, 87), // Wednesday - 87%
        FlSpot(3, 90), // Thursday - 90%
        FlSpot(4, 85), // Friday - 85%
        FlSpot(5, 89), // Saturday - 89%
        FlSpot(6, 85), // Sunday - 85% (current)
      ];
    }
  }

  List<FlSpot> _getMonthData() {
    if (widget.chartType == ProgressChartType.playingMinutes) {
      // Monthly playing minutes data (average per day of week over the month)
      return const [
        FlSpot(0, 180), // Monday average - 3h = 180 minutes
        FlSpot(1, 240), // Tuesday average - 4h = 240 minutes
        FlSpot(2, 320), // Wednesday average - 5h 20m = 320 minutes
        FlSpot(3, 280), // Thursday average - 4h 40m = 280 minutes
        FlSpot(4, 300), // Friday average - 5h = 300 minutes
        FlSpot(5, 220), // Saturday average - 3h 40m = 220 minutes
        FlSpot(6, 260), // Sunday average - 4h 20m = 260 minutes
      ];
    } else {
      // Monthly success rate data (average per day of week)
      return const [
        FlSpot(0, 85), // Monday average - 85%
        FlSpot(1, 88), // Tuesday average - 88%
        FlSpot(2, 82), // Wednesday average - 82%
        FlSpot(3, 87), // Thursday average - 87%
        FlSpot(4, 80), // Friday average - 80% (current)
        FlSpot(5, 83), // Saturday average - 83%
        FlSpot(6, 86), // Sunday average - 86%
      ];
    }
  }

  double _getMaxXValue() {
    // Always return 6 to show 7 days (0-6) regardless of time period
    return 6;
  }

  double _getMaxYValue() {
    if (widget.chartType == ProgressChartType.playingMinutes) {
      switch (widget.selectedPeriod) {
        case TimePeriod.day:
          return 50; // 50 minutes max
        case TimePeriod.week:
          return 200; // ~3h 20m max
        case TimePeriod.month:
          return 350; // ~6h max
      }
    } else {
      return 100; // 100% max for success rate
    }
  }

  List<String> _getBottomLabels() {
    // Always return day names regardless of time period
    final l10n = context.l10n;
    return [
      l10n.progressDayMonday,
      l10n.progressDayTuesday,
      l10n.progressDayWednesday,
      l10n.progressDayThursday,
      l10n.progressDayFriday,
      l10n.progressDaySaturday,
      l10n.progressDaySunday,
    ];
  }

  List<int> _getBottomLabelIntervals() {
    // Always return all 7 days (0-6) regardless of time period
    return [0, 1, 2, 3, 4, 5, 6];
  }

  String _formatMinutesTooltip(double value) {
    final minutes = value.round();
    if (minutes < 60) {
      return '${minutes}m';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${remainingMinutes}m';
      }
    }
  }
}

enum ProgressChartType {
  playingMinutes,
  successRate,
}
