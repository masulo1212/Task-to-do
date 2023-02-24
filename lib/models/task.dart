// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final String description;
  final String id;
  final String date;
  bool? isDone;
  bool? isDelete;
  bool? isFavorite;

  Task(
      {required this.title,
      required this.id,
      required this.date,
      required this.description,
      this.isDone,
      this.isDelete,
      this.isFavorite}) {
    isDone = isDone ?? false;
    isDelete = isDelete ?? false;
    isFavorite = isFavorite ?? false;
  }

  Task copyWith({
    String? title,
    String? description,
    String? id,
    String? date,
    bool? isDone,
    bool? isDelete,
    bool? isFavorite,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      id: id ?? this.id,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
      isDelete: isDelete ?? this.isDelete,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [title, description, id, date, isDone, isDelete, isFavorite];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'id': id,
      'date': date,
      'is_done': isDone,
      'is_delete': isDelete,
      'is_favorite': isFavorite,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] as String,
      description: map['description'] as String,
      id: map['id'] as String,
      date: map['date'] as String,
      isDone: map['is_done'] != null ? map['is_done'] as bool : null,
      isDelete: map['is_delete'] != null ? map['is_delete'] as bool : null,
      isFavorite: map['is_favorite'] != null ? map['is_favorite'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source) as Map<String, dynamic>);
}
