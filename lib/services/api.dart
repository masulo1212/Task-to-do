import 'package:flutter_tasks_app/services/http.dart';

import '../models/task.dart';

class Api {
  //pending
  static Future addPending(Task task) async {
    await HttpHelper().post("/pending/add-task", data: task.toJson());
  }

  static Future<List<Task>> getAllPending() async {
    var t = await HttpHelper().get('/pending/get-alltask');
    List<Task> allPendingList = [];
    allPendingList = t.data.map<Task>((e) => Task.fromMap(e)).toList();
    return allPendingList;
  }

  static Future updatePending(Task task) async {
    await HttpHelper().post("/pending/update-task", data: task.toJson());
  }

  static Future deletePending(Task task) async {
    await HttpHelper().post("/pending/delete-task", data: task.toJson());
  }

  //complete

  static Future addComplete(Task task) async {
    await HttpHelper().post("/complete/add-task", data: task.toJson());
  }

  static Future<List<Task>> getAllComplete() async {
    var t = await HttpHelper().get('/complete/get-alltask');
    List<Task> allCompleteList = [];
    allCompleteList = t.data.map<Task>((e) => Task.fromMap(e)).toList();
    return allCompleteList;
  }

  static Future updateComplete(Task task) async {
    await HttpHelper().post("/complete/update-task", data: task.toJson());
  }

  static Future deleteComplete(Task task) async {
    await HttpHelper().post("/complete/delete-task", data: task.toJson());
  }

  //fav

  static Future addFav(Task task) async {
    await HttpHelper().post("/fav/add-task", data: task.toJson());
  }

  static Future<List<Task>> getAllFav() async {
    var t = await HttpHelper().get('/fav/get-alltask');
    List<Task> allFavList = [];
    allFavList = t.data.map<Task>((e) => Task.fromMap(e)).toList();
    return allFavList;
  }

  static Future updateFav(Task task) async {
    await HttpHelper().post("/fav/update-task", data: task.toJson());
  }

  static Future deleteFav(Task task) async {
    await HttpHelper().post("/fav/delete-task", data: task.toJson());
  }

  // bin

  static Future addBin(Task task) async {
    await HttpHelper().post("/bin/add-task", data: task.toJson());
  }

  static Future<List<Task>> getAllBin() async {
    var t = await HttpHelper().get('/bin/get-alltask');
    List<Task> allFavList = [];
    allFavList = t.data.map<Task>((e) => Task.fromMap(e)).toList();
    return allFavList;
  }

  static Future deleteBin(Task task) async {
    await HttpHelper().post("/bin/delete-task", data: task.toJson());
  }

  static Future deleteAllBin() async {
    await HttpHelper().post("/bin/delete-alltask");
  }
}
