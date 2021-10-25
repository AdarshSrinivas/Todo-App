import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './menu.dart';
import '../model/todo.dart';
import './addCategory.dart';
import '../database/service.dart';
import './addTask.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DbService(FirebaseAuth.instance.currentUser!.uid);

  String username = FirebaseAuth.instance.currentUser!.displayName.toString();
  bool dataLoaded = false;
  List<Todo> todos = [];

   void initState() {
    super.initState();
    if (!dataLoaded) {
      dataLoaded = true;
      loadFirestoreData();
    }
    
  }

  void loadFirestoreData() async {
    await db.loadTodo().then((value) {
      value.docs.forEach((element) {
        todos.add(Todo(
            (element.data() as dynamic)['cardColor'],
            (element.data() as dynamic)['title'],
            (element.data() as dynamic)['description']));
      });
    });
    for (int i = 0; i < todos.length; i++) {
      await db.getAllTodo(i).then((value) {
        value.docs.forEach((element) {
          todos[i].items.add(TodoItem((element.data() as dynamic)['item_name'],
              (element.data() as dynamic)['done']));
        });
      });
    }
    setState(() {});
  }

  Widget todoCard(int i) {
    String value = todos[i].color;
    Color color = Color(int.parse(value));
    return Container(
      padding: EdgeInsets.all(10.0),
      height: 150,
      width: double.maxFinite,
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() {
            todos.removeAt(i);
            db.deletedSelected(i);
            print(todos.length);
          });
        },
        child: GestureDetector(
          onLongPress: () {},
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTask(todo: todos[i], index: i),
              ),
            );
          },
          child: Card(
            elevation: 5,
            color: color,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${todos[i].title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${todos[i].description}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loadTodo() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return todoCard(index);
      },
    );
  }

  void callCategoryScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anumation, secondAnimation) {
          return AddCategory();
        },
        transitionsBuilder: (context, animation, secondAnimation, child) {
          final begin = Offset(1, 0);
          final end = Offset.zero;
          final curve = Curves.ease;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
    
    todos.add(result);
    print(todos.length);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: username == ''
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              ),
            )
          : WillPopScope(
              onWillPop: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Exiting App..'),
                        content: Text('Do you want to exit?'),
                        actions: [
                          // ignore: deprecated_member_use
                          FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('No')),
                          // ignore: deprecated_member_use
                          FlatButton(
                              onPressed: () {
                                print(todos.length);
                                db.saveData(todos);
                                exit(0);
                              },
                              child: Text('Yes')),
                        ],
                      );
                    });
                throw 'error';
              },
              child: Scaffold(
                //extendBodyBehindAppBar: true,
                drawer: MenuDrawer(),
                appBar: AppBar(
                  title: Text(
                    'Todo.',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 50,
                    ),
                  ),
                  iconTheme: IconThemeData(color: Colors.black),
                  bottom: PreferredSize(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Divider(
                            thickness: 1.2,
                            color: Colors.cyan,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          width: double.infinity,
                          child: Text(
                            'Hey, $username',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    preferredSize: Size.fromHeight(40),
                  ),
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  elevation: 0.0,
                ),
                body: loadTodo(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    callCategoryScreen(context);
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                  splashColor: Colors.cyan,
                  backgroundColor: Colors.amber,
                ),
              ),
            ),
    );
  }
}
