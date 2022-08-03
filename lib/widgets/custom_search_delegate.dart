import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<TaskModel> allTasks;

  CustomSearchDelegate({required this.allTasks});

  LocalStorage _localStorage = locator<LocalStorage>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          query.isEmpty ? null : query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 24,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<TaskModel> filterList = allTasks.where((element) {
      return element.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return filterList.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              TaskModel _nowThatTask = filterList[index];
              return Dismissible(
                key: Key(_nowThatTask.id),
                onDismissed: (direction) async {
                  allTasks.removeAt(index);
                  await _localStorage.deleteTaskModel(taskModel: _nowThatTask);
                },
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    Text('remove_task').tr(),
                  ],
                ),
                child: TaskItem(taskModel: _nowThatTask),
              );
            },
            itemCount: filterList.length,
          )
        : Center(
            child: Text('search_not_found').tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
