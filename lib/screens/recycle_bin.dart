import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/widgets/task_list.dart';

import '../blocs/bloc_exports.dart';
import 'mydrawer.dart';

class RecycleBin extends StatelessWidget {
  const RecycleBin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bin'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              )
            ],
          ),
          drawer: const MyDrawer(),
          body: Column(
            children: [
              Center(
                child: Chip(
                  label: Text(
                    '${state.removeTasks.length} Tasks',
                  ),
                ),
              ),
              TaskList(taskList: state.removeTasks)
            ],
          ),
        );
      },
    );
  }
}
