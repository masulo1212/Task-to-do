import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/widgets/task_tile.dart';

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
      child: SingleChildScrollView(
        child: ExpansionPanelList.radio(
          elevation: 1,
          children: taskList
              .map((e) => ExpansionPanelRadio(
                    value: e.id, //唯一標誌符
                    headerBuilder: (context, isOpen) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TaskTile(task: e),
                    ),
                    //SelectableText讓user可以複製文字
                    //textspan可以讓文字格式化
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        SelectableText.rich(TextSpan(children: [
                          const TextSpan(text: 'Title:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: e.title),
                          const TextSpan(text: '\n\nDescription:\n', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: e.description),
                        ])),
                      ]),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// Expanded(
//       child: ListView.builder(
//           itemCount: taskList.length,
//           itemBuilder: (context, index) {
//             final task = taskList[index];
//             return TaskTile(task: task);
//           }),
//     );