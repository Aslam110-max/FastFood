
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimensions/dimensions.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late final Map notificationDataMap;
  late final List notificationList;
  bool loaded = false;
  Future<void> _loadNotificationData()async {
    DatabaseReference data =FirebaseDatabase.instance.ref();
        await data.child('Notification').once().then((value) {
          if(value.snapshot.value!=null){
           notificationDataMap =value.snapshot.value as Map;
           notificationList = notificationDataMap.keys.toList();
           setState(() {
             loaded = true;
           });
          }
        });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNotificationData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        backgroundColor: ColorClass.mainColor,
      ),
      body:loaded? ListView.builder(
        itemCount: notificationList.length,
          itemBuilder: (context,i){
        return Padding(
          padding: EdgeInsets.only(bottom: Dimensions.height10,right: Dimensions.height10,left: Dimensions.height10,top: i==0?Dimensions.height10:0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.height10),
              border: Border.all(color: Colors.black)
            ),
            child: Padding(
              padding: EdgeInsets.all(Dimensions.height10/2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                            '${notificationDataMap[notificationList[i]]['title']}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:Dimensions.height10*1.3,
                                overflow: TextOverflow.ellipsis
                            ),
                          )
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.height10*0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(
                              '${notificationDataMap[notificationList[i]]['body']}',
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                fontSize: Dimensions.height10,
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${notificationDataMap[notificationList[i]]['dateAndTime']}',
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: Dimensions.height10,
                            overflow: TextOverflow.ellipsis
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }):Center(child: Text('Loading...'),)
    );
  }
}
