import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/widgets/task_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../blocs/bloc_exports.dart';
import 'mydrawer.dart';

class RecycleBin extends StatelessWidget {
  RecycleBin({Key? key}) : super(key: key);

  final RefreshController refreshController = RefreshController(
    initialRefresh: false, // 一开始就自动下拉刷新
  );

  void onRefresh(BuildContext context) {
    try {
      context.read<TasksBloc>().add(LoadBinTask());
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
        return SmartRefresher(
          controller: refreshController,
          onRefresh: () => onRefresh(context),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Recycle'),
              actions: [
                PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: const [Icon(Icons.delete_forever), SizedBox(width: 10), Text('Delete forever')],
                            ),
                            onTap: () => context.read<TasksBloc>().add(DeleteAllTask()),
                          )
                        ])
              ],
            ),
            drawer: const MyDrawer(),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Chip(
                      label: Text(
                        '${state.removeTasks.length} Tasks',
                      ),
                    ),
                  ),
                ),
                TaskList(taskList: state.removeTasks)
              ],
            ),
          ),
        );
      },
    );
  }
}
