import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/calendar_controller.dart';
import '../../../../app/theme/app_colors.dart';

class CalendarHeader extends GetView<CalendarController> {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [_buildMonthPicker(), const Spacer(), _buildViewSwitcher()],
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Obx(() {
      final date = controller.focusedDay.value;
      final viewType = controller.viewType.value;

      String label;
      if (viewType == 'Month') {
        label = DateFormat('MMMM yyyy').format(date);
      } else if (viewType == 'Week') {
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        if (startOfWeek.month == endOfWeek.month) {
          label =
              '${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('d, yyyy').format(endOfWeek)}';
        } else {
          label =
              '${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d, yyyy').format(endOfWeek)}';
        }
      } else {
        label = DateFormat('MMMM d, yyyy').format(date);
      }

      return Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.textSecondary,
            ),
            onPressed: controller.previous,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
            onPressed: controller.next,
          ),
        ],
      );
    });
  }

  Widget _buildViewSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildViewButton('Month'),
          _buildViewButton('Week'),
          _buildViewButton('Day'),
        ],
      ),
    );
  }

  Widget _buildViewButton(String type) {
    return Obx(() {
      final isSelected = controller.viewType.value == type;
      return GestureDetector(
        onTap: () => controller.changeView(type),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            type,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      );
    });
  }
}
