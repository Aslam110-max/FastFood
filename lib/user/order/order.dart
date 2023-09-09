
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../dimensions/dimensions.dart';
class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);
  @override
  State<Order> createState() => _OrderState();
}
Map processingOrdersDataMap={};
List processingOrdersList=[];
Map cancelOrdersDataMap={};
List cancelOrdersList=[];
Map deliveredOrdersDataMap={};
List deliveredOrdersList=[];
bool loaded =false;
bool noProcessingOrder =true;
bool noCanceledOrder =true;
bool noDeliveredOrder =true;
class _OrderState extends State<Order> {
  Future<void> _loadProcessingOrdersData() async {

    setState(() {
      processingOrdersDataMap={};
      cancelOrdersDataMap={};
      deliveredOrdersDataMap={};
      noProcessingOrder=true;
    });
    DatabaseReference data = FirebaseDatabase.instance.ref();
    FirebaseAuth login = FirebaseAuth.instance;
     List arr = login.currentUser!.email!.split("@").toList();
     Map myOrders ={};
     List myOrderList=[];
     await data.child("Users").child(arr[0]).child("myOrders").once().then((value) async {
      if(value.snapshot.value!=null){
        myOrders = value.snapshot.value as Map;
        myOrderList = myOrders.keys.toList();
        for (var i = 0; i < myOrderList.length; i++) {
          if(myOrders[myOrderList[i]]=='Processing'){
            await data.child("Orders").child('Processing').child(myOrderList[i]).once().then((value){
              processingOrdersDataMap[myOrderList[i]] = value.snapshot.value as Map;
            });
          }
          if(myOrders[myOrderList[i]]=='Canceled'){
            await data.child("Orders").child('Canceled').child(myOrderList[i]).once().then((value){
              cancelOrdersDataMap[myOrderList[i]] = value.snapshot.value as Map;
            });
          }
           if(myOrders[myOrderList[i]]=='Delivered'){
            await data.child("Orders").child('Delivered').child(myOrderList[i]).once().then((value){
              deliveredOrdersDataMap[myOrderList[i]] = value.snapshot.value as Map;
            });
          }
        }
       
        setState(() {
          
          if(processingOrdersDataMap.isEmpty){
            noProcessingOrder =true;
          }else{
            noProcessingOrder = false;
            processingOrdersList = processingOrdersDataMap.keys.toList();
            processingOrdersList.sort();
            processingOrdersList = processingOrdersList.reversed.toList();
            
          }
          if(cancelOrdersDataMap.isEmpty){
            noCanceledOrder = true;
          }else{
            cancelOrdersList =cancelOrdersDataMap.keys.toList();
            noCanceledOrder = false;
             cancelOrdersList.sort();
            cancelOrdersList = cancelOrdersList.reversed.toList();
          }
          if(deliveredOrdersDataMap.isEmpty){
            noDeliveredOrder =true;
          }else{
            noDeliveredOrder = false;
            deliveredOrdersList = deliveredOrdersDataMap.keys.toList();
            deliveredOrdersList.sort();
            deliveredOrdersList = deliveredOrdersList.reversed.toList();
          }
          loaded =true;
        });
      
      }
     });
   
  }
      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loaded =false;
    });
    _loadProcessingOrdersData();
    
    
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context,isScrolled){
              return [
                SliverAppBar(
                  leading: BackButton(color: Colors.black,),
                  bottom: TabBar(
                    unselectedLabelColor: Colors.black38,
                    labelColor: Colors.black,
                    indicatorColor: ColorClass.mainColor,
                    tabs: [
                      Tab(
                        text: 'Processing',
                      ),
                      Tab(
                        text: 'Delivered',
                      ),
                      Tab(
                        text: 'Canceled',
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white,
                  expandedHeight: Dimensions.height210,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(bottom: Dimensions.height10*3,left: Dimensions.height10*1.5),
                    title: Text('My Orders',style: TextStyle(color: Colors.black,fontSize: Dimensions.height10*1.5),),
                  ),
                ),
              ];
            },
            body:loaded?TabBarView(
                children: [
                  !noProcessingOrder?
                  ListView.builder(
                      itemCount:processingOrdersList.length ,
                      itemBuilder: (context,i){
                       
                          return Padding(
                          padding: EdgeInsets.only(bottom:Dimensions.height10,left: Dimensions.height10,right: Dimensions.height10),
                          child: Container(
                            height: Dimensions.height120*1.45,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 5
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(Dimensions.height10)
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top:Dimensions.height10/2,left: Dimensions.height10,right: Dimensions.height10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Order ${i+1}',style: TextStyle(fontSize: Dimensions.height10*1.3,fontWeight: FontWeight.bold),),
                                      processingOrdersDataMap['${processingOrdersList[i]}']['state']=='NotConfirm'?TextButton(
                                          child: Text('Cancel',
                                            style: TextStyle(
                                                color: Colors.red[700],
                                                fontSize: Dimensions.height10*1.3),),
                                        onPressed: (){
                                            CancelDialogBox(processingOrdersDataMap, processingOrdersList, i);
                                        },
                                      ):Text("")
                                    ],
                                  ),
                                  Container(
                                    height: Dimensions.height70*0.5,
                                    child: ListView.builder(itemCount:processingOrdersDataMap['${processingOrdersList[i]}']['Orders'].keys.length,itemBuilder: (context,j){
                                      List Orders = processingOrdersDataMap['${processingOrdersList[i]}']['Orders'].keys.toList();
                                      return Text('${processingOrdersDataMap['${processingOrdersList[i]}']['Orders'][Orders[j]]['foodName']}',style: TextStyle(color: Colors.black38),);
                                    }),
                                  ),
                                  Text('Total Amount: Rs.${processingOrdersDataMap['${processingOrdersList[i]}']['totalAmount']}',style: TextStyle(color: Colors.black38),),
                                  Text('${processingOrdersDataMap['${processingOrdersList[i]}']['dateAndTime']}',style: TextStyle(color: Colors.black38),),
                                  Padding(
                                    padding: EdgeInsets.only(top: Dimensions.height10*0.5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            height: Dimensions.height10*3,
                                            width: Dimensions.width120*1.5,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Dimensions.height10*2),
                                              border: Border.all(color: Colors.black,width: 2)
                                            ),
                                            child: Center(
                                              child: Text('Details'),
                                            ),
                                          ),
                                          onTap: (){DialogBox(processingOrdersDataMap, processingOrdersList,i);},
                                        ),
                                        processingOrdersDataMap['${processingOrdersList[i]}']['state']=='NotConfirm'?Text('Processing...'):Text('Confirmed',style: TextStyle(color: Colors.green),)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }):Center(child: Text('No Orders'),),
                  !noDeliveredOrder?
                  ListView.builder(
                      itemCount:deliveredOrdersList.length-1 ,
                      itemBuilder: (context,i){
                        deliveredOrdersList.remove('ordersCount');
                        return Padding(
                          padding: EdgeInsets.only(bottom:Dimensions.height10,left: Dimensions.height10,right: Dimensions.height10),
                          child: Container(
                            height: Dimensions.height120*1.3,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 5
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(Dimensions.height10)
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top:Dimensions.height10/2,left: Dimensions.height10,right: Dimensions.height10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order ${i+1}',style: TextStyle(fontSize: Dimensions.height10*1.3,fontWeight: FontWeight.bold),),
                                  Container(
                                    height: Dimensions.height70*0.5,
                                    child: ListView.builder(itemCount:deliveredOrdersDataMap['${deliveredOrdersList[i]}']['Orders'].keys.length,itemBuilder: (context,j){
                                      List Orders = deliveredOrdersDataMap['${deliveredOrdersList[i]}']['Orders'].keys.toList();
                                      return Text('${deliveredOrdersDataMap['${deliveredOrdersList[i]}']['Orders'][Orders[j]]['foodName']}',style: TextStyle(color: Colors.black38),);
                                    }),
                                  ),
                                  Text('Total Amount: ${deliveredOrdersDataMap['${deliveredOrdersList[i]}']['totalAmount']}',style: TextStyle(color: Colors.black38),),
                                  Text('${deliveredOrdersDataMap['${deliveredOrdersList[i]}']['dateAndTime']}',style: TextStyle(color: Colors.black38),),
                                  Padding(
                                    padding: EdgeInsets.only(top: Dimensions.height10*0.5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            height: Dimensions.height10*3,
                                            width: Dimensions.width120*1.5,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Dimensions.height10*2),
                                                border: Border.all(color: Colors.black,width: 2)
                                            ),
                                            child: Center(
                                              child: Text('Details'),
                                            ),
                                          ),
                                          onTap: (){DialogBox(deliveredOrdersDataMap, deliveredOrdersList,i);},
                                        ),
                                        Text('Delivered',style: TextStyle(color: Colors.green),)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }):Center(child: Text('No Orders'),),
                  !noCanceledOrder?
                  ListView.builder(
                      itemCount:cancelOrdersList.length ,
                      itemBuilder: (context,i){
                        
                        return Padding(
                          padding: EdgeInsets.only(bottom:Dimensions.height10,left: Dimensions.height10,right: Dimensions.height10),
                          child: Container(
                            height: Dimensions.height120*1.3,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 5
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(Dimensions.height10)
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top:Dimensions.height10/2,left: Dimensions.height10,right: Dimensions.height10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order ${i+1}',style: TextStyle(fontSize: Dimensions.height10*1.3,fontWeight: FontWeight.bold),),
                                  Container(
                                    width: Dimensions.width120*2.5,
                                    height: Dimensions.height70*0.5,
                                    child: ListView.builder(itemCount:cancelOrdersDataMap['${cancelOrdersList[i]}']['Orders'].keys.length,itemBuilder: (context,j){
                                      List Orders = cancelOrdersDataMap['${cancelOrdersList[i]}']['Orders'].keys.toList();
                                      return Text('${cancelOrdersDataMap['${cancelOrdersList[i]}']['Orders'][Orders[j]]['foodName']}',style: TextStyle(color: Colors.black38),);
                                    }),
                                  ),
                                  Text('Total Amount: ${cancelOrdersDataMap['${cancelOrdersList[i]}']['totalAmount']}',style: TextStyle(color: Colors.black38),),
                                  Text('${cancelOrdersDataMap['${cancelOrdersList[i]}']['dateAndTime']}',style: TextStyle(color: Colors.black38),),
                                  Padding(
                                    padding: EdgeInsets.only(top: Dimensions.height10*0.5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            height: Dimensions.height10*3,
                                            width: Dimensions.width120*1.5,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Dimensions.height10*2),
                                                border: Border.all(color: Colors.black,width: 2)
                                            ),
                                            child: Center(
                                              child: Text('Details'),
                                            ),
                                          ),
                                          onTap: (){DialogBox(cancelOrdersDataMap, cancelOrdersList,i);},
                                        ),
                                        Text('Canceled',style: TextStyle(color: Colors.red[700]),)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }):Center(child: Text('No Orders'),),
                ]):Center(child: Text('Please wait...'),)
        ),
      ),
    );
  }
  DialogBox(Map ordersDataMap,List ordersList,int i) {
    List Orders = ordersDataMap['${ordersList[i]}']['Orders'].keys.toList();
    showDialog(
        context: context,
        builder:(context){
          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.height10),
                  color: Colors.white,
                ),
                width: Dimensions.screenWidth,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.height10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(Dimensions.height10/2),
                          child: Text('Order ${i+1}',style: TextStyle(fontSize: Dimensions.height10*1.3,fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom:Dimensions.height10/2),
                          child: Text('Name: ${ordersDataMap['${ordersList[i]}']['name']}',style: TextStyle(fontSize: Dimensions.height10*1.1,),
                        ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom:Dimensions.height10/2),
                          child: Text('Phone Number 1: ${ordersDataMap['${ordersList[i]}']['PhoneNumber1']}',style: TextStyle(fontSize: Dimensions.height10*1.1,),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom:Dimensions.height10/2),
                          child: Text('Phone Number 2: ${ordersDataMap['${ordersList[i]}']['PhoneNumber2']}',style: TextStyle(fontSize: Dimensions.height10*1.1,),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom:Dimensions.height10/2),
                          child: Text('Orders:'),
                        ),
                        for(int j =0;j<ordersDataMap['${ordersList[i]}']['Orders'].keys.length;++j)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: Dimensions.height120*0.8,
                            width: Dimensions.screenWidth,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(Dimensions.height10)
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(Dimensions.height10/3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Expanded(child: Text('${ordersDataMap['${ordersList[i]}']['Orders'][Orders[j]]['foodName']}',style: TextStyle(color: Colors.black,fontSize: Dimensions.height10*1.1),overflow: TextOverflow.ellipsis,)),
                                     Text('${ordersDataMap['${ordersList[i]}']['Orders']['${Orders[j]}']['foodType']}',
                                       style: TextStyle(
                                           color: Colors.black38,
                                           fontSize: Dimensions.height10),
                                     ),
                                   ],
                                 ),
                                  Text('${ordersDataMap['${ordersList[i]}']['Orders']['${Orders[j]}']['hotelName']}',
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: Dimensions.height10),
                                  ),
                                  Text('${ordersDataMap['${ordersList[i]}']['Orders']['${Orders[j]}']['foodWidth']}',
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: Dimensions.height10),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Quantity: ${ordersDataMap['${ordersList[i]}']['Orders']['${Orders[j]}']['foodCount']}',
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: Dimensions.height10),
                                      ),
                                      Text('Rs: ${ordersDataMap['${ordersList[i]}']['Orders']['${Orders[j]}']['price']}',
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: Dimensions.height10),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom:Dimensions.height10/2),
                          child: Row(
                            children: [
                              Text('Location: ',style: TextStyle(fontSize: Dimensions.height10*1.1,),),
                          Expanded(child: Text('${ordersDataMap['${ordersList[i]}']['Area']},${ordersDataMap['${ordersList[i]}']['location']}',style: TextStyle(fontSize: Dimensions.height10*1.1,),))
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom:Dimensions.height10/2),
                          child: Text('Bill Amount: Rs.${ordersDataMap['${ordersList[i]}']['billAmount']}',style: TextStyle(fontSize: Dimensions.height10*1.1,),
                          ),
                        ),
                       
                        Padding(
                          padding: EdgeInsets.only(bottom:Dimensions.height10/2),
                          child: Text('Total Amount: Rs.${ordersDataMap['${ordersList[i]}']['totalAmount']}',style: TextStyle(fontSize: Dimensions.height10*1.1,),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:Dimensions.height70/2),
                          child: Text('${ordersDataMap['${ordersList[i]}']['dateAndTime']}',style: TextStyle(fontSize: Dimensions.height10*1.1,color: Colors.black38),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          );
        }
    );
  }
  CancelDialogBox(Map ordersDataMap,List ordersList,int i) {
    bool canceling = false;
    bool canceled = false;
    List Orders = ordersDataMap['${ordersList[i]}']['Orders'].keys.toList();
    showDialog(
        context: context,
        builder:(context){
          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              content: Container(
                height: 200,
                child:
                canceling?
                Column(
                  children: [
                    Padding(
                  padding: EdgeInsets.only(bottom:Dimensions.height10*2),
                  child: Text('Please wait until cancel',style: TextStyle(color: Colors.white,fontSize: Dimensions.height10*1.5),),
                ),CircularProgressIndicator(color: ColorClass.mainColor,)],):
                canceled?
                Center(
                  child: TextButton(child: Text('Done',style: TextStyle(color: Colors.white,fontSize: Dimensions.height10*1.5),),onPressed: (){Navigator.pop(context);},),):
                Column(
                  children: [
                    Text('Do you want to cancel',style: TextStyle(color: Colors.white,fontSize: Dimensions.height10*1.5),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: (){Navigator.pop(context);},
                            child: Text('No',
                              style: TextStyle(
                                  fontSize: Dimensions.height10*1.5,
                                  color: Colors.white54),
                            )
                        ),
                        TextButton(
                            onPressed: () async {
                              setState((){canceling=true;});
                              int orderCount =0;
                              DatabaseReference database =
                              FirebaseDatabase.instance.ref();
                              FirebaseAuth login = FirebaseAuth.instance;
                             
                              
                              await database.child('Orders').child('Canceled').child(ordersList[i]).update(
                                  {
                                    'account':'${ordersDataMap['${ordersList[i]}']['account']}',
                                    'name':'${ordersDataMap['${ordersList[i]}']['name']}',
                                    'PhoneNumber1':'${ordersDataMap['${ordersList[i]}']['PhoneNumber1']}',
                                    'PhoneNumber2':'${ordersDataMap['${ordersList[i]}']['PhoneNumber2']}',
                                    'Area':'${ordersDataMap['${ordersList[i]}']['Area']}',
                                    'location':'${ordersDataMap['${ordersList[i]}']['location']}',
                                    'billAmount':'${ordersDataMap['${ordersList[i]}']['billAmount']}',
                                    'deliveryFee':'${ordersDataMap['${ordersList[i]}']['deliveryFee']}',
                                    'totalAmount':'${ordersDataMap['${ordersList[i]}']['totalAmount']}',
                                    'dateAndTime':'${ordersDataMap['${ordersList[i]}']['dateAndTime']}',
                                    "Orders":{
                                      for(int j =0;j<Orders.length;++j)
                                      "order$i":{
                                         'foodName':'${ordersDataMap['${ordersList[i]}']['Orders'][Orders[j]]['foodName']}',
                                      'hotelName':'${ordersDataMap['${ordersList[i]}']['Orders']['${Orders[j]}']['hotelName']}',
                                      'foodWidth':'${ordersDataMap['${ordersList[i]}']['Orders']['${Orders[j]}']['foodWidth']}',
                                      'foodType':'${ordersDataMap['${ordersList[i]}']['Orders']['${Orders[j]}']['foodType']}',
                                      'foodCount':'${ordersDataMap['${ordersList[i]}']['Orders']['${Orders[j]}']['foodCount']}',
                                      'price':'${ordersDataMap['${ordersList[i]}']['Orders']['${Orders[j]}']['price']}'
                                      }
                                    }
                                  });
                                   List arr = login.currentUser!.email!.split("@").toList();
                                await database.child("Users").child(arr[0]).child("myOrders").update({
                                  ordersList[i]:"Canceled"
                                });
                             
                              await database.child('Orders').child('Processing').child(ordersList[i]).set(null);
                              setState((){canceling=false;canceled=true;loaded=true;});
                              this.setState(() {
                                setState((){
                                  processingOrdersList.remove(ordersList[i]);
                                });
                              });
                              await _loadProcessingOrdersData();
                             
                            },
                            child: Text('yes',
                              style: TextStyle(
                                  fontSize: Dimensions.height10*1.5,
                                  color: Colors.red[700]),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          );
        }
    );
  }
}
