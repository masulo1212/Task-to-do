import 'package:equatable/equatable.dart';
import 'package:flutter_tasks_app/services/api.dart';
import '../bloc_exports.dart';

import '../../models/task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavTask>(_onMarkFavTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTask>(_onDeleteAllTask);
    on<LoadPendingTask>(_onLoadPendingTask);
    on<LoadCompleteTask>(_onLoadCompleteTask);
    on<LoadFavTask>(_onLoadFavTask);
    on<LoadBinTask>(_onLoadBinTask);
  }

//loading handler
  Future<void> _onLoadPendingTask(LoadPendingTask event, Emitter<TasksState> emit) async {
    var allPendingList = await Api.getAllPending();
    emit(TasksState(
        pendingTasks: allPendingList,
        completeTasks: state.completeTasks,
        favoriteTasks: state.favoriteTasks,
        removeTasks: state.removeTasks));
  }

  Future<void> _onLoadCompleteTask(LoadCompleteTask event, Emitter<TasksState> emit) async {
    var allCompleteList = await Api.getAllComplete();
    emit(TasksState(
        pendingTasks: state.pendingTasks,
        completeTasks: allCompleteList,
        favoriteTasks: state.favoriteTasks,
        removeTasks: state.removeTasks));
  }

  Future<void> _onLoadFavTask(LoadFavTask event, Emitter<TasksState> emit) async {
    var allFavList = await Api.getAllFav();
    emit(TasksState(
        pendingTasks: state.pendingTasks,
        completeTasks: state.completeTasks,
        favoriteTasks: allFavList,
        removeTasks: state.removeTasks));
  }

  Future<void> _onLoadBinTask(LoadBinTask event, Emitter<TasksState> emit) async {
    var allBinList = await Api.getAllBin();
    emit(TasksState(
        pendingTasks: state.pendingTasks,
        completeTasks: state.completeTasks,
        favoriteTasks: state.favoriteTasks,
        removeTasks: allBinList));
  }

  //event handler
  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    final state = this.state;

    await Api.addPending(event.task);

    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks)..add(event.task),
      completeTasks: state.completeTasks,
      favoriteTasks: state.favoriteTasks,
      removeTasks: state.removeTasks,
    ));
    //allTasks 的值是由當前 state 的 allTasks 複製一份出來，再加上一個新的 task。
    //不是同一個實例，每次傳遞 TasksState 物件給外面時，都是傳遞的新的物件，而不是之前的物件。每次觸發emit事件後，state就會被替換為新的TasksState實例。
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    final task = event.task;

    List<Task> pendingTasks = state.pendingTasks;
    List<Task> completeTasks = state.completeTasks;
    List<Task> favTasks = state.favoriteTasks;
    //如果完成 就加進complete list 且pending list要remove

    //如果有勾選
    if (task.isDone == false) {
      if (task.isFavorite == false) {
        //call api
        await Api.deletePending(task);
        await Api.addComplete(task.copyWith(isDone: true));

        pendingTasks = List.from(state.pendingTasks)..remove(task);
        completeTasks = List.from(state.completeTasks)..insert(0, task.copyWith(isDone: true));
      } else {
        //call api
        await Api.deletePending(task);
        await Api.addComplete(task.copyWith(isDone: true));
        await Api.updateFav(task.copyWith(isDone: true));

        final index = favTasks.indexOf(task);
        pendingTasks = List.from(state.pendingTasks)..remove(task);
        completeTasks = List.from(state.completeTasks)..insert(0, task.copyWith(isDone: true));
        favTasks = List.from(state.favoriteTasks)
          ..remove(task)
          ..insert(index, task.copyWith(isDone: true));
      }
    } else {
      //如果取消勾選 會移動回pending, complete就要刪除
      if (task.isFavorite == false) {
        //call api
        await Api.deleteComplete(task);
        await Api.addPending(task.copyWith(isDone: false));

        pendingTasks = List.from(state.pendingTasks)..insert(0, task.copyWith(isDone: false));
        completeTasks = List.from(state.completeTasks)..remove(task);
      } else {
        //如果取消勾選 會移動回pending, complete就要刪除, fav也要取消勾選
        //call api
        await Api.deleteComplete(task);
        await Api.addPending(task.copyWith(isDone: false));
        await Api.updateFav(task.copyWith(isDone: false));

        final index = favTasks.indexOf(task);
        pendingTasks = List.from(state.pendingTasks)..insert(0, task.copyWith(isDone: false));
        completeTasks = List.from(state.completeTasks)..remove(task);
        favTasks = List.from(state.favoriteTasks)
          ..remove(task)
          ..insert(index, task.copyWith(isDone: false));
      }
    }

    emit(TasksState(
        pendingTasks: pendingTasks,
        completeTasks: completeTasks,
        favoriteTasks: favTasks,
        removeTasks: state.removeTasks));
  }

  //完全刪除
  Future<void> _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    final task = event.task;

    await Api.deleteBin(task);

    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks), //主頁task數量不變
      completeTasks: List.from(state.completeTasks), //主頁task數量不變
      favoriteTasks: List.from(state.favoriteTasks), //主頁task數量不變
      removeTasks: List.from(state.removeTasks)..remove(task), //從bin永久刪除
    ));
  }

  //remove 放到bin
  Future<void> _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    final task = event.task;

    await Api.deletePending(task);
    await Api.deleteComplete(task);
    await Api.deleteFav(task);
    await Api.addBin(task.copyWith(isDelete: true));

    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks)..remove(task),
      completeTasks: List.from(state.completeTasks)..remove(task),
      favoriteTasks: List.from(state.favoriteTasks)..remove(task),
      removeTasks: List.from(state.removeTasks)..add(task.copyWith(isDelete: true)),
    ));
  }

  //mark fav
  Future<void> _onMarkFavTask(MarkFavTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    final task = event.task;
    //fav會牽涉到pending & complete 的list-> 在pending or complete按下後會加入到fav list, 但原本的task也不會消失
    List<Task> pendingTasks = state.pendingTasks;
    List<Task> completeTasks = state.completeTasks;
    List<Task> favoriteTasks = state.favoriteTasks;

    //先處理pending list
    if (task.isDone == false) {
      if (task.isFavorite == false) {
        //call api
        await Api.updatePending(task.copyWith(isFavorite: true));
        await Api.addFav(task.copyWith(isFavorite: true));

        //1. 在pending list更新bool fav
        final index = pendingTasks.indexWhere((element) => element == task);
        pendingTasks = List.from(state.pendingTasks)
          ..remove(task)
          ..insert(index, task.copyWith(isFavorite: true));

        //2. 加入到fav list
        favoriteTasks = List.from(state.favoriteTasks)..insert(0, task.copyWith(isFavorite: true));
      } else {
        //call api
        await Api.updatePending(task.copyWith(isFavorite: false));
        await Api.deleteFav(task);

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
        //call api
        await Api.updateComplete(task.copyWith(isFavorite: true));
        await Api.addFav(task.copyWith(isFavorite: true));

        //1. 在complete list更新bool fav
        final index = completeTasks.indexWhere((element) => element == task);
        completeTasks = List.from(state.completeTasks)
          ..remove(task)
          ..insert(index, task.copyWith(isFavorite: true));

        //2. 加入到fav list
        favoriteTasks = List.from(state.favoriteTasks)..insert(0, task.copyWith(isFavorite: true));
      } else {
        //call api
        await Api.updateComplete(task.copyWith(isFavorite: false));
        await Api.deleteFav(task);

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

  //邏輯：修改過的task會出現在pending, 而原本在complete的則會消失
  Future<void> _onEditTask(EditTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    final oldTask = event.oldTask;
    final newTask = event.newTask;

    //原本在pending的task 會再次更新 - 有fav的也會更新 - 沒fav就不更新
    //原本在complete的task 會移除，加在pending - 有fav的會更新 - 沒fav就不更新
    List<Task> favList = state.favoriteTasks;
    List<Task> pendingList = state.pendingTasks;
    List<Task> completeList = state.completeTasks;

    //pending
    if (oldTask.isDone == false) {
      if (oldTask.isFavorite == true) {
        //call api
        await Api.updateFav(newTask); //TODO
        await Api.updatePending(newTask); //TODO

        favList
          ..remove(oldTask)
          ..insert(0, newTask);
        pendingList = List.from(state.pendingTasks)
          ..remove(oldTask)
          ..insert(0, newTask);
      } else {
        //call api
        await Api.updatePending(newTask);

        pendingList = List.from(state.pendingTasks)
          ..remove(oldTask)
          ..insert(0, newTask);
      }

      //complete
    } else {
      if (oldTask.isFavorite == true) {
        //call api
        await Api.updateFav(newTask);
        await Api.deleteComplete(oldTask);
        await Api.addPending(newTask);

        favList
          ..remove(oldTask)
          ..insert(0, newTask);
        completeList = List.from(state.completeTasks)..remove(oldTask);
        pendingList = List.from(state.pendingTasks)..insert(0, newTask);
      } else {
        //call api
        await Api.deleteComplete(oldTask);
        await Api.addPending(newTask);

        completeList = List.from(state.completeTasks)..remove(oldTask);
        pendingList = List.from(state.pendingTasks)..insert(0, newTask);
      }
    }

    emit(TasksState(
        pendingTasks: pendingList,
        completeTasks: completeList,
        favoriteTasks: favList,
        removeTasks: state.removeTasks));
  }

  Future<void> _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    final task = event.task;

    //call api
    await Api.deleteBin(task);
    await Api.addPending(task.copyWith(isDelete: false, isDone: false, isFavorite: false));

    emit(TasksState(
        removeTasks: List.from(state.removeTasks)..remove(task),
        pendingTasks: List.from(state.pendingTasks)
          ..insert(0, task.copyWith(isDelete: false, isDone: false, isFavorite: false)),
        completeTasks: state.completeTasks,
        favoriteTasks: state.favoriteTasks));
  }

  Future<void> _onDeleteAllTask(DeleteAllTask event, Emitter<TasksState> emit) async {
    final state = this.state;

    await Api.deleteAllBin();

    emit(TasksState(
        removeTasks: List.from(state.removeTasks)..clear(),
        pendingTasks: state.pendingTasks,
        completeTasks: state.completeTasks,
        favoriteTasks: state.favoriteTasks));
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
