import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatefulWidget {
  TaskItem({Key? key, required this.taskModel}) : super(key: key);

  TaskModel taskModel;
  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController taskNameController = TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    taskNameController.text = widget.taskModel.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.2),
          blurRadius: 10,
        )
      ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            setState(() {
              widget.taskModel.isCompleted = !widget.taskModel.isCompleted;
              _localStorage.updateTaskModel(taskModel: widget.taskModel);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.taskModel.isCompleted ? Colors.green : Colors.white,
              border: Border.all(color: Colors.grey, width: 0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
        title: widget.taskModel.isCompleted
            ? Text(
                widget.taskModel.name,
                style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: taskNameController,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (value) {
                  if (value.length > 3) {
                    widget.taskModel.name = value;
                    _localStorage.updateTaskModel(taskModel: widget.taskModel);
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.taskModel.createdAtTime),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
