import 'package:flutter/material.dart';
import 'package:flutter_todo/service/api.dart';
import 'package:flutter_todo/ui/components/error_snackbar.dart';
import 'package:flutter_todo/utils/utils.dart';

Key dialogKey;

class TodoPage extends StatefulWidget {
  final String tag;
  final int id;

  TodoPage({@required this.tag, this.id});

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  MyService myService = (MyService());
  DateTime _dateTime = DateTime.now();
  String _job;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: dialogKey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Utils.paddingX)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        width: (MediaQuery.of(context).size.width * 0.8),
        height: (MediaQuery.of(context).size.width * 0.6),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: myPadding(),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Enter job"),
                  onChanged: (text) {
                    _job = text;
                  },
                ),
              ),
              FlatButton(
                  onPressed: () {
                    if (widget.tag == "new") {
                      myService.postTodo(_job, _dateTime).then((value) {
                        if (value != null) {
                          Navigator.pop(context);
                        } else {
                          errorSnackbar("Can not add Todo");
                        }
                      });
                    } else {
                      myService.updateTodo(widget.id, _job).then((value) {
                        if (value != null) {
                          Navigator.pop(context);
                        } else {
                          errorSnackbar("Can not update Todo");
                        }
                      });
                    }
                  },
                  child: Text("Add Job"))
            ],
          ),
        ),
      ),
    );
  }
}

Widget loginTextField(TextEditingController controller) {
  return Padding(
    padding: myPadding(),
    child: TextField(
      controller: controller,
      decoration:
          InputDecoration(border: OutlineInputBorder(), labelText: "Enter job"),
      onChanged: (value) {
        controller.text = value.toString();
      },
    ),
  );
}
