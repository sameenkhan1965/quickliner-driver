import 'dart:async';

import 'package:drivers_app/authentication/login_screen.dart';
import 'package:drivers_app/global/global.dart';
import 'package:drivers_app/mainScreens/main_screen.dart';
import 'package:drivers_app/splashScreen/splash_screen2.dart';
import 'package:flutter/material.dart';
import 'package:drivers_app/configuraton/configuration.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class MySplashScreen extends StatefulWidget
{
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}



class _MySplashScreenState extends State<MySplashScreen>
{
  startTimer()
  {
    Timer(const Duration(seconds: 7), () async
    {
      if(await fAuth.currentUser != null)
      {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
      }
      else
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen2()));
      }
    });
  }

  //used whenever you navigate or yh sb se phle execute ho ga jb bhi is oage py aye gay
  //or is mn jo bhi ho ga wowh sb se phle execute ho ga
  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context)
  {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("QuickLiner",style: TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ), ),
              SizedBox(height: 260,width:260,
                child:  Image.asset("images/time.png"),
              ),
              const DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Color(0xFF121212),
                    fontFamily: "myFont1",
                  ),
                  child:  Text(
                      "Make your lives easy"
                  )
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: const DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 14.0,
                      //fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Color(0xFF121212),
                      fontFamily: "myFont2",
                    ),
                    textAlign: TextAlign.center,
                    child: Text(
                        "Book rides based on your availability and choice."
                            "  Schedule a ride or book a permanent ride anywhere anytime "
                    )

                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                },
                child: Container(
                  height: 120,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      //  Expanded(
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            height:50,
                            width: 260,
                            decoration: BoxDecoration(color:primaryGreen,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: shadowList,
                            ),
                            margin: EdgeInsets.only(top: 0, left: 55),
                            child: Text(
                              " Skip",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                  ),
                ),
              )
            ],
          ),


        ),
        ),

    );
  }
}
