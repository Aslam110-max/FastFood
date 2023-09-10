import 'package:fastfood/login2.dart';
import 'package:fastfood/user/order/order.dart';
import 'package:fastfood/user/tabBar/cart/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fastfood/user/userMain.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final data = message.data;

  // Extract custom data from the notification payload
  final screen = data['screen'];
  //Get.offAll(Cart());

  // Navigate to the appropriate screen based on the custom data
  print(screen+"_firebaseMessagingBackgroundHandler");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    FlutterLocalNotificationsPlugin _notificationPlugins =
        FlutterLocalNotificationsPlugin();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationPlugins.initialize(initializationSettings);
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) async {
      final id = DateTime.now().microsecondsSinceEpoch ~/ 10000000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("FastFood", "FastFood channel",
              importance: Importance.max, priority: Priority.high));
      if (message.notification != null) {
        print(message.notification!.body);
       print(message.data);
         
       
      }
      try {
        await _notificationPlugins.show(id, message.notification!.title,
            message.notification!.body, notificationDetails);
      } catch (e) {
        print('Nerro: $e');
      }
    });
    ////////////////
   

/*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
 final data = message.data;

  // Extract custom data from the notification payload
  final screen = data['screen'];

  // Navigate to the appropriate screen based on the custom data
  print(screen+"onMessage");
});*/

FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
 final data = message.data;

  // Extract custom data from the notification payload
  final screen = data['screen'];
  if(screen!=null){
    //Get.offAll(Order());
  }
  

  // Navigate to the appropriate screen based on the custom data
  print(screen+"onMessageOpenedApp");
});


FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


    ///
    

    //FirebaseMessaging.onBackgroundMessage((message) =>);
   
  /////////////////////
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@drawable/ic_launcher');

  final DarwinInitializationSettings iosInitializationSettings =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  );

  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    
    onDidReceiveNotificationResponse: onSelectNotification,
    
  );
  var details = flutterLocalNotificationsPlugin
    .getNotificationAppLaunchDetails();

    print(details);

  runApp(const MyApp());
}
void onSelectNotification(NotificationResponse? payload) {
  if (payload != null) {
    debugPrint('Notification payload: $payload');
  }
  // Handle the notification tap event, e.g., navigate to a specific screen.
}

Future<void> onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // Handle the notification when the app is in the foreground.
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
  void initState() {
    //login.signOut();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return login.currentUser==null? const LoginPage2(): const UserMain();
  }
}

