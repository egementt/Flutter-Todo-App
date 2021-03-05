import 'package:flutter/material.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/service/api.dart';
import 'package:flutter_todo/ui/components/bottom_nav_bar.dart';
import 'package:flutter_todo/ui/components/error_snackbar.dart';
import 'package:flutter_todo/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  MyService _service;
  bool _passwordVisible;
  bool _loginPref = false;

  @override
  void initState() {
    init();
    _service = MyService();
    _passwordVisible = false;
    checkAutoLogin();
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
            loginTextField("Email", false),
            SizedBox(
              height: 8,
            ),
            loginTextField("Password", true),
            FlatButton(
                color: ThemeData().accentColor,
                onPressed: () {
                  loginUser(_email, _password);
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

  static Future init() async {
    prefences = await SharedPreferences.getInstance();
  }

  void save() async {
    await init();
    if (_loginPref == false) {
      await prefences.setBool('autoLogin', true);
      await prefences.setString('savedEmail', _email);
      await prefences.setString('savedPassword', _password);
    }
  }

  void checkAutoLogin() async {
    await init();
    if (prefences != null) {
      final loginPref = prefences.getBool('autoLogin');
      final savedEmail = prefences.getString('savedEmail');
      final savedPassword = prefences.getString('savedPassword');

      if (loginPref == true) {
        loginUser(savedEmail, savedPassword);
      }
    }
  }

  void loginUser(String email, String password) {
    _service.loginFunc(email, password).then((result) {
      if (result != null) {
        setState(() {
          currentUser = result;
        });
        save();
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

  Widget loginTextField(String label, bool isPassword) {
    return Padding(
      padding: myPadding(),
      child: TextField(
        obscureText: isPassword == true ? _passwordVisible : false,
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
            _email = value;
          else
            _password = value;
        },
      ),
    );
  }
}
