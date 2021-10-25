

class TodoItem{
  String itemName;
  bool done;
  TodoItem(this.itemName,this.done);
}

class Todo {
  String color;
  String title;
  String description;
  late List<TodoItem> items;
  int isDone=0;

  Todo(this.color,this.title,this.description){
    this.items=[];
    isDone=0;
  }

  get length => null;
}