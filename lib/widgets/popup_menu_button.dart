import 'package:flutter/material.dart';

import '../models/task.dart';

class PopupButton extends StatelessWidget {
  final VoidCallback cancelOrDelete;
  final VoidCallback likeOrDislike;
  final Task task;
  const PopupButton({
    Key? key,
    required this.cancelOrDelete,
    required this.task,
    required this.likeOrDislike,
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
                        onPressed: null,
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                      onTap: () {}),
                  PopupMenuItem(
                      child: TextButton.icon(
                        onPressed: null,
                        icon: task.isFavorite == false ? const Icon(Icons.bookmark) : const Icon(Icons.bookmark_remove),
                        label: task.isFavorite == false ? const Text('Add bookmark') : const Text('Remove bookmark'),
                      ),
                      onTap: likeOrDislike),
                  PopupMenuItem(
                      child: TextButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                      ),
                      onTap: cancelOrDelete)
                  // onTap: () => _removeOrDelete(context, task))
                ]
            :
            //三元運算
            (context) => [
                  PopupMenuItem(
                      child: TextButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.restore_from_trash),
                        label: const Text('Restore'),
                      ),
                      onTap: () {}),
                  PopupMenuItem(
                      child: TextButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.delete_forever),
                        label: const Text('Delete Forever'),
                      ),
                      onTap: cancelOrDelete)
                ]);
  }
}
