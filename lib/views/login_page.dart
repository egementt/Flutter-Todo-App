import 'package:flutter/material.dart';
import 'package:flutter_todo/service/api.dart';
import 'package:flutter_todo/ui/components/bottom_nav_bar.dart';
import 'package:flutter_todo/ui/components/error_snackbar.dart';
import 'package:flutter_todo/utils/utils.dart';

TextEditingController _usernameController;
TextEditingController _passwordController;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  MyService _service;
  bool _passwordVisible;

  @override
  void initState() {
    _service = MyService();
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loginTextField("Email", _usernameController, false),
            SizedBox(
              height: 8,
            ),
            loginTextField("Password", _passwordController, true),
            FlatButton(
                color: ThemeData().accentColor,
                onPressed: () {
                  loginUser();
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  void loginUser() {
    _service.loginFunc(email, password).then((result) {
      if (result != null) {
        setState(() {
          currentUser = result;
        });
        print(currentUser.userId);
        checkLoginSuccess(currentUser.status);
      } else {
        errorSnackbar("Connection failed");
      }
    });
  }

  void checkLoginSuccess(String status) {
    if (status == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyBottomNavBar()),
      );
    } else {
      errorSnackbar("Wrong email or password");
    }
  }

  Widget loginTextField(
      String label, TextEditingController controller, bool isPassword) {
    return Padding(
      padding: myPadding(),
      child: TextField(
        obscureText: isPassword == true ? _passwordVisible : false,
        controller: controller,
        decoration: isPassword == true
            ? InputDecoration(
                // Eğer textfield bir şifre içeriyorsa, şifreyi görmek için Icon oluştur.
                border: OutlineInputBorder(),
                labelText: label,
                suffixIcon: IconButton(
                    icon: Icon(_passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    }))
            : InputDecoration(
                border: OutlineInputBorder(),
                labelText: label,
              ),
        onChanged: (value) {
          if (label == "Email")
            email = value;
          else
            password = value;
        },
      ),
    );
  }
}
