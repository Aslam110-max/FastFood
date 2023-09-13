
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../colors.dart';
import '../../dimensions/dimensions.dart';
import '../../order/order.dart';
import 'cartDetails.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}
class ImageReturn{
  late final NetworkImage images;
  ImageReturn({required this.images});
  NetworkImage Rimage(){return images;}
}
class _CartState extends State<Cart> {
  late final Map deliveryPercentage;

  
  List<Map<String,dynamic>> _orders =[];
  double _total=0;
  double _deliveryFee=0;
  bool _isLoading = true;
  bool _noLocation=false;
  bool _noDeliveryPercentage = true;
  List locations =[];
  Future<void> _loadLocations()async{
    Map locationMap={};
    DatabaseReference data = FirebaseDatabase.instance.ref();
    await data.child("Loactions").once().then((value){
      locationMap = value.snapshot.value as Map;
      locations = locationMap.keys.toList();
    });
   
  }
  Future<void> sendPushNotification(String tocken, String title,String body) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
            'key =AAAAPenv4LI:APA91bGL1CBHHemT7ng4U976UqatzRtnyB-SWAUXkguoaeOP79FTFWe-JzzFZ7s_gN0VZog7OihHYomukJbN03oNtd-fyJ5bJ3X2iHvY7DBk4PN4JKj5HuZoeESpdvi53XIVjxgngHgw'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': '$body',
              'title': '$title',
            },
            "notification": <String, dynamic>{
              "title": "$title",
              "body": "$body",
              "android_channel_id": "Fast Food"
            },
            "to": tocken
          }));
      print('done && $tocken');
    } catch (e) {
      print('Error is $e');
    }
  }

  Future<void> _updateTotal()async{
    setState(() {
      _deliveryFee =0;
      _total =0;
    });
    for(int i=0;i<_orders.length;++i)
    {
      setState(() {
        _total = _total+(_orders[i]['price']*_orders[i]['foodCount']);
      });
    }
  }
  Future<void> _refreshOrders()async{
    await _loadLocations();
    final data = await OrderHelper.getItems();
    setState(() {
      _orders = data;
      _isLoading =false;
    });
    _updateTotal();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _refreshOrders();
  }
  String? location;
TextEditingController _locationTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _phoneNo1TextController = TextEditingController();
  TextEditingController _phoneNo2TextController = TextEditingController();
  Future<void> _updateItem(int id,String foodName,String hotelName,String foodWidth,double price,int foodCount,String foodType,String imageUrl)async{
    await OrderHelper.updateItem(id, foodName, hotelName, foodWidth, price, foodCount,foodType,imageUrl);
    _refreshOrders();
  }
  Future<void> _deleteItem(int id)async{
    await OrderHelper.deleteItem(id);
    _refreshOrders();

  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Order()));}, icon: Icon(Icons.emoji_food_beverage_outlined,color: Colors.black,))
        ],
      ),
      body: _isLoading? Center(child: CircularProgressIndicator(color: ColorClass.mainColor,),):
      _orders.length != 0
          ?
      Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child:
                Expanded(
                  child: ListView.builder(
                  itemCount:_orders.length,
                  itemBuilder: (context,i){
                    final imageReturn = new ImageReturn(images: NetworkImage(_orders[i]['imageUrl']));
                    return Padding(
                      padding: EdgeInsets.only(right: Dimensions.height10,left: Dimensions.height10,bottom: Dimensions.height10),
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black45,offset: Offset(0,3),blurRadius: 5)],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        height: Dimensions.height120,
                        width: Dimensions.screenWidth,
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(Dimensions.height10/2),
                              child: Row(
                                children: [
                                  Container(
                                    height: Dimensions.height120,
                                    width: Dimensions.width120*1.8,
                                    decoration: BoxDecoration(
                                        color: Colors.black26,
                                        image: DecorationImage(image: imageReturn.Rimage(),fit: BoxFit.fill),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width120*0.1,),
                                  Container(
                                    width: Dimensions.width120*2,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text('${_orders[i]['foodName']}',style: TextStyle(fontSize: Dimensions.height10*1.3),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                          ],
                                        ),
                                        Text('${_orders[i]['hotelName']}',style: TextStyle(fontSize: Dimensions.height10*0.9,color: Colors.black45),),
                                        Text('${_orders[i]['foodWidth']}',style: TextStyle(fontSize: Dimensions.height10*0.9,color: Colors.black45),),
                                        Text('${_orders[i]['foodType']}',style: TextStyle(fontSize: Dimensions.height10*0.9,color: Colors.black45),),
                                        SizedBox(height: Dimensions.height10*1.5,),
                                        Text('Rs.${_orders[i]['price']*_orders[i]['foodCount']}',style: TextStyle(fontSize: Dimensions.height10*1.3,fontWeight: FontWeight.bold),),
                                      ],
                                    ),),
                                  Container(
                                    height: Dimensions.height70*1.25,
                                    width: Dimensions.width120*0.5,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: ColorClass.mainColor),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(Dimensions.height10/2)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(onPressed: (){
                                          _updateItem(_orders[i]['id'], '${_orders[i]['foodName']}', '${_orders[i]['hotelName']}', '${_orders[i]['foodWidth']}', _orders[i]['price'], _orders[i]['foodCount']+1,_orders[i]['foodType'],_orders[i]['imageUrl']);
                                        },
                                          icon: Icon(Icons.add),
                                          padding: EdgeInsets.zero,
                                          iconSize: Dimensions.height10*1.2,
                                          color: ColorClass.mainColor,),
                                        Text('${_orders[i]['foodCount']}',style: TextStyle(color: Colors.black,fontSize: Dimensions.height10),),
                                        IconButton(onPressed: (){
                                          if(_orders[i]['foodCount']>0){
                                            _updateItem(_orders[i]['id'], '${_orders[i]['foodName']}', '${_orders[i]['hotelName']}', '${_orders[i]['foodWidth']}', _orders[i]['price'], _orders[i]['foodCount']-1,_orders[i]['foodType'],_orders[i]['imageUrl']);
                                          }
                                          if(_orders[i]['foodCount']==1) _deleteItem(_orders[i]['id']);
                                        },
                                          icon: Icon(Icons.remove),
                                          iconSize: Dimensions.height10*1.2,
                                          color: ColorClass.mainColor,)
                                      ],),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );}
              ),
                ),
              ),
              Container(
                height: Dimensions.height120*1.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0,-3),
                      blurRadius: 5
                    )
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.height10*1.5),
                      topRight: Radius.circular(Dimensions.height10*1.5)
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.only(top:Dimensions.height10,bottom: Dimensions.height10,right: Dimensions.height10*2,left: Dimensions.height10*2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: Dimensions.height10*1.2),),
                            Text('$_total',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: Dimensions.height10*1.2),),
                          ],
                        ),
                      ],),
                      GestureDetector(
                        child: Container(
                          height: Dimensions.height70*0.55,
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorClass.mainColor),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white
                          ),
                          child: Center(
                            child: Text('Continue',style: TextStyle(color: ColorClass.mainColor,fontSize: Dimensions.height10*1.3,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        onTap: (){
                          DialogBox(context, _total);
                          setState(() {
                            location =null;
                            _deliveryFee =0;
                          });
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          )
          :
          Center(
            child: Image.asset('image/empty_cart.png',height: Dimensions.height70*2,)
          )
    );
  }
  DialogBox(BuildContext context,double _total) {
    bool loading =false;
    bool ordered= false;
    showDialog(
        context: context,
        builder:(context){
          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              content: Column(
                children: [
                  Form(
                    key:_formKey ,
                    child: Container(
                      height: Dimensions.height210*2.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.height10),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(right: Dimensions.height10,left: Dimensions.height10),
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.height10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Personal Details:',style: TextStyle(fontSize: Dimensions.height10*1.2,fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                Padding(
                                  padding:EdgeInsets.only(top: Dimensions.height10/2),
                                  child: TextFormField(
                                    validator: (val){
                                      if(val!.isEmpty) return "Name can't be empty";
                                    },
                                    controller: _nameTextController,
                                    cursorColor: Colors.black38,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        label: Text('Name',style: TextStyle(color: Colors.black38),),
                                        enabledBorder:OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black38),
                                          borderRadius: BorderRadius.circular(Dimensions.height10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Dimensions.height10),
                                            borderSide: BorderSide(color: Colors.black38)
                                        )
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:EdgeInsets.only(top: Dimensions.height10/2),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (val){
                                      if(val!.isEmpty) return "Please enter a phone number";
                                      if(val.length<9||val.length>10)return"Enter valid phone number";
                                    },
                                    controller: _phoneNo1TextController,
                                    cursorColor: Colors.black38,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        label: Text('Phone Number1',style: TextStyle(color: Colors.black38),),
                                        enabledBorder:OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black38),
                                          borderRadius: BorderRadius.circular(Dimensions.height10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Dimensions.height10),
                                            borderSide: BorderSide(color: Colors.black38)
                                        )
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:EdgeInsets.only(top: Dimensions.height10/2,bottom: Dimensions.height10/2),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (val){
                                      if(val!.isEmpty) return "Please enter a phone number";
                                      if(val.length<9||val.length>10)return"Enter valid phone number";
                                    },
                                    controller: _phoneNo2TextController,
                                    cursorColor: Colors.black38,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        label: Text('Phone Number2',style: TextStyle(color: Colors.black38),),
                                        enabledBorder:OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black38),
                                          borderRadius: BorderRadius.circular(Dimensions.height10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Dimensions.height10),
                                            borderSide: BorderSide(color: Colors.black38)
                                        )
                                    ),
                                  ),
                                ),
                                Center(
                                child: DropdownButton<String>(
                                  hint: Text("Select Your Location"),
                                                    value: location,
                                                    items: locations.map((loc) {
                                                      return DropdownMenuItem<String>(
                                                        onTap: (){
                                                          this.setState(() {
                                                            setState((){
                                                              location = loc;
                                                            });
                                                          });
                                                        },
                                                        
                                                        
                                                        value: loc,
                                                        child: Text(loc,
                                                          style: TextStyle(color: Colors.black,fontSize: Dimensions.height10),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? location) {
                                                      setState(() {
                                                          location = location!;
                                                          
                                                         
                                                      });
                                                    }),
                              ),

                                Row(
                                  children: [
                                    Text('Address:',style: TextStyle(fontSize: Dimensions.height10*1.2,fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                                                Padding(
                                  padding:EdgeInsets.only(bottom: Dimensions.height10),
                                  child: TextFormField(
                                    validator: (val){
                                      if(val!.isEmpty) return "Mention your location";
                                    },
                                    controller: _locationTextController,
                                    cursorColor: Colors.black38,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                        label: Text('Mention Your Location',style: TextStyle(color: Colors.black38),),
                                        enabledBorder:OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black38),
                                          borderRadius: BorderRadius.circular(Dimensions.height10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Dimensions.height10),
                                            borderSide: BorderSide(color: Colors.black38)
                                        )
                                    ),
                                  ),
                                ),
                               
                               
                                Padding(
                                  padding: EdgeInsets.only(top: Dimensions.height10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Amount',style: TextStyle(color: Colors.black,fontSize: Dimensions.height10*1.2,fontWeight: FontWeight.bold),),
                                      Text('${_total+_deliveryFee}',style: TextStyle(color: Colors.black,fontSize: Dimensions.height10*1.2,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('+Delivery Fee',style: TextStyle(color: Colors.black45,fontSize: Dimensions.height10),),
                                   
                                  ],
                                ),
                                SizedBox(height: Dimensions.height10*0.5,),
                                if(loading&&!ordered)CircularProgressIndicator(color: ColorClass.mainColor,)
                                else if(!loading&&ordered)Icon(Icons.done_outline_rounded,size: Dimensions.height10*3,color: ColorClass.mainColor,)
                                else GestureDetector(
                                  child: Container(
                                    height: Dimensions.height70*0.55,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: ColorClass.mainColor
                                    ),
                                    child: Center(
                                      child: Text('Order Now',style: TextStyle(color: Colors.white,fontSize: Dimensions.height10*1.2,fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  onTap: () async {
                                    if(!_formKey.currentState!.validate()){
                                      if(location==null){
                                        this.setState(() {
                                          setState((){_noLocation=true;});
                                        });
                                      }
                                      return;
                                    }else{
                                      if(location==null){
                                        this.setState(() {
                                          setState((){_noLocation=true;});
                                        });
                                      }
                                      else{
                                        setState((){loading=true;});
                          String dateAndTime=DateFormat('yyyy-MM-dd kk:mm:ss') .format(DateTime.now());
                           String dateAndTimeId = DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()).replaceAll(RegExp('[^A-Za-z0-9]'),'');
                            
                                DatabaseReference database =
                                FirebaseDatabase.instance.ref();
                                FirebaseAuth login = FirebaseAuth.instance;
                                List arr = login.currentUser!.email!.split("@").toList();
                                await database.child("Users").child(arr[0]).child("myOrders").update({
                                  '${login.currentUser!.uid}_+$dateAndTimeId':"Processing"
                                });
                              
                                await database.child('Orders').child('Processing').child('${login.currentUser!.uid}_+$dateAndTimeId').update(
                                    {
                                      'account':arr[0],
                                      'name':_nameTextController.text,
                                      'PhoneNumber1':_phoneNo1TextController.text,
                                      'PhoneNumber2':_phoneNo2TextController.text,
                                      'Area':location,
                                      'location':_locationTextController.text,
                                      'billAmount':_total,
                                      'deliveryFee':_deliveryFee,
                                      'totalAmount':(_total+_deliveryFee),
                                      'state':'NotConfirm',
                                      'dateAndTime':dateAndTime,
                                          "Orders":{
                                             for(int i=0;i<_orders.length;++i)
                                             "order$i":{
                                      'foodName':_orders[i]['foodName'],
                                      'hotelName':_orders[i]['hotelName'],
                                      'foodWidth':_orders[i]['foodWidth'],
                                      'foodType':_orders[i]['foodType'],
                                      'foodCount':_orders[i]['foodCount'],
                                      'price':(_orders[i]['foodCount']*_orders[i]['price'])
                                             }

                                          }
                                    });
                                    await database.child("Admins").once().then((value) async {
                                      if(value.snapshot.value !=null){
                                        Map adminsMap = value.snapshot.value as Map;
                                        List adminList = adminsMap.keys.toList();
                                        for (int i = 0; i < adminList.length; i++) {
                                          await sendPushNotification(adminsMap[adminList[i]]['tocken'], "New order placed!", "Check your order");
                                        }
                                      }
                                    });
                                
                                for(int i=0;i<_orders.length;++i)_deleteItem(_orders[i]['id']);
                                setState((){loading=false;ordered=true;});
                                Future.delayed(Duration(seconds: 2),()=>Navigator.pop(context));

                                      }
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: (){Navigator.pop(context);},
                    icon: Icon(Icons.close_outlined),
                    color: Colors.white,)
                ],
              ),
            );
          }
          );
        }
    );
  }
}
