import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Color primaryGreen = Color(0xff416d6d);
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey, blurRadius: 30, offset: Offset(0, 10))
];

List<Map> categories = [
  {'name': ' Solo\n Ride', 'iconPath': 'images/solo.png'},
  {'name': '     Generate\n     Request', 'iconPath': 'images/instant.png'},
  {'name': '     Permanent\n         Ride', 'iconPath': 'images/longterm.png'},
  {'name': '       View\n  Broadcasts', 'iconPath': 'images/broadcast.png'},
  {'name': '    Schedule\n        Ride', 'iconPath':  'images/schedule.png'}
];

List<Map> drawerItems=[
  {
     'icon': Icons.route_outlined,
    'title' : 'Trips',
  },
  {
    'icon': Icons.wallet,
    'title' : 'Wallet'
  },
  {
    'icon': Icons.swap_horizontal_circle,
    'title' : 'Switch Mode'
  },
  {
    'icon': Icons.handshake,
    'title' : 'Contract'
  },
  {
    'icon': Icons.chat,
    'title' : 'Chat'
  },
  {
    'icon': FontAwesomeIcons.userLarge,
    'title' : 'Profile',

  },
];