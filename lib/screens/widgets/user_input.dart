import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/blocs/bloc_exports.dart';
import 'package:flutter_tasks_app/utils/uuid.dart';

import '../../models/task.dart';

class UserInput {
  //singleton
  factory UserInput() => _userInput;
  static final _userInput = UserInput._internal();
  UserInput._internal();

  void addTask(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true, //讓鍵盤不會檔到輸入框
        context: context,
        builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const AddTaskWidget(),
              ), //viewInsets.bottom 是取得底部的留白區域
            ));
  }
}

class AddTaskWidget extends StatelessWidget {
  const AddTaskWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleCon = TextEditingController();
    TextEditingController desCon = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Add a task',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          //標題
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              autofocus: true,
              controller: titleCon,
              decoration: const InputDecoration(label: Text('title'), border: OutlineInputBorder()),
            ),
          ),

          //說明
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              autofocus: true,
              controller: desCon,
              decoration: const InputDecoration(label: Text('description'), border: OutlineInputBorder()),
              minLines: 3,
              maxLines: 5,
            ),
          ),

          //按鈕
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    final task = Task(
                        title: titleCon.text,
                        description: desCon.text,
                        id: GenId.genUuid(),
                        date: DateTime.now().toString());
                    context.read<TasksBloc>().add(AddTask(task: task));
                    // BlocProvider.of<TasksBloc>(context).add(AddTask(task: task));
                    Navigator.pop(context);
                    //也可執行 context.read<TasksBloc>().add(AddTask(task: task))則是使用BuildContext來讀取和操作Bloc物件
                  },
                  child: const Text('Add'))
            ],
          )
        ],
      ),
    );
  }
}

class EditTaskWidget extends StatelessWidget {
  const EditTaskWidget({Key? key, required this.oldTask}) : super(key: key);
  final Task oldTask;

  @override
  Widget build(BuildContext context) {
    TextEditingController titleCon = TextEditingController(text: oldTask.title);
    TextEditingController desCon = TextEditingController(text: oldTask.description);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Edit a task',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          //標題
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              autofocus: true,
              controller: titleCon,
              decoration: const InputDecoration(label: Text('title'), border: OutlineInputBorder()),
            ),
          ),

          //說明
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              autofocus: true,
              controller: desCon,
              decoration: const InputDecoration(label: Text('description'), border: OutlineInputBorder()),
              minLines: 3,
              maxLines: 5,
            ),
          ),

          //按鈕
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    //注意！只有pending
                    final editTask = Task(
                        title: titleCon.text,
                        description: desCon.text,
                        id: oldTask.id,
                        isDone: false, //邏輯：修改過的task會出現在pending, 而原本在complete的則會消失
                        isFavorite: oldTask.isFavorite,
                        date: DateTime.now().toString());
                    context.read<TasksBloc>().add(EditTask(oldTask: oldTask, newTask: editTask));
                    // BlocProvider.of<TasksBloc>(context).add(AddTask(task: task));
                    Navigator.pop(context);
                    //也可執行 context.read<TasksBloc>().add(AddTask(task: task))則是使用BuildContext來讀取和操作Bloc物件
                  },
                  child: const Text('Save'))
            ],
          )
        ],
      ),
    );
  }
}
