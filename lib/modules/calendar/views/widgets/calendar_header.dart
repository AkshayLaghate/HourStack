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
        children: [
          _buildMonthPicker(),
          const Spacer(),
          _buildViewSwitcher(),
          const SizedBox(width: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Obx(() {
      final date = controller.focusedDay.value;
      return Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.textSecondary,
            ),
            onPressed: controller.previousMonth,
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat('MMMM yyyy').format(date),
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
            onPressed: controller.nextMonth,
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Container(
          width: 300,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.textHint,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.notifications_none, color: AppColors.textSecondary),
        const SizedBox(width: 16),
        const CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFFE2E8F0),
          child: Icon(
            Icons.person_outline,
            size: 20,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
