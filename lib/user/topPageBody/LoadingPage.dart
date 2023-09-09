import 'package:flutter/material.dart';
import 'package:fastfood/user/dimensions/dimensions.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.height10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.height70*0.6,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Dimensions.height70*1.4,
                      width: Dimensions.screenWidth!*0.7,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(Dimensions.height10)
                      ),
                    ),
                    SizedBox(width: Dimensions.height10,),
                    Container(
                      height: Dimensions.height70*1.4,
                      width: Dimensions.screenWidth!*0.7,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(Dimensions.height10)
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height70*0.4,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: Dimensions.height10*1.5,
                    width: Dimensions.width120*2,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(Dimensions.height10)
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height70*0.4,),
              SingleChildScrollView(
                scrollDirection:  Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: Dimensions.height70,
                      width: Dimensions.width120*2,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(Dimensions.height10)
                      ),
                    ),
                    SizedBox(width: Dimensions.height10,),
                    Container(
                      height: Dimensions.height70,
                      width: Dimensions.width120*2,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(Dimensions.height10)
                      ),
                    ),
                    SizedBox(width: Dimensions.height10,),
                    Container(
                      height: Dimensions.height70,
                      width: Dimensions.width120*2,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(Dimensions.height10)
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height70*0.4,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: Dimensions.height10*1.5,
                    width: Dimensions.width120*2,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(Dimensions.height10)
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height70*0.4,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Dimensions.height70*2.2,
                    width: Dimensions.screenWidth!*0.85,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(Dimensions.height10)
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Dimensions.height70*2.2,
                    width: Dimensions.screenWidth!*0.85,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(Dimensions.height10)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
