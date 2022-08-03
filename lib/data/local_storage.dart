import 'package:flutter_todo_app/models/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class LocalStorage {
  Future<void> addTask({required TaskModel taskModel});
  Future<TaskModel?> getTaskModel({required String id});
  Future<List<TaskModel>> getAllTask();
  Future<bool> deleteTaskModel({required TaskModel taskModel});
  Future<TaskModel> updateTaskModel({required TaskModel taskModel});
}

class MockData extends LocalStorage {
  @override
  Future<void> addTask({required TaskModel taskModel}) {
    // TODO: implement addTask
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTaskModel({required TaskModel taskModel}) {
    // TODO: implement deleteTaskModel
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> getAllTask() {
    // TODO: implement getAllTask
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> getTaskModel({required String id}) {
    // TODO: implement getTaskModel
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> updateTaskModel({required TaskModel taskModel}) {
    // TODO: implement updateTaskModel
    throw UnimplementedError();
  }
}

class HiveLocalStorage extends LocalStorage {
  late Box<TaskModel> _taskBox;

  HiveLocalStorage() {
    _taskBox = Hive.box<TaskModel>('tasks');
  }
  @override
  Future<void> addTask({required TaskModel taskModel}) async {
    await _taskBox.put(taskModel.id, taskModel);
  }

  @override
  Future<bool> deleteTaskModel({required TaskModel taskModel}) async {
    await taskModel.delete();
    return true;
  }

  @override
  Future<List<TaskModel>> getAllTask() async {
    List<TaskModel> _allTask = <TaskModel>[];
    _allTask = _taskBox.values.toList();

    if (_allTask.isNotEmpty) {
      _allTask.sort((TaskModel a, TaskModel b) {
        return a.createdAtTime.compareTo(b.createdAtTime);
      });
    }
    return _allTask;
  }

  @override
  Future<TaskModel?> getTaskModel({required String id}) async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    }
    return null;
  }

  @override
  Future<TaskModel> updateTaskModel({required TaskModel taskModel}) async {
    taskModel.save();
    return taskModel;
  }
}
