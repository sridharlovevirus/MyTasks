import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todolist/Todo.dart';
import 'dart:async';
class DBHelper {
  static Database _db;

  _onCreate(Database db, int version) async {
    await
    db.execute("CREATE TABLE todo(id INTEGER PRIMARY KEY, task TEXT)");
  }

  initDB() async {
    io.Directory document = await getApplicationDocumentsDirectory();
    String path = join(document.path, 'todo.db');
    var _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _db;
  }

  Future <Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<Todo> addTodo(Todo todo) async{
    var dbClient = await db;
    todo.id = await dbClient.insert('todo', todo.toMap());
    return todo;
  }

  Future<List<Todo>> getTodoList() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query("todo",columns:['id','task']);
    List<Todo> todoList = [];
    if(maps.length>0){
      for(int i=0;i<maps.length;i++){
        todoList.add(Todo.fromMap(maps[i]));
      }
    }
    return todoList;
  }

  Future<int> delete (int id) async{
    var dbClient = await db;
    return dbClient.delete("todo",where: "id = ?",whereArgs: [id]);

  }

  Future<int> update(Todo todo) async{
    var dbClient = await db;
    return await dbClient.update('todo', todo.toMap(),where: "id = ?",whereArgs: [todo.id],);
  }

}