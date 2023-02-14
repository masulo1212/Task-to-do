part of 'tasks_bloc.dart';

class TasksState extends Equatable {
  final List<Task> allTasks;
  const TasksState({this.allTasks = const <Task>[]});

  @override
  List<Object> get props => [allTasks];
}

//只寫TasksState()，flutter就會自動幫我設定allTasks是空的list
abstract class TaskState1 {}

class TaskState2 extends TaskState1 {}

class TaskState3 extends TaskState1 {}

class TaskState4 extends TaskState1 {}
