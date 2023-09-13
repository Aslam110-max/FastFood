
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fastfood/user/tabBar/cart/cart.dart';
import 'package:fastfood/user/topPageBody/LoadingPage.dart';
import 'package:fastfood/user/userData.dart';

import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';
import 'dimensions/dimensions.dart';
import 'tabBar/homePageNew.dart';

class UserMain extends StatefulWidget {
  const UserMain({Key? key}) : super(key: key);

  @override
  State<UserMain> createState() => _UserMainState();
}
class _UserMainState extends State<UserMain> {
  int index = 0;
  bool loading = true;
 
  late final String appUrl;
  Future<void> _loadData()async {
    DatabaseReference data = FirebaseDatabase.instance.ref();
    await data.child('AdImage').once().then((value) {
      if(value.snapshot.value !=null){
        UserData.adImageUrlMap = value.snapshot.value as Map;
        UserData.adImageUrlList = UserData.adImageUrlMap.keys.toList();
      }
    });
   
    await data.child('Hotels').once().then((value) {
      UserData.hotelDataMap = value.snapshot.value as Map;
      UserData.hotelList = UserData.hotelDataMap.keys.toList();
    });
    await data.child("ContactUs").once().then((value) {
      Map adminDetails = value.snapshot.value as Map;
      setState(() {
        UserData.adminContactNumber = adminDetails["phoneNumber"];
      });

    });
        setState(() {
      loading = false;
    });
  }
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
   
  }
  List<Widget> tabBarpages = [
  HomePageNew(),
 Cart()
];
int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return loading &&UserData.hotelList.isEmpty? Center(child: CircularProgressIndicator(color: ColorClass.mainColor,),): Scaffold(
                body: Stack(
        children: [
          tabBarpages[selectedIndex],
          Padding(
            padding: EdgeInsets.only(
                left: Dimensions.height10,
                right: Dimensions.height10,
                bottom: Dimensions.height10 * 2),
            child: Align(
              alignment: Alignment(0.0, 1.0),
              child: Container(
                width: Dimensions.width120*2,
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(Dimensions.height10 * 2),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black45,
                          blurRadius: Dimensions.height10 * 0.3,
                          offset: Offset(0, 3))
                    ]),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimensions.space15 * 2)),
                  child: BottomNavigationBar(
                    
                      onTap: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      currentIndex: selectedIndex,
                      backgroundColor: Colors.white,
                      unselectedItemColor: Colors.grey,
                      showUnselectedLabels: true,
                      selectedItemColor: ColorClass.mainColor,
                      selectedIconTheme:
                          IconThemeData(color: ColorClass.mainColor),
                      items:  [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home_outlined), label: 'Home'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
                      
                           
                      ]),
                ),
              ),
            ),
          )
        ],
      ),

    );
  }
 }
