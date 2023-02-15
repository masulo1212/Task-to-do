import 'package:flutter/material.dart';

import '../models/task.dart';

class PopupButton extends StatelessWidget {
  final VoidCallback cancelOrDelete;
  final Task task;
  const PopupButton({
    Key? key,
    required this.cancelOrDelete,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: task.isDelete == false
            ?
            //三元運算
            (context) => [
                  PopupMenuItem(
                      child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  )),
                  PopupMenuItem(
                      child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark),
                    label: const Text('Add bookmark'),
                  )),
                  PopupMenuItem(
                    child: TextButton.icon(
                      onPressed: cancelOrDelete,
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    ),
                  )
                  // onTap: () => _removeOrDelete(context, task))
                ]
            :
            //三元運算
            (context) => [
                  PopupMenuItem(
                      child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.restore_from_trash),
                    label: const Text('Restore'),
                  )),
                  PopupMenuItem(
                    child: TextButton.icon(
                      onPressed: cancelOrDelete,
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Delete Forever'),
                    ),
                  )
                ]);
  }
}
