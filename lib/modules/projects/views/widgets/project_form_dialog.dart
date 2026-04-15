import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hourstack/app/theme/app_colors.dart';
import 'package:hourstack/modules/projects/controllers/project_controller.dart';
import 'package:hourstack/app/utils/constants.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../data/models/project_model.dart';

class ProjectFormDialog extends StatefulWidget {
  final ProjectModel? project;
  const ProjectFormDialog({super.key, this.project});

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  final _nameCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();

  String? _selectedClient;
  String _paymentType = 'Hourly';
  String _selectedCurrency = AppConstants.defaultCurrency;
  bool _isBillable = true;
  DateTime? _selectedDeadline;

  bool get _isEdit => widget.project != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final project = widget.project!;
      _nameCtrl.text = project.name;
      _paymentType = project.paymentType;
      _selectedClient = project.clientName.isEmpty ? null : project.clientName;
      _selectedCurrency = project.currency;
      _isBillable = project.isBillable;
      _selectedDeadline = project.deadline;

      final controller = Get.find<ProjectController>();
      if (_selectedClient != null) {
        controller.addClient(_selectedClient!);
      }

      if (_paymentType != 'Hourly' && _paymentType != 'Fixed Price') {
        _paymentType = 'Hourly';
      }

      if (_paymentType == 'Hourly') {
        _rateCtrl.text = project.hourlyRate.toString();
      } else {
        _rateCtrl.text = project.fixedPrice.toString();
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter a project name',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    final rateValue = double.tryParse(_rateCtrl.text) ?? 0.0;
    final controller = Get.find<ProjectController>();

    if (_isEdit) {
      controller.updateProject(
        widget.project!,
        name: name,
        clientName: _selectedClient ?? '',
        paymentType: _paymentType,
        hourlyRate: _paymentType == 'Hourly' ? rateValue : 0.0,
        fixedPrice: _paymentType == 'Fixed Price' ? rateValue : 0.0,
        isBillable: _isBillable,
        currency: _selectedCurrency,
        deadline: _selectedDeadline,
      );
    } else {
      controller.addProject(
        name,
        '',
        _paymentType == 'Hourly' ? rateValue : 0.0,
        clientName: _selectedClient ?? '',
        paymentType: _paymentType,
        fixedPrice: _paymentType == 'Fixed Price' ? rateValue : 0.0,
        estimatedBudget: 0.0,
        isBillable: _isBillable,
        isBudgetAlertEnabled: false,
        currency: _selectedCurrency,
        deadline: _selectedDeadline,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.loginDarkSurface,
      surfaceTintColor: Colors.transparent,
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.loginDarkSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.loginDarkBorder),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEdit ? 'Edit Project' : 'Create New Project',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.loginDarkTextPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isEdit
                    ? 'Update your project settings and tracking preferences.'
                    : 'Set up your workspace and start tracking billable hours.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.loginDarkTextSecondary,
                ),
              ),
              const SizedBox(height: 32),
              Divider(color: AppColors.loginDarkBorder, height: 1),
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
                        _buildDashedCoverUploader(height: 180),
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
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              _selectedCurrency == 'INR' ? '₹' : '\$',
                              style: const TextStyle(
                                color: AppColors.loginDarkTextSecondary,
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Currency'),
                        const SizedBox(height: 8),
                        _buildCurrencyDropdown(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Deadline (Optional)'),
                        const SizedBox(height: 8),
                        _buildDeadlinePicker(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              _buildSettingCard(
                icon: Icons.payments_outlined,
                title: 'Billable Project',
                subtitle: 'Track earnings for this project',
                value: _isBillable,
                onChanged: (val) => setState(() => _isBillable = val),
                iconColor: AppColors.greenGlow,
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.loginDarkBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.loginDarkTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _isEdit ? 'Save Changes' : 'Create Project',
                        style: const TextStyle(fontWeight: FontWeight.w600),
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
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.loginDarkTextSecondary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    Widget? prefixIcon,
    TextInputType? keyboardType,
    bool autofocus = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autofocus: autofocus,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.loginDarkTextPrimary,
      ),
      cursorColor: AppColors.primaryGlow,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.loginDarkTextSecondary.withValues(alpha: 0.4),
        ),
        prefixIcon: prefixIcon != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [prefixIcon],
              )
            : null,
        filled: true,
        fillColor: AppColors.loginDarkInputBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.loginDarkInputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    String? value,
    List<String>? dropdownItems,
    String? hint,
    void Function(String?)? onChanged,
  }) {
    final controller = Get.find<ProjectController>();

    Widget buildDropdownField() {
      return DropdownButtonFormField<String>(
        initialValue: value ?? _selectedClient,
        isExpanded: true,
        dropdownColor: AppColors.loginDarkCard,
        style: const TextStyle(
          color: AppColors.loginDarkTextPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.loginDarkInputBg,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.loginDarkInputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.loginDarkTextSecondary,
        ),
        hint: Text(
          hint ?? 'Select Client',
          style: TextStyle(
            color: AppColors.loginDarkTextSecondary.withValues(alpha: 0.5),
          ),
        ),
        items: [
          if (dropdownItems == null)
            ...controller.clients.map(
              (client) => DropdownMenuItem(
                value: client,
                child: Text(client),
              ),
            ),
          if (dropdownItems != null)
            ...dropdownItems.map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
            ),
          if (dropdownItems == null) ...[
            DropdownMenuItem(
              value: 'ADD_NEW',
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: AppColors.greenGlow,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add New Client...',
                    style: TextStyle(
                      color: AppColors.greenGlow,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
        onChanged: (val) {
          if (onChanged != null) {
            onChanged(val);
          } else if (val == 'ADD_NEW') {
            _showAddClientDialog();
          } else {
            setState(() => _selectedClient = val);
          }
        },
      );
    }

    if (dropdownItems == null) {
      return Obx(() => buildDropdownField());
    }

    return buildDropdownField();
  }

  Widget _buildCurrencyDropdown() {
    final currencies = ['USD', 'INR', 'EUR', 'GBP'];
    if (!currencies.contains(_selectedCurrency)) {
      currencies.add(_selectedCurrency);
    }
    return _buildDropdown(
      value: _selectedCurrency,
      dropdownItems: currencies,
      hint: 'Select Currency',
      onChanged: (val) {
        if (val != null) {
          setState(() => _selectedCurrency = val);
        }
      },
    );
  }

  void _showAddClientDialog() {
    final clientNameCtrl = TextEditingController();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.loginDarkSurface,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.loginDarkSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.loginDarkBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Client',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.loginDarkTextPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter the name of the new client to add to your list.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.loginDarkTextSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _buildLabel('Client Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: clientNameCtrl,
                hintText: 'e.g. Acme Corporation',
                autofocus: true,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.loginDarkTextSecondary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final name = clientNameCtrl.text.trim();
                      if (name.isNotEmpty) {
                        final controller = Get.find<ProjectController>();
                        controller.addClient(name);
                        setState(() => _selectedClient = name);
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Add Client'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTypeDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _paymentType,
      dropdownColor: AppColors.loginDarkCard,
      style: const TextStyle(
        color: AppColors.loginDarkTextPrimary,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.loginDarkInputBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.loginDarkInputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.loginDarkTextSecondary,
      ),
      items: const [
        DropdownMenuItem(value: 'Hourly', child: Text('Hourly')),
        DropdownMenuItem(value: 'Fixed Price', child: Text('Fixed Price')),
      ],
      onChanged: (val) => setState(() => _paymentType = val!),
    );
  }

  Widget _buildDashedCoverUploader({double height = 124}) {
    final controller = Get.find<ProjectController>();
    return InkWell(
      onTap: () => controller.pickCoverImage(),
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.loginDarkBorder,
          radius: 12,
        ),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.loginDarkInputBg,
          ),
          child: Obx(() {
            final XFile? selectedImage = controller.selectedCoverImage.value;
            final existingImageUrl = widget.project?.coverImageUrl;

            if (selectedImage != null) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    GetPlatform.isWeb
                        ? Image.network(selectedImage.path, fit: BoxFit.cover)
                        : Image.file(
                            File(selectedImage.path),
                            fit: BoxFit.cover,
                          ),
                    Container(
                      color: Colors.black45,
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (existingImageUrl != null && existingImageUrl.isNotEmpty) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      existingImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.error_outline, color: AppColors.darkTextMuted)),
                    ),
                    Container(
                      color: Colors.black45,
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_photo_alternate_rounded,
                  color: AppColors.darkTextMuted,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  'Click to upload',
                  style: TextStyle(
                    color: AppColors.darkTextMuted.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            );
          }),
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
        color: AppColors.loginDarkInputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.loginDarkInputBorder),
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
                    color: AppColors.loginDarkTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.loginDarkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
            activeThumbColor: Colors.white,
            inactiveThumbColor: AppColors.loginDarkTextSecondary,
            inactiveTrackColor: AppColors.loginDarkBorder,
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlinePicker() {
    return InkWell(
      onTap: _selectDeadline,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.loginDarkInputBg,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.loginDarkInputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: _selectedDeadline == null
                  ? AppColors.darkTextMuted
                  : AppColors.primaryGlow,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedDeadline == null
                    ? 'Select Date'
                    : DateFormat('MMM dd, yyyy').format(_selectedDeadline!),
                style: TextStyle(
                  color: _selectedDeadline == null
                      ? AppColors.darkTextMuted
                      : AppColors.loginDarkTextPrimary,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_selectedDeadline != null)
              GestureDetector(
                onTap: () {
                  setState(() => _selectedDeadline = null);
                },
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.darkTextMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.loginDarkCard,
              onSurface: AppColors.loginDarkTextPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primaryGlow),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDeadline = picked);
    }
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

    PathMetrics pathMetrics = path.computeMetrics();
    Path dashedPath = Path();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      while (distance < pathMetric.length) {
        double length = 6.0;
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
