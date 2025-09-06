import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/progress/progress.dart';

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
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1.4,
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: LineChart(
              _mainData(),
            ),
          ),
        ),
        // Positioned(
        //   top: 8,
        //   right: 8,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: colors.primary[50],
        //       borderRadius: BorderRadius.circular(8),
        //       border: Border.all(
        //         color: colors.primary[200]!,
        //         width: 1,
        //       ),
        //     ),
        //     child: TextButton(
        //       onPressed: () {
        //         setState(() {
        //           showAvg = !showAvg;
        //         });
        //       },
        //       style: TextButton.styleFrom(
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 12,
        //           vertical: 4,
        //         ),
        //         minimumSize: const Size(0, 0),
        //       ),
        //       child: Text(
        //         showAvg ? 'Data' : 'Avg',
        //         style: GoogleFonts.lexend(
        //           fontSize: 12,
        //           fontWeight: FontWeight.w500,
        //           color: showAvg ? colors.primary[800] : colors.primary[600],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    final colors = context.colors;
    final style = GoogleFonts.lexend(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: colors.grey[600],
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
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: colors.grey[600],
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

  LineChartData _avgData() {
    final colors = context.colors;
    final avgValue = _calculateAverage();
    final gradientColors = [
      colors.secondary[300]!,
      colors.secondary[500]!,
    ];

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: _getMaxYValue() / 5,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: colors.grey[200],
            strokeWidth: 0.5,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: colors.grey[200],
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: _bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: _leftTitleWidgets,
            reservedSize: 42,
            interval: _getMaxYValue() / 5,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
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
          spots: _getAverageSpots(avgValue),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.1))
                  .toList(),
            ),
          ),
        ),
      ],
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
      // Daily playing minutes data (in minutes, converted to chart scale)
      return const [
        FlSpot.zero,
        FlSpot(2, 15), // 15 minutes
        FlSpot(4, 28), // 28 minutes
        FlSpot(6, 35), // 35 minutes
        FlSpot(8, 32), // 32 minutes
        FlSpot(10, 42), // 42 minutes
        FlSpot(12, 38), // 38 minutes
        FlSpot(14, 45), // 45 minutes
        FlSpot(16, 30), // 30 minutes (current)
        FlSpot(18, 0),
        FlSpot(20, 0),
        FlSpot(22, 0),
        FlSpot(24, 0),
      ];
    } else {
      // Daily success rate data (in percentage)
      return const [
        FlSpot.zero,
        FlSpot(2, 85),
        FlSpot(4, 88),
        FlSpot(6, 92),
        FlSpot(8, 87),
        FlSpot(10, 95),
        FlSpot(12, 90),
        FlSpot(14, 93),
        FlSpot(16, 90), // Current
        FlSpot(18, 0),
        FlSpot(20, 0),
        FlSpot(22, 0),
        FlSpot(24, 0),
      ];
    }
  }

  List<FlSpot> _getWeekData() {
    if (widget.chartType == ProgressChartType.playingMinutes) {
      // Weekly playing minutes data (converted to hours on chart scale)
      return const [
        FlSpot(0, 45), // 45 minutes (Monday)
        FlSpot(1, 65), // 1h 5m (Tuesday)
        FlSpot(2, 90), // 1h 30m (Wednesday)
        FlSpot(3, 120), // 2h (Thursday)
        FlSpot(4, 105), // 1h 45m (Friday)
        FlSpot(5, 135), // 2h 15m (Saturday)
        FlSpot(6, 180), // 3h (Sunday - current week total: 3h 45m)
      ];
    } else {
      // Weekly success rate data
      return const [
        FlSpot(0, 88), // Monday
        FlSpot(1, 92), // Tuesday
        FlSpot(2, 87), // Wednesday
        FlSpot(3, 90), // Thursday
        FlSpot(4, 85), // Friday
        FlSpot(5, 89), // Saturday
        FlSpot(6, 85), // Sunday (current: 85%)
      ];
    }
  }

  List<FlSpot> _getMonthData() {
    if (widget.chartType == ProgressChartType.playingMinutes) {
      // Monthly playing minutes data (in hours, scaled)
      return const [
        FlSpot(0, 180), // Week 1: 3h
        FlSpot(7, 240), // Week 2: 4h
        FlSpot(14, 320), // Week 3: 5h 20m
        FlSpot(21, 280), // Week 4: 4h 40m
        FlSpot(28, 300), // Week 5: 5h (current total: ~15h 20m)
      ];
    } else {
      // Monthly success rate data
      return const [
        FlSpot(0, 85), // Week 1
        FlSpot(7, 88), // Week 2
        FlSpot(14, 82), // Week 3
        FlSpot(21, 87), // Week 4
        FlSpot(28, 80), // Week 5 (current: 80%)
      ];
    }
  }

  List<FlSpot> _getAverageSpots(double avgValue) {
    final maxX = _getMaxXValue();
    return List.generate(
      (maxX ~/ 2) + 1,
      (index) => FlSpot(index * 2.0, avgValue),
    );
  }

  double _calculateAverage() {
    final spots = _getDataSpots();
    final values = spots
        .where((spot) => spot.y > 0)
        .map((spot) => spot.y)
        .toList();
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  double _getMaxXValue() {
    switch (widget.selectedPeriod) {
      case TimePeriod.day:
        return 24; // 24 hours
      case TimePeriod.week:
        return 6; // 7 days (0-6)
      case TimePeriod.month:
        return 28; // ~4 weeks
    }
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
    switch (widget.selectedPeriod) {
      case TimePeriod.day:
        return [
          '00',
          '02',
          '04',
          '06',
          '08',
          '10',
          '12',
          '14',
          '16',
          '18',
          '20',
          '22',
          '24',
        ];
      case TimePeriod.week:
        return ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
      case TimePeriod.month:
        return List.generate(29, (index) => '${index + 1}');
    }
  }

  List<int> _getBottomLabelIntervals() {
    switch (widget.selectedPeriod) {
      case TimePeriod.day:
        return [0, 4, 8, 12, 16, 20, 24]; // Every 4 hours
      case TimePeriod.week:
        return [0, 1, 2, 3, 4, 5, 6]; // Every day
      case TimePeriod.month:
        return [0, 7, 14, 21, 28]; // Every week
    }
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
