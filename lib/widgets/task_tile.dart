import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/widgets/popup_menu_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../blocs/bloc_exports.dart';
import '../models/task.dart';
import '../screens/widgets/user_input.dart';

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

  void _editTask(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true, //讓鍵盤不會檔到輸入框
        context: context,
        builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: EditTaskWidget(
                  oldTask: task,
                ),
              ), //viewInsets.bottom 是取得底部的留白區域
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              //icon
              task.isFavorite == false ? const Icon(Icons.star_outline) : const Icon(Icons.star),
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
                    const SizedBox(height: 10),
                    Text(
                      DateFormat().add_yMMMd().add_Hms().format(DateTime.parse(task.date)),
                      style: const TextStyle(fontSize: 10, color: Colors.black54),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        //圖標
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
            PopupButton(
              task: task,
              cancelOrDelete: () => _removeOrDelete(context, task),
              likeOrDislike: () => context.read<TasksBloc>().add(MarkFavTask(task: task)),
              editTask: () {
                Get.back();
                _editTask(context);
              },
              restoreTask: () => context.read<TasksBloc>().add(RestoreTask(task: task)),
            )
          ],
        ),
      ],
    );
  }
}
