import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/DBHelper.dart';
import 'package:todolist/Todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.deepOrange
      ),
      home: TodoPage(),

    );
  }
}
class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  DBHelper dbHelper;
  Future<List<Todo>> todoList;
  TextEditingController addTask = new TextEditingController();
  TextEditingController editTask = new TextEditingController();
  showCreateDialogBox(BuildContext context){
    return showDialog<String>(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(title: Text("Add Task"),content: TextField(controller: addTask,),actions: [RaisedButton(child: Text("ADD"),color: Colors.green,onPressed: (){
            dbHelper.addTodo(Todo(null,addTask.text));
            addTask.text = '';
            refreshTodoList();
            Navigator.of(context).pop();
          },
          ),
          ],
          );
        }
    );
  }

  showEditDialogBox(BuildContext context,Todo todo){
    editTask.text = todo.task;
    return showDialog<String>(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(title: Text("Edit Task"),content: TextField(controller: editTask,),actions: [RaisedButton(child: Text("ADD"),color: Colors.green,onPressed: (){
            todo.task = editTask.text;
            dbHelper.update(todo);
            refreshTodoList();
            Navigator.of(context).pop();
          },
          ),
          ],
          );
        }
    );
  }
  @override
  void initState() {
    super.initState();
    dbHelper = new DBHelper();
    refreshTodoList();
  }

  refreshTodoList() {
    setState(() {
      todoList = dbHelper.getTodoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo List"),
      ),
      body: new FutureBuilder<List<Todo>>(future: todoList, builder: (context,future){
        if(future.hasData && future.data.isNotEmpty){
          List<Todo> list = future.data;
          return new ListView.builder(
              itemCount: list.length,
              itemBuilder: (context,index){
                return Card(
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(icon: Icon(Icons.edit),onPressed: (){
                          showEditDialogBox(context, list[index]);
                        },),
                        Text(list[index].task),
                        IconButton(icon: Icon(Icons.delete),onPressed: (){
                          dbHelper.delete(list[index].id).then((value){
                            refreshTodoList();
                          });
                        },
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        }else{
          return Container(child: Text("No data found"),);
        }
      },
      ),
      floatingActionButton: FloatingActionButton
        (child: IconButton(icon: Icon(Icons.add,color: Colors.white,),onPressed: (){
        showCreateDialogBox(context);
      },
      ),
      ),
    );
  }

}