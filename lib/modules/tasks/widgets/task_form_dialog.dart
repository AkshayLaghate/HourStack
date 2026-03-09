import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hourstack/app/theme/app_colors.dart';
import 'package:hourstack/app/theme/app_text_styles.dart';
import 'package:hourstack/data/models/task_model.dart';
import 'package:hourstack/modules/kanban/controllers/kanban_controller.dart';
import 'package:intl/intl.dart';

class TaskFormDialog extends StatefulWidget {
  final TaskModel? task;
  final TaskStatus? initialStatus;
  const TaskFormDialog({super.key, this.task, this.initialStatus});

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _estCtrl = TextEditingController();

  TaskPriority _selectedPriority = TaskPriority.medium;
  late TaskStatus _selectedStatus;
  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleCtrl.text = widget.task!.title;
      _descCtrl.text = widget.task!.description;
      _estCtrl.text = widget.task!.estimatedHours.toString();
      _selectedPriority = widget.task!.priority;
      _selectedStatus = widget.task!.status;
      _selectedDueDate = widget.task!.dueDate;
    } else {
      _selectedStatus = widget.initialStatus ?? TaskStatus.backlog;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _estCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  void _handleSubmit() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter a task title',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final controller = Get.find<KanbanController>();

    if (widget.task != null) {
      controller.updateTask(
        widget.task!.copyWith(
          title: title,
          description: _descCtrl.text.trim(),
          estimatedHours: double.tryParse(_estCtrl.text) ?? 0.0,
          priority: _selectedPriority,
          status: _selectedStatus,
          dueDate: _selectedDueDate,
        ),
      );
    } else {
      controller.addTask(
        title,
        _descCtrl.text.trim(),
        double.tryParse(_estCtrl.text) ?? 0.0,
        _selectedPriority,
        status: _selectedStatus,
        dueDate: _selectedDueDate,
      );
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task != null ? 'Edit Task' : 'Create Task',
                        style: AppTextStyles.h2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.task != null
                            ? 'Update the details of this task.'
                            : 'Add a new task to this project board.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.background,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              _buildLabel('Task Title', isRequired: true),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _titleCtrl,
                hintText: 'e.g., Design system audit',
                autofocus: true,
              ),
              const SizedBox(height: 24),

              _buildLabel('Description (Optional)'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _descCtrl,
                hintText: 'Briefly describe the task goals...',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Priority'),
                        const SizedBox(height: 8),
                        _buildDropdown<TaskPriority>(
                          initialValue: _selectedPriority,
                          items: TaskPriority.values,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedPriority = val);
                            }
                          },
                          itemBuilder: (p) => Text(p.name.capitalizeFirst!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Status'),
                        const SizedBox(height: 8),
                        _buildDropdown<TaskStatus>(
                          initialValue: _selectedStatus,
                          items: TaskStatus.values,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedStatus = val);
                            }
                          },
                          itemBuilder: (s) => Text(s.name.capitalizeFirst!),
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
                        _buildLabel('Estimated Time'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _estCtrl,
                          hintText: '2.5',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              'hrs',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textHint,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Due Date'),
                        const SizedBox(height: 8),
                        _buildDatePickerTrigger(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Total hours for this task.',
                style: TextStyle(fontSize: 11, color: AppColors.textHint),
              ),
              const SizedBox(height: 32),

              _buildInfoBox(),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    child: Text(
                      widget.task != null ? 'Update Task' : 'Create Task',
                      style: const TextStyle(fontWeight: FontWeight.w700),
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

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155), // Slate 700
            ),
          ),
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    bool autofocus = false,
    TextInputType? keyboardType,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      autofocus: autofocus,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.textHint,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: suffix != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [suffix],
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T initialValue,
    required List<T> items,
    required void Function(T?) onChanged,
    required Widget Function(T) itemBuilder,
  }) {
    return DropdownButtonFormField<T>(
      value: initialValue,
      items: items
          .map(
            (item) => DropdownMenuItem(value: item, child: itemBuilder(item)),
          )
          .toList(),
      onChanged: onChanged,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textSecondary,
      ),
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDatePickerTrigger() {
    return InkWell(
      onTap: _selectDueDate,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.textHint,
            ),
            const SizedBox(width: 12),
            Text(
              _selectedDueDate == null
                  ? 'Select date'
                  : DateFormat('MMM dd, yyyy').format(_selectedDueDate!),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: _selectedDueDate == null
                    ? AppColors.textHint
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time_filled_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Tasks can be tracked with the timer once created.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
