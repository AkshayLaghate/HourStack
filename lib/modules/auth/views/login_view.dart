import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/theme/app_colors.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginDarkBg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 900) {
            return _buildMobileLayout(context);
          }
          return _buildDesktopLayout(context);
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.loginDarkBg,
            Color(0xFF0E1225),
            AppColors.loginDarkBg,
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                _buildLogo(),
                const SizedBox(height: 40),
                _buildLoginCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left — Immersive brand showcase
        Expanded(
          flex: 11,
          child: _buildHeroPanel(),
        ),
        // Right — Login form
        Expanded(
          flex: 9,
          child: Container(
            color: AppColors.loginDarkSurface,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 56),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _buildLoginCard(context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Hero Panel (Desktop Left Side) ──────────────────────────────────

  Widget _buildHeroPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D1120),
            AppColors.loginDarkBg,
            Color(0xFF0F0D1F),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Subtle radial glow behind content
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -60,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryGlow.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Grid lines overlay
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter()),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogo(),
                const Spacer(),
                _buildHeroContent(),
                const SizedBox(height: 48),
                _buildMetricCards(),
                const Spacer(),
                _buildSocialProof(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryGlow],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.timer_outlined,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        const Text(
          'HourStack',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.loginDarkTextPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pill badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Trusted by 2,400+ freelancers',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGlow,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Time tracking\nthat works for you.',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: AppColors.loginDarkTextPrimary,
            height: 1.08,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Stop guessing where your hours go. HourStack gives\nyou clarity, focus, and control over every billable minute.',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.loginDarkTextSecondary,
            height: 1.65,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCards() {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.schedule_rounded,
            value: '1.2M+',
            label: 'Hours tracked',
            accentColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _MetricCard(
            icon: Icons.trending_up_rounded,
            value: '32%',
            label: 'Avg. productivity gain',
            accentColor: AppColors.success,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _MetricCard(
            icon: Icons.folder_outlined,
            value: '18K+',
            label: 'Active projects',
            accentColor: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialProof() {
    return Row(
      children: [
        // Overlapping avatars
        SizedBox(
          width: 100,
          height: 36,
          child: Stack(
            children: List.generate(4, (i) {
              final colors = [
                const Color(0xFF6366F1),
                const Color(0xFF22C55E),
                const Color(0xFFF59E0B),
                const Color(0xFF3B82F6),
              ];
              return Positioned(
                left: i * 22.0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors[i],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.loginDarkBg,
                      width: 2.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      ['A', 'M', 'S', 'K'][i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (_) => const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFBBF24),
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Loved by independent professionals',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.loginDarkTextSecondary.withValues(alpha: 0.7),
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Login Card ──────────────────────────────────────────────────────

  Widget _buildLoginCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.loginDarkTextPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue to your dashboard.',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.loginDarkTextSecondary,
          ),
        ),
        const SizedBox(height: 36),
        // Google sign-in button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () => controller.signInWithGoogle(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.loginDarkBorder),
              backgroundColor: AppColors.loginDarkCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Simple Google "G" icon
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.g_mobiledata,
                    size: 28,
                    color: AppColors.loginDarkTextPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.loginDarkTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        // Divider with "or"
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.loginDarkBorder,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.loginDarkTextSecondary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.loginDarkBorder,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        // Email field
        _buildDarkTextField(
          label: 'Email',
          hint: 'name@company.com',
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.mail_outline_rounded,
        ),
        const SizedBox(height: 20),
        // Password field
        _buildDarkPasswordField(),
        const SizedBox(height: 14),
        // Forgot password
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: _handleForgotPassword,
            child: Text(
              'Forgot password?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryGlow.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        // Sign in button
        Obx(
          () => SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.login,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ).copyWith(
                overlayColor: WidgetStateProperty.all(
                  Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Sign up link
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.loginDarkTextSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.REGISTER),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGlow,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Text Fields ────────────────────────────────────────────────────

  Widget _buildDarkTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.loginDarkTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.loginDarkTextPrimary,
          ),
          cursorColor: AppColors.primaryGlow,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.loginDarkTextSecondary.withValues(alpha: 0.4),
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.loginDarkInputBg,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    size: 18,
                    color: AppColors.loginDarkTextSecondary.withValues(alpha: 0.5),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.loginDarkInputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.loginDarkInputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDarkPasswordField() {
    final obscure = true.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.loginDarkTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextField(
            controller: controller.passwordController,
            obscureText: obscure.value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.loginDarkTextPrimary,
            ),
            cursorColor: AppColors.primaryGlow,
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(
                color: AppColors.loginDarkTextSecondary.withValues(alpha: 0.4),
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.loginDarkInputBg,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                size: 18,
                color: AppColors.loginDarkTextSecondary.withValues(alpha: 0.5),
              ),
              suffixIcon: GestureDetector(
                onTap: () => obscure.value = !obscure.value,
                child: Icon(
                  obscure.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: AppColors.loginDarkTextSecondary.withValues(alpha: 0.5),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.loginDarkInputBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.loginDarkInputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleForgotPassword() {
    if (controller.emailController.text.isNotEmpty) {
      controller.forgotPassword(controller.emailController.text.trim());
    } else {
      Get.snackbar(
        'Hint',
        'Enter your email address first to reset password',
        backgroundColor: AppColors.loginDarkCard,
        colorText: AppColors.loginDarkTextPrimary,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}

// ── Metric Card Widget ──────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color accentColor;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.loginDarkCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.loginDarkBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.loginDarkTextPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.loginDarkTextSecondary,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Grid Background Painter ──────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.loginDarkBorder.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;

    const spacing = 60.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
