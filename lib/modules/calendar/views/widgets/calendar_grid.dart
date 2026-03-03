import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/calendar_controller.dart';
import '../../../../app/theme/app_colors.dart';

class CalendarGrid extends GetView<CalendarController> {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
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
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHint,
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
      final totalHours = controller.getTotalHoursForDay(day);
      final totalRevenue = controller.getTotalRevenueForDay(day);

      return GestureDetector(
        onTap: () => controller.onDaySelected(day, controller.focusedDay.value),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryLight.withOpacity(0.5)
                : AppColors.card,
            border: Border.all(color: AppColors.divider.withOpacity(0.5)),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isCurrentMonth
                      ? AppColors.textPrimary
                      : AppColors.textHint,
                ),
              ),
              const Spacer(),
              if (totalHours > 0) ...[
                Text(
                  '${totalHours.toStringAsFixed(1)}h',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '\$${totalRevenue.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
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

    // Calculate days before the month to align with Monday
    final daysBefore = (firstDayOfMonth.weekday - 1) % 7;
    final startDate = firstDayOfMonth.subtract(Duration(days: daysBefore));

    // Calculate days after the month to fill the 6-week grid
    final totalDays = 42; // standard 6-week grid
    return List.generate(
      totalDays,
      (index) => startDate.add(Duration(days: index)),
    );
  }
}
