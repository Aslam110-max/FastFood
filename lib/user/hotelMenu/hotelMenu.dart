
import 'package:flutter/material.dart';
import '../colors.dart';
import '../dimensions/dimensions.dart';
import '../tabBar/cart/cart.dart';
import '../userData.dart';
import 'dinner.dart';
import 'lunch.dart';

class HotelMenuNew extends StatefulWidget {
  const HotelMenuNew({Key? key}) : super(key: key);
  @override
  State<HotelMenuNew> createState() => _HotelMenuNewState();
}

late bool loaded;
class _HotelMenuNewState extends State<HotelMenuNew> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context,isScrolled){
            return [
              SliverAppBar(
                leading: BackButton(color: Colors.black,),
              bottom:  TabBar(
                labelColor: ColorClass.mainColor,
                labelStyle: TextStyle(color: ColorClass.mainColor),
                indicatorColor: ColorClass.mainColor,
                tabs: [
                  Tab(
                    icon: Icon(Icons.dinner_dining,color: ColorClass.mainColor,),
                    text: 'Dinner',
                    
                  ),
                  Tab(
                    icon: Icon(Icons.lunch_dining,color: ColorClass.mainColor,),
                    text: 'Lunch',
                  ),
                ],
              ),
              actions: [
                IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Cart()));}, icon: Icon(Icons.shopping_cart_outlined,color: Colors.black,)),
              ],
              backgroundColor: ColorClass.mainColor,
              expandedHeight: Dimensions.height210,
              pinned: true,
              
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                titlePadding: EdgeInsets.only(left: Dimensions.height10*9.5),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    Text(UserData.hotelList[UserData.index] as String,style: TextStyle(color: Colors.black,fontSize: Dimensions.height10*1.5),),
                    Text( UserData.hotelDataMap[UserData
                                                        .hotelList[UserData.index]]
                                                    ['location'] as String,style: TextStyle(color: Colors.grey.shade500,fontSize: Dimensions.height10),),
                  ],
                ) ,
                background: Container(color: Colors.white,),
              ),
            ),
            ];
          },
            body:TabBarView(
                children: [
                  Dinner(),
                  Lunch()
                ])
        ),
      ),
    );
  }
}
