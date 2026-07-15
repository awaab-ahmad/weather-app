import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/search_location.dart';
import 'package:weather/services/cards.dart';
import 'package:weather/services/globals.dart';
import 'package:weather/services/provider.dart';
import 'package:weather/services/styles.dart';

// Making the Model Class and then shifting the data on basis

// ignore: must_be_immutable
class ModelClass extends StatefulWidget {
  const ModelClass({super.key});

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
    return Scaffold(
      body: Stack(
        children: [
          const GradientContainer(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RefreshIndicator(
                backgroundColor: const Color(0xFFFFFFFF),
                color: const Color(0xFF0088FF),
                key: refreshState,
                onRefresh: () async {
                  final p = context.read<MainProvider>();
                  return p.refreshIndicatorFunction(p.indexHelper);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: .center,
                    children: [
                      const TopRow(),
                      const CityDetailsCard(),
                      const SizedBox(height: 05),
                      const HourlyForecastCard(),
                      const SizedBox(height: 05),
                      const DailyForecastCard(),
                    ],
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

class TopRow extends StatelessWidget {
  const TopRow({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('The Top row rebuild');
    final sz = MediaQuery.sizeOf(context);
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            bottomSheet(
              context,
              Padding(
                padding: EdgeInsets.only(bottom: sz.height * 0.02),
                child: BackdropFilter(
                  filter: .blur(sigmaX: 02, sigmaY: 02),
                  child: const AllLocationsSheet(),
                ),
              ),
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
        const LoadingIndicator(),
        const Expanded(child: SizedBox()),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(navigator(SearchPage()));
          },
          padding: EdgeInsets.all(0),
          icon: Image.asset(
            'images/location.png',
            height: 30,
            color: const Color(0xFFFFFFFF),
          ),
        ),
      ],
    );
  }
}

class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return Selector<MainProvider, LinearGradient>(
      selector: (_, pro) => pro.gradientBack,
      builder: (context, gradientColor, child) => Container(
        width: sz.width * 1.0,
        height: sz.height * 1.0,
        decoration: BoxDecoration(gradient: gradientColor),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<MainProvider>().isLoading == true) {
      return SizedBox(
        height: 30,
        width: 30,
        child: Card(
          color: const Color(0x00000000),
          shadowColor: const Color(0x00000000),
          child: CircularProgressIndicator(color: const Color(0xFFFFFFFF)),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class CityDetailsCard extends StatelessWidget {
  const CityDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('The Whole City card build');
    final sz = MediaQuery.sizeOf(context);
    return Card(
      margin: const EdgeInsets.all(0),
      color: const Color(0x00000000),
      shadowColor: const Color(0x00000000),
      child: Column(
        children: [
          Selector<MainProvider, String>(
            selector: (_, pro) => pro.cityName,
            builder: (_, city, _) {
              // if (kDebugMode) print('City Name rebuilt');
              return Text(city, style: Style.medWhite);
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: .center,
            children: [
              Selector<MainProvider, double>(
                selector: (_, pro) => pro.temp,
                builder: (_, temp, _) =>
                    Text(temp.toStringAsFixed(0), style: Style.largeWhite),
              ),
              Transform.translate(
                offset: Offset(0, -21),
                child: const Text('°', style: Style.simpleWhite),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: .center,
            children: [
              Selector<MainProvider, String>(
                selector: (_, pro) => pro.weatherDescription,
                builder: (_, desc, _) => Text(desc, style: Style.simpleWhite),
              ),
              const SizedBox(width: 10),
              Selector<MainProvider, String>(
                selector: (_, pro) => pro.mainWeatherImage,
                builder: (_, image, _) {
                  return Image.asset(image, width: sz.width * 0.09);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset('images/sunrise.png', height: 20),
                  const SizedBox(width: 05),
                  Selector<MainProvider, String>(
                    selector: (p, pro) =>
                        pro.dataList[pro.indexHelper]['sunriseHour'],
                    builder: (_, sunrise, _) {
                      if (sunrise.isNotEmpty) {
                        return Text(sunrise, style: Style.standardWhite);
                      }
                      return const Text('Not set', style: Style.standardWhite);
                    },
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Row(
                children: [
                  Image.asset('images/sunset.png', height: 20),
                  const SizedBox(width: 05),
                  Selector<MainProvider, String>(
                    selector: (_, pro) =>
                        pro.dataList[pro.indexHelper]['sunsetHour'],
                    builder: (_, sunset, _) {
                      if (sunset.isNotEmpty) {
                        return Text(sunset, style: Style.standardWhite);
                      }
                      return const Text('Not Set', style: Style.standardWhite);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 05),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              _SmallCard(
                imagePath: 'images/hot.png',
                child: Row(
                  children: [
                    Selector<MainProvider, double>(
                      selector: (_, pro) => pro.feelsLike,
                      builder: (_, feels, _) => FittedBox(
                        child: Text(
                          'Feels Like: ${feels.toStringAsFixed(0)}',
                          style: Style.smallWhite,
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Transform.translate(
                        offset: const Offset(0, -6),
                        child: const Text('°', style: Style.smlStandardWhite),
                      ),
                    ),
                  ],
                ),
              ),
              _SmallCard(
                imagePath: 'images/wind.png',
                child: Selector<MainProvider, double>(
                  selector: (_, pro) => pro.windSpeed,
                  builder: (_, wind, _) {
                    // if (kDebugMode) print('Wind small box rebuilt');
                    return Text(
                      '${wind.toStringAsFixed(2)} km/h',
                      style: Style.smallWhite,
                    );
                  },
                ),
              ),
              _SmallCard(
                imagePath: 'images/humidity.png',
                child: Selector<MainProvider, int>(
                  selector: (_, pro) => pro.humidity,
                  builder: (_, humidity, _) {
                    // if (kDebugMode) print('Humidity small rebuilt');
                    return Text('$humidity %', style: Style.smallWhite);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final String imagePath;
  final Widget child;
  const _SmallCard({required this.imagePath, required this.child});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return SizedBox(
      height: 28,
      width: sz.width * 0.28,
      child: Card(
        margin: const EdgeInsets.all(0),
        color: const Color(0x33727272),
        shadowColor: const Color(0x33727272),
        elevation: 0,
        child: Row(
          mainAxisAlignment: .center,
          children: [
            const Expanded(child: SizedBox()),
            Image.asset(
              imagePath,
              height: 15,
              color: imagePath.contains('wind')
                  ? const Color(0xffffffff)
                  : null,
            ),
            const SizedBox(width: 05),
            child,
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
