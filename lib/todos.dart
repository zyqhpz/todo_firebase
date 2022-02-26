import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isDone = false;
  TextEditingController _todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(index.toString()),
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
                          onDismissed: (direction) {
                            print('Dismissed');
                          },
                          child: ListTile(
                            onTap: () => {
                              setState(() {
                                isDone = !isDone;
                              })
                            },
                            leading: Container(
                              padding: EdgeInsets.all(2),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: isDone
                                    ? Colors.yellow[800]
                                    : Colors.green[400],
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
                              'Item',
                              style: TextStyle(
                                // fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Icon(Icons.delete),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
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
                      onPressed: () {
                        if (_todoTitleController.text.isNotEmpty) {
                          print(_todoTitleController.text);
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
