import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/search_location.dart';
import 'package:weather/services/globals.dart';
import 'package:weather/services/cards.dart';
import 'package:weather/services/provider.dart';

// Making the Model Class and then shifting the data on basis

// ignore: must_be_immutable
class ModelClass extends StatefulWidget {
  int index;
  String city;
  double? temperature;
  String? weatherImage;
  String? weatherType;
  String? weatherDescription;
  double? feels;

  int? pressure;
  double? wind;
  int? humidity;
  ModelClass({
    super.key,
    required this.index,
    required this.city,
    required this.temperature,
    required this.weatherImage,
    required this.weatherType,
    required this.weatherDescription,
    required this.feels,
    required this.pressure,
    required this.wind,
    required this.humidity,
  });

  @override
  State<ModelClass> createState() => _ModelClassState();
}

class _ModelClassState extends State<ModelClass> {
  final GlobalKey<RefreshIndicatorState> refreshState =
      GlobalKey<RefreshIndicatorState>();
  DateTime dt = DateTime.now().toLocal();
  @override
  void initState() {
    super.initState();
    if (context.read<MainProvider>().isDoneOnce == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (kDebugMode) print(dt.hour);
        context.read<MainProvider>().helperFunction(context);
      });
    } else {
      if (kDebugMode) print('Its already done once');
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(       
      extendBody: true,   
      body: Stack(
        children: [
          //        Image.asset(
          //           fit: BoxFit.fill,
          //           'images/night_time.jpg',
          //           height: h * 1.0,
          //           width: w * 1.0,
          //         )
          Container(
            width: w * 1.0,
            height: h * 1.0,
            decoration: BoxDecoration(
              gradient: context.read<MainProvider>().gradientBack,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RefreshIndicator(
                backgroundColor: const Color(0xFFFFFFFF),
                color: const Color(0xFF0088FF),
                key: refreshState,
                onRefresh: () async {
                  return context.read<MainProvider>().refreshIndicatorFunction(
                    widget.index,
                  );
                },
                child: SingleChildScrollView(                  
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: Column(
                      key: ValueKey(widget.index),
                      crossAxisAlignment: .center,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  barrierColor: const Color(0x66000000),
                                  context: context,
                                  useSafeArea: true,
                                  backgroundColor: const Color(0x00000000),
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: h * 0.08,
                                      ),
                                      child: BackdropFilter(
                                        filter: .blur(
                                          sigmaX: 02, sigmaY: 02
                                        ),
                                        child: allLocationsBottomSheet(
                                          h,
                                          w,
                                          context,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              padding: EdgeInsets.zero,
                              icon: Image.asset(
                                'images/navigation.png',
                                color: const Color(0xFFffffff),
                                height: 30,
                              ),
                            ),
                            const SizedBox(width: 05),
                            context.read<MainProvider>().isLoading == true
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
                                : const SizedBox.shrink(),
                            const Expanded(child: SizedBox()),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SearchPage(),
                                  ),
                                );
                              },
                              padding: EdgeInsets.all(0),
                              icon: Image.asset(
                                'images/location.png',
                                height: 30,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          ],
                        ),
                        Card(
                          margin: const EdgeInsets.all(0),
                          color: const Color(0x00000000),
                          shadowColor: const Color(0x00000000),
                          child: Column(
                            children: [
                              text(widget.city, 20, FontWeight.w600),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: .center,
                                children: [
                                  text(
                                    widget.temperature!.toStringAsFixed(0),
                                    40,
                                    FontWeight.w600,
                                  ),
                                  Transform.translate(
                                    offset: Offset(0, -21),
                                    child: text('°', 15, FontWeight.w600),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: .center,
                                children: [
                                  text(
                                    widget.weatherDescription!,
                                    16,
                                    FontWeight.w600,
                                  ),
                                  const SizedBox(width: 10),
                                  Image.asset(
                                    widget.weatherImage!,
                                    width: w * 0.09,
                                  ),
                                ],
                              ),
                              context.read<MainProvider>().dataList.isEmpty
                                  ? const SizedBox.shrink()
                                  : Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'images/sunrise.png',
                                              height: 20,
                                            ),
                                            const SizedBox(width: 05),
                                            text(
                                              '${context.read<MainProvider>().dataList[widget.index]['sunriseHour']}',
                                              12,
                                              FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 30),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'images/sunset.png',
                                              height: 20,
                                            ),
                                            const SizedBox(width: 05),
                                            text(
                                              '${context.read<MainProvider>().dataList[widget.index]['sunsetHour']}',
                                              12,
                                              FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                              const SizedBox(height: 05),
                              Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 28,
                                    width: w * 0.3,
                                    child: Card(
                                      margin: const EdgeInsets.all(0),
                                      color: const Color(0x33727272),
                                      shadowColor: const Color(0x33727272),
                                      elevation: 0,
                                      child: Row(
                                        mainAxisAlignment: .center,
                                        children: [
                                          const SizedBox(width: 05),
                                          Image.asset(
                                            'images/hot.png',
                                            height: 15,
                                          ),
                                          const SizedBox(width: 05),
                                          Expanded(
                                            child: FittedBox(
                                              child: text(
                                                'Feels Like: ${widget.feels!.toStringAsFixed(0)}',
                                                08,
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Transform.translate(
                                            offset: Offset(0, -06),
                                            child: text(
                                              '°',
                                              10,
                                              FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 05),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 28,
                                    width: w * 0.3,
                                    child: Card(
                                      margin: const EdgeInsets.all(0),
                                      color: const Color(0x33727272),
                                      shadowColor: const Color(0x33727272),
                                      elevation: 0,
                                      child: Row(
                                        mainAxisAlignment: .center,
                                        children: [
                                          const SizedBox(width: 05),
                                          Image.asset(
                                            'images/wind.png',
                                            color: const Color(0xFfffffff),
                                            height: 15,
                                          ),
                                          const SizedBox(width: 05),
                                          text(
                                            '${widget.wind!.toStringAsFixed(2)} km/h',
                                            08,
                                            FontWeight.w500,
                                          ),
                                          const SizedBox(width: 05),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 28,
                                    width: w * 0.3,
                                    child: Card(
                                      margin: const EdgeInsets.all(0),
                                      color: const Color(0x33727272),
                                      shadowColor: const Color(0x33727272),
                                      elevation: 0,
                                      child: Row(
                                        mainAxisAlignment: .center,
                                        children: [
                                          const SizedBox(width: 05),
                                          Image.asset(
                                            'images/humidity.png',
                                            height: 15,
                                          ),
                                          const SizedBox(width: 05),
                                          text(
                                            '${widget.humidity} %',
                                            08,
                                            FontWeight.w500,
                                          ),
                                          const SizedBox(width: 05),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 05),
                        hourlyForecastCard(h, w, context),
                        const SizedBox(height: 05),
                        dailyForecastCard(h, w, context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
