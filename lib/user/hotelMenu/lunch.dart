
import 'package:flutter/material.dart';

import '../colors.dart';
import '../dimensions/dimensions.dart';
import '../tabBar/cart/cartDetails.dart';
import '../userData.dart';


class Lunch extends StatefulWidget {
  const Lunch({Key? key}) : super(key: key);

  @override
  State<Lunch> createState() => _LunchState();
}
class ImageReturn{
  late final NetworkImage images;
  ImageReturn({required this.images});
  NetworkImage Rimage(){return images;}
}
class _LunchState extends State<Lunch> {
  List<Map<String,dynamic>> _orders=[];
  late bool loaded;
  int total = 0;
  late final lunchCountController;
  String foodState = '';
  late final foodWidth;
  bool noLunchData = false;
  late final foodCount;
  Future<void> _refreshOrders()async{
    final data = await OrderHelper.getItems();
    setState(() {
      _orders = data;
    });
  }
  Future<void> _addItem(String foodName,String hotelName,String foodWidth,double price,int foodCount,String imageUrl)async{
    await OrderHelper.createItem(foodName, hotelName, foodWidth, price,foodCount,'Lunch',imageUrl);
    _refreshOrders();
    print('Number Of items is ${_orders.length}');
  }
  Future<void> _loadLunchData() async {
    if(UserData.hotelDataMap['${UserData.hotelList[UserData.index]}']['Menu']['Lunch']!=null)
    {
      setState(() {
        UserData.lunchMenuDataMap  = UserData.hotelDataMap['${UserData.hotelList[UserData.index]}']['Menu']['Lunch'];
        UserData.lunchMenuList = UserData.lunchMenuDataMap.keys.toList();
        foodWidth = List<String>.filled(UserData.dinnerMenuList.length, '');
        foodCount = List<int>.filled(UserData.dinnerMenuList.length, 0);
      });
    }else{
      setState(() {
        noLunchData = true;
      });
    }

    setState(() {
      loaded =true;
    });
  }
  @override
  void initState() {
    setState(() {
      loaded = false;
    });
    // TODO: implement initState
    super.initState();
    _loadLunchData();
  }
  @override
  Widget build(BuildContext context) {
    return loaded
        ? !noLunchData
        ? Padding(
      padding: EdgeInsets.only(right: Dimensions.height10,left: Dimensions.height10),
      child: ListView.builder(
        itemBuilder: (_,i){
          final imageReturn = new ImageReturn(images: NetworkImage(UserData
              .lunchMenuDataMap[UserData
              .lunchMenuList[
          i]]['ImageUrl'] as String,));
          return Container(
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
                                "${UserData.lunchMenuList[i]}",style: 
                                TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black,fontSize: Dimensions.height10*1.2,fontWeight: FontWeight.w600),)),
                            SizedBox(height: Dimensions.height10,),
                            SizedBox(width: Dimensions.width120*1.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Normal:",style: TextStyle(color: Colors.black38,fontSize: Dimensions.height10),),
                                  Text(" Rs.${UserData.lunchMenuDataMap[UserData.lunchMenuList[i]]['NormalPrice']}",style: TextStyle(color: Colors.black,fontSize: Dimensions.height10))
                                ],
                              )),
                             SizedBox(width: Dimensions.width120*1.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Full:",style: TextStyle(color: Colors.black38,fontSize: Dimensions.height10),),
                                  Text(" Rs.${UserData.lunchMenuDataMap[UserData.lunchMenuList[i]]['FullPrice']}",style: TextStyle(color: Colors.black,fontSize: Dimensions.height10))
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
                                      if(UserData.lunchMenuDataMap[UserData.lunchMenuList[i]]['FullPrice']==null) {
                            setState(() {
                            UserData.hotelDataMap[UserData
                                .hotelList[UserData.index]]
                            ['HotelState'] ==
                                'Open'?showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context)
                                {
                                  return NoneCustomizableBottomSheet(context,i,imageReturn.Rimage());}):showHotelClosedSnackBar(context);
                          });
                          } else if(UserData.lunchMenuDataMap[UserData.lunchMenuList[i]]['FullPrice']!=null) {
                            UserData.hotelDataMap[UserData
                                .hotelList[UserData.index]]
                            ['HotelState'] ==
                                'Open'?
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context)
                                {
                                  return CustomizableBottomSheet(context,i,imageReturn.Rimage());}):showHotelClosedSnackBar(context);
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
        itemCount: UserData.lunchMenuList.length,
        shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),
        
      ),
    )
        : const Center(
      child: Text(
        'Empty',
        style: TextStyle(
            fontSize: 50,
            color: Colors.black45),
      ),
    )
        : Center(
      child: CircularProgressIndicator(
        color: ColorClass.mainColor,
      ),
    );
  }
  Widget CustomizableBottomSheet(BuildContext context,int i,NetworkImage image)
  {
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
                                        child: Text(UserData.lunchMenuList[
                                        i]
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
                                            Text('Rs.${UserData.lunchMenuDataMap[UserData.lunchMenuList[i]]['NormalPrice']}'),
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
                                            Text('Rs.${UserData.lunchMenuDataMap[UserData.lunchMenuList[i]]['FullPrice']}'),
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
                                          child: Container(
                                            height: Dimensions.height10*4,
                                            width: Dimensions.width120*2.8,
                                            decoration: BoxDecoration(
                                                color: foodCount[i]!=0&&foodWidth[i]!=''?ColorClass.mainColor:Colors.black38,
                                                borderRadius: BorderRadius.circular(Dimensions.height10)),
                                            child: Center(
                                              child: Text('Add to Cart',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                          onTap: foodCount[i]!=0&&foodWidth[i]!=''?(){
                                            _addItem(
                                                '${UserData.lunchMenuList[i]}',
                                                '${UserData.hotelList[UserData.index]}',
                                                foodWidth[i],
                                                double.parse('${UserData.lunchMenuDataMap[UserData.lunchMenuList[i]]['${foodWidth[i]}Price']}'),
                                                foodCount[i],
                                                '${UserData
                                                    .lunchMenuDataMap[UserData
                                                    .lunchMenuList[
                                                i]]['ImageUrl']}');
                                            Navigator.pop(context);
                                            showAddCartSnackBar(context);
                                          }:(){}
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
  Widget NoneCustomizableBottomSheet(BuildContext context,int i,NetworkImage image)
  {
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
                                        child: Text(UserData.lunchMenuList[
                                        i]
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
                                            Text('Rs.${UserData.lunchMenuDataMap[UserData.lunchMenuList[i]]['NormalPrice']}'),
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
                                          child: Container(
                                            height: Dimensions.height10*4,
                                            width: Dimensions.width120*2.8,
                                            decoration: BoxDecoration(
                                                color: foodCount[i]!=0&&foodWidth[i]!=''?ColorClass.mainColor:Colors.black38,
                                                borderRadius: BorderRadius.circular(Dimensions.height10)),
                                            child: Center(
                                              child: Text('Add to Cart',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                          onTap: foodCount[i]!=0&&foodWidth[i]!=''?(){
                                            _addItem(
                                                '${UserData.lunchMenuList[i]}',
                                                '${UserData.hotelList[UserData.index]}',
                                                foodWidth[i],
                                                double.parse('${UserData.lunchMenuDataMap[UserData.lunchMenuList[i]]['${foodWidth[i]}Price']}'),
                                                foodCount[i],
                                                '${UserData
                                                    .lunchMenuDataMap[UserData
                                                    .lunchMenuList[
                                                i]]['ImageUrl']}');
                                            Navigator.pop(context);
                                            showAddCartSnackBar(context);
                                          }:(){}
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
