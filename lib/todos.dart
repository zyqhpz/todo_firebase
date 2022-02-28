// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:todo_firebase/services/database_services.dart';

import 'model/todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isDone = false;
  final TextEditingController _todoTitleController = TextEditingController();
  final TextEditingController _todoUpdateTitleController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Todo>>(
          stream: DatabaseService().listTodos(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Todo> todos = snapshot.data;
            return Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'My Todos',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Divider(),
                  SizedBox(height: 25),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: NoGlowBehavior(),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[700],
                        ),
                        shrinkWrap: true,
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onDismissed: (direction) async {
                              await DatabaseService()
                                  .deleteTodo(todos[index].id);
                            },
                            child: ListTile(
                              onTap: () => {
                                DatabaseService().doneTodo(todos[index].id),
                              },
                              leading: Container(
                                padding: EdgeInsets.all(2),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: todos[index].isDone
                                      ? Colors.green[400]
                                      : Colors.yellow[800],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(
                                todos[index].title,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _todoUpdateTitleController.text =
                                        todos[index].title;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        backgroundColor: Colors.grey[700],
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: Row(
                                          children: [
                                            Text(
                                              'Edit Todo',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Spacer(),
                                            IconButton(
                                              icon: Icon(
                                                Icons.cancel,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                        children: [
                                          TextField(
                                            controller:
                                                _todoUpdateTitleController,
                                            autofocus: true,
                                            style:
                                                TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              hintText: 'Edit Todo',
                                              hintStyle: TextStyle(
                                                  color: Colors.white),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                            ),
                                          ),
                                          Divider(),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            child: ElevatedButton(
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (_todoUpdateTitleController
                                                    .text.isNotEmpty) {
                                                  await DatabaseService()
                                                      .updateTodo(
                                                          todos[index].id,
                                                          _todoUpdateTitleController
                                                              .text);
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          setState(() {
            // _todoTitleController.text = '';
            _todoTitleController.clear();
          });
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                backgroundColor: Colors.grey[700],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Text('Add New Todo', style: TextStyle(color: Colors.white)),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                children: [
                  TextField(
                    controller: _todoTitleController,
                    autofocus: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter Todo',
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        if (_todoTitleController.text.isNotEmpty) {
                          await DatabaseService()
                              .addTodo(_todoTitleController.text.trim());
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
