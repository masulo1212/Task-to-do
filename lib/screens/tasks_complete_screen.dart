import 'package:flutter/material.dart';

import '../blocs/bloc_exports.dart';
import '../models/task.dart';
import '../widgets/task_list.dart';

class TaskComplete extends StatelessWidget {
  const TaskComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        List<Task> taskList = state.completeTasks; //state change -> rebuild
        return Scaffold(
          body: Column(
            children: [
              Center(
                child: Chip(
                  label: Text(
                    '${taskList.length} Tasks',
                  ),
                ),
              ),
              TaskList(taskList: taskList)
            ],
          ),
        );
      },
    );
  }
}
