import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hourstack/main.dart';
import 'package:hourstack/data/services/auth_service.dart';
import 'package:hourstack/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockAuthService extends GetxService implements AuthService {
  @override
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  late Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> register(String name, String email, String password) async {}

  @override
  Future<void> forgotPassword(String email) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> logout() async {}
}

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('App renders Login screen correctly', (
    WidgetTester tester,
  ) async {
    // Provide MockAuthService before pumping MyApp
    Get.put<AuthService>(MockAuthService());

    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Verify that Login screen elements are present
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login to HourStack'), findsOneWidget);
    expect(
      find.byType(TextField),
      findsAtLeastNWidgets(2),
    ); // Email and Password
    expect(find.text('Login'), findsOneWidget);
  });
}
