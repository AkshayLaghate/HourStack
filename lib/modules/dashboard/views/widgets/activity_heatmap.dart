import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../controllers/dashboard_controller.dart';
import 'package:intl/intl.dart';

class ActivityHeatmap extends StatefulWidget {
  const ActivityHeatmap({super.key});

  @override
  State<ActivityHeatmap> createState() => _ActivityHeatmapState();
}

class _ActivityHeatmapState extends State<ActivityHeatmap> {
  final DashboardController controller = Get.find<DashboardController>();
  Offset? _lastTapPosition;
  OverlayEntry? _overlayEntry;

  int _getMinutesForDate(DateTime lookupDate) {
    for (var entry in controller.heatmapMinutes.entries) {
      if (entry.key.year == lookupDate.year &&
          entry.key.month == lookupDate.month &&
          entry.key.day == lookupDate.day) {
        return entry.value;
      }
    }
    return 0;
  }

  void _showTooltip(DateTime date, Offset position) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    final minutes = _getMinutesForDate(date);
    final dateStr = DateFormat('MMM d, yyyy').format(date);

    final h = minutes ~/ 60;
    final m = minutes % 60;
    final timeStr = minutes > 0
        ? (h > 0 ? '${h}h ${m}m' : '${m}m')
        : 'No time logged';

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              left: (position.dx - 75).clamp(
                10.0,
                MediaQuery.of(context).size.width - 160.0,
              ),
              top: (position.dy - 60).clamp(
                10.0,
                MediaQuery.of(context).size.height - 80.0,
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkCardHover,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.darkBorder.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dateStr,
                        style: TextStyle(
                          color: AppColors.darkTextMuted,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeStr,
                        style: const TextStyle(
                          color: AppColors.darkTextPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      if (_overlayEntry != null && _overlayEntry!.mounted) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Activity Heatmap', style: AppTextStyles.darkH3),
                  const SizedBox(height: 4),
                  Text(
                    'Daily work intensity over the last year',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.darkTextMuted,
                    ),
                  ),
                ],
              ),
              _buildLegendRow(),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Obx(() {
                final datasets = Map<DateTime, int>.from(
                  controller.heatmapDatasets,
                );
                return GestureDetector(
                  onTapDown: (details) =>
                      _lastTapPosition = details.globalPosition,
                  child: HeatMap(
                    datasets: datasets,
                    colorMode: ColorMode.opacity,
                    showText: false,
                    scrollable: false,
                    size: 14,
                    colorsets: const {1: AppColors.primaryGlow},
                    startDate: now.subtract(const Duration(days: 365)),
                    endDate: now,
                    onClick: (value) {
                      if (_lastTapPosition != null) {
                        final date =
                            DateTime(value.year, value.month, value.day);
                        _showTooltip(date, _lastTapPosition!);
                      }
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow() {
    return Row(
      children: [
        Text(
          'Less',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.darkTextMuted,
          ),
        ),
        const SizedBox(width: 6),
        _buildLegendBox(AppColors.primaryGlow.withAlpha(40)),
        const SizedBox(width: 3),
        _buildLegendBox(AppColors.primaryGlow.withAlpha(80)),
        const SizedBox(width: 3),
        _buildLegendBox(AppColors.primaryGlow.withAlpha(130)),
        const SizedBox(width: 3),
        _buildLegendBox(AppColors.primaryGlow.withAlpha(190)),
        const SizedBox(width: 3),
        _buildLegendBox(AppColors.primaryGlow),
        const SizedBox(width: 6),
        Text(
          'More',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.darkTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
