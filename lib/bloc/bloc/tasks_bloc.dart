import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  //event handler
  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(allTasks: List.from(state.allTasks)..add(event.task)));
    add(event)
    //allTasks 的值是由當前 state 的 allTasks 複製一份出來，再加上一個新的 task。
    //不是同一個實例，每次傳遞 TasksState 物件給外面時，都是傳遞的新的物件，而不是之前的物件。每次觸發emit事件後，state就會被替換為新的TasksState實例。
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {}
  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {}
}