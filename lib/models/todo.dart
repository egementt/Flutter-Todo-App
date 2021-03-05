import "body.dart";

class Todo {
  int count;
  List<Body> body;

  Todo({this.count, this.body});

  @override
  String toString() => 'Todo(count: $count, body: $body)';

  factory Todo.fromJson(Map<String, dynamic> json) {
    var list = json['body'] as List;
    print(list.runtimeType);
    List<Body> bodyList = list.map((e) => Body.fromJson(e)).toList();
    return Todo(count: json['count'], body: bodyList);
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'body': body?.map((e) => e?.toJson())?.toList(),
    };
  }
}
