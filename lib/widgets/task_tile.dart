import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/widgets/popup_menu_button.dart';
import 'package:intl/intl.dart';

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
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              //icon
              const Icon(Icons.star_outline),
              const SizedBox(width: 10),

              //標題
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(decoration: task.isDone! ? TextDecoration.lineThrough : null),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(DateFormat().add_yMMMd().add_Hms().format(DateTime.now()))
                  ],
                ),
              ),
            ],
          ),
        ),

        //圖片
        Row(
          children: [
            Checkbox(
                value: task.isDone,
                //如果已經在垃圾桶，禁止再更新勾勾
                onChanged: task.isDelete == false
                    ? (val) {
                        context.read<TasksBloc>().add(UpdateTask(task: task));
                        // BlocProvider.of<TasksBloc>(context).add(UpdateTask(task: task));
                      }
                    : null),

            //彈出menu
            PopupButton(task: task, cancelOrDelete: () => _removeOrDelete(context, task))
          ],
        ),
      ],
    );
  }
}



// ListTile(
//         title: Text(
//           task.title,
//           style: TextStyle(decoration: task.isDone! ? TextDecoration.lineThrough : null),
//           overflow: TextOverflow.ellipsis,
//         ),
//         trailing: Checkbox(
//             value: task.isDone,
//             //如果已經在垃圾桶，禁止再更新勾勾
//             onChanged: task.isDelete == false
//                 ? (val) {
//                     context.read<TasksBloc>().add(UpdateTask(task: task));
//                     // BlocProvider.of<TasksBloc>(context).add(UpdateTask(task: task));
//                   }
//                 : null),
//         onLongPress: () => _removeOrDelete(context, task));
