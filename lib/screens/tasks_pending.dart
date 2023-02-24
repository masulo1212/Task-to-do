import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/models/task.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './widgets/user_input.dart';

import '../blocs/bloc_exports.dart';
import '../widgets/task_list.dart';

class TasksPending extends StatelessWidget {
  TasksPending({Key? key}) : super(key: key);

  final RefreshController refreshController = RefreshController(
    initialRefresh: false, // 一开始就自动下拉刷新
  );

  void onRefresh(BuildContext context) {
    try {
      context.read<TasksBloc>().add(LoadPendingTask());
      refreshController.refreshCompleted();
    } catch (error) {
      // 刷新失败
      refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        List<Task> taskList = state.pendingTasks;
//state change -> rebuild
        return SmartRefresher(
          controller: refreshController,
          onRefresh: () => onRefresh(context),
          child: Scaffold(
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
          ),
        );
      },
    );
  }
}
