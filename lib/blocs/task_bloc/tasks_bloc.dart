import 'package:equatable/equatable.dart';
import '../bloc_exports.dart';

import '../../models/task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavTask>(_onMarkFavTask);
  }

  //event handler
  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks)..add(event.task),
      completeTasks: state.completeTasks,
      favoriteTasks: state.favoriteTasks,
      removeTasks: state.removeTasks,
    ));

    //allTasks 的值是由當前 state 的 allTasks 複製一份出來，再加上一個新的 task。
    //不是同一個實例，每次傳遞 TasksState 物件給外面時，都是傳遞的新的物件，而不是之前的物件。每次觸發emit事件後，state就會被替換為新的TasksState實例。
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final task = event.task;

    List<Task> pendingTasks = state.pendingTasks;
    List<Task> completeTasks = state.completeTasks;
    //如果完成 就加進complete list 且pending list要remove
    task.isDone == false
        ? {
            pendingTasks = List.from(state.pendingTasks)..remove(task),
            completeTasks = List.from(state.completeTasks)..insert(0, task.copyWith(isDone: true))
          }
        : {
            pendingTasks = List.from(state.pendingTasks)..insert(0, task.copyWith(isDone: false)),
            completeTasks = List.from(state.completeTasks)..remove(task)
          };
    emit(TasksState(
        pendingTasks: pendingTasks,
        completeTasks: completeTasks,
        favoriteTasks: state.favoriteTasks,
        removeTasks: state.removeTasks));
  }

  //完全刪除
  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final task = event.task;

    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks), //主頁task數量不變
      completeTasks: List.from(state.completeTasks), //主頁task數量不變
      favoriteTasks: List.from(state.favoriteTasks), //主頁task數量不變
      removeTasks: List.from(state.removeTasks)..remove(task), //從bin永久刪除
    ));
  }

  //remove 放到bin
  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final task = event.task;

    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks)..remove(task),
      completeTasks: List.from(state.completeTasks)..remove(task),
      favoriteTasks: List.from(state.favoriteTasks)..remove(task),
      removeTasks: List.from(state.removeTasks)..add(task.copyWith(isDelete: true)),
    ));
  }

  //mark fav
  void _onMarkFavTask(MarkFavTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final task = event.task;
    //fav會牽涉到pending & complete 的list-> 在pending or complete按下後會加入到fav list, 但原本的task也不會消失
    List<Task> pendingTasks = state.pendingTasks;
    List<Task> completeTasks = state.completeTasks;
    List<Task> favoriteTasks = state.favoriteTasks;

    //先處理pending list
    if (task.isDone == false) {
      if (task.isFavorite == false) {
        //1. 在pending list更新bool fav
        final index = pendingTasks.indexWhere((element) => element == task);
        pendingTasks = List.from(state.pendingTasks)
          ..remove(task)
          ..insert(index, task.copyWith(isFavorite: true));

        //2. 加入到fav list
        favoriteTasks = List.from(state.favoriteTasks)..insert(0, task.copyWith(isFavorite: true));
      } else {
        //1. 在pending list更新bool fav
        final index = pendingTasks.indexWhere((element) => element == task);
        pendingTasks = List.from(state.pendingTasks)
          ..remove(task)
          ..insert(index, task.copyWith(isFavorite: false));

        //2. 從fav list移除
        favoriteTasks = List.from(state.favoriteTasks)..remove(task);
      }
    } else {
      // complete list
      if (task.isFavorite == false) {
        //1. 在complete list更新bool fav
        final index = completeTasks.indexWhere((element) => element == task);
        completeTasks = List.from(state.completeTasks)
          ..remove(task)
          ..insert(index, task.copyWith(isFavorite: true));

        //2. 加入到fav list
        favoriteTasks = List.from(state.favoriteTasks)..insert(0, task.copyWith(isFavorite: true));
      } else {
        //1. 在completeTasks list更新bool fav
        final index = completeTasks.indexWhere((element) => element == task);
        completeTasks = List.from(state.completeTasks)
          ..remove(task)
          ..insert(index, task.copyWith(isFavorite: false));

        //2. 從fav list移除
        favoriteTasks = List.from(state.favoriteTasks)..remove(task);
      }
    }
    emit(TasksState(
        pendingTasks: pendingTasks,
        completeTasks: completeTasks,
        favoriteTasks: favoriteTasks,
        removeTasks: state.removeTasks));
  }

  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    return TasksState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TasksState state) {
    return state.toMap();
  }
}
