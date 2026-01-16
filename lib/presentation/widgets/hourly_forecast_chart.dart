import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/forecast.dart';
import 'glass_container.dart';

class HourlyForecastChart extends StatelessWidget {
  final List<ForecastItemEntity> items;

  const HourlyForecastChart({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // 1. Prepare Data: Take next 24 hours (8 items * 3h = 24h)
    // Actually let's take more to make it scrollable, say 12 items (36h)
    final chartItems = items.take(12).toList();
    if (chartItems.isEmpty) return const SizedBox.shrink();

    // 2. Find Min/Max for Y-Axis
    double minTemp = chartItems[0].temperature;
    double maxTemp = chartItems[0].temperature;
    for (var item in chartItems) {
      if (item.temperature < minTemp) minTemp = item.temperature;
      if (item.temperature > maxTemp) maxTemp = item.temperature;
    }
    // Add buffer
    minTemp -= 2;
    maxTemp += 2;

    return GlassContainer(
      opacity: 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 12),
            child: Text(
              'BIỂU ĐỒ NHIỆT ĐỘ (3h)', 
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 20),
          
          // Chart Container
          SizedBox(
            height: 180, // Height for the chart area
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Container(
                // Width = number of items * step width
                width: chartItems.length * 70.0, 
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < chartItems.length) {
                               final time = DateFormat('HH:mm').format(chartItems[index].dateTime);
                               return Text(time, style: const TextStyle(color: Colors.white70, fontSize: 12));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (chartItems.length - 1).toDouble(),
                    minY: minTemp,
                    maxY: maxTemp,
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartItems.asMap().entries.map((e) {
                           return FlSpot(e.key.toDouble(), e.value.temperature);
                        }).toList(),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: Colors.white,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: Colors.black26, 
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.3),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    // Tooltip to show Temp above dot
                    lineTouchData: LineTouchData(
                       enabled: false, // We will manually draw text? 
                       // FL Chart doesn't easily support always-visible labels above dots without a custom painter or using 'showingTooltipIndicators'.
                       // Let's use showingTooltipIndicators to force labels.
                       touchTooltipData: LineTouchTooltipData(
                          // tooltipBgColor: Colors.transparent, // Deprecated or changed
                          getTooltipColor: (_) => Colors.transparent,
                          tooltipPadding: const EdgeInsets.all(0),
                          tooltipMargin: -40, // Move UP
                          getTooltipItems: (touchedSpots) {
                             return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  '${spot.y.toStringAsFixed(0)}°',
                                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                );
                             }).toList();
                          }
                       ),
                    ),
                    showingTooltipIndicators: chartItems.asMap().entries.map((entry) {
                       return ShowingTooltipIndicators([
                          LineBarSpot(
                             LineChartBarData(spots: []), // Dummy, not used for rendering logic usually if just position
                             0,
                             FlSpot(entry.key.toDouble(), entry.value.temperature),
                          ),
                       ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          
          // Hack: Since FL Chart tooltip always-show is tricky with exact styling, 
          // let's try a simplified approach first: Standard Chart.
          // IF labels don't show, we can try robust "Stack" approach later.
        ],
      ),
    );
  }
}
