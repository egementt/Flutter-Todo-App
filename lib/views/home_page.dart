import 'package:flutter/material.dart';
import 'package:flutter_todo/models/body.dart';
import 'package:flutter_todo/service/api.dart';
import 'package:flutter_todo/utils/utils.dart';
import 'package:flutter_todo/views/add_todo_page.dart';
import 'package:flutter_todo/views/login_page.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MyService _service;
  Future<List<Body>> _myFutureList;

  @override
  void initState() {
    _service = MyService();
    _myFutureList = _service.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo's"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }),
            ),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            print(currentUser.token);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return TodoPage(
                      tag:
                          "new"); // Todo eklemek için TodoPage'ye new tagı, düzenlemek için old tagı yolladım.
                });
          },
          child: Icon(Icons.add),
        ),
        body: Center(
          child: FutureBuilder(
            future: _myFutureList,
            builder: (context, AsyncSnapshot<List<Body>> snapshot) {
              if (snapshot.hasData) {
                List<Body> body = snapshot.data;
                return _myListView(body);
              } else if (snapshot.data == null) {
                return Center(
                  child: Text("No data"),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.block,
                        color: Colors.red[900],
                      ),
                      Text("An error occured.")
                    ],
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ));
  }

  ListView _myListView(List<Body> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          final item = list[index];
          return Dismissible(
            key: Key(item.toString()),
            background: Container(
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(Utils.paddingX),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            child: Column(
              children: [
                GestureDetector(
                    child: _myListTile(
                        list[index].name, _convertTime(list[index].date)),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TodoPage(
                              tag: "old",
                              id: list[index].id,
                            ); // Todo eklemek için TodoPage'ye new tagı, düzenlemek için old tagı yolladım.
                          });
                    }),
                Divider(
                  thickness: 0.8,
                )
              ],
            ),
            onDismissed: (direction) {
              _service.deleteTodo(list[index].id);
              list.removeAt(index);
            },
          );
        });
  }

  ListTile _myListTile(String name, String dateTime) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(dateTime),
    );
  }

  String _convertTime(String date) {
    var dateStr = DateTime.parse(date).toLocal().toString();
    return dateStr;
  }
}
