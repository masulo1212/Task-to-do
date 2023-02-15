import 'package:flutter/material.dart';

import '../blocs/bloc_exports.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  void _removeOrDelete(BuildContext ctx, Task task) {
    task.isDelete!
        ? ctx.read<TasksBloc>().add(DeleteTask(task: task))
        : ctx.read<TasksBloc>().add(RemoveTask(task: task));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          task.title,
          style: TextStyle(decoration: task.isDone! ? TextDecoration.lineThrough : null),
        ),
        trailing: Checkbox(
            value: task.isDone,
            //如果已經在垃圾桶，禁止再更新勾勾
            onChanged: task.isDelete == false
                ? (val) {
                    context.read<TasksBloc>().add(UpdateTask(task: task));
                    // BlocProvider.of<TasksBloc>(context).add(UpdateTask(task: task));
                  }
                : null),
        onLongPress: () => _removeOrDelete(context, task));
  }
}
