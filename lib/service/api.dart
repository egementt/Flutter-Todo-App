import 'dart:convert';

import 'package:flutter_todo/models/body.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/utils/utils.dart';
import 'package:http/http.dart' as http;

  String serviceToken = currentUser.token;

class MyService {
  
  final String _baseUrl = "https://aodapi.eralpsoftware.net/";

  loginFunc(String username, String password) async {
    var response = await http.post(
      "${_baseUrl}login/apply",
      body: jsonEncode(
        {
          "username": username, // username = başvuru yaptığınız mail adresi
          "password": password, // password = 123456
        },
      ),
      headers: {
        "content-type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final myResponse = User.fromJson(jsonDecode(response.body));
      return myResponse;
    } else {
      print("Error: ${response.request.url}");
    }
  }

  postTodo(String job, DateTime dateTime) async {
    final response = await http.post(
      "${_baseUrl}todo",
      headers: {
        "content-type": "application/json",
        "token": serviceToken,
      },
      body: jsonEncode({
        "name": job,
        "date": dateTime.toIso8601String(), // date DateTime biçiminde olmalı
      }),
    );
    if (response.statusCode == 200) {
      final myResponse = Body.fromJson(jsonDecode(response.body));
      return myResponse;
    } else {
      print("Error: ${response.body}");
    }
  }

  updateTodo(int id, String newName) async {
    final response = await http.put(
      "${_baseUrl}todo/$id",
      body: jsonEncode(<String, String>{"name": newName}),
      headers: {
        "content-type": "application/json",
        "token": serviceToken,
      },
    );
    if (response.statusCode == 200) {
      final myResponse = Body.fromJson(jsonDecode(response.body));
      print("hey $myResponse");
      return myResponse;
    } else {
      print("Error: ${response.request}");
    }
  }

  deleteTodo(int id) async {
    final response = await http.delete(
      "${_baseUrl}todo/$id",
      headers: {
        "content-type": "application/json",
        "token": serviceToken,
      },
    );
    if (response.statusCode == 200) {
      return response.body[0];
    } else {
      print("Error: ${response.body}");
    }
  }

  Future<List<Body>> getAll() async {
    final response = await http.get(
      "${_baseUrl}todo",
      headers: {
        "token": serviceToken,
      },
    );
    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body)).body;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<String> getUserName(int userId) async {
    var response = await http.get(
      "${_baseUrl}user/$userId",
      headers: {
        "content-type": "application/json",
        "token": serviceToken,
      },
    );

    if (response.statusCode == 200) {
      final myResponse = jsonDecode(response.body);

      return myResponse["data"][0]['username'];
    } else {
      throw ("Error: ${response.statusCode}");
    }
  }
}
