import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/project_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/empty_state_widget.dart';
import 'summary_card.dart';

class AnalyticsTabView extends StatelessWidget {
  final ProjectModel project;

  const AnalyticsTabView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceMetrics(),
          const SizedBox(height: 48),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildWeeklyActivityChart()),
              const SizedBox(width: 48),
              Expanded(flex: 1, child: _buildMonthlyProgress()),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    final currencyFormat = NumberFormat.simpleCurrency(name: project.currency);

    final weeklyEfficiency = project.weeklyGoalHours > 0
        ? (project.thisWeekHours / project.weeklyGoalHours * 100).toInt()
        : 0;
    final avgHourlyRate = project.totalHours > 0
        ? project.totalRevenue / project.totalHours
        : project.hourlyRate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Revenue Efficiency',
                value: '$weeklyEfficiency%',
                subtitle: 'vs Weekly Goal',
                icon: Icons.trending_up_rounded,
                iconColor: AppColors.primary,
                trend:
                    '${(project.thisWeekHours - project.lastWeekHours).abs().toStringAsFixed(1)} hrs diff',
                isTrendPositive: project.thisWeekHours >= project.lastWeekHours,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SummaryCard(
                title: 'Avg. Hourly Rate',
                value: currencyFormat.format(avgHourlyRate),
                subtitle: 'Blended rate',
                icon: Icons.insights_rounded,
                iconColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SummaryCard(
                title: 'Project Health',
                value: project.isActive ? 'Active' : 'Paused',
                subtitle: 'Current status',
                icon: project.isActive
                    ? Icons.check_circle_outline_rounded
                    : Icons.pause_circle_outline_rounded,
                iconColor:
                    project.isActive ? AppColors.success : AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyActivityChart() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weekly Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Hours tracked over the last weeks',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
              _buildChartLegend(),
            ],
          ),
          const SizedBox(height: 48),
          if (project.historicalWeeklyHours.every((h) => h == 0))
            const SizedBox(
              height: 300,
              child: EmptyStateWidget(
                isCompact: true,
                icon: Icons.bar_chart_rounded,
                title: 'No Weekly Activity',
                description:
                    'Weekly activity data will appear here once you start tracking time for this project.',
              ),
            )
          else
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY:
                      ([
                                ...project.historicalWeeklyHours,
                                project.weeklyGoalHours,
                              ].reduce((a, b) => a > b ? a : b) *
                              1.2)
                          .clamp(20, 1000),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppColors.loginDarkCard,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toStringAsFixed(1)} hrs',
                          const TextStyle(
                            color: AppColors.darkTextPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: AppColors.darkTextSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          );
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = 'Week 1';
                              break;
                            case 1:
                              text = 'Week 2';
                              break;
                            case 2:
                              text = 'Last Week';
                              break;
                            case 3:
                              text = 'This Week';
                              break;
                            default:
                              text = '';
                              break;
                          }
                          return SideTitleWidget(
                            meta: meta,
                            space: 10,
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              '${value.toInt()}h',
                              style: const TextStyle(
                                color: AppColors.darkTextMuted,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.darkDivider,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    project.historicalWeeklyHours.length,
                    (index) => _makeGroupData(
                      index,
                      project.historicalWeeklyHours[index],
                      project.weeklyGoalHours,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, double goal) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: y >= goal
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.6),
          width: 32,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: goal,
            color: AppColors.darkBorder.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildChartLegend() {
    return Row(
      children: [
        _buildLegendItem('Tracked', AppColors.primary),
        const SizedBox(width: 16),
        _buildLegendItem('Goal', AppColors.darkBorder.withValues(alpha: 0.5)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyProgress() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          const Text(
            'Monthly Target',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 160,
            width: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: project.monthlyProgress,
                  strokeWidth: 12,
                  backgroundColor: AppColors.darkBorder.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(project.monthlyProgress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkTextPrimary,
                          letterSpacing: -1,
                        ),
                      ),
                      const Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildTargetDetail(
            'Total Goal',
            '${project.monthlyHours.toInt()} hrs',
          ),
          Divider(height: 24, color: AppColors.darkDivider),
          _buildTargetDetail(
            'Remaining',
            '${(project.monthlyHours * (1 - project.monthlyProgress)).toInt()} hrs',
          ),
        ],
      ),
    );
  }

  Widget _buildTargetDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.darkTextSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
          ),
        ),
      ],
    );
  }
}
