import 'package:get/get.dart';

class MainController extends GetxController {
  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;

  void changeIndex(int index) {
    _selectedIndex.value = index;
  }

  // Map route names to indices if needed for direct navigation
  void navigateTo(String route) {
    switch (route) {
      case '/dashboard':
        _selectedIndex.value = 0;
        break;
      case '/projects':
        _selectedIndex.value = 1;
        break;
      case '/reports':
        _selectedIndex.value = 2;
        break;
      // Add more as needed
    }
  }
}
