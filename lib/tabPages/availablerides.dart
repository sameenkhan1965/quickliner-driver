import 'package:drivers_app/assistants/assistant_methods.dart';
import 'package:drivers_app/infoHandler/app_info.dart';
import 'package:drivers_app/mainScreens/trips_history_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';
import '../mainScreens/new_trip_screen.dart';
import '../models/user_ride_request_information.dart';


class AvailableRidesTabPage extends StatefulWidget {
  const AvailableRidesTabPage({Key? key}) : super(key: key);

  @override
  _EarningsTabPageState createState() => _EarningsTabPageState();
}



class _EarningsTabPageState extends State<AvailableRidesTabPage> {

  final dbRef =  FirebaseDatabase.instance.ref().child("All Ride Requests").orderByChild("driverId").equalTo(onlineDriverData?.id);
  List lists = [];

  // final dbRef = FirebaseDatabase.instance.ref().child("All Ride Requests");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade300,
      appBar: AppBar(
        title: Text("Available Rides",style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
          stream: dbRef.onValue,
          builder: (context,snapshot) {
          if (snapshot.hasData &&
          snapshot.data != null &&
          (snapshot.data! as DatabaseEvent).snapshot.value !=
          null) {
            final myMessages = Map<dynamic, dynamic>.from(
                (snapshot.data! as DatabaseEvent).snapshot.value
                as Map<dynamic, dynamic>); //typecasting
            lists=[];
            myMessages.forEach((key, value) {
              final currentMessage = Map<String, dynamic>.from(value);
              lists.add([key,currentMessage]);
            });
          }
          return lists.length>0?ListView.builder(
            itemCount: lists.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              var l=lists[index][1];
              double originLat = double.parse(l["origin"]["latitude"]);
              double originLng = double.parse(l["origin"]["longitude"]);
              String originAddress = l["originAddress"];

              double destinationLat = double.parse(l["destination"]["latitude"]);
              double destinationLng = double.parse(l["destination"]["longitude"]);
              String destinationAddress = l["destinationAddress"];

              String userName = l["userName"];
              String userPhone = l["userPhone"];
              String noOfSeats = l["noOfSeats"];
              String scheduleDate = "";
              String scheduleTime = "";

              String stratDate = "";
              String endDate = "";
              String startTimeO = "";
              String startTimeD = "";
              if(l['rideType']=="scheduleRide"){
                scheduleDate = l["scheduleDate"];
                scheduleTime = l["scheduleTime"];
              }
              else if(l['rideType']=="permanentRide"){
                stratDate = l['startDate'];
                endDate = l['endDate'];
                startTimeO = l['pickupOriginTime'];
                startTimeD = l['pickupDestinationTime'];
              }
              // String scheduleDate = l["scheduleDate"];
              // String scheduleTime = l["scheduleTime"];

              // scheduleDate
              // scheduleTime
              // print("key====>> ${lists[index][0]}");
              String? rideRequestId =lists[index][0];

              UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();

              userRideRequestDetails.originLatLng = LatLng(originLat, originLng);
              userRideRequestDetails.originAddress = originAddress;

              userRideRequestDetails.destinationLatLng = LatLng(destinationLat, destinationLng);
              userRideRequestDetails.destinationAddress = destinationAddress;

              userRideRequestDetails.userName = userName;
              userRideRequestDetails.userPhone = userPhone;

              userRideRequestDetails.rideRequestId = rideRequestId;
              userRideRequestDetails.noOfSeats = noOfSeats;

              userRideRequestDetails.scheduleTime = scheduleTime;
              userRideRequestDetails.scheduleDate = scheduleDate;


              userRideRequestDetails.startDate = stratDate;
              userRideRequestDetails.endDate = endDate;
              userRideRequestDetails.startTimeO = startTimeO;
              userRideRequestDetails.startTimeD = startTimeD;
              userRideRequestDetails.rideType=l['rideType'];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0,right: 0,bottom: 8),
                  child:       Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 30,
                        decoration:const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                          )
                        ),
                         child:  Center(
                          child: Text("${l['rideType']}",style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15
                          ),),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            CircleAvatar(
                              radius:20,
                              foregroundImage:Image.asset(
                                "images/car_logo.png",
                                fit: BoxFit.fill,
                              ).image ,
                            ),

                            Column(
                              children: [
                                Text("${l['userName']}",style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                                ),)
                              ],
                            ),
                            // Image.asset(
                            //   "images/car_logo.png",
                            //   width: 100,
                            // ),


                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text("${l['distance']}",style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12
                                ),),
                                Text("${l['duration']}",style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12
                                ),),
                                Text("${l['fareAmount']}",style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12
                                ),)
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      /// Fromm
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Column(
                            children: [
                                Container(
                                  width: 50,
                                  child: Text("From:",style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                              ),),
                                )
                            ],
                          ),
                          Container(
                            width: 220,
                            child:  Text(
                              "${l['originAddress']}",
                              style:  TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      /// to
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 50,
                                child: Text("To:",style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                                ),),
                              )
                            ],
                          ),
                          Container(
                            width: 220,
                            child:  Text(
                              "${l['destinationAddress']}",
                              style:  TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      /// datae and calender shown here
                      l['rideType']=="scheduleRide"? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_month,color: Colors.black,size: 20,),
                              SizedBox(width: 5,),
                              Text("${ l['scheduleDate']}")
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.timelapse,color: Colors.black,size: 20,),
                              SizedBox(width: 5,),
                              Text("Start Time: ${l['scheduleTime']}")
                            ],
                          ),

                        ],
                      ):l['rideType']=="permanentRide"?
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month,color: Colors.black,size: 20,),
                                  SizedBox(width: 5,),
                                  Text("${l['startDate']}")
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.timelapse,color: Colors.black,size: 20,),
                                  SizedBox(width: 5,),
                                  Text("${l['endDate']}")
                                ],
                              ),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month,color: Colors.black,size: 20,),
                                  SizedBox(width: 5,),
                                  Text("Start Origin Time: ${l['pickupOriginTime']}")
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.timelapse,color: Colors.black,size: 20,),
                                  SizedBox(width: 5,),
                                  Text("Start Destination Time: ${l['pickupDestinationTime']}")
                                ],
                              ),

                            ],
                          ),
                        ],
                      ):SizedBox(),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// cancell buttonis her
                          InkWell(
                            onTap: (){
                              FirebaseDatabase.instance.ref()
                                  .child("All Ride Requests")
                                  .child(rideRequestId!)
                                  .remove().then((value)
                              {
                                FirebaseDatabase.instance.ref()
                                    .child("drivers")
                                    .child(currentFirebaseUser!.uid)
                                    .child("newRideStatus")
                                    .set("idle");
                              }).then((value)
                              {
                                FirebaseDatabase.instance.ref()
                                    .child("drivers")
                                    .child(currentFirebaseUser!.uid)
                                    .child("tripsHistory")
                                    .child(rideRequestId!)
                                    .remove();
                              }).then((value)
                              {
                                Fluttertoast.showToast(msg: "Ride Request has been Cancelled, Successfully. Restart App Now.");
                              });

                              // Future.delayed(const Duration(milliseconds: 3000), ()
                              // {
                              //   SystemNavigator.pop();
                              // });
                            },
                            child: Container(
                              // width: 100,
                              padding: EdgeInsets.only(left:50,right: 50,top: 10,bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:Border.all(
                                    color: Colors.red,
                                    width: 0.8
                                ),
                              ),
                              child:const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),

                              ),
                            ),
                          ),
                          /// accept button is here
                          InkWell(
                            onTap: (){
                              if(l['rideType']=="scheduleRide"){
                                DateTime dt = DateFormat("yyyy-MM-dd hh:mm a").parse('${l['scheduleDate']} ${l['scheduleTime']}');
                                var cur = DateTime.now();
                                if(dt.microsecondsSinceEpoch>cur.microsecondsSinceEpoch){
                                  Fluttertoast.showToast(msg: "Time is not started yet");
                                }
                                else{
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=> NewTripScreen(
                                    userRideRequestDetails: userRideRequestDetails,
                                  )));
                                }
                              }
                            },
                            child: Container(
                              // width: 100,
                              padding: EdgeInsets.only(left:50,right: 50,top: 10,bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                                border:Border.all(
                                    color: Colors.green,
                                    width: 0.8
                                ),
                              ),
                              child:const Text(
                                "Start",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),

                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 10,),
                    ],
                  )
                ),
              );
            },):Center(child: Text("No Rides available"),);
        }
      ),
    );
  }
}
