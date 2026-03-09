import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/calendar_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../data/models/session_model.dart';
import '../../../../data/models/project_model.dart';

class DayDetailSidebar extends GetView<CalendarController> {
  const DayDetailSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: Obx(() {
        final selectedDay = controller.selectedDay.value!;
        final sessions = controller.getSessionsForDay(selectedDay);
        final totalHours = controller.getTotalHoursForDay(selectedDay);
        final totalRevenue = controller.getTotalRevenueForDay(selectedDay);

        return Column(
          children: [
            _buildHeader(selectedDay, totalHours),
            Expanded(
              child: sessions.isEmpty
                  ? _buildEmptyState()
                  : _buildSessionList(sessions),
            ),
            _buildRevenueFooter(totalRevenue),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(DateTime date, double totalHours) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM d, yyyy').format(date),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${totalHours.toStringAsFixed(1)} hours tracked',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textHint),
            onPressed: () => controller.selectedDay.value = null,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList(List<SessionModel> sessions) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: sessions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final session = sessions[index];
        final project = controller.projectsMap[session.projectId];
        return _buildSessionCard(session, project);
      },
    );
  }

  Widget _buildSessionCard(SessionModel session, ProjectModel? project) {
    final startTimeStr = DateFormat('hh:mm a').format(session.startTime);
    final endTimeStr = session.endTime != null
        ? DateFormat('hh:mm a').format(session.endTime!)
        : 'Running';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (project?.name ?? 'Unknown Project').toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Color(project?.colorValue ?? AppColors.primary.value),
                ),
              ),
              Text(
                '${(session.durationMinutes / 60.0).toStringAsFixed(1)}h',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'High-fidelity mockups for landing page hero section...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '$startTimeStr - $endTimeStr',
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
              const Spacer(),
              const Icon(
                Icons.edit_outlined,
                size: 16,
                color: AppColors.textHint,
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.delete_outline,
                size: 16,
                color: AppColors.textHint,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueFooter(double totalRevenue) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Text(
            'Daily Revenue',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${totalRevenue.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No sessions tracked for this day',
        style: TextStyle(color: AppColors.textHint),
      ),
    );
  }
}
