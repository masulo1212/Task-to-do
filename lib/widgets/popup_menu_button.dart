import 'package:flutter/material.dart';

import '../models/task.dart';

class PopupButton extends StatelessWidget {
  final VoidCallback cancelOrDelete;
  final VoidCallback likeOrDislike;
  final VoidCallback editTask;
  final VoidCallback restoreTask;

  final Task task;
  const PopupButton({
    Key? key,
    required this.cancelOrDelete,
    required this.task,
    required this.likeOrDislike,
    required this.editTask,
    required this.restoreTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(
          Icons.more_vert,
          color: Colors.black54,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        itemBuilder: task.isDelete == false
            ?
            //三元運算
            (context) => [
                  PopupMenuItem(
                      child: GestureDetector(
                    onTap: editTask, //較特殊 因為是modalsheet 必須透過此方式才能顯示
                    behavior: HitTestBehavior.opaque, //讓點擊範圍變大
                    child: Row(children: const [
                      Icon(Icons.edit),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Edit')
                    ]),
                  )),
                  PopupMenuItem(
                      child: task.isFavorite == false
                          ? Row(children: const [
                              Icon(Icons.bookmark),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Add bookmark')
                            ])
                          : Row(children: const [
                              Icon(Icons.bookmark_remove),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Remove bookmark')
                            ]),
                      onTap: likeOrDislike),
                  PopupMenuItem(
                      child: Row(children: const [
                        Icon(Icons.delete),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Delete')
                      ]),
                      onTap: cancelOrDelete)
                  // onTap: () => _removeOrDelete(context, task))
                ]
            :
            //三元運算
            (context) => [
                  PopupMenuItem(
                      child: Row(children: const [
                        Icon(Icons.restore_from_trash),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Restore')
                      ]),
                      onTap: restoreTask),
                  PopupMenuItem(
                      child: Row(children: const [
                        Icon(Icons.delete_forever),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Delete Forever')
                      ]),
                      onTap: cancelOrDelete)
                ]);
  }
}
