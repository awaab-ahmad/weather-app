import 'package:flutter/material.dart';

PageRouteBuilder navigator(Widget toPage) {
  return PageRouteBuilder(
    reverseTransitionDuration: Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = Offset(1.0, 0);
      final end = Offset(0, 0);
      return SlideTransition(
        position: animation.drive(Tween(begin: begin, end: end)),
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) => toPage,
  );
}

Container container(double w, double h) {
  return Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xFFFFFFFF),
    ),
  );
}

// Making the Global Card Radius
RoundedRectangleBorder cardRadius = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(20),
);

Future bottomSheet(BuildContext context, Widget child) {
  return showModalBottomSheet(
    barrierColor: const Color(0x66000000),
    context: context,
    useSafeArea: true,
    backgroundColor: const Color(0x00000000),
    isScrollControlled: true,
    builder: (context) {
      return child;
    },
  );
}

// // Making the Random List with the Size of 5 to check the elements
// // List randomCheckHourlyForecast = ['15:00', '16:00', '17:00', '18:00', '19:00'];

// // Making the list of the Random Days
// List randomDailyForecast = [
//   'Monday',
//   'Tuesday',
//   'Wednesday',
//   'Thursday',
//   'Friday',
//   'Saturday',
//   'Sunday',
//   'Monday',
// ];

// // Making the Function that will give me the time
// // List<dynamic> names = ['Lahore', 'Islamabad', 'Depalpur', 'Naran', 'Murree'];

// List<dynamic> suggested = [
//   'Lahore, Pakistan',
//   'Islamabad, Pakistan',
//   'Rawalpindi, Pakistan',
//   'Murree, Pakistan',
//   'Karachi, Pakistan',
//   'Gujranwala, Pakistan',
//   'Faisalabad, Pakistan',
//   'Jeddah, Saudi Arab',
//   'Tokyo, Japan',
//   'Amsterdam, Netherlands',
//   'Hong Kong, China ',
//   'Dubai, UAE',
//   'Abu Dhabi, UAE',
//   'Mumbai, India',
//   'Delhi, India',
//   'Istanbul, Turkey',
// ];

// // // List<dynamic> weather = ['Clear', 'Cloud', 'Rain', 'Storm', 'Snow'];
// // List<Color> colors = [
// //   Color(0xFFFFBF00),
// //   Color(0xFF9AA5B1),
// //   Color(0xFF4A6FA5),
// //   Color(0xFF474878),
// //   Color(0xFF4FA2FF),
// // ];
