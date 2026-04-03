import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Now making the Text for the working
Text text(String s, double sz, FontWeight fw) {
  return Text(
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    s,
    style: GoogleFonts.poppins(
      height: 1.0,
      fontSize: sz,
      fontWeight: fw,
      color: Colors.white,
    ),
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

// making the Style for the Richtext type elements
TextStyle style(double sz, FontWeight fw) {
  return GoogleFonts.poppins(color: Colors.white, fontSize: sz, fontWeight: fw);
}

// Making the Global Card Radius
RoundedRectangleBorder cardRadius = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(20),
);

// Making the Random List with the Size of 5 to check the elements
// List randomCheckHourlyForecast = ['15:00', '16:00', '17:00', '18:00', '19:00'];

// Making the list of the Random Days
List randomDailyForecast = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
  'Monday',
];

// Making the Function that will give me the time
// List<dynamic> names = ['Lahore', 'Islamabad', 'Depalpur', 'Naran', 'Murree'];

List<dynamic> suggested = [
  'Lahore, Pakistan',
  'Islamabad, Pakistan',
  'Rawalpindi, Pakistan',
  'Murree, Pakistan',
  'Karachi, Pakistan',
  'Gujranwala, Pakistan',
  'Faisalabad, Pakistan',
  'Jeddah, Saudi Arab',
  'Tokyo, Japan',
  'Amsterdam, Netherlands',
  'Hong Kong, China ',
  'Dubai, UAE',
  'Abu Dhabi, UAE',
  'Mumbai, India',
  'Delhi, India',
  'Istanbul, Turkey',
];

// List<dynamic> weather = ['Clear', 'Cloud', 'Rain', 'Storm', 'Snow'];
List<Color> colors = [
  Color(0xFFFFBF00),
  Color(0xFF9AA5B1),
  Color(0xFF4A6FA5),
  Color(0xFF474878),
  Color(0xFF4FA2FF),
];
