
import 'package:fastfood/user/tabBar/cart/cartDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Notifications.dart';
import '../colors.dart';
import '../dimensions/dimensions.dart';
import '../order/order.dart';

import '../topPageBody/Hotels.dart';
import '../topPageBody/TopPage.dart';
import '../userData.dart';

class HomePageNew extends StatefulWidget {
  const HomePageNew({Key? key}) : super(key: key);

  @override
  State<HomePageNew> createState() => _HomePageNewState();
}
class ImageReturn{
  late final NetworkImage images;
  ImageReturn({required this.images});
  NetworkImage Rimage(){return images;}
}

class _HomePageNewState extends State<HomePageNew> {
  String searchString ="";
  Map searchedFood={};
  List seachedFoodList=[];
    List foodWidth=[];
    List foodCount=[];
    
     Future<void> _addItem(String foodName,String hotelName,String foodWidth,double price,int foodCount,String imageUrl,String foodType)async{
    await OrderHelper.createItem(foodName, hotelName, foodWidth, price,foodCount,foodType,imageUrl);
  
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          
          child: Container(
            width: 50,
            color: ColorClass.mainColor,
            child: ListView(
              children: [
                DrawerHeader(
                    child: Center(
                        child: Image.asset('image/logoNew.png',height: Dimensions.topLogoHeight*2,width: Dimensions.topLogoWidth*2,)
                    )
                ),
                ListTile(
                  onTap: (){ Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Order()),
                        (Route<dynamic> route) => true,
                  );},
                  title: Text('Orders',style: TextStyle(color: Colors.white),),
                  leading: Icon(Icons.emoji_food_beverage_outlined,color: Colors.white,),
                ),
                ListTile(
                  onTap: (){
                   /* launch(
                        'tel://${UserData.adminContactNumber}');*/
                  },
                  title: Text('Contact Us',style: TextStyle(color: Colors.white),),
                  leading: Icon(Icons.numbers_outlined,color: Colors.white,),
                )
              ],
            ),
        ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: Dimensions.width120*0.05,),
                  Image.asset(
                    'image/logoNew.png',
                    height: Dimensions.topLogoHeight,
                    width: Dimensions.topLogoWidth,
                  ),
                  IconButton(
                      onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Notifications()));},
                      icon: Icon(Icons.notifications,
                          color: Colors.black))
                ],
              ),
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background:Column(
                  children: [
                    SizedBox(
                      height: Dimensions.topTopPageSpace,
                    ),
                    
                    TopPage(),
                  ],
                ),),
              backgroundColor: Colors.white,
              expandedHeight: Dimensions.topBarExpandHeight,),
          
            SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: Dimensions.height10,),
                Container(
                          height: Dimensions.height10 * 3.5,
                          width: Dimensions.width120 * 4.5,
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black38,blurRadius: Dimensions.height10*0.2)],
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimensions.height10*2))),
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: Dimensions.height10,
                                left: Dimensions.height10),
                            child: TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  searchString ="";
                                  searchedFood={};
                                   
                                  for(int i=0;i<UserData.hotelDataMap.length;++i){
                                    List hotelNames = UserData.hotelDataMap.keys.toList();
                                    for(String hotel in hotelNames){
                                      Map dinnerMenu = UserData.hotelDataMap[hotel]["Menu"]["Dinner"] as Map;
                                      List dinnerMenuList = dinnerMenu.keys.toList();
                                      for(String dinnerFood in dinnerMenuList){
                                        if(dinnerFood.toLowerCase().contains(val.toLowerCase())){
                                          searchedFood["${dinnerFood}_${hotel}_Dinner"] =UserData.hotelDataMap[hotel]["Menu"]["Dinner"][dinnerFood] as Map;
                                        }
                                      }
                                      ///////////for lunch////////////
                                      Map lunchMenu = UserData.hotelDataMap[hotel]["Menu"]["Lunch"] as Map;
                                      List lunchMenuList = lunchMenu.keys.toList();
                                      for(String lunchFood in lunchMenuList){
                                        if(lunchFood.toLowerCase().contains(val.toLowerCase())){
                                          searchedFood["${lunchFood}_${hotel}_Lunch"] =UserData.hotelDataMap[hotel]["Menu"]["Lunch"][lunchFood] as Map;
                                        }
                                      }
                                    }
                                  }
                                  seachedFoodList = searchedFood.keys.toList();
                                 
                                  foodWidth=[];
                                  foodCount=[];
                                  foodWidth = List<String>.filled(seachedFoodList.length, '');
                                  foodCount = List<int>.filled(seachedFoodList.length, 0);
                                  print(foodWidth);
                                 
                                  searchString = val;
                                });
                        
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.search,
                                    color: ColorClass.mainColor,
                                  ),
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                      
                                      color: Colors.black38,
                                      fontSize: Dimensions.height10)),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.height10,),
                        searchString==""?
                Restaurants():
                ListView.builder(
                  
      itemBuilder: (_,i){
        List arr =seachedFoodList[i].split("_");
        final imageReturn = new ImageReturn(images: NetworkImage(searchedFood[seachedFoodList[i]]["ImageUrl"]));
            return 
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(Dimensions.height10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                             SizedBox(
                              width: Dimensions.width120*2,
                              child: Text(
                                "${arr[1]}",style: 
                                TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black38,fontSize: Dimensions.height10*1.2,fontWeight: FontWeight.w500),)),
                             SizedBox(
                              width: Dimensions.width120*2,
                              child: Text(
                                "${arr[2]}",style: 
                                TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black38,fontSize: Dimensions.height10*1.2,fontWeight: FontWeight.w500),)),
                            
                            SizedBox(
                              width: Dimensions.width120*2,
                              child: Text(
                                "${arr[0]}",style: 
                                TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black,fontSize: Dimensions.height10*1.2,fontWeight: FontWeight.w600),)),
                            SizedBox(height: Dimensions.height10,),
                            SizedBox(width: Dimensions.width120*1.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Normal:",style: TextStyle(color: Colors.black38,fontSize: Dimensions.height10),),
                                  Text(" Rs.${searchedFood[seachedFoodList[i]]['NormalPrice']}",style: TextStyle(color: Colors.black,fontSize: Dimensions.height10))
                                ],
                              )),
                             SizedBox(width: Dimensions.width120*1.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Full:",style: TextStyle(color: Colors.black38,fontSize: Dimensions.height10),),
                                  Text(" Rs.${searchedFood[seachedFoodList[i]]['FullPrice']}",style: TextStyle(color: Colors.black,fontSize: Dimensions.height10))
                                ],
                              )),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                         Stack(
                          children: [
                            Container(
                              height: Dimensions.height120*1.2,
                              width: Dimensions.topDesignHeight,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                              image:imageReturn.Rimage(),fit: BoxFit.cover),
                                
                                borderRadius: BorderRadius.circular(Dimensions.height10),
                                
                              ),
                            ),
                            Container(
                               height: Dimensions.height120*1.3,
                                width: Dimensions.topDesignHeight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      List arr = seachedFoodList[i].split("_");
                                      if(searchedFood[seachedFoodList[i]]['FullPrice']==null) {
                            setState(() {
                              
                            UserData.hotelDataMap[arr[1]]
                            ['HotelState'] ==
                                'Open'?showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context)
                                {
                                  return NoneCustomizableBottomSheet(context,i,imageReturn.Rimage(),arr[2]);}):showHotelClosedSnackBar(context);
                          });
                          } else if(searchedFood[seachedFoodList[i]]['FullPrice']!=null) {
                           UserData.hotelDataMap[arr[1]]
                            ['HotelState'] ==
                                'Open'?
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context)
                                {
                                  return CustomizableBottomSheet(context,i,imageReturn.Rimage(),arr[2]);}):showHotelClosedSnackBar(context);
                          }
                                    },
                                    child: Container(
                                                              height: Dimensions.height10*3,
                                                              width: Dimensions.width120*1.3,
                                                              decoration: BoxDecoration(
                                    border: Border.all(color: ColorClass.mainColor),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(Dimensions.height10),
                                    
                                                              ),
                                                              child: Center(
                                                          child: Text('Add',style: TextStyle(color: ColorClass.mainColor),),)
                                                      
                                                            ),
                                  ),
                                ],
                              ),
                            )
                          ],
                         )
                        ],
                      )
                    ],
                  ),
                Divider(
                  color: Colors.grey.shade600,
                )
                ],
              ),
            );
                        },
      itemCount:seachedFoodList.length,
      shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),
         ),

              ],
            ),)



          ],)
      ),
    );
  }
   Widget CustomizableBottomSheet(BuildContext context,int i,NetworkImage image,String foodType)
  {
    List foodNameArr =seachedFoodList[i].split("_");
    return StatefulBuilder(builder: (context,setState){
      return Container(
      height: Dimensions.height210*1.5,
      child: Column(
        children: [
          Center(
            child: IconButton(
                onPressed: (){Navigator.pop(context);},
                icon: Icon(
                  Icons.close_outlined,
                  color: Colors.white,)
            ),
          ),
          Expanded(
              child: Stack(
                children: [
                  Container(decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.height10*2),
                        topRight: Radius.circular(Dimensions.height10*2)
                    ),
                    color: Colors.white,
                  ),),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.height10*2),
                            topRight: Radius.circular(Dimensions.height10*2)
                        ),
                        color: Colors.black12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: Dimensions.height70*0.9,
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(0, 3),blurRadius: 5)],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimensions.height10*2),
                                  topRight: Radius.circular(Dimensions.height10*2)
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: Dimensions.height10,top:Dimensions.height10/2,bottom: Dimensions.height10/2 ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: Dimensions.height70*0.9,
                                      width: Dimensions.height70*0.9,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(image: image,fit: BoxFit.fill),
                                          color: Colors.black26,
                                          borderRadius: BorderRadius.circular(Dimensions.height10*2)
                                      ),),
                                    SizedBox(width: Dimensions.height10,),
                                    Expanded(
                                      child: Text(foodNameArr[0]
                                      as String,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(fontSize: Dimensions.height10*6/5,fontWeight: FontWeight.bold),
                                      ),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:EdgeInsets.only(left: Dimensions.height10*1.5,right: Dimensions.height10*1.5),
                            child: Container(
                              height: Dimensions.height70*1.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.height10*2
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left:Dimensions.height10*2,right:Dimensions.height10*2 ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Text('Normal',
                                            style: TextStyle(fontSize: Dimensions.height10*6/5,fontWeight: FontWeight.bold),
                                          ),),
                                        Row(children: [
                                          Text('Rs.${searchedFood[seachedFoodList[i]]['NormalPrice']}'),
                                          Radio(
                                            activeColor: ColorClass.mainColor,
                                              value: 'Normal',
                                              groupValue:foodWidth[i] ,
                                              onChanged: (val){
                                            this.setState(() {
                                              setState(() {
                                                foodCount[i]=0;
                                                foodWidth[i]=val;
                                              });
                                          });

                                          }
                                          )
                                        ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text('Full',
                                            style: TextStyle(fontSize: Dimensions.height10*6/5,fontWeight: FontWeight.bold),
                                          ),),
                                        Row(children: [
                                          Text('Rs.${searchedFood[seachedFoodList[i]]['FullPrice']}'),
                                          Radio(
                                              activeColor: ColorClass.mainColor,
                                              value: 'Full',
                                              groupValue:foodWidth[i] ,
                                              onChanged: (val){
                                                this.setState(() {
                                                  setState(() {
                                                    foodCount[i]=0;
                                                    foodWidth[i]=val;
                                                  });
                                                });

                                              }
                                          )
                                        ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: Dimensions.height70*0.7,
                            color: Colors.white,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: Dimensions.height10,top:Dimensions.height10/2,bottom: Dimensions.height10/2,right: Dimensions.height10 ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: Dimensions.height10*4,
                                      width: Dimensions.width120*1.8,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: ColorClass.mainColor),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(Dimensions.height10)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(onPressed: (){
                                            if(foodCount[i]>0)
                                             {
                                             this.setState(() {
                                               setState(() {
                                                 foodCount[i]=foodCount[i]-1;
                                               });
                                             });}
                                          },
                                              icon: Icon(Icons.remove),
                                              iconSize: Dimensions.height10*1.5,
                                              color: ColorClass.mainColor),
                                          Text('${foodCount[i]}',style: TextStyle(color: Colors.black,fontSize: Dimensions.height10*1.2),),
                                          IconButton(onPressed: (){
                                            if(foodCount[i]<99)
                                              {
                                                this.setState(() {
                                                  setState(() {
                                                    foodCount[i]=foodCount[i]+1;
                                                  });
                                                });
                                              }
                                          }, icon: Icon(Icons.add),iconSize: Dimensions.height10*1.5,color: ColorClass.mainColor,)
                                        ],),
                                    ),
                                    GestureDetector(
                                      onTap:
                                      foodCount[i]!=0&&foodWidth[i]!=''?(){

                                        _addItem(
                                            '${foodNameArr[0]}',
                                            '${foodNameArr[1]}',
                                            foodWidth[i],
                                            double.parse('${searchedFood[seachedFoodList[i]]['${foodWidth[i]}Price']}'),
                                            foodCount[i],
                                            '${searchedFood[seachedFoodList[i]]['ImageUrl']}',foodType);
                                        Navigator.pop(context);
                                        showAddCartSnackBar(context);
                                      }:(){},
                                      child: Container(
                                        height: Dimensions.height10*4,
                                        width: Dimensions.width120*2.8,
                                        decoration: BoxDecoration(
                                            color: foodCount[i]!=0&&foodWidth[i]!=''?ColorClass.mainColor:Colors.black38,
                                            borderRadius: BorderRadius.circular(Dimensions.height10)),
                                        child: Center(
                                          child: Text('Add to Cart',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              )
          ),
        ],
      ),
    );
    }
    );
  }
  Widget NoneCustomizableBottomSheet(BuildContext context,int i,NetworkImage image,String foodType)
  {
    List foodNameArr =seachedFoodList[i].split("_");
    return StatefulBuilder(builder: (context,setState){
      return Container(
        height: Dimensions.height210*1.5,
        child: Column(
          children: [
            Center(
              child: IconButton(
                  onPressed: (){Navigator.pop(context);},
                  icon: Icon(
                    Icons.close_outlined,
                    color: Colors.white,)
              ),
            ),
            Expanded(
                child: Stack(
                  children: [
                    Container(decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.height10*2),
                          topRight: Radius.circular(Dimensions.height10*2)
                      ),
                      color: Colors.white,
                    ),),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.height10*2),
                              topRight: Radius.circular(Dimensions.height10*2)
                          ),
                          color: Colors.black12,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: Dimensions.height70*0.9,
                              decoration: BoxDecoration(
                                boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(0, 3),blurRadius: 5)],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(Dimensions.height10*2),
                                    topRight: Radius.circular(Dimensions.height10*2)
                                ),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: Dimensions.height10,top:Dimensions.height10/2,bottom: Dimensions.height10/2 ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: Dimensions.height70*0.9,
                                        width: Dimensions.height70*0.9,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(image: image,fit: BoxFit.fill),
                                            color: Colors.black26,
                                            borderRadius: BorderRadius.circular(Dimensions.height10*2)
                                        ),),
                                      SizedBox(width: Dimensions.height10,),
                                      Expanded(
                                        child: Text(foodNameArr[0]
                                        as String,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: Dimensions.height10*6/5,fontWeight: FontWeight.bold),
                                        ),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:EdgeInsets.only(left: Dimensions.height10*1.5,right: Dimensions.height10*1.5),
                              child: Container(
                                height: Dimensions.height70*1.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.height10*2
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left:Dimensions.height10*2,right:Dimensions.height10*2 ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Text('Normal',
                                              style: TextStyle(fontSize: Dimensions.height10*6/5,fontWeight: FontWeight.bold),
                                            ),),
                                          Row(children: [
                                            Text('Rs.${searchedFood[seachedFoodList[i]]['NormalPrice']}'),
                                            Radio(
                                                activeColor: ColorClass.mainColor,
                                                value: 'Normal',
                                                groupValue:foodWidth[i] ,
                                                onChanged: (val){
                                                  this.setState(() {
                                                    setState(() {
                                                      foodCount[i]=0;
                                                      foodWidth[i]=val;
                                                    });
                                                  });

                                                }
                                            )
                                          ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: Dimensions.height70*0.7,
                              color: Colors.white,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: Dimensions.height10,top:Dimensions.height10/2,bottom: Dimensions.height10/2,right: Dimensions.height10 ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        height: Dimensions.height10*4,
                                        width: Dimensions.width120*1.8,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: ColorClass.mainColor),
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(Dimensions.height10)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(onPressed: (){
                                              if(foodCount[i]>0)
                                              {
                                                this.setState(() {
                                                  setState(() {
                                                    foodCount[i]=foodCount[i]-1;
                                                  });
                                                });}
                                            },
                                                icon: Icon(Icons.remove),
                                                iconSize: Dimensions.height10*1.5,
                                                color: ColorClass.mainColor),
                                            Text('${foodCount[i]}',style: TextStyle(color: Colors.black,fontSize: Dimensions.height10*1.2),),
                                            IconButton(onPressed: (){
                                              if(foodCount[i]<99)
                                              {
                                                this.setState(() {
                                                  setState(() {
                                                    foodCount[i]=foodCount[i]+1;
                                                  });
                                                });
                                              }
                                            }, icon: Icon(Icons.add),iconSize: Dimensions.height10*1.5,color: ColorClass.mainColor,)
                                          ],),
                                      ),
                                      GestureDetector(
                                          onTap: foodCount[i]!=0&&foodWidth[i]!=''?(){
                                            _addItem(
                                                '${foodNameArr[0]}',
                                                '${foodNameArr[1]}',
                                                foodWidth[i],
                                                double.parse('${searchedFood[seachedFoodList[i]]['${foodWidth[i]}Price']}'),
                                                foodCount[i],
                                                '${searchedFood[seachedFoodList[i]]['ImageUrl']}',foodType);
                                            Navigator.pop(context);
                                            showAddCartSnackBar(context);
                                          }:(){},
                                          child: Container(
                                            height: Dimensions.height10*4,
                                            width: Dimensions.width120*2.8,
                                            decoration: BoxDecoration(
                                                color: foodCount[i]!=0&&foodWidth[i]!=''?ColorClass.mainColor:Colors.black38,
                                                borderRadius: BorderRadius.circular(Dimensions.height10)),
                                            child: Center(
                                              child: Text('Add to Cart',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                )
            ),
          ],
        ),
      );
    }
    );
  }
  void showAddCartSnackBar(BuildContext context){
    final snackBar = SnackBar(
        content: Text('Successfully Added, Check your Cart',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
            backgroundColor: ColorClass.mainColor,
      duration: Duration(seconds: 2),
      shape: StadiumBorder(),
      behavior: SnackBarBehavior.floating,

    );
    ScaffoldMessenger.of(context)..showSnackBar(snackBar);
  }
  void showHotelClosedSnackBar(BuildContext context){
    final snackBar = SnackBar(
      content: Text("Sorry, This Hotel is Closed! You Can't order",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
      backgroundColor: ColorClass.mainColor,
      duration: Duration(seconds: 2),
      shape: StadiumBorder(),
      behavior: SnackBarBehavior.floating,

    );
    ScaffoldMessenger.of(context)..showSnackBar(snackBar);
  }

}

