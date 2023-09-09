import 'package:fastfood/login2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fastfood/user/userMain.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FooddUser(),
    );
  }
}
class FooddUser extends StatefulWidget {
  const FooddUser({Key? key}) : super(key: key);

  @override
  State<FooddUser> createState() => _FooddUserState();
}

class _FooddUserState extends State<FooddUser> {
  FirebaseAuth login = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return login.currentUser==null? const LoginPage2(): const UserMain();
  }
}

