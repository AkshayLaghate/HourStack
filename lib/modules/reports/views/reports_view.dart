import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reports_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../../app/utils/number_extensions.dart';
import '../../../app/widgets/empty_state_widget.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(32.0),
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildTopStats(),
            const SizedBox(height: 32),
            _buildProjectSummaryCard(),
          ],
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reports',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Analyze and export your workspace performance',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF64748B), // Custom Slate 500
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Obx(() {
        final projects = controller.projectController.projects;
        return DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: controller.selectedProject.value?.id,
            hint: const Text('All Projects', style: TextStyle(fontSize: 14)),
            icon: const Icon(Icons.keyboard_arrow_down, size: 20),
            onChanged: (String? id) {
              final project = id == null
                  ? null
                  : projects.firstWhere((p) => p.id == id);
              controller.onProjectChanged(project);
            },
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('All Projects', style: TextStyle(fontSize: 14)),
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
                      Text(p.name, style: const TextStyle(fontSize: 14)),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<dynamic>(
                // Use dynamic or DateRangeType
                value: controller.rangeType.value,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    controller.rangeLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF64748B),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)), // Custom Slate 100
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
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
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
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
          const Divider(height: 1),
          _buildTable(),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Export Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Generate a downloadable file with all current report data.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B), // Custom Slate 500
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
            color: Color(0xFF64748B), // Custom Slate 500
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
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
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
          ), // Custom Slate 50
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
          fontWeight: FontWeight.w600,
          color: Color(0xFF94A3B8), // Custom Slate 400
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
              ? const Color(0xFF1E293B)
              : const Color(0xFF475569), // Custom Slate 600
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
              color: Color(0xFF1E293B),
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
        color: isPrimary ? const Color(0xFF6366F1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isPrimary
            ? null
            : Border.all(color: const Color(0xFFE2E8F0)), // Custom Slate 200
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.3),
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
                      : const Color(0xFF334155), // Custom Slate 700
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPrimary
                        ? Colors.white
                        : const Color(0xFF334155), // Custom Slate 700
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
              const Color(0xFF6366F1).withValues(alpha: 0.1),
              const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _buildStatCard(
              'BILLABLE HOURS',
              controller.billableHours.value.toDurationString(),
              Icons.verified_user,
              const Color(0xFF10B981).withValues(alpha: 0.1),
              const Color(0xFF10B981),
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
              const Color(0xFFF59E0B).withValues(alpha: 0.1),
              const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _buildStatCard(
              'ACTIVE PROJECTS',
              controller.activeProjectsCount.value.toString(),
              Icons.folder_special,
              const Color(0xFF3B82F6).withValues(alpha: 0.1),
              const Color(0xFF3B82F6),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)), // Custom Slate 100
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
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8), // Custom Slate 400
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
