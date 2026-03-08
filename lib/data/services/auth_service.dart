import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/user_model.dart';
import '../../app/routes/app_pages.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Rx<User?> firebaseUser;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(_auth.currentUser);
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      await _fetchUserData(user.uid);
      Get.offAllNamed(Routes.MAIN);
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        currentUser.value = UserModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel newUser = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(newUser.id).set(newUser.toMap());
      currentUser.value = newUser;
    } catch (e) {
      Get.snackbar('Error', 'Registration failed: ${e.toString()}');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email sent');
    } catch (e) {
      Get.snackbar('Error', 'Failed to send reset email: ${e.toString()}');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      User? user;

      if (kIsWeb) {
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        final UserCredential userCredential = await _auth.signInWithPopup(
          authProvider,
        );
        user = userCredential.user;
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );
        user = userCredential.user;
      }

      if (user != null) {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (!doc.exists) {
          UserModel newUser = UserModel(
            id: user.uid,
            name: user.displayName ?? 'Google User',
            email: user.email ?? '',
            photoUrl: user.photoURL,
            createdAt: DateTime.now(),
          );
          await _firestore
              .collection('users')
              .doc(newUser.id)
              .set(newUser.toMap());
          currentUser.value = newUser;
        } else {
          // Update photoUrl if it's missing in the document
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data['photoUrl'] == null && user.photoURL != null) {
            await _firestore.collection('users').doc(user.uid).update({
              'photoUrl': user.photoURL,
            });
            // Re-fetch to update currentUser
            await _fetchUserData(user.uid);
          }
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Google sign in failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    currentUser.value = null;
  }
}
