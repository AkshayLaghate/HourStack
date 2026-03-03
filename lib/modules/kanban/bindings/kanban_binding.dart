import 'package:get/get.dart';
import '../controllers/kanban_controller.dart';

class KanbanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KanbanController>(() => KanbanController());
  }
}
