import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/bloc/bloc_exports.dart';

import '../models/task.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.taskList,
  }) : super(key: key);

  final List<Task> taskList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            final task = taskList[index];
            return ListTile(
              title: Text(task.title),
              trailing: Checkbox(
                  value: task.isDone,
                  onChanged: (val) {
                    BlocProvider.of<TasksBloc>(context).add(UpdateTask(task: task));
                  }),
              onLongPress: () => BlocProvider.of<TasksBloc>(context).add(DeleteTask(task: task)),
            );
          }),
    );
  }
}
