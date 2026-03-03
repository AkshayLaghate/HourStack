import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  Future<void> register() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  Future<void> forgotPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }
    await _authService.forgotPassword(email);
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      await _authService.signInWithGoogle();
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  void logout() {
    _authService.logout();
  }
}
