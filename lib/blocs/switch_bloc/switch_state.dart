part of 'switch_bloc.dart';

class SwitchState extends Equatable {
  final bool switchVal;
  const SwitchState({required this.switchVal});

  @override
  List<Object> get props => [switchVal];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'switchVal': switchVal,
    };
  }

  factory SwitchState.fromMap(Map<String, dynamic> map) {
    return SwitchState(
      switchVal: map['switchVal'] as bool,
    );
  }
}

class SwitchInitial extends SwitchState {
  const SwitchInitial({required bool switchVal}) : super(switchVal: switchVal);
}

//ex SwitchInitial(switchVal: true) -> 同時利用switchVal = true初始化父類的class
//SwitchInitial 类的作用是为开关的状态提供一个初始值 这个初始值可以作为其他状态的基础。