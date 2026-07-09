// This is the file in which the very first screen would appear

import 'package:flutter/material.dart';
import 'package:weather/services/geolocator_location.dart';
import 'package:weather/services/styles.dart';

class CoverPage extends StatelessWidget {
  const CoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              'images/Cover page.jpg',
              height: h * 1.0,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  const SizedBox(height: 100),
                  Image.asset(
                    fit: .fill,
                    'images/weather-app.png',
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Get latest Insights about weather',
                      style: Style.standardWhite,
                    ),
                  ),
                  Text(
                    'Stay updated with real-time forecasts, temperature, and air quality in your area.',
                    style: Style.standardWhite,
                  ),
                  const Expanded(flex: 2, child: SizedBox()),
                  ElevatedButton(
                    onPressed: () async {
                      await locationSetup(context);
                    },
                    style: buttonStyle(w, h),
                    child: Text('Get Started', style: Style.standardWhite),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                  Text(
                    textAlign: .center,
                    'We use your location to provide accurate local forecasts',
                    style: Style.standardWhite,
                  ),
                  const SizedBox(height: 05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle buttonStyle(double w, double h) {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3770FF),
      fixedSize: Size(w * 0.5, h * 0.07),
      overlayColor: const Color(0xFF000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
    );
  }
}
