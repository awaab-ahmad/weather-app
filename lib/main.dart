import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/cover_page.dart';
import 'package:weather/pages/weather_page.dart';
import 'package:weather/services/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: const Color(0x00FFFFFF),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: const Color(0x00000000),
      systemNavigationBarIconBrightness: .light,
      systemNavigationBarContrastEnforced: false
    ),    
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    ChangeNotifierProvider(
      create: (_) => MainProvider()
        ..gettingFirstTimeSetupDetails()
        ..gettingDataFromStorage(),
      child: const MainClass(),
    ),
  );
}

class MainClass extends StatefulWidget {
  const MainClass({super.key});

  @override
  State<MainClass> createState() => _MainClassState();
}

class _MainClassState extends State<MainClass> {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<MainProvider>();
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 600),
      child: MaterialApp(
        key: ValueKey(p.firstTimeSetupDone),
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: context.read<MainProvider>().firstTimeSetupDone == false
            ? CoverPage()
            : ModelClass(
                index: p.indexHelper,
                city: p.cityName,
                temperature: p.temp,
                weatherImage: p.mainWeatherImage,
                weatherType: p.typeOfWeather,
                weatherDescription: p.weatherDescription,
                feels: p.feelsLike,
                pressure: p.pressure,
                wind: p.windSpeed,
                humidity: p.humidity,
              ),
      ),
    );
  }
}
