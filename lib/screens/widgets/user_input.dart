import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/bloc/bloc_exports.dart';

import '../../models/task.dart';

class UserInput {
  //singleton
  factory UserInput() => _userInput;
  static final _userInput = UserInput._internal();
  UserInput._internal();

  TextEditingController titleCon = TextEditingController();

  void addTask(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddTaskWidget(titleCon: titleCon),
              ), //viewInsets.bottom 是取得底部的留白區域
            ));
  }
}

class AddTaskWidget extends StatelessWidget {
  const AddTaskWidget({
    Key? key,
    required this.titleCon,
  }) : super(key: key);

  final TextEditingController titleCon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Add a task',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            autofocus: true,
            controller: titleCon,
            decoration: const InputDecoration(label: Text('title'), border: OutlineInputBorder()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    final task = Task(title: titleCon.text);
                    BlocProvider.of<TasksBloc>(context).add(AddTask(task: task));
                    titleCon.clear();
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
