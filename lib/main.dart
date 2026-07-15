import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/cover_page.dart';
import 'package:weather/pages/weather_page.dart';
import 'package:weather/services/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => MainProvider()
        ..gettingFirstTimeSetupDetails()
        ..gettingDataFromStorage(),
      child: const MainClass(),
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: const Color(0x00000000),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  });
}

class MainClass extends StatefulWidget {
  const MainClass({super.key});

  @override
  State<MainClass> createState() => _MainClassState();
}

class _MainClassState extends State<MainClass> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Selector<MainProvider, bool?>(
        selector: (_, pro) => pro.firstTimeSetupDone,
        builder: (_, setup, _) {
          if (setup == null) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (setup == false) {
            return CoverPage();
          }
          return const ModelClass();
        },
      ),
    );
  }
}
