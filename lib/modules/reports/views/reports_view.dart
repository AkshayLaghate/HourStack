import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reports_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../../app/utils/number_extensions.dart';
import '../../../app/widgets/empty_state_widget.dart';
import '../../../app/theme/app_colors.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground(context),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(32.0),
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            _buildTopStats(),
            const SizedBox(height: 32),
            _buildProjectSummaryCard(),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryColor(context),
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Analyze and export your workspace performance',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondaryColor(context),
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildProjectDropdown(),
            const SizedBox(width: 12),
            _buildDateRangeSelector(),
          ],
        ),
      ],
    );
  }

  Widget _buildProjectDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(Get.context!),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderColor(Get.context!).withValues(alpha: 0.5),
        ),
      ),
      child: Obx(() {
        final projects = controller.projectController.projects;
        return DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: controller.selectedProject.value?.id,
            hint: const Text(
              'All Projects',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkTextSecondary,
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: AppColors.darkTextSecondary,
            ),
            dropdownColor: AppColors.darkCard,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.darkTextPrimary,
            ),
            onChanged: (String? id) {
              final project = id == null
                  ? null
                  : projects.firstWhere((p) => p.id == id);
              controller.onProjectChanged(project);
            },
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text(
                  'All Projects',
                  style: TextStyle(fontSize: 14, color: AppColors.darkTextPrimary),
                ),
              ),
              ...projects.map(
                (p) => DropdownMenuItem<String?>(
                  value: p.id,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(p.colorValue),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.darkTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDateRangeSelector() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(Get.context!),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
              color: AppColors.borderColor(Get.context!).withValues(alpha: 0.5),
            ),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<dynamic>(
                value: controller.rangeType.value,
                dropdownColor: AppColors.darkCard,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.darkTextPrimary,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppColors.darkTextSecondary,
                ),
                onChanged: (value) {
                  if (value != null) controller.setRange(value);
                },
                items: const [
                  DropdownMenuItem(
                    value: DateRangeType.day,
                    child: Text('Daily', style: TextStyle(fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: DateRangeType.week,
                    child: Text('Weekly', style: TextStyle(fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: DateRangeType.month,
                    child: Text('Monthly', style: TextStyle(fontSize: 14)),
                  ),
                  DropdownMenuItem(
                    value: DateRangeType.custom,
                    child: Text('Custom', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () => controller.selectDateRange(Get.context!),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground(Get.context!),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderColor(Get.context!).withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    controller.rangeLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.darkTextSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground(Get.context!),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderColor(Get.context!).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Project Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
                Row(
                  children: [
                    _buildSummaryStat(
                      'Total Hours:',
                      controller.totalHours.value.toDurationString(),
                    ),
                    const SizedBox(width: 24),
                    _buildSummaryStat(
                      'Total Revenue:',
                      controller.totalRevenue.value.toCurrency(
                        symbol: controller.currencySymbol.value,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.darkDivider),
          _buildTable(),
          Divider(height: 1, color: AppColors.darkDivider),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkTextPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Generate a downloadable file with all current report data.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkTextSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildExportButton(
                      'Export CSV',
                      Icons.description_outlined,
                      controller.exportToCSV,
                    ),
                    const SizedBox(width: 12),
                    _buildExportButton(
                      'Export Excel',
                      Icons.table_view_outlined,
                      controller.exportToExcel,
                    ),
                    const SizedBox(width: 12),
                    _buildExportButton(
                      'Export PDF',
                      Icons.picture_as_pdf_outlined,
                      controller.exportToPDF,
                      isPrimary: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkTextPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTable() {
    if (controller.reportEntries.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.analytics_outlined,
        title: 'No Data Found',
        description:
            'There are no time entries for the selected project and date range.',
      );
    }

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
          ),
          children: [
            _buildTableHeader('DATE'),
            _buildTableHeader('PROJECT'),
            _buildTableHeader('HOURS'),
            _buildTableHeader('RATE'),
            _buildTableHeader('REVENUE'),
          ],
        ),
        ...controller.reportEntries.map(
          (entry) => TableRow(
            children: [
              _buildTableCell(entry.date),
              _buildTableCellWithDot(entry.project, Color(entry.color)),
              _buildTableCell(entry.hours.toDurationString()),
              _buildTableCell(
                entry.rate.toCurrency(symbol: entry.currencySymbol),
              ),
              _buildTableCell(
                entry.revenue.toCurrency(symbol: entry.currencySymbol),
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextMuted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: isBold
              ? AppColors.darkTextPrimary
              : AppColors.darkTextSecondary,
        ),
      ),
    );
  }

  Widget _buildTableCellWithDot(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primary : AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: isPrimary
            ? null
            : Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isPrimary
                      ? Colors.white
                      : AppColors.darkTextSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPrimary
                        ? Colors.white
                        : AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopStats() {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'TOTAL HOURS',
              controller.totalHours.value.toDurationString(),
              Icons.access_time_filled,
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.primaryGlow,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _buildStatCard(
              'BILLABLE HOURS',
              controller.billableHours.value.toDurationString(),
              Icons.verified_user,
              AppColors.success.withValues(alpha: 0.1),
              AppColors.greenGlow,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _buildStatCard(
              'TOTAL REVENUE',
              controller.totalRevenue.value.toCurrency(
                symbol: controller.currencySymbol.value,
              ),
              Icons.payments,
              AppColors.warning.withValues(alpha: 0.1),
              AppColors.amberGlow,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _buildStatCard(
              'ACTIVE PROJECTS',
              controller.activeProjectsCount.value.toString(),
              Icons.folder_special,
              AppColors.info.withValues(alpha: 0.1),
              AppColors.blueGlow,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkTextMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkTextPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
