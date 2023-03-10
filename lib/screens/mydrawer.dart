import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/recycle_bin.dart';
import 'package:flutter_tasks_app/screens/tab_screen.dart';
import 'package:get/get.dart';

import '../blocs/bloc_exports.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.blueGrey,
              child: const Text(
                'Tasks Drawer',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            //項目一
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => Get.offAll(const TabScreen()),
                  child: ListTile(
                    leading: const Icon(Icons.folder_special),
                    title: const Text('My Task'),
                    trailing: Text('${state.pendingTasks.length} / ${state.completeTasks.length}'),
                  ),
                );
              },
            ),
            const Divider(
              thickness: 2,
            ),

            //項目二
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => Get.offAll(RecycleBin()),
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Recycle'),
                    trailing: Text('${state.removeTasks.length}'),
                  ),
                );
              },
            ),
            //在Flutter中，Switch小部件的onChanged回調函數接受一個布爾值參數newVal，它代表Switch的新狀態。當用戶切換Switch時，Flutter將自動更新小部件的狀態，並調用onChanged回調函數，將新狀態作為參數傳遞給該函數

            const Divider(
              thickness: 2,
            ),

            BlocBuilder<SwitchBloc, SwitchState>(
              builder: (context, state) {
                return ListTile(
                  leading: !state.switchVal ? const Icon(Icons.sunny) : const Icon(Icons.dark_mode),
                  title: !state.switchVal ? const Text('Light Mode') : const Text('Dark Mode'),
                  trailing: Switch(
                      value: state.switchVal,
                      onChanged: (newVal) {
                        newVal
                            ? context.read<SwitchBloc>().add(SwitchOnEvent())
                            : context.read<SwitchBloc>().add(SwitchOffEvent());
                      }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
