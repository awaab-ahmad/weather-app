import 'package:flutter/material.dart';

/*
Here would be the list of all the colors that are going to be used
*/
final begin = Alignment.topCenter;
final end = Alignment.bottomCenter;

LinearGradient sunny = LinearGradient(
  begin: begin,
  end: end,
  colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
);

LinearGradient cloudy = LinearGradient(
  begin: begin,
  end: end,
  colors: [Color(0xFF9AA5B1), Color(0xFF00F2FE)],
);

LinearGradient rainy = LinearGradient(
  begin: begin,
  end: end,
  colors: [Color(0xFF4A6FA5), Color(0xFFA7C7E7)],
);

LinearGradient stormy = LinearGradient(
  begin: begin,
  end: end,
  colors: [Color(0xFF474878), Color(0xFF5B6187)],
);

LinearGradient snowy = LinearGradient(
  begin: begin,
  end: end,
  colors: [Color(0xFF4FA2FF), Color(0xFFE5F4FF)],
);

// Making the color of the Card that would be used throughout the application with opacity
Color cardColor = const Color(0x33727272);
Color buttonColor = const Color(0xFF5C64FF);
