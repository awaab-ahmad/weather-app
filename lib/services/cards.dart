import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/globals.dart';
import 'package:weather/services/colors.dart';
import 'package:weather/services/provider.dart';
import 'package:weather/services/snackbar.dart';
import 'package:weather/services/styles.dart';

class HourlyForecastCard extends StatelessWidget {
  const HourlyForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(' Next 48 Hours', style: Style.standardWhite),
              ),
              const SizedBox(height: 05),
              SizedBox(
                height: sz.height * 0.18,
                width: double.maxFinite,
                child: Scrollbar(
                  radius: Radius.circular(20),
                  child: p.dataList.isEmpty
                      ? Center(
                          child: const Text(
                            'Loading First time setup',
                            style: Style.smlStandardWhite,
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              (p.dataList[p.indexHelper]['apiData']['hourly']
                                      as List)
                                  .length,
                          itemBuilder: (context, index) {
                            final dataStream =
                                p.dataList[p
                                    .indexHelper]['apiData']['hourly'][index];
                            final dt = dataStream['dt'];
                            final time = DateTime.fromMillisecondsSinceEpoch(
                              dt * 1000,
                              isUtc: true,
                            ).toLocal();
                            final formattedTime = DateFormat(
                              'h a',
                            ).format(time);
                            double temp = (dataStream['temp'] - 273.15);
                            double wind = (dataStream['wind_speed'] * 3.6);
                            String image = p.forecastImageLoading(
                              dataStream['weather'][0]['main'],
                            );
                            return _PerHourCard(
                              formattedTime: formattedTime,
                              image: image,
                              temp: temp,
                              wind: wind,
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
}

class _PerHourCard extends StatelessWidget {
  final String formattedTime;
  final String image;
  final double temp;
  final double wind;
  const _PerHourCard({
    required this.formattedTime,
    required this.image,
    required this.temp,
    required this.wind,
  });

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return SizedBox(
      width: sz.width * 0.23,
      child: Card(
        clipBehavior: .antiAlias,
        color: const Color(0x00666666),
        shape: cardRadius,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 08, vertical: 08),
          child: Column(
            children: [
              Text(formattedTime, style: Style.smlStandardWhite),
              const Expanded(child: SizedBox()),
              Image.asset(image, height: 25),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: .center,
                children: [
                  Text(temp.toStringAsFixed(0), style: Style.standardWhite),
                  Transform.translate(
                    offset: Offset(0, -8),
                    child: const Text('°', style: Style.standardWhite),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Text('${wind.toStringAsFixed(1)} km/h', style: Style.smallWhite),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyForecastCard extends StatelessWidget {
  const DailyForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return SizedBox(
      height: sz.height * 0.435,
      width: double.maxFinite,
      child: Card(
        margin: const EdgeInsets.all(0),
        clipBehavior: .antiAlias,
        color: cardColor,
        shape: cardRadius,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 05),
          child: Consumer<MainProvider>(
            builder: (context, p, child) => Column(
              crossAxisAlignment: .start,
              children: [
                const Text(' Next 8 Days', style: Style.simpleWhite),
                const SizedBox(height: 05),
                Expanded(
                  child: context.read<MainProvider>().dataList.isEmpty
                      ? Center(
                          child: const Text(
                            'Loading First Time setup',
                            style: Style.smlStandardWhite,
                          ),
                        )
                      : Card(
                          clipBehavior: .antiAlias,
                          color: const Color(0x00000000),
                          shadowColor: const Color(0x00000000),
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(20),
                          ),
                          child: ListView.builder(
                            itemCount: p
                                .dataList[p.indexHelper]['apiData']['daily']
                                .length,
                            itemBuilder: (context, index) {
                              final dataStream =
                                  p.dataList[p
                                      .indexHelper]['apiData']['daily'][index];
                              final weatherApi =
                                  dataStream['weather'][0]['main'];
                              // making the weekend days for here work
                              final time = DateTime.fromMillisecondsSinceEpoch(
                                dataStream['dt'] * 1000,
                                isUtc: true,
                              ).toLocal();
                              String formattedDay = DateFormat(
                                'EEEE',
                              ).format(time);
                              final image = p.forecastImageLoading(weatherApi);
                              double tempMin =
                                  (dataStream['temp']['min'] - 273.15);
                              double tempMax =
                                  (dataStream['temp']['max'] - 273.15);
                              String desc =
                                  dataStream['weather'][0]['description'];
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
                                        return _PerDayCard(
                                          day: formattedDay,
                                          weather: weatherApi,
                                          desc: desc,
                                          image: image,
                                          tempMin: tempMin,
                                          tempMax: tempMax,
                                          humidity: humidity,
                                          winds: winds,
                                          pressure: pressure,
                                          dayTemp: dayTemp,
                                          nightTemp: nightTemp,
                                          summary: summary,
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: sz.height * 0.07,
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
                                          width: sz.width * 0.40,
                                          child: Text(
                                            formattedDay,
                                            style: Style.standardWhite,
                                          ),
                                        ),
                                        Image.asset(image, height: 30),
                                        const Expanded(child: SizedBox()),
                                        SizedBox(
                                          width: sz.width * 0.26,
                                          child: Row(
                                            mainAxisAlignment: .end,
                                            children: [
                                              Text(
                                                tempMin.toStringAsFixed(0),
                                                style: Style.simpleWhite,
                                              ),
                                              Transform.translate(
                                                offset: Offset(0, -08),
                                                child: const Text(
                                                  '°',
                                                  style: Style.simpleWhite,
                                                ),
                                              ),
                                              const Text(
                                                ' / ',
                                                style: Style.simpleWhite,
                                              ),
                                              Text(
                                                tempMax.toStringAsFixed(0),
                                                style: Style.simpleWhite,
                                              ),
                                              Transform.translate(
                                                offset: Offset(0, -08),
                                                child: const Text(
                                                  '°',
                                                  style: Style.standardWhite,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PerDayCard extends StatelessWidget {
  final String day;
  final String weather;
  final String desc;
  final String image;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double winds;
  final int pressure;
  final double dayTemp;
  final double nightTemp;
  final String summary;
  const _PerDayCard({
    required this.day,
    required this.weather,
    required this.desc,
    required this.image,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.winds,
    required this.pressure,
    required this.dayTemp,
    required this.nightTemp,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: sz.height * 0.02),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: sz.height * 0.30,
            width: sz.width * 0.9,
            decoration: BoxDecoration(
              color: const Color(0x33ffffff),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const SizedBox(height: 05),
                Center(
                  child: SizedBox(
                    height: 15,
                    width: 60,
                    child: Card(color: const Color(0xFFFFFFFF)),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text('On $day', style: Style.simpleWhite),
                    Text(' - $weather', style: Style.standardWhite),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: .start,
                  children: [
                    Text(desc, style: Style.standardWhite),
                    const Expanded(child: SizedBox()),
                    Image.asset(image, height: 30),
                    const Expanded(child: SizedBox()),
                    Text(tempMin.toStringAsFixed(0), style: Style.simpleWhite),
                    Transform.translate(
                      offset: Offset(0, -8),
                      child: const Text('°', style: Style.standardWhite),
                    ),
                    Text(' / ', style: Style.simpleWhite),
                    Text(tempMax.toStringAsFixed(0), style: Style.simpleWhite),
                    Transform.translate(
                      offset: Offset(0, -8),
                      child: const Text('°', style: Style.standardWhite),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: .start,
                  children: [
                    Image.asset('images/humidity.png', height: 25),
                    Text('$humidity%', style: Style.standardWhite),
                    const Expanded(child: SizedBox()),
                    Image.asset(
                      'images/wind.png',
                      color: const Color(0xFFFFFFFF),
                      height: 20,
                    ),
                    Text(
                      ' ${winds.toStringAsFixed(2)} km/h',
                      style: Style.standardWhite,
                    ),
                    const Expanded(child: SizedBox()),
                    Image.asset('images/thermometer.png', height: 25),
                    Text('$pressure pa', style: Style.standardWhite),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Feels like: ', style: Style.standardWhite),
                    const SizedBox(width: 20),
                    Text(
                      'Day: ${dayTemp.toStringAsFixed(0)}',
                      style: Style.standardWhite,
                    ),
                    Transform.translate(
                      offset: Offset(0, -8),
                      child: const Text('°', style: Style.standardWhite),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Night: ${nightTemp.toStringAsFixed(0)}',
                      style: Style.standardWhite,
                    ),
                    Transform.translate(
                      offset: Offset(0, -8),
                      child: const Text('°', style: Style.standardWhite),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(summary, style: Style.smlStandardWhite),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AllLocationsSheet extends StatelessWidget {
  const AllLocationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('Location Sheet rebuilt');
    final sz = MediaQuery.sizeOf(context);
    return Container(
      clipBehavior: .antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      height: sz.height * 0.47,
      width: sz.width * 0.9,
      decoration: BoxDecoration(
        color: const Color(0x00000000),
        border: BoxBorder.all(
          width: 1.5,
          color: const Color.fromARGB(106, 255, 255, 255),
        ),
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
              const Text('Added Locations', style: Style.simpleWhite),
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
                        await context.read<MainProvider>().refreshAllFunction(
                          context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        visualDensity: VisualDensity(vertical: -2),
                      ),
                      child: const Text(
                        'Refresh All',
                        style: Style.standardWhite,
                      ),
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
                  color = colorReturner(
                    index,
                    context.read<MainProvider>().dataList[index]['weatherList'],
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 04),
                    child: GestureDetector(
                      onTap: () {
                        p.changingLocation(index);
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
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 10,
                          bottom: 10,
                          right: 5,
                        ),
                        height: sz.height * 0.1,
                        width: sz.width * 0.85,
                        decoration: BoxDecoration(
                          gradient: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: sz.width * 0.52,
                              child: Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(
                                    p.dataList[index]['cityName'],
                                    style: Style.simpleWhite,
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Text(
                                    p.dataList[index]['weatherList'],
                                    style: Style.simpleWhite,
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              p.dataList[index]['tempList'].toStringAsFixed(0),
                              style: Style.medWhite,
                            ),
                            Transform.translate(
                              offset: Offset(0, -10),
                              child: const Text('°', style: Style.simpleWhite),
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
}

LinearGradient colorReturner(int index, String address) {
  switch (address) {
    case 'Clear':
      return sunny;

    case 'Clouds':
    case 'haze':
      return cloudy;

    case 'Rain':
    case 'Drizzle':
    case 'Mist':
      return rainy;

    case 'Thunderstorm':
    case 'Squall':
    case 'Tornado':
      return stormy;

    case 'Snow':
      return snowy;

    default:
      return sunny;
  }
}
