import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/globals.dart';
import 'package:weather/services/colors.dart';
import 'package:weather/services/provider.dart';
import 'package:weather/services/snackbar.dart';

Card hourlyForecastCard(double h, double w, BuildContext context) {
  return Card(
    margin: const EdgeInsets.all(0),
    color: cardColor,
    shape: cardRadius,
    elevation: 0,
    clipBehavior: .antiAlias,
    child: Padding(
      padding: const EdgeInsets.only(top: 10, left: 0, bottom: 00),
      child: Consumer<MainProvider>(
        builder: (context, p, child) => Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: text(' Next 48 Hours', 12, FontWeight.w500),
            ),
            const SizedBox(height: 05),
            SizedBox(
              height: h * 0.18,
              width: double.maxFinite,
              child: Scrollbar(
                radius: Radius.circular(20),
                child: p.dataList.isEmpty
                    ? Center(
                        child: text(
                          'Loading First time setup',
                          10,
                          FontWeight.w500,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // itemCount: p
                        //     .apiDataOfIndexesStorer[p.indexHelper]['hourly']
                        //     .length,
                        itemCount:
                            (p.dataList[p.indexHelper]['apiData']['hourly']
                                    as List)
                                .length,
                        itemBuilder: (context, index) {
                          // final dataStream =
                          //     p.apiDataOfIndexesStorer[p
                          //         .indexHelper]['hourly'][index];
                          final dataStream =
                              p.dataList[p
                                  .indexHelper]['apiData']['hourly'][index];
                          final dt = dataStream['dt'];
                          final time = DateTime.fromMillisecondsSinceEpoch(
                            dt * 1000,
                            isUtc: true,
                          ).toLocal();
                          final formattedTime = DateFormat('h a').format(time);
                          double temp = (dataStream['temp'] - 273.15);
                          double wind = (dataStream['wind_speed'] * 3.6);
                          String image = p.forecastImageLoading(
                            dataStream['weather'][0]['main'],
                          );
                          return SizedBox(
                            width: w * 0.23,
                            child: Card(
                              clipBehavior: .antiAlias,
                              color: const Color(0x00666666),
                              shape: cardRadius,
                              elevation: 0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 08,
                                  vertical: 08,
                                ),
                                child: Column(
                                  children: [
                                    text(formattedTime, 10, FontWeight.w500),
                                    const Expanded(child: SizedBox()),
                                    Image.asset(image, height: 25),
                                    const Expanded(child: SizedBox()),
                                    Row(
                                      mainAxisAlignment: .center,
                                      children: [
                                        text(
                                          temp.toStringAsFixed(0),
                                          13,
                                          FontWeight.w700,
                                        ),
                                        Transform.translate(
                                          offset: Offset(0, -8),
                                          child: text('°', 12, FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const Expanded(child: SizedBox()),
                                    text(
                                      '${wind.toStringAsFixed(1)} km/h',
                                      09,
                                      FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

SizedBox dailyForecastCard(double h, double w, BuildContext context) {
  return SizedBox(
    height: h * 0.435,
    width: double.maxFinite,
    child: Card(
      margin: const EdgeInsets.all(0),
      clipBehavior: .antiAlias,
      color: cardColor,
      shape: cardRadius,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Consumer<MainProvider>(
          builder: (context, p, child) => Column(
            crossAxisAlignment: .start,
            children: [
              text(' Next 8 Days', 16, FontWeight.w500),
              const SizedBox(height: 05),
              Expanded(
                child: context.read<MainProvider>().dataList.isEmpty
                    ? Center(
                        child: text(
                          'Loading First Time setup',
                          10,
                          FontWeight.w600,
                        ),
                      )
                    : ListView.builder(
                        itemCount: p
                            .dataList[p.indexHelper]['apiData']['daily']
                            .length,
                        // itemCount: p
                        //     .apiDataOfIndexesStorer[p.indexHelper]['daily']
                        // .length,
                        itemBuilder: (context, index) {
                          final dataStream =
                              p.dataList[p
                                  .indexHelper]['apiData']['daily'][index];
                          // final dataStream =
                          //     p.apiDataOfIndexesStorer[p
                          //         .indexHelper]['daily'][index];
                          final weatherApi = dataStream['weather'][0]['main'];
                          // making the weekend days for here work
                          final time = DateTime.fromMillisecondsSinceEpoch(
                            dataStream['dt'] * 1000,
                            isUtc: true,
                          ).toLocal();
                          String formattedDay = DateFormat('EEEE').format(time);
                          final image = p.forecastImageLoading(weatherApi);
                          double tempMin = (dataStream['temp']['min'] - 273.15);
                          double tempMax = (dataStream['temp']['max'] - 273.15);
                          String desc = dataStream['weather'][0]['description'];
                          final humidity = dataStream['humidity'];
                          final pressure = dataStream['pressure'];
                          double dayTemp =
                              (dataStream['feels_like']['day'] - 273.15);
                          double nightTemp =
                              (dataStream['feels_like']['night'] - 273.15);
                          double winds = (dataStream['wind_speed'] * 3.6);
                          final summary = dataStream['summary'];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 03),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: const Color(0x00000000),
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: h * 0.08),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 5,
                                            sigmaY: 5,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            height: h * 0.30,
                                            width: w * 0.9,
                                            decoration: BoxDecoration(
                                              color: const Color(0x33ffffff),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: .start,
                                              children: [
                                                const SizedBox(height: 05),
                                                Center(
                                                  child: SizedBox(
                                                    height: 15,
                                                    width: 60,
                                                    child: Card(
                                                      color: const Color(
                                                        0xFFFFFFFF,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    text(
                                                      'On $formattedDay',
                                                      16,
                                                      FontWeight.w500,
                                                    ),
                                                    text(
                                                      ' - $weatherApi',
                                                      14,
                                                      FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: .start,
                                                  children: [
                                                    text(
                                                      desc,
                                                      14,
                                                      FontWeight.w600,
                                                    ),
                                                    const Expanded(
                                                      child: SizedBox(),
                                                    ),
                                                    Image.asset(
                                                      image,
                                                      height: 30,
                                                    ),
                                                    const Expanded(
                                                      child: SizedBox(),
                                                    ),
                                                    text(
                                                      tempMin.toStringAsFixed(
                                                        0,
                                                      ),
                                                      18,
                                                      FontWeight.w600,
                                                    ),
                                                    Transform.translate(
                                                      offset: Offset(0, -8),
                                                      child: text(
                                                        '°',
                                                        13,
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                    text(
                                                      ' / ',
                                                      12,
                                                      FontWeight.w600,
                                                    ),
                                                    text(
                                                      tempMax.toStringAsFixed(
                                                        0,
                                                      ),
                                                      18,
                                                      FontWeight.w600,
                                                    ),
                                                    Transform.translate(
                                                      offset: Offset(0, -8),
                                                      child: text(
                                                        '°',
                                                        13,
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: .start,
                                                  children: [
                                                    Image.asset(
                                                      'images/humidity.png',
                                                      height: 25,
                                                    ),
                                                    text(
                                                      '$humidity%',
                                                      12,
                                                      FontWeight.w500,
                                                    ),
                                                    const Expanded(
                                                      child: SizedBox(),
                                                    ),
                                                    Image.asset(
                                                      'images/wind.png',
                                                      color: const Color(
                                                        0xFFFFFFFF,
                                                      ),
                                                      height: 20,
                                                    ),
                                                    text(
                                                      ' ${winds.toStringAsFixed(2)} km/h',
                                                      12,
                                                      FontWeight.w500,
                                                    ),
                                                    const Expanded(
                                                      child: SizedBox(),
                                                    ),
                                                    Image.asset(
                                                      'images/thermometer.png',
                                                      height: 25,
                                                    ),
                                                    text(
                                                      '$pressure pa',
                                                      12,
                                                      FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    text(
                                                      'Feels like: ',
                                                      12,
                                                      FontWeight.w600,
                                                    ),
                                                    const SizedBox(width: 20),
                                                    text(
                                                      'Day: ${dayTemp.toStringAsFixed(0)}',
                                                      14,
                                                      FontWeight.w700,
                                                    ),
                                                    Transform.translate(
                                                      offset: Offset(0, -8),
                                                      child: text(
                                                        '°',
                                                        12,
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    text(
                                                      'Night: ${nightTemp.toStringAsFixed(0)}',
                                                      14,
                                                      FontWeight.w700,
                                                    ),
                                                    Transform.translate(
                                                      offset: Offset(0, -8),
                                                      child: text(
                                                        '°',
                                                        12,
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  summary,
                                                  style: GoogleFonts.poppins(
                                                    color: const Color(
                                                      0xFFFFFFFF,
                                                    ),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: h * 0.07,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0x33FFFFFF),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x1A000000),
                                      offset: Offset(0, 2),
                                      spreadRadius: 0.4,
                                      blurRadius: 0,
                                      blurStyle: .inner,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: .start,
                                  children: [
                                    const SizedBox(width: 08),
                                    SizedBox(
                                      width: w * 0.40,
                                      child: text(
                                        formattedDay,
                                        14,
                                        FontWeight.w600,
                                      ),
                                    ),                                    
                                    Image.asset(image, height: 30),
                                    const Expanded(child: SizedBox()),
                                    SizedBox(
                                      width: w * 0.26,
                                      child: Row(
                                        mainAxisAlignment: .end,
                                        children: [
                                          text(
                                            tempMin.toStringAsFixed(0),
                                            16,
                                            FontWeight.w600,
                                          ),
                                          Transform.translate(
                                            offset: Offset(0, -08),
                                            child: text(
                                              '°',
                                              12,
                                              FontWeight.w500,
                                            ),
                                          ),
                                          text(' / ', 16, FontWeight.w700),
                                          text(
                                            tempMax.toStringAsFixed(0),
                                            16,
                                            FontWeight.w600,
                                          ),
                                          Transform.translate(
                                            offset: Offset(0, -08),
                                            child: text(
                                              '°',
                                              12,
                                              FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 04),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Container allLocationsBottomSheet(double h, double w, BuildContext context) {
  return Container(
    clipBehavior: .antiAlias,
    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    height: h * 0.47,
    width: w * 0.9,
    decoration: BoxDecoration(          
      color: const Color(0x00000000),
      border: BoxBorder.all(
        width: 1.5,
        color: const Color.fromARGB(106, 255, 255, 255)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: .start,
      children: [
        const SizedBox(height: 05),
        Center(
          child: const SizedBox(
            height: 15,
            width: 70,
            child: Card(color: Color(0xFFffffff)),
          ),
        ),
        const SizedBox(height: 05),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            text('Added Locations', 16, FontWeight.w500),
            context.watch<MainProvider>().isRefreshingAll == true
                ? SizedBox(
                    height: 30,
                    width: 30,
                    child: Card(
                      color: const Color(0x00000000),
                      shadowColor: const Color(0x00000000),
                      child: CircularProgressIndicator(
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      await context.read<MainProvider>().refreshAllFunction(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      visualDensity: VisualDensity(vertical: -2),
                    ),
                    child: text('Refresh All', 12, FontWeight.w500),
                  ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(0),
            clipBehavior: .antiAlias,
            color: const Color(0x00000000),
            shadowColor: const Color(0x00000000),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.builder(
              itemCount: context.read<MainProvider>().dataList.length,
              itemBuilder: (context, index) {
                final p = context.read<MainProvider>();
                LinearGradient color = sunny;
                // making the switch here for the working
                switch (p.dataList[index]['weatherList']) {
                  case 'Clear':
                    color = sunny;
                    break;
    
                  case 'Clouds':
                  case 'haze':
                    color = cloudy;
                    break;
    
                  case 'Rain':
                  case 'Drizzle':
                  case 'Mist':
                    color = rainy;
                    break;
    
                  case 'Thunderstorm':
                  case 'Squall':
                  case 'Tornado':
                    color = stormy;
                    break;
    
                  case 'Snow':
                    color = snowy;
                    break;
    
                  default:
                    color = sunny;
                    break;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 04),
                  child: GestureDetector(
                    onTap: () {
                      p.changingIndex(index);
                      p.reChangingMainData(index);
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          globalBar(
                            'Data of ${p.dataList[index]['cityName']}',
                            context,
                          ),
                        );
                      if (kDebugMode) {
                        print(
                          'Pressing the Index no: ${context.read<MainProvider>().indexHelper}',
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 10,
                        bottom: 10,
                        right: 5,
                      ),
                      height: h * 0.1,
                      width: w * 0.85,
                      decoration: BoxDecoration(
                        gradient: color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: w * 0.52,
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                text(
                                  p.dataList[index]['cityName'],
                                  16,
                                  FontWeight.w500,
                                ),
                                const Expanded(child: SizedBox()),
                                text(
                                  p.dataList[index]['weatherList'],
                                  16,
                                  FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          text(
                            p.dataList[index]['tempList'].toStringAsFixed(0),
                            20,
                            FontWeight.w600,
                          ),
                          Transform.translate(
                            offset: Offset(0, -10),
                            child: text('°', 14, FontWeight.w600),
                          ),
                          IconButton(
                            onPressed: () {
                              final p = context.read<MainProvider>();
                              if (index == 0) {
                              } else {
                                if (p.indexHelper == index) {
                                  p.movingOneListBackThenDeletingTheLocation(
                                    index,
                                  );
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                } else {
                                  p.removingLocationDetails(index);
                                }
                              }
                            },
                            color: const Color(0xFF000000),
                            padding: const EdgeInsets.all(0),
                            icon: index == 0
                                ? Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: const Color(0xFFFFFFFF),
                                  )
                                : Image.asset(
                                    'images/trash.png',
                                    height: 30,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 05),
      ],
    ),
  );
}
