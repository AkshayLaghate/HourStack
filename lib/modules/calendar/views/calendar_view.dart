import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';
import 'widgets/calendar_header.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/day_detail_sidebar.dart';
import '../../../app/theme/app_colors.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1200;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const CalendarHeader(),
          Expanded(
            child: Row(
              children: [
                const Expanded(child: CalendarGrid()),
                if (isDesktop) const DayDetailSidebar(),
              ],
            ),
          ),
        ],
      ),
      // For mobile, we could show the sidebar as a bottom sheet or drawer
      floatingActionButton: !isDesktop
          ? FloatingActionButton(
              onPressed: () {
                Get.bottomSheet(
                  const DayDetailSidebar(),
                  backgroundColor: AppColors.sidebar,
                  isScrollControlled: true,
                );
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.list_alt),
            )
          : null,
    );
  }
}
