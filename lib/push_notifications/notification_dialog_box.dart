import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers_app/assistants/assistant_methods.dart';
import 'package:drivers_app/global/global.dart';
import 'package:drivers_app/mainScreens/new_trip_screen.dart';
import 'package:drivers_app/models/user_ride_request_information.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


class NotificationDialogBox extends StatefulWidget
{
  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}




class _NotificationDialogBoxState extends State<NotificationDialogBox>
{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  initilize() async {
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    initilize();
    // the initialization settings are initialized after they are setted

  }


  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[800],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 14,),

            Image.asset(
              "images/car_logo.png",
              width: 160,
            ),

            const SizedBox(height: 10,),

            //title
            const Text(
              "New Ride Request",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.grey
              ),
            ),

            const SizedBox(height: 14.0),

            const Divider(
              height: 3,
              thickness: 3,
            ),

            //addresses origin destination
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //origin location with icon
                  Row(
                    children: [
                      Image.asset(
                        "images/origin.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 14,),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),

                  //destination location with icon
                  Row(
                    children: [
                      Image.asset(
                        "images/destination.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 14,),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  //destination location with icon
                  Row(
                    children: [
                      Icon(Icons.event_seat_sharp,color: Colors.white,size: 26,),
                      const SizedBox(width: 14,),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails!.noOfSeats!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            const Divider(
              height: 3,
              thickness: 3,
            ),

            //buttons cancel accept
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: ()
                    {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();

                      //cancel the rideRequest
                      FirebaseDatabase.instance.ref()
                          .child("All Ride Requests")
                          .child(widget.userRideRequestDetails!.rideRequestId!)
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
                            .child(widget.userRideRequestDetails!.rideRequestId!)
                            .remove();
                      }).then((value)
                      {
                        Fluttertoast.showToast(msg: "Ride Request has been Cancelled, Successfully. Restart App Now.");
                      });

                      Future.delayed(const Duration(milliseconds: 3000), ()
                      {
                        SystemNavigator.pop();
                      });
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                  const SizedBox(width: 25.0),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: ()
                    {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();

                      //accept the rideRequest
                      acceptRideRequest(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  saveAssignedDriverDetailsToUserRideRequest()
  {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .child(widget.userRideRequestDetails!.rideRequestId!);

    Map driverLocationDataMap =
    {
      "latitude": driverCurrentPosition!.latitude.toString(),
      "longitude": driverCurrentPosition!.longitude.toString(),
    };
    databaseReference.child("driverLocation").set(driverLocationDataMap);

    databaseReference.child("status").set("accepted");
    databaseReference.child("driverId").set(onlineDriverData.id);
    databaseReference.child("driverName").set(onlineDriverData.name);
    databaseReference.child("driverPhone").set(onlineDriverData.phone);
    databaseReference.child("car_details").set(onlineDriverData.carColor.toString() + " " + onlineDriverData.carModel.toString() + onlineDriverData.carNumber.toString());

    // saveRideRequestIdToDriverHistory();
  }
  acceptRideRequest(BuildContext context)
  {
    String getRideRequestId="";
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        getRideRequestId = snap.snapshot.value.toString();
      }
      else
      {
        Fluttertoast.showToast(msg: "This ride request do not exists.");
      }
      print("type in UIIII--->>>> ${widget.userRideRequestDetails?.rideType}");
      if(getRideRequestId == widget.userRideRequestDetails!.rideRequestId)
      {
        FirebaseDatabase.instance.ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("newRideStatus")
            .set("accepted");
        // widget.userRideRequestDetails.
        AssistantMethods.pauseLiveLocationUpdates();
        // print("type in UIIII--->>>> ${widget.userRideRequestDetails?.rideType}");
      if(widget.userRideRequestDetails?.rideType=="permanentRide"){
        DateTime dt = DateFormat("yyyy-MM-dd").parse('${widget.userRideRequestDetails?.startDate}');
        DateTime dt2 = DateFormat("yyyy-MM-dd").parse('${widget.userRideRequestDetails?.endDate}');
        List<DateTime> days = [];
        for (int i = 0; i <= dt2.difference(dt).inDays; i++) {
          var day = dt.add(Duration(days: i));
          var d__ = DateFormat("yyyy-MM-dd").format(day).toString();
          DateTime dt_notify = DateFormat("yyyy-MM-dd hh:mm a").parse('${d__} ${widget.userRideRequestDetails?.startTimeO}');
          DateTime dt2_notify = dt.subtract(Duration(minutes: 5));

          DateTime dt_notify2 = DateFormat("yyyy-MM-dd hh:mm a").parse('${d__} ${widget.userRideRequestDetails?.startTimeD}');
          DateTime dt2_notify2 = dt.subtract(Duration(minutes: 5));
          flutterLocalNotificationsPlugin.schedule(1, "Permanent Ride is about to start", "The ride with ${widget.userRideRequestDetails?.userName} is starting in 5 minutes", dt2_notify,  const NotificationDetails(

            // Android details
            android: AndroidNotificationDetails('main_channel', 'Main Channel',
                channelDescription: "quickliner",
                importance: Importance.max,
                priority: Priority.max),

          ),
          );
          flutterLocalNotificationsPlugin.schedule(1, "Permanent Ride is about to start", "The ride with ${widget.userRideRequestDetails?.userName} is starting in 5 minutes", dt2_notify2,  const NotificationDetails(

            // Android details
            android: AndroidNotificationDetails('main_channel', 'Main Channel',
                channelDescription: "quickliner",
                importance: Importance.max,
                priority: Priority.max),

          ),
          );
          saveAssignedDriverDetailsToUserRideRequest();
        }


      }
      else if(widget.userRideRequestDetails?.rideType=="scheduleRide"){
          DateTime dt = DateFormat("yyyy-MM-dd hh:mm a").parse('${widget.userRideRequestDetails?.scheduleDate} ${widget.userRideRequestDetails?.scheduleTime}');
          DateTime dt2 = dt.subtract(Duration(minutes: 5));
          flutterLocalNotificationsPlugin.schedule(1, "Schedule Ride is about to start", "The ride with ${widget.userRideRequestDetails?.userName} is starting in 5 minutes", dt2,  const NotificationDetails(

            // Android details
            android: AndroidNotificationDetails('main_channel', 'Main Channel',
                channelDescription: "quickliner",
                importance: Importance.max,
                priority: Priority.max),

          ),
          );
          saveAssignedDriverDetailsToUserRideRequest();
        }

        else{
          Navigator.push(context, MaterialPageRoute(builder: (c)=> NewTripScreen(
            userRideRequestDetails: widget.userRideRequestDetails,
          )));
        }
        Navigator.pop(context);
        // Future.delayed(const Duration(milliseconds: 3000), ()
        // {
        //   SystemNavigator.pop();
        // });
        //trip started now - send driver to new tripScreen
        // Navigator.push(context, MaterialPageRoute(builder: (c)=> NewTripScreen(
        //   userRideRequestDetails: widget.userRideRequestDetails,
        // )));
      }
      else
      {
        // DateTime dt = DateFormat("yyyy-MM-dd").parse('${widget.userRideRequestDetails?.startDate}');
        // DateTime dt2 = DateFormat("yyyy-MM-dd").parse('${widget.userRideRequestDetails?.endDate}');
        // print("dt ${dt} ${dt2}");
        // var d__ = DateFormat("yyyy-MM-dd").format(dt).toString();
        // print("next ${d__}");
        // DateTime dt_notify = DateFormat("yyyy-MM-dd hh:mm a").parse('${d__} ${widget.userRideRequestDetails?.startTimeO}');
        // print("third--->> ${dt_notify}");
        Fluttertoast.showToast(msg: "This Ride Request do not exists.");
      }
    });
  }
}
