import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/pages/weather_page.dart';
import 'package:weather/services/colors.dart';
import 'package:weather/services/geolocator_location.dart';
import 'package:http/http.dart' as http;
import 'package:weather/services/snackbar.dart';

// The Provider file with all the required Business Logic
class MainProvider extends ChangeNotifier {
  final client = http.Client();
  bool firstTimeSetupDone = false;
  bool isLoading = false;
  bool isDoneOnce = false;
  bool isRefreshingAll = false;
  bool cityAlreadyExist = false;

  int indexHelper = 0;
  int humidity = 0;
  int pressure = 0;

  dynamic dataFromWebsite;
  dynamic reverseCodingResults;

  double latitude = 0.0;
  double longitude = 0.0;
  double temp = 0;
  double windSpeed = 0;

  String cityName = '';
  String countryName = '';
  String weatherDescription = '';
  String mainWeatherImage = 'images/sunny.png';
  String typeOfWeather = 'Clear';
  double feelsLike = 0;

  LinearGradient gradientBack = sunny;

  List<Map<String, dynamic>> dataList = [];
  // remember this order for dataList: latitude, longitude, cityName, apiData, tempList, weatherList

  void puttingFirstTimeSetupToTrue() {
    firstTimeSetupDone = true;
    notifyListeners();
  }

  // writing down the sharedpreferences
  Future<void> settingFirstTimeData() async {
    final pref = await SharedPreferences.getInstance();
    firstTimeSetupDone = await pref.setBool('status', true);
    notifyListeners();
  }

  Future<void> gettingFirstTimeSetupDetails() async {
    final pref = await SharedPreferences.getInstance();
    firstTimeSetupDone = pref.getBool('status') ?? false;
    notifyListeners();
  }

  // The below function is for getting saved data from mobile storage
  Future<void> gettingDataFromStorage() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('allData');
    if (data != null && data.isNotEmpty) {
      dataList = List<Map<String, dynamic>>.from(jsonDecode(data));
      dataFromWebsite = dataList[0]['apiData'];
      cityName = dataList[0]['cityName'];
      await settingUpMainData();
      await mainWeatherIconChanging();
    } else {
      if (kDebugMode) print('The Data List is empty right now');
    } 
  }

  Future<void> helperFunction(BuildContext context) async {
    await gettingLocationCoords(context);
    if (kDebugMode) print('Now saving');
    await savingDataToMobile();
  }

  Future gettingLocationCoords(BuildContext context) async {
    isLoading = true;
    final b = ScaffoldMessenger.of(context);
    notifyListeners();
    try {
      dataFromWebsite = '';
      await locationSetup(context);
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: .high,
          distanceFilter: 100,
        ),
      );
      latitude = position.latitude;
      longitude = position.longitude;
      if (kDebugMode) print('Latitude: $latitude and Longitude: $longitude');
      // now here below is the function for getting the reverse coding from the website
      String reverseCodingUrl =
          'http://api.openweathermap.org/geo/1.0/reverse?lat=$latitude&lon=$longitude&limit=5&appid=5e7ee8b6f949b363109fb9f4f4660b30';
      final reverseCoding = await http
          .get(Uri.parse(reverseCodingUrl))
          .timeout(Duration(seconds: 15));
      if (reverseCoding.statusCode == 200) {
        reverseCodingResults = json.decode(reverseCoding.body);
        if (kDebugMode) print(reverseCodingResults);
        cityName = reverseCodingResults[0]['name'];
      } else {
        if (kDebugMode) print('The Reverse Coding is not working');
      }
      await getWeatherData(latitude, longitude);
      final tmZone = dataFromWebsite['timezone_offset'];
      final sunriseSetting = DateTime.fromMillisecondsSinceEpoch(
        (tmZone + dataFromWebsite['current']['sunrise']) * 1000,
        isUtc: true,
      );
      final sunsetSetting = DateTime.fromMillisecondsSinceEpoch(
        (tmZone + dataFromWebsite['current']['sunset']) * 1000,
        isUtc: true,
      );
      final sunriseConverted = DateFormat('h:mm a').format(sunriseSetting);
      final sunsetConverted = DateFormat('h:mm a').format(sunsetSetting);
      if (kDebugMode) {
        print('Sunrise is: $sunriseConverted \n Sunset is: $sunsetConverted');
      }
      if (dataList.isEmpty) {
        dataList.add({
          'latitude': reverseCodingResults[0]['lat'],
          'longitude': reverseCodingResults[0]['lon'],
          'cityName': reverseCodingResults[0]['name'],
          'apiData': dataFromWebsite,
          'tempList': temp,
          'weatherList': typeOfWeather,
          'sunriseHour': sunriseConverted,
          'sunsetHour': sunsetConverted,
        });
      } else {
        dataList[0] = {
          'latitude': reverseCodingResults[0]['lat'],
          'longitude': reverseCodingResults[0]['lon'],
          'cityName': reverseCodingResults[0]['name'],
          'apiData': dataFromWebsite,
          'tempList': temp,
          'weatherList': typeOfWeather,
          'sunriseHour': sunriseConverted,
          'sunsetHour': sunsetConverted,
        };
      }
      dataFromWebsite = '';
      reverseCodingResults = '';
      isLoading = false;
    } catch (e) {
      isLoading = false;
      if (kDebugMode) print('Network Error');
      if(context.mounted) {
      b.showSnackBar(globalBar('Network Error', context));
      }
    }
    isDoneOnce = true;
    notifyListeners();
  }

  Future<void> savingDataToMobile() async {
    final pref = await SharedPreferences.getInstance();
    final dataConverted = json.encode(dataList);
    await pref.setString('allData', dataConverted);
    if (kDebugMode) print('Data saved to mobile');
  }

  Future getWeatherData(double lati, double longi) async {
    String url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=$lati&lon=$longi&appid=5e7ee8b6f949b363109fb9f4f4660b30';
    try {
      final result = await client
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 20));
      if (result.statusCode == 200) {
        dataFromWebsite = json.decode(result.body);
        if (kDebugMode) print('$dataFromWebsite');
        await settingUpMainData();
        await mainWeatherIconChanging();
      } else {
        if (kDebugMode) print('Unable to receive the data');
      }
    } catch (e) {
      if (kDebugMode) print('Network Error');
    }
  }

  // Below is the function that is used for assigning the variables the data from the API
  Future settingUpMainData() async {
    temp = (dataFromWebsite['current']['temp'] - 273.15);
    feelsLike = (dataFromWebsite['current']['feels_like'] - 273.15);
    pressure = dataFromWebsite['current']['pressure'];
    typeOfWeather = dataFromWebsite['current']['weather'][0]['main'];
    weatherDescription =
        dataFromWebsite['current']['weather'][0]['description'];
    windSpeed = (dataFromWebsite['current']['wind_speed'] * 3.6);
    humidity = dataFromWebsite['current']['humidity'];
    notifyListeners();
  }

  // Below function is used for changing the Main Page Image based on weather API
  Future mainWeatherIconChanging() async {
    switch (typeOfWeather) {
      case 'Clear':
        mainWeatherImage = 'images/sunny.png';
        gradientBack = sunny;

      case 'Clouds':
      case 'haze':
        mainWeatherImage = 'images/cloudy.png';
        gradientBack = cloudy;

      case 'Rain':
      case 'Drizzle':
      case 'Mist':
        mainWeatherImage = 'images/rainy.png';
        gradientBack = rainy;

      case 'Thunderstorm':
      case 'Squall':
      case 'Tornado':
        mainWeatherImage = 'images/thunder.png';
        gradientBack = stormy;

      case 'Snow':
        mainWeatherImage = 'images/snowy.png';
        gradientBack = snowy;

      default:
        mainWeatherImage = 'images/sunny.png';
        gradientBack = sunny;
    }
  }

  // Below is the one function for chaning the image of the next 48 hours
  String forecastImageLoading(String weatherApi) {
    switch (weatherApi) {
      case 'Clear':
        return 'images/sunny.png';

      case 'Clouds':
      case 'haze':
        return 'images/cloudy.png';

      case 'Rain':
      case 'Drizzle':
        return 'images/rainy.png';

      case 'Thunderstorm':
      case 'Squall':
      case 'Tornado':
        return 'images/thunder.png';

      case 'Snow':
        return 'images/snowy.png';

      default:
        return 'images/sunny.png';
    }
  }

  Future<void> refreshIndicatorFunction(int index) async {
    // now here making the working of the refresh to work when some user try to refresh the page
    dataFromWebsite = '';
    isLoading == true;
    String url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=${dataList[index]['latitude']}&lon=${dataList[index]['longitude']}&appid=5e7ee8b6f949b363109fb9f4f4660b30';
    try {
      if (dataList.isNotEmpty) {
        final result = await client
            .get(Uri.parse(url))
            .timeout(Duration(seconds: 10));
        if (result.statusCode == 200) {
          dataFromWebsite = json.decode(result.body);
          if (kDebugMode) print('$dataFromWebsite');
          await settingUpMainData();
          await mainWeatherIconChanging();
          if (dataList.isEmpty) {
            if (kDebugMode) print('DataList is empty');
          } else {
            final tmZone = dataFromWebsite['timezone_offset'];
            final sunriseSetting = DateTime.fromMillisecondsSinceEpoch(
              (tmZone + dataFromWebsite['current']['sunrise']) * 1000,
              isUtc: true,
            );
            final sunsetSetting = DateTime.fromMillisecondsSinceEpoch(
              (tmZone + dataFromWebsite['current']['sunset']) * 1000,
              isUtc: true,
            );
            final sunriseConverted = DateFormat(
              'h:mm a',
            ).format(sunriseSetting);
            final sunsetConverted = DateFormat('h:mm a').format(sunsetSetting);
            dataList[index] = {
              ...dataList[index],
              'apiData': dataFromWebsite,
              'tempList': temp,
              'weatherList': typeOfWeather,
              'sunriseHour': sunriseConverted,
              'sunsetHour': sunsetConverted,
            };
          }
          await savingDataToMobile();
        } else {
          if (kDebugMode) print('Unable to receive the data');
        }
      } else {
        if (kDebugMode) print('DataList is empty so no updates');
      }
    } catch (e) {
      if (kDebugMode) print('Network Error');
    }
  }

  Future<void> gettingDataOfSerachedPlace(
    double lati,
    double longi,
    BuildContext context,
  ) async {
    dataFromWebsite = '';
    cityAlreadyExist = false;
    String reverseCodingUrl =
        'http://api.openweathermap.org/geo/1.0/reverse?lat=$lati&lon=$longi&limit=5&appid=5e7ee8b6f949b363109fb9f4f4660b30';
    String url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=$lati&lon=$longi&appid=5e7ee8b6f949b363109fb9f4f4660b30';
    try {
      // making the working of that function
      final locationName = await client
          .get(Uri.parse(reverseCodingUrl))
          .timeout(Duration(seconds: 10));
      dynamic reverseCodingResultInFunction;
      if (locationName.statusCode == 200) {
        reverseCodingResultInFunction = json.decode(locationName.body);
        for (int i = 0; i < dataList.length; i++) {
          if (reverseCodingResultInFunction[0]['name'] ==
              dataList[i]['cityName']) {
            cityAlreadyExist = true;
            if (kDebugMode) print('City Already Present');
            break;
          } else {
            // cityAlreadyExist = false;
            if (kDebugMode) print('Moving Forward');
          }
        }
      } else {
        'Un-Able to show the data';
      }
      if (dataList.isNotEmpty) {
        if (cityAlreadyExist == false) {
          final data = await client
              .get(Uri.parse(url))
              .timeout(Duration(seconds: 15));
          if (data.statusCode == 200) {
            dataFromWebsite = json.decode(data.body);
            final tmZone = dataFromWebsite['timezone_offset'];
            final sunriseSetting = DateTime.fromMillisecondsSinceEpoch(
              (tmZone + dataFromWebsite['current']['sunrise']) * 1000,
              isUtc: true,
            );
            final sunsetSetting = DateTime.fromMillisecondsSinceEpoch(
              (tmZone + dataFromWebsite['current']['sunset']) * 1000,
              isUtc: true,
            );
            final sunriseConverted = DateFormat(
              'h:mm a',
            ).format(sunriseSetting);
            final sunsetConverted = DateFormat('h:mm a').format(sunsetSetting);
            dataList.add({
              'latitude': lati,
              'longitude': longi,
              'apiData': dataFromWebsite,
              'cityName': reverseCodingResultInFunction[0]['name'],
              'tempList': (dataFromWebsite['current']['temp'] - 273.15),
              'weatherList': dataFromWebsite['current']['weather'][0]['main'],
              'sunriseHour': sunriseConverted,
              'sunsetHour': sunsetConverted,
            });
            dataFromWebsite = '';
            await savingDataToMobile();
            await changingIndex(dataList.length - 1);
            await reChangingMainData(indexHelper);
            if (!context.mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ModelClass(
                  index: indexHelper,
                  city: cityName,
                  temperature: temp,
                  weatherImage: mainWeatherImage,
                  weatherType: typeOfWeather,
                  weatherDescription: weatherDescription,
                  feels: feelsLike,
                  pressure: pressure,
                  wind: windSpeed,
                  humidity: humidity,
                ),
              ),
              (Route<dynamic> route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              globalBar(
                'Added ${reverseCodingResultInFunction[0]['name']}',
                context,
              ),
            );
          } else {
            if (kDebugMode) print('Un-able can\'t receive the data');
          }
        } else {
          if (!context.mounted) return;
          Navigator.of(context).pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).unfocus();
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(globalBar('City Already Present', context));
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    cityAlreadyExist = false;
  }

  // // making the function for  changing the index of data in the WeatherPage
  Future<void> changingIndex(int ind) async {
    indexHelper = ind;
    notifyListeners();
  }

  // making the Function for changing the main elements of the page based on index
  Future<void> reChangingMainData(int ind) async {
    cityName = dataList[ind]['cityName'];
    temp = (dataList[ind]['apiData']['current']['temp'] - 273.15);
    feelsLike = (dataList[ind]['apiData']['current']['feels_like'] - 273.15);
    pressure = dataList[ind]['apiData']['current']['pressure'];
    typeOfWeather = dataList[ind]['apiData']['current']['weather'][0]['main'];
    weatherDescription =
        dataList[ind]['apiData']['current']['weather'][0]['description'];
    windSpeed = (dataList[ind]['apiData']['current']['wind_speed'] * 3.6);
    humidity = dataList[ind]['apiData']['current']['humidity'];
    await mainWeatherIconChanging();
    notifyListeners();
  }

  Future<void> refreshAllFunction(BuildContext context) async {
    final b = ScaffoldMessenger.of(context);
    try {
      if (dataList.length > 1) {
        isRefreshingAll = true;
        notifyListeners();
        for (int i = 1; i < dataList.length; i++) {
          String url =
              'https://api.openweathermap.org/data/3.0/onecall?lat=${dataList[i]['latitude']}&lon=${dataList[i]['longitude']}&appid=5e7ee8b6f949b363109fb9f4f4660b30';
          final data = await http.get(Uri.parse(url));
          if (data.statusCode == 200) {
            final res = jsonDecode(data.body);
            if (kDebugMode) {
              print(res);
            }
            final tmZone = res['timezone_offset'];
            final sunriseSetting = DateTime.fromMillisecondsSinceEpoch(
              (tmZone + res['current']['sunrise']) * 1000,
              isUtc: true,
            );
            final sunsetSetting = DateTime.fromMillisecondsSinceEpoch(
              (tmZone + res['current']['sunset']) * 1000,
              isUtc: true,
            );
            final sunriseConverted = DateFormat(
              'h:mm a',
            ).format(sunriseSetting);
            final sunsetConverted = DateFormat('h:mm a').format(sunsetSetting);
            dataList[i] = {
              ...dataList[i],
              'apiData': (res),
              'tempList': (res['current']['temp'] - 273.15),
              'weatherList': (res['current']['weather'][0]['main']),
              'sunriseHour': sunriseConverted,
              'sunsetHour': sunsetConverted,
            };
          }
        }
        isRefreshingAll = false;
        if(context.mounted) {
        b.showSnackBar(globalBar('All Cities Refreshed', context));
        Navigator.of(context).pop();
        }
        await savingDataToMobile();
      } else {
        if (kDebugMode) print('Cannot refresh');
      }
    } catch (e) {
       if(context.mounted) {
        b.showSnackBar(globalBar('Un-able to refresh', context));
        Navigator.of(context).pop();
        }
      if (kDebugMode) print(e);
      isRefreshingAll = false;
    }
    notifyListeners();
  }

  // making the function for removing the location from the dataset
  void removingLocationDetails(int indexAt) async {
    dataList.removeAt(indexAt);
    await savingDataToMobile();
    notifyListeners();
  }

  // making the function for moving data one index previous if same index matches in Locations List
  void movingOneListBackThenDeletingTheLocation(int index) async {
    changingIndex(0);
    reChangingMainData(indexHelper);
    dataList.removeAt(index);
    await savingDataToMobile();
    notifyListeners();
  }
}
