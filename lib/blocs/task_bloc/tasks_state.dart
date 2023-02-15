part of 'tasks_bloc.dart';

//Bloc在管理state時，如果你的state物件被更新，Bloc將會呼叫props函式比較當前的state物件和最新的state物件，如果相同則不進行更新，否則則進行更新。
//state類別繼承自Equatable時，會自動呼叫props函式

class TasksState extends Equatable {
  final List<Task> pendingTasks;
  final List<Task> completeTasks;
  final List<Task> favoriteTasks;
  final List<Task> removeTasks;
  const TasksState({
    this.pendingTasks = const <Task>[],
    this.completeTasks = const <Task>[],
    this.favoriteTasks = const <Task>[],
    this.removeTasks = const <Task>[],
  });

  @override
  List<Object> get props => [pendingTasks, completeTasks, favoriteTasks, removeTasks];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pendingTasks': pendingTasks.map((x) => x.toMap()).toList(),
      'completeTasks': completeTasks.map((x) => x.toMap()).toList(),
      'favoriteTasks': favoriteTasks.map((x) => x.toMap()).toList(),
      'removeTasks': removeTasks.map((x) => x.toMap()).toList(),
    };
  }

  factory TasksState.fromMap(Map<String, dynamic> map) {
    return TasksState(
        pendingTasks: List<Task>.from(
            //注意這裡的dynamic -> 原本自動生成是int
            (map['pendingTasks'] as List<dynamic>).map<Task>(
          (x) => Task.fromMap(x as Map<String, dynamic>),
        )),
        completeTasks: List<Task>.from(
            //注意這裡的dynamic -> 原本自動生成是int
            (map['completeTasks'] as List<dynamic>).map<Task>(
          (x) => Task.fromMap(x as Map<String, dynamic>),
        )),
        favoriteTasks: List<Task>.from(
            //注意這裡的dynamic -> 原本自動生成是int
            (map['favoriteTasks'] as List<dynamic>).map<Task>(
          (x) => Task.fromMap(x as Map<String, dynamic>),
        )),
        removeTasks: List<Task>.from(
            //注意這裡的dynamic -> 原本自動生成是int
            (map['removeTasks'] as List<dynamic>).map<Task>(
          (x) => Task.fromMap(x as Map<String, dynamic>),
        )));
  }
}
//只寫TasksState()，flutter就會自動幫我設定allTasks是空的list