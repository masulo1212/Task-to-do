part of 'tasks_bloc.dart';

//Bloc在管理state時，如果你的state物件被更新，Bloc將會呼叫props函式比較當前的state物件和最新的state物件，如果相同則不進行更新，否則則進行更新。
//state類別繼承自Equatable時，會自動呼叫props函式

class TasksState extends Equatable {
  final List<Task> allTasks;
  final List<Task> removeTasks;
  const TasksState({this.allTasks = const <Task>[], this.removeTasks = const <Task>[]});

  @override
  List<Object> get props => [allTasks, removeTasks];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'allTasks': allTasks.map((x) => x.toMap()).toList(),
      'removeTasks': removeTasks.map((x) => x.toMap()).toList(),
    };
  }

  factory TasksState.fromMap(Map<String, dynamic> map) {
    return TasksState(
        allTasks: List<Task>.from(
            //注意這裡的dynamic -> 原本自動生成是int
            (map['allTasks'] as List<dynamic>).map<Task>(
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