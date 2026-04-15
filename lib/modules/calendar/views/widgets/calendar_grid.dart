import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/calendar_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/utils/number_extensions.dart';
import 'weekly_grid.dart';
import 'daily_grid.dart';

class CalendarGrid extends GetView<CalendarController> {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final viewType = controller.viewType.value;

      if (viewType == 'Week') {
        return const WeeklyGrid();
      } else if (viewType == 'Day') {
        return const DailyGrid();
      }

      // Default: Month View
      return Column(
        children: [
          _buildDaysOfWeek(),
          Expanded(
            child: Obx(() {
              final focusedDay = controller.focusedDay.value;
              final days = _generateDaysForMonth(focusedDay);
              return GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.0,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  return _buildDateCell(days[index]);
                },
              );
            }),
          ),
        ],
      );
    });
  }

  Widget _buildDaysOfWeek() {
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: days
            .map(
              (day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkTextMuted,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDateCell(DateTime day) {
    return Obx(() {
      final isSelected =
          controller.selectedDay.value != null &&
          DateUtils.isSameDay(controller.selectedDay.value!, day);
      final isCurrentMonth = day.month == controller.focusedDay.value.month;
      final isToday = DateUtils.isSameDay(DateTime.now(), day);
      final totalHours = controller.getTotalHoursForDay(day);
      final totalRevenue = controller.getTotalRevenueForDay(day);

      return GestureDetector(
        onTap: () => controller.onDaySelected(day, controller.focusedDay.value),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.darkSurface,
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.darkDivider.withValues(alpha: 0.5),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: isToday
                    ? BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                    color: isToday
                        ? Colors.white
                        : isCurrentMonth
                            ? AppColors.darkTextPrimary
                            : AppColors.darkTextMuted,
                  ),
                ),
              ),
              const Spacer(),
              if (totalHours > 0) ...[
                Text(
                  totalHours.toDurationString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGlow,
                  ),
                ),
                Text(
                  totalRevenue.toCurrency(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  List<DateTime> _generateDaysForMonth(DateTime focusedDay) {
    final firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final daysBefore = (firstDayOfMonth.weekday - 1) % 7;
    final startDate = firstDayOfMonth.subtract(Duration(days: daysBefore));
    final totalDays = 42;
    return List.generate(
      totalDays,
      (index) => startDate.add(Duration(days: index)),
    );
  }
}
