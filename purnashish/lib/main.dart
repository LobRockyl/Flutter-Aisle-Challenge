import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fstore;
import 'package:badges/badges.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

final storage = fstore.FlutterSecureStorage();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        fontFamily: 'GilRoy',
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class SecondRoute extends StatelessWidget {
  final String text;
  SecondRoute({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(text)],
      )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Dio dio = new Dio();
  Future sendNumber(num) async {
    final String pathUrl =
        'https://testa2.aisle.co/V1/users/phone_number_login';
    dynamic data = {'number': num};
    var response = await dio.post(pathUrl,
        data: data,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Cookie': '__cfduid=df9b865983bd04a5de2cf5017994bbbc71618565720',
        }));
    print(response);
    return response.data;
  }

  List<Widget> getListFiles(arr) {
    List<Widget> list = [];
    for (int i = 0; i < arr.length; i++) {
      list.add(Container(
          width: 0.45 * MediaQuery.of(context).size.width,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            clipBehavior: Clip.hardEdge,
            elevation: 0.0,
            color: Colors.white,
            margin: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 197,
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     fit: BoxFit.cover,
                  //     alignment: FractionalOffset.topCenter,
                  //     image: NetworkImage(arr[i]['avatar']),
                  //   ),
                  // ),

                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.network(arr[i]['avatar'], fit: BoxFit.cover),
                      ClipRRect(
                        // Clip it cleanly.
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.grey.withOpacity(0.27),
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 27,
                        left: 11,
                        child: Column(
                          children: <Widget>[
                            Text(
                              arr[i]['first_name'],
                              style: TextStyle(
                                  fontFamily: 'GilRoy',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )));
    }
    return list;
  }

  Future sendNumberOTP(num, otp) async {
    final String pathUrl = 'https://testa2.aisle.co/V1/users/verify_otp';
    dynamic data = {'number': num, 'otp': otp};
    var response = await dio.post(pathUrl,
        data: data,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Cookie': '__cfduid=df9b865983bd04a5de2cf5017994bbbc71618565720',
        }));
    print(response);
    return response.data;
  }

  Future ProfileData(token) async {
    final String pathUrl = 'https://testa2.aisle.co/V1/users/test_profile_list';

    var response = await dio.get(pathUrl,
        options: Options(headers: {
          'Authorization': token,
          'Cookie': '__cfduid=df9b865983bd04a5de2cf5017994bbbc71618565720',
        }));
    print(response);
    return response.data;
  }

  Future getToken() async {
    var token = await storage.read(key: "jwt");
    // if (token == null) {
    //   return "";
    // }
    final String pathUrl = 'https://testa2.aisle.co/V1/users/test_profile_list';
    //print(token);
    var response = await dio.get(pathUrl,
        options: Options(headers: {
          'Authorization': token,
          'Cookie': '__cfduid=df9b865983bd04a5de2cf5017994bbbc71618565720',
        }));
    var responseBody = response.data;
    print(responseBody['invites']['totalPages']);
    // if (response == null) return "";
    return responseBody;
  }

  bool numberEnter = true;
  bool otpEnter = false;
  int secondsLeft = 60;
  TextEditingController numberCtrl = new TextEditingController();
  TextEditingController otpCtrl = new TextEditingController();
  TextEditingController stdCtrl = new TextEditingController();

  @override
  void initState() {
    Stream.periodic(Duration(seconds: 1), (i) {
      setState(() {
        if (secondsLeft >= 1) {
          secondsLeft -= 1;
        }
      });
    }).listen((event) {
      print('Recieved Data!');
    });
    super.initState();
  }

  void loadAndMoveToNext2(BuildContext context, data) async {
    double h = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: h / 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.amber,
                child: Center(child: Text("Loading!")),
              ),
            ),
          );
        });
    await Future.delayed(Duration(seconds: 3));
    Navigator.pop(context);
    setState(() {
      if (numberEnter) {
        numberEnter = false;
        otpEnter = true;
        secondsLeft = 60;
      } else if (otpEnter) {
        otpEnter = false;
      }
    });
  }

  void loadAndMoveToNext(BuildContext context) async {
    double h = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: h / 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.amber,
                child: Center(child: Text("Loading!")),
              ),
            ),
          );
        });
    Navigator.pop(context);
    setState(() {
      if (numberEnter) {
        numberEnter = false;
        otpEnter = true;
        secondsLeft = 60;
      } else if (otpEnter) {
        otpEnter = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double w = size.width;
    double h = size.height;
    if (numberEnter) {
      return Container(
        color: Colors.white,
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, right: 272),
                child: Text(
                  "Get OTP",
                  style: TextStyle(
                      fontFamily: 'GilRoy',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 8, right: 125),
                child: Text(
                  "Enter Your\nPhone Number",
                  style: TextStyle(
                      fontFamily: 'GilRoy',
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18, top: 12),
                      child: TextField(
                        cursorHeight: 36,
                        controller: stdCtrl,
                        decoration: InputDecoration(
                            labelText: '+xx',
                            labelStyle: TextStyle(
                                fontFamily: 'GilRoy', color: Colors.black),
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, top: 12, right: 120),
                      child: TextField(
                        controller: numberCtrl,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontFamily: 'GilRoy', color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 19, right: 247),
                child: FloatingActionButton.extended(
                    onPressed: () async {
                      var x = await sendNumber(stdCtrl.text + numberCtrl.text);
                      if (x['status'] == true) {
                        loadAndMoveToNext(context);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => SecondRoute(
                        //           key: new Key('123'),
                        //           text: emailController.text + passwordController.text)),
                        // );
                      }
                    },
                    label: Text(
                      "Continue",
                      style:
                          TextStyle(fontFamily: 'GilRoy', color: Colors.black),
                    ),
                    backgroundColor: Colors.amber),
              )
            ],
          ),
        ),
      );
    } else if (otpEnter) {
      return Container(
        color: Colors.white,
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0, left: 30),
                child: Text(
                  stdCtrl.text + numberCtrl.text,
                  style: TextStyle(
                      fontFamily: 'GilRoy',
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 30),
                child: Text(
                  "Enter\nThe OTP",
                  style: TextStyle(
                      fontFamily: 'GilRoy',
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 0.3 * w,
                height: 0.10 * h,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 30, right: 0),
                  child: TextField(
                    controller: otpCtrl,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            fontFamily: 'GilRoy', color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 19, left: 28),
                    child: FloatingActionButton.extended(
                        onPressed: () async {
                          var x = await sendNumberOTP(
                              stdCtrl.text + numberCtrl.text, otpCtrl.text);
                          if (x['token'] != null) {
                            storage.write(key: "jwt", value: x['token']);
                            loadAndMoveToNext(context);
                          }
                        },
                        label: Text(
                          "Continue",
                          style: TextStyle(
                              fontFamily: 'GilRoy', color: Colors.black),
                        ),
                        backgroundColor: Colors.amber),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, left: 12),
                      child: Text("00:$secondsLeft",
                          style: TextStyle(
                              fontFamily: 'GilRoy',
                              color: Colors.black,
                              fontWeight: FontWeight.bold)))
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return FutureBuilder(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final x = snapshot.data;
            final likes_profiles = x['likes']['profiles'];
            final invites_profiles = x['invites']['profiles'];
            int wid = MediaQuery.of(context).size.width.round();
            return Scaffold(
                body: Padding(
                  padding: EdgeInsets.only(top: 0.058 * h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Notes",
                            style: TextStyle(
                                fontFamily: 'GilRoy',
                                fontSize: 27,
                                color: Colors.black,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            "Personal messages to you",
                            style: TextStyle(
                                fontFamily: 'GilRoy',
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 0.90 * w,
                        height: 0.4 * h,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                          elevation: 0.0,
                          color: Colors.white,
                          margin: EdgeInsets.only(right: 2.0, left: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 0.90 * w,
                                height: 0.4 * h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    alignment: FractionalOffset(0.2, 0.1),
                                    image: AssetImage("assets/photo_1.png"),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color(0xCC000000),
                                      const Color(0x00000000),
                                      const Color(0x00000000),
                                      const Color(0xCC000000),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Positioned(
                                      bottom: 15,
                                      left: 15,
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Meena, 23\n',
                                                style: TextStyle(
                                                    fontFamily: "GilRoy",
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 22,
                                                    color: Colors.white)),
                                            TextSpan(
                                                text: 'Tap to review 50+ notes',
                                                style: TextStyle(
                                                    fontFamily: 'GilRoy',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 31, top: 12),
                          child: SizedBox(
                              child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Interested In You",
                                    style: TextStyle(
                                        fontFamily: 'GilRoy',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "Premium members can\nview all their likes at once",
                                    style: TextStyle(
                                        fontFamily: 'GilRoy',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 31, top: 12),
                                  child: SizedBox(
                                    width: 0.3 * w,
                                    height: 0.055 * h,
                                    child: FloatingActionButton.extended(
                                        onPressed: () async {},
                                        label: Text(
                                          "Upgrade",
                                          style: TextStyle(
                                            fontFamily: 'GilRoy',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                          ),
                                        ),
                                        backgroundColor: Colors.amber),
                                  ))
                            ],
                          ))),
                      SizedBox(
                        height: 0.2817 * h,
                        width: 0.915 * w,
                        child: ListView(
                          // This next line does the trick.

                          scrollDirection: Axis.horizontal,
                          children: List.unmodifiable(() sync* {
                            yield* getListFiles(likes_profiles);
                          }()),
                        ),
                      )
                    ],
                  ),
                ),
                bottomNavigationBar: SizedBox(
                  height: 0.07845 * h,
                  child: BottomNavigationBar(
                    selectedItemColor: Colors.black,
                    unselectedItemColor: Colors.grey.shade600,
                    selectedLabelStyle: TextStyle(
                        fontFamily: 'GilRoy', fontWeight: FontWeight.w600),
                    unselectedLabelStyle: TextStyle(
                        fontFamily: 'GilRoy', fontWeight: FontWeight.w600),
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                          icon: ImageIcon(
                            AssetImage("assets/discover1.png"),
                          ),
                          label: 'Discover'),
                      BottomNavigationBarItem(
                        icon: new Stack(
                          children: <Widget>[
                            new ImageIcon(
                              AssetImage("assets/notes1.png"),
                            ),
                            new Positioned(
                              right: 0,
                              child: new Container(
                                padding: EdgeInsets.all(1),
                                decoration: new BoxDecoration(
                                  color: Colors.purple[600],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: new Text(
                                  x['likes']['likes_received_count'].toString(),
                                  style: new TextStyle(
                                    fontFamily: 'GilRoy',
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                        label: 'Notes',
                      ),
                      BottomNavigationBarItem(
                        icon: new Stack(
                          children: <Widget>[
                            new ImageIcon(
                              AssetImage("assets/matches1.png"),
                            ),
                            new Positioned(
                              right: 0,
                              child: new Container(
                                padding: EdgeInsets.all(1),
                                decoration: new BoxDecoration(
                                  color: Colors.purple[600],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: new Text(
                                  x['likes']['likes_received_count'].toString(),
                                  style: new TextStyle(
                                    fontFamily: 'GilRoy',
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                        label: 'Matches',
                      ),
                      BottomNavigationBarItem(
                          icon: ImageIcon(
                            AssetImage("assets/profile1.png"),
                          ),
                          label: 'Profile'),
                    ],
                  ),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }
}
