import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/calendar_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/utils/number_extensions.dart';

class WeeklyGrid extends GetView<CalendarController> {
  const WeeklyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDaysHeader(),
        Expanded(
          child: Obx(() {
            final focusedDay = controller.focusedDay.value;
            final days = _generateDaysForWeek(focusedDay);
            return Row(
              children: days
                  .map((day) => Expanded(child: _buildDayColumn(day)))
                  .toList(),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDaysHeader() {
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

  Widget _buildDayColumn(DateTime day) {
    return Obx(() {
      final isSelected =
          controller.selectedDay.value != null &&
          DateUtils.isSameDay(controller.selectedDay.value!, day);
      final isToday = DateUtils.isSameDay(DateTime.now(), day);
      final totalHours = controller.getTotalHoursForDay(day);
      final totalRevenue = controller.getTotalRevenueForDay(day);
      final sessions = controller.getSessionsForDay(day);

      return GestureDetector(
        onTap: () => controller.onDaySelected(day, controller.focusedDay.value),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.06)
                : AppColors.darkSurface,
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.darkDivider.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.darkDivider.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isToday
                              ? Colors.white
                              : AppColors.darkTextPrimary,
                        ),
                      ),
                    ),
                    if (totalHours > 0)
                      Text(
                        totalHours.toDurationString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGlow,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    final project = controller.projectsMap[session.projectId];
                    final projectColor = project != null
                        ? Color(project.colorValue)
                        : AppColors.primary;
                    final task = session.taskId != null
                        ? controller.tasksMap[session.taskId]
                        : null;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: projectColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border(
                          left: BorderSide(color: projectColor, width: 4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task?.title ?? 'No Task',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkTextPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (session.durationMinutes / 60.0).toDurationString(),
                            style: TextStyle(
                              fontSize: 10,
                              color: projectColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (totalHours > 0)
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  color: AppColors.darkBg.withValues(alpha: 0.5),
                  child: Text(
                    totalRevenue.toCurrency(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  List<DateTime> _generateDaysForWeek(DateTime focusedDay) {
    final startOfWeek = focusedDay.subtract(
      Duration(days: focusedDay.weekday - 1),
    );
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }
}
