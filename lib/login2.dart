import 'dart:convert';
import 'package:fastfood/user/dimensions/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fastfood/user/colors.dart';
import 'package:fastfood/user/userMain.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class LoginPage2 extends StatefulWidget {
  const LoginPage2({Key? key}) : super(key: key);

  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

late String name, phoneNumber;
bool loading = false;
String? mtocken = " ";

class _LoginPage2State extends State<LoginPage2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    FlutterLocalNotificationsPlugin _notificationPlugins =
        FlutterLocalNotificationsPlugin();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationPlugins.initialize(initializationSettings);
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) async {
      final id = DateTime.now().microsecondsSinceEpoch ~/ 10000000;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("foodD", "foodD channel",
              importance: Importance.max, priority: Priority.high));
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
      try {
        await _notificationPlugins.show(id, message.notification!.title,
            message.notification!.body, notificationDetails);
      } catch (e) {
        print('Nerro: $e');
      }
    });
  }


  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted permission provisional');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> getTocken() async {
    await FirebaseMessaging.instance.getToken().then((tocken) {
      setState(() {
        mtocken = tocken;
      });
      saveTocken(tocken!);
    });

  }

  Future<void> saveTocken(String tocken) async {
    try {
      FirebaseAuth user = FirebaseAuth.instance;
      DatabaseReference database = FirebaseDatabase.instance.ref();
      database
          .child('Users')
          .child(phoneNumber)
          .update({'tocken': tocken});
    } catch (e) {
      print('Save Tocken Error is $e');
    }
  }

  Future<void> sendPushNotification(String tocken, String name) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key =AAAAcfy3p7A:APA91bFJvFL6QkcvKT0_hCLShLT4tNpQWiQYenvfl-414Az9KUC0_234cRpUNvIJKU3OUiLCqe8_DBhJh1k943o2483tj0VpsW8aOGwrIHeq4Uc-62VFiDAlYDdA1bena4VYxPAtYEs8'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': 'Enjoy your food',
              'title': 'Welcome $name',
            },
            "notification": <String, dynamic>{
              "title": "Welcome $name",
              "body": "Enjoy your food",
              "android_channel_id": "foodD"
            },
            "to": tocken
          }));
      print('done && $tocken');
    } catch (e) {
      print('Error is $e');
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: ColorClass.mainColor,
                  width: Dimensions.screenWidth,
                  height: Dimensions.height120*2.5,
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.height10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimensions.height10*7,),
                        Text("Welcome Again!",style: TextStyle(color: Colors.white,fontSize: Dimensions.height10*1.8,fontWeight: FontWeight.w600),),
                        Text("Enjoy your food",style: TextStyle(color: Colors.white,fontSize: Dimensions.height10),)
                      ],
                    ),
                  ),
                )
              ],
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: 
                MainAxisAlignment.start,
                
                children: [
                  SizedBox(height: Dimensions.height210*0.9,),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.black26,blurRadius: Dimensions.height10)],
                        borderRadius: BorderRadius.circular(Dimensions.height10),
                        color: Colors.white,
                      ),
                      height: Dimensions.height210*2.2,
                      width: Dimensions.width120*4,
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.height10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('image/foodDelivery.png',height: Dimensions.height120*1.4,width: Dimensions.height120*1.4,),
                              SizedBox(height: Dimensions.height10,),
                              Container(
                                                      height:
                                                          Dimensions.height10 * 3.5,
                                                      width:
                                                          Dimensions.width120 * 4,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.black45,
                                                                blurRadius: Dimensions
                                                                        .height10 *
                                                                    0.3,
                                                                offset: Offset(
                                                                    Dimensions
                                                                            .height10 *
                                                                        0.1,
                                                                    Dimensions
                                                                            .height10 *
                                                                        0.1))
                                                          ],
                                                          gradient: LinearGradient(
                                                              colors: [
                                                                 Colors.white,
                                                                ColorClass
                                                                    .mainColor,
                                                               
                                                              ],
                                                              begin: Alignment
                                                                  .centerRight,
                                                              end: Alignment
                                                                  .centerLeft),
                                                          borderRadius: BorderRadius
                                                              .all(Radius.circular(
                                                                  Dimensions
                                                                      .height10))),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            right:
                                                                Dimensions.height10,
                                                            left: Dimensions
                                                                .height10),
                                                        child: TextFormField(
                                                          style: TextStyle(color: Colors.white),
                                                          onChanged: (val) {
                                                            
                                                              setState(() {
                                                                name = val;
                                                              });
                                                          
                                                          },
                                                          validator: (val) {
                                                            if (val!.isEmpty)
                                                              return "Please Enter a Username!";
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                hoverColor: Colors.white,
                                                                focusColor: Colors.white,
                                                                fillColor: Colors.white,
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  icon: Icon(
                                                                    Icons.person,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  hintText:
                                                                      "Username",
                                                                      hintStyle: TextStyle(color: Colors.white)
                                                                      ),
                                                        ),
                                                      ),
                                                    ),
                              SizedBox(height: Dimensions.height10,),
                              Container(
                                                      height:
                                                          Dimensions.height10 * 3.5,
                                                      width:
                                                          Dimensions.width120 * 4,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.black45,
                                                                blurRadius: Dimensions
                                                                        .height10 *
                                                                    0.3,
                                                                offset: Offset(
                                                                    Dimensions
                                                                            .height10 *
                                                                        0.1,
                                                                    Dimensions
                                                                            .height10 *
                                                                        0.1))
                                                          ],
                                                          gradient: LinearGradient(
                                                              colors: [
                                                                 Colors.white,
                                                                ColorClass
                                                                    .mainColor,
                                                               
                                                              ],
                                                              begin: Alignment
                                                                  .centerRight,
                                                              end: Alignment
                                                                  .centerLeft),
                                                          borderRadius: BorderRadius
                                                              .all(Radius.circular(
                                                                  Dimensions
                                                                      .height10))),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            right:
                                                                Dimensions.height10,
                                                            left: Dimensions
                                                                .height10),
                                                        child: TextFormField(
                                                          style: TextStyle(color: Colors.white),
                                                          keyboardType: TextInputType.number,
                                                          onChanged: (val) {
                                                            
                                                              setState(() {
                                                                phoneNumber = val;
                                                              });
                                                          
                                                          },
                                                          validator: (val) {
                                                            if (val!.isEmpty)
                                                              return "Please Enter a Phone Number!";
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  icon: Icon(
                                                                    Icons.person,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  hintText:
                                                                      "Phone Number",
                                                                      hintStyle: TextStyle(color: Colors.white)
                                                                      ),
                                                        ),
                                                      ),
                                                    ),
                                SizedBox(height: Dimensions.height10*4,),
                                !loading
                      ? GestureDetector(
                        onTap: () async {
                           FirebaseAuth login = FirebaseAuth.instance;
                              if (_formKey.currentState!.validate())  {
                                setState(() {
                                  loading = true;
                                });
                                try {
                                  FirebaseAuth login = FirebaseAuth.instance;
                                      await login.signInWithEmailAndPassword(
                                          email: '$phoneNumber@gmail.com',
                                          password: 'foodDUser');
                                      await getTocken();
                                      await sendPushNotification(
                                          mtocken!,
                                          name);
                                      Get.offAll(UserMain());
                                      /*Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) => new UserMain()),
                                      );*/
                                }catch(e){
                                  print("object  $e");
                                  await login.createUserWithEmailAndPassword(
                                      email: '$phoneNumber@gmail.com',
                                      password: 'foodDUser');
                                  await login.signInWithEmailAndPassword(
                                      email: '$phoneNumber@gmail.com',
                                      password: 'foodDUser');
                                  DatabaseReference database =
                                  FirebaseDatabase.instance.ref();
                                  await database
                                      .child('Users')
                                      .child(phoneNumber)
                                      .update({
                                    'Name': name,
                                    'PhoneNumber': phoneNumber
                                  });
                                  await getTocken();
                                  await sendPushNotification(
                                      mtocken!,
                                      name);
                                  Get.offAll(UserMain());
                                  /*Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => new UserMain()),
                                  );*/
                                };
                              }

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: ColorClass.mainColor),
                            borderRadius: BorderRadius.circular(Dimensions.height10*2)
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: Dimensions.width120*4,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:  [
                                    Text(
                                      'Continue',
                                      style: TextStyle(fontSize: 20,color: ColorClass.mainColor),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: ColorClass.mainColor,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.red,
                            )
                          ],
                        )    
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
              ),
    );
  }
}
