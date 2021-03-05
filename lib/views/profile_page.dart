import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_todo/service/api.dart';
import 'package:flutter_todo/ui/components/error_snackbar.dart';
import 'package:flutter_todo/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  MyService _service;
  File _image;
  final _picker = ImagePicker();
  Future _myFuture;
  bool _buttonVisibility = true;
  bool _fbVisibility = false;

  @override
  void initState() {
    _service = MyService();
    setUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Container(
                  width: 200,
                  height: 200,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage: _image == null
                        ? AssetImage("assets/add_image.png")
                        : FileImage(_image),
                  )),
              onTap: getImage,
            ),
            SizedBox(
              height: 25,
            ),
            Visibility(
              visible: _buttonVisibility,
              child: FlatButton(
                  color: ThemeData().accentColor,
                  onPressed: () {
                    setState(() {
                      _myFuture = myLocation();
                      if (_myFuture != null) {
                        _buttonVisibility = false;
                        _fbVisibility = true;
                      } else {
                        errorSnackbar("Can not get location");
                      }
                    });
                  },
                  child: Text("Get my location")),
            ),
            Visibility(visible: _fbVisibility, child: myFB()),
            Padding(
              padding: const EdgeInsets.all(Utils.paddingX * 2),
              child: TextFormField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    icon: Icon(Icons.mail),
                    hintText: currentUser.userName),
              ),
            )
          ],
        ),
      ),
    );
  }

  setUserName() {
    _service.getUserName(currentUser.userId).then((value) {
      setState(() {
        currentUser.userName = value;
      });
    });
  }

  FutureBuilder myFB() {
    return FutureBuilder(
      future: _myFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Text(
              snapshot.data,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Please select image');
      }
    });
  }

  Future<String> myLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return _getAddress(position);
  }

  Future<String> _getAddress(Position position) async {
    try {
      List<Placemark> p = await GeocodingPlatform.instance
          .placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = p[0];

      return placemark.locality;
    } catch (e) {
      throw e.toString();
    }
  }
}
