import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../dimensions/dimensions.dart';
import '../hotelMenu/hotelMenu.dart';
import '../userData.dart';


class Restaurants extends StatefulWidget {
  const Restaurants({Key? key}) : super(key: key);

  @override
  State<Restaurants> createState() => _RestaurantsState();
}
class ImageReturn{
  late final NetworkImage images;
  ImageReturn({required this.images});
  NetworkImage Rimage(){return images;}
}
bool noFoodItems =false;
class _RestaurantsState extends State<Restaurants> {
  bool loaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadHotelData();
  }
  late var adUrl;

  final Map<String,String> foodItems={' ':' '};
  Map<String,int> foodCount={};
  String hotelState = '';

  Future<void> _loadHotelData() async {
  
    for(int i=0;i<UserData.hotelList.length;++i){
      if (UserData.hotelDataMap['${UserData.hotelList[i]}']['Menu']['Dinner']!=null) {
        setState(() {
          UserData.dinnerMenuDataMap  = UserData.hotelDataMap['${UserData.hotelList[i]}']['Menu']['Dinner'];
          UserData.dinnerMenuList = UserData.dinnerMenuDataMap.keys.toList();
         
         
          foodCount['${UserData.hotelList[i]}'] =UserData.dinnerMenuList.length;
          for(int j=0;j<UserData.dinnerMenuList.length;++j){
            setState(() {
              foodItems['${UserData.hotelList[i]}'+'$j'] = UserData.dinnerMenuDataMap[UserData.dinnerMenuList[j]]['ImageUrl'];
            });}

        });
      } else {
        setState(() {
          noFoodItems = true;

        });
      }

    }
    setState(() {
      loaded=true;
    });
   
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: Dimensions.height10,bottom: Dimensions.height10*3/4),
            child: Text('Restaurants',
              style: TextStyle(
                  fontSize: Dimensions.height10*1.3,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),),
          ),
        ],
      ),
      loaded ?
      Column(
          children: [
            for (int i = 0; i < UserData.hotelDataMap.length; ++i)
              Padding(
                padding: EdgeInsets.only(bottom:Dimensions.height10*3/2),
                child: GestureDetector(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: Dimensions.height210,
                    width: Dimensions.screenWidth!-Dimensions.screenWidth!*0.09,
                    decoration: BoxDecoration(
                      color: Colors.white,
                        boxShadow:[
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(0,5 ),
                              blurRadius: 5)],
                        borderRadius: BorderRadius.circular(
                            Dimensions.height10),
                       ),
                    child: Stack(
                      children: [
                      CarouselSlider.builder(
                          itemCount: foodCount['${UserData.hotelList[i]}'],
                          itemBuilder: (context, index, realIndex) {
                            final urlImage = foodItems['${UserData.hotelList[i]}'+'$index'];
                            final imageReturn = new ImageReturn(images: NetworkImage(urlImage as String));
                            return _buildImage(imageReturn.Rimage());
                          },
                          options: CarouselOptions(
                            height: Dimensions.height210,
                            autoPlay: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            viewportFraction: 1,
                            autoPlayInterval: Duration(seconds: 8),)),
                      Column(
                        mainAxisAlignment:MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft:Radius.circular(
                                        Dimensions.height10),
                                    bottomRight:Radius.circular(Dimensions.height10)),
                                color: Colors.white),
                            height: Dimensions.height10*4,width: Dimensions.screenWidth!-Dimensions.screenWidth!*0.09,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: Dimensions.height10*1.3,top: Dimensions.height10*0.8),
                                      child: Text(
                                        UserData.hotelList[i] as String,
                                        style:  TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimensions.height10*1.3),
                                      ),
                                    ),

                    UserData.hotelDataMap[UserData
                        .hotelList[i]]
                    ['HotelState'] ==
                        'Open'?Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text('Open',style: TextStyle(color: Colors.green),),
                        ):Padding(
                          padding: EdgeInsets.only(right: Dimensions.height10*1.6),
                          child: Text('Closed',style: TextStyle(color: ColorClass.mainColor),),
                        )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: Dimensions.height10*1.2),
                                  child: Text( UserData.hotelDataMap[UserData
                                                        .hotelList[i]]
                                                    ['location'],style: TextStyle(color: Colors.black38,fontSize: Dimensions.height10),),
                                )                              ],
                            ),)],)],),
                  ),
                  onTap: (){
                    setState(() {
                    UserData.index =i;
                  });
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> HotelMenuNew()));
                    },
                ),
              )
          ]):
    Center(
    child: CircularProgressIndicator(
    color: ColorClass.mainColor,
    ),
    )
    ],);

  }
  Widget _buildImage(NetworkImage Image) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(image: DecorationImage(image: Image,fit: BoxFit.fill)),
  height: Dimensions.height210,
  width: Dimensions.screenWidth!-Dimensions.screenWidth!*0.09,

      )],);
  
}
