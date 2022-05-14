import 'package:daily_reminder/database/db_helper.dart';
import 'package:daily_reminder/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;
  
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task!);
  }
  
  void getTask() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTask(Task task) {
    DBHelper.delete(task);
    getTask();
  }

  void markTaskCompleted(int id) {
    DBHelper.updateStatus(id);
    getTask();
  }
}