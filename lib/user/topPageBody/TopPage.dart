import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';


import 'package:flutter/material.dart';
import 'package:fastfood/user/userData.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../colors.dart';
import '../dimensions/dimensions.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}



class ImageReturn{
  late final NetworkImage images;
  ImageReturn({required this.images});
  NetworkImage Rimage(){return images;}
}
class _TopPageState extends State<TopPage> {
  var _currentPageVal = 0;
  double _height = Dimensions.topPageHeight;
  @override
  Widget build(BuildContext context) {
    return 
    Column(
      children: [
        Center(
          child:
          CarouselSlider.builder(
              itemCount: UserData.adImageUrlList.length,
              itemBuilder: (context, index, realIndex) {
                final urlImage = UserData.adImageUrlMap[UserData.adImageUrlList[index]]['Url'];
                ImageReturn imageReturen = new ImageReturn(images: NetworkImage(urlImage as String));
                return _buildImage(imageReturen.Rimage(), index);
              },
              options: CarouselOptions(height: _height,autoPlay: true,enlargeCenterPage: true,enlargeStrategy: CenterPageEnlargeStrategy.height,autoPlayInterval: Duration(seconds: 4),onPageChanged: (index,reason)=>setState(()=>_currentPageVal=index))),
        ),
        SizedBox(height: Dimensions.height10,),
        _buildIndicator()
      ],
    );
  }

  Widget _buildImage(NetworkImage Image, int index) => 
  Stack(
    children: [
      Container(
        child: Center(child: Text('Loading...'),),
        decoration: BoxDecoration(color:Colors.white,boxShadow:[BoxShadow(color: Colors.black38,offset: Offset(0, 5),blurRadius: 5)],borderRadius: BorderRadius.circular(30),),
        height: _height,
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.space15,vertical:Dimensions.space15
        ),
      ),
      Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),image: DecorationImage(image: Image,fit: BoxFit.fill)),
    height: _height,
    margin: EdgeInsets.symmetric(
        horizontal: Dimensions.space15,vertical:Dimensions.space15
    ),
  )],);
  Widget _buildIndicator()=>AnimatedSmoothIndicator(activeIndex: _currentPageVal, count: UserData.adImageUrlList.length,effect: ExpandingDotsEffect(dotHeight: 5,activeDotColor: ColorClass.mainColor),);
}
