class Todo{
  int id;
  String task;
  Todo(this.id,this.task);

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'id':id,
      'task':task
    };
    return map;
  }
  Todo.fromMap(Map<String,dynamic> map){
    id = map['id'];
    task = map['task'];
  }
}