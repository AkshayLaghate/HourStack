import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hourstack/app/theme/app_colors.dart';
import 'package:hourstack/app/theme/app_text_styles.dart';
import 'package:hourstack/modules/projects/controllers/project_controller.dart';
import 'dart:ui';

class CreateProjectDialog extends StatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  final _nameCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();

  String? _selectedClient;
  String _paymentType = 'Hourly';
  bool _isBillable = true;
  bool _isBudgetAlertEnabled = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rateCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  void _createProject() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter a project name',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final rateValue = double.tryParse(_rateCtrl.text) ?? 0.0;
    final budgetValue = double.tryParse(_budgetCtrl.text) ?? 0.0;

    final controller = Get.find<ProjectController>();
    controller.addProject(
      name,
      '', // description placeholder
      _paymentType == 'Hourly' ? rateValue : 0.0,
      clientName: _selectedClient ?? '',
      paymentType: _paymentType,
      fixedPrice: _paymentType == 'Fixed Price' ? rateValue : 0.0,
      estimatedBudget: budgetValue,
      isBillable: _isBillable,
      isBudgetAlertEnabled: _isBudgetAlertEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create New Project', style: AppTextStyles.h2),
              const SizedBox(height: 8),
              const Text(
                'Set up your workspace and start tracking billable hours.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Project Cover'),
                        const SizedBox(height: 8),
                        _buildDashedCoverUploader(
                          height: 180,
                        ), // Normalized height to match two input fields
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Project Name'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _nameCtrl,
                          hintText: 'e.g. Website Redesign',
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Client'),
                        const SizedBox(height: 8),
                        _buildDropdown(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Payment Type'),
                        const SizedBox(height: 8),
                        _buildPaymentTypeDropdown(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(
                          _paymentType == 'Hourly'
                              ? 'Hourly Rate'
                              : 'Fixed Price',
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _rateCtrl,
                          hintText: '0.00',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '\$',
                              style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _paymentType == 'Hourly'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Estimated Budget'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _budgetCtrl,
                                hintText: '0.00',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    '\$',
                                    style: TextStyle(
                                      color: AppColors.textHint,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 24),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
              const SizedBox(height: 32),

              _buildSettingCard(
                icon: Icons.payments_outlined,
                title: 'Billable Project',
                subtitle: 'Track earnings for this project',
                value: _isBillable,
                onChanged: (val) => setState(() => _isBillable = val),
                iconColor: const Color(0xFF14B8A6), // Teal color
              ),
              const SizedBox(height: 16),
              _buildSettingCard(
                icon: Icons.notifications_none_rounded,
                title: 'Budget Alerts',
                subtitle: 'Notify when 80% of budget is reached',
                value: _isBudgetAlertEnabled,
                onChanged: (val) => setState(() => _isBudgetAlertEnabled = val),
                iconColor: AppColors.textHint,
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _createProject,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create Project',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    Widget? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textHint),
        prefixIcon: prefixIcon != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [prefixIcon],
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedClient,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textHint,
      ),
      hint: const Text(
        'Select a client',
        style: TextStyle(color: AppColors.textHint),
      ),
      items: const [
        DropdownMenuItem(value: 'Acme Corp', child: Text('Acme Corp')),
        DropdownMenuItem(value: 'Global Tech', child: Text('Global Tech')),
        DropdownMenuItem(value: 'Starlight Inc', child: Text('Starlight Inc')),
      ],
      onChanged: (val) => setState(() => _selectedClient = val),
    );
  }

  Widget _buildPaymentTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _paymentType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textHint,
      ),
      items: const [
        DropdownMenuItem(value: 'Hourly', child: Text('Hourly')),
        DropdownMenuItem(value: 'Fixed Price', child: Text('Fixed Price')),
      ],
      onChanged: (val) => setState(() => _paymentType = val!),
    );
  }

  Widget _buildDashedCoverUploader({double height = 124}) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: AppColors.border.withOpacity(0.8),
        radius: 12,
      ),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.background.withOpacity(0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate_rounded,
              color: AppColors.textHint,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              'Click to upload',
              style: TextStyle(
                color: AppColors.textHint.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(
              0xFF14B8A6,
            ), // match the teal from design
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.border,
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    var path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    // Extract path metrics to draw dashed line
    PathMetrics pathMetrics = path.computeMetrics();
    Path dashedPath = Path();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      while (distance < pathMetric.length) {
        double length = 6.0; // dash length
        if (distance + length > pathMetric.length) {
          length = pathMetric.length - distance;
        }
        if (draw) {
          dashedPath.addPath(
            pathMetric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
