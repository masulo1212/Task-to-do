import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/models/task.dart';
import './widgets/user_input.dart';

import '../blocs/bloc_exports.dart';
import '../widgets/task_list.dart';

class TasksPending extends StatelessWidget {
  const TasksPending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        List<Task> taskList = state.pendingTasks; //state change -> rebuild
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Chip(
                    label: Text(
                      '${taskList.length} Waiting | ${state.completeTasks.length} Complete',
                    ),
                  ),
                ),
              ),
              TaskList(taskList: taskList)
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => UserInput().addTask(context),
            tooltip: 'Add Task',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
