import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInformation
{
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  String? originAddress;
  String? destinationAddress;
  String? rideRequestId;
  String? userName;
  String? userPhone;
  String? noOfSeats;
  String? rideType;

  var scheduleTime;
  var scheduleDate;
  var startDate;
  var endDate;
  var startTimeO;
  var startTimeD;

  UserRideRequestInformation({
    this.originLatLng,
    this.destinationLatLng,
    this.originAddress,
    this.destinationAddress,
    this.rideRequestId,
    this.userName,
    this.userPhone,
    this.rideType,
    this.scheduleTime,
    this.scheduleDate,
    this.startDate,
    this.endDate,
    this.startTimeD,
    this.startTimeO

  });
//we cannot access the data without the model class i.e. outside the if condition we cannot access them
}