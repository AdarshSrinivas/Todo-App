import 'package:flutter/material.dart';
import '../model/todo.dart';

// ignore: must_be_immutable
class AddTask extends StatefulWidget {
  Todo todo;
  int index;
  AddTask({Key? key, required this.todo, required this.index})
      : super(key: key);
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  void addItem() async {
    String task = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'New Task',
          ),
          content: TextField(
            onChanged: (value) => task = value,
            decoration: InputDecoration(hintText: 'Task Name'),
          ),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  widget.todo.items.add(TodoItem(task, false));
                });
              },
              child: Text(
                'Save',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildTaskRow(int index) {
    bool done = widget.todo.items[index].done;
    return ListTile(
      title: Text(
        '${widget.todo.items[index].itemName}',
        style: TextStyle(
          decoration: done ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      trailing: Checkbox(
          activeColor: Colors.lightBlueAccent,
          value: done ? true : false,
          onChanged: (state) {
            setState(() {
              widget.todo.isDone += (done ? -1 : 1);
              widget.todo.items[index].done = !done;
              done = !done;
            });
          }),
    );
  }

  Widget buildTodoTasks() {
    return ListView.builder(
      itemCount: widget.todo.items.length,
      itemBuilder: (context, index) {
        return buildTaskRow(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 60,
              left: 30,
              right: 30,
              bottom: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${widget.todo.title}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${widget.todo.items.length} Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: buildTodoTasks(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add),
        onPressed: () {
          /*showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
                  child: ,
                ),
              );
            },
          );*/
          addItem();
        },
      ),
    );
  }
}
