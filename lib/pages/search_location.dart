import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:weather/services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:weather/services/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String googlePlacesApi = "// not visible";
  TextEditingController controller = TextEditingController();
  var uuid = const Uuid().v4();
  List data = [];
  double lati = 0.0;
  double longi = 0.0;
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      _onChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0x00000000),
        body: Stack(
          children: [
            Opacity(
              opacity: 0.7,
              child: Image.asset(
                'images/search_page.jpg',
                height: h * 1.0,
                width: w * 1.0,
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 08),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const SizedBox(height: 05),
                    Row(
                      mainAxisAlignment: .start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: const Color(0xffffffff),
                          ),
                        ),
                        const Expanded(flex: 2, child: SizedBox()),
                        text('Add Location', 16, FontWeight.w600),
                        const Expanded(flex: 2, child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    text('Search Locations to Add', 14, FontWeight.w500),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller,
                      onChanged: (value) {
                        setState(() {
                          if (controller.text.trim().isEmpty) {
                            data = [];
                          }
                        });
                      },
                      cursorColor: const Color(0xFFFFFFFF),
                      style: style(14, FontWeight.w600),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 08,
                          vertical: 0,
                        ),
                        focusedBorder: focus,
                        enabledBorder: enabled,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Image.asset(
                            'images/location.png',
                            height: 15,
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),
                        hintText: 'Search Place',
                        hintStyle: style(12, FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: h * 0.4,
                      width: w * 1.0,
                      child: Card(
                        color: const Color(0x33FFFFFF),
                        child: data.isEmpty
                            ? Center(
                                child: text(
                                  'Search something ',
                                  10,
                                  FontWeight.w500,
                                ),
                              )
                            : ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  // now making the things to go working perfectly
                                  final ind = data[index]['placePrediction'];
                                  final placeName = ind['text']['text'];
                                  final placeId = ind['placeId'];
                                  return ListTile(
                                    onTap: () async {
                                      final p = context.read<MainProvider>();
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => Center(
                                          child: CircularProgressIndicator(
                                            color: const Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      );
                                      await gettingLocationData(placeId);
                                      await p.gettingDataOfSerachedPlace(
                                        lati,
                                        longi,
                                        // ignore: use_build_context_synchronously
                                        context,
                                      );
                                    },
                                    leading: Icon(
                                      Icons.location_on,
                                      color: const Color(0xFFFFFFFF),
                                      size: 30,
                                    ),
                                    title: Text(
                                      placeName,
                                      style: style(12, FontWeight.w600),
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
          ],
        ),
      ),
    );
  }

  TextStyle style(double s, FontWeight fw) {
    return GoogleFonts.poppins(
      fontSize: s,
      fontWeight: fw,
      color: const Color(0xFFFFFFFF),
    );
  }

  final focus = OutlineInputBorder(
    borderSide: BorderSide(color: const Color(0xFFFFFFFF), width: 1.5),
    borderRadius: BorderRadius.circular(25),
  );

  final enabled = OutlineInputBorder(
    borderSide: BorderSide(width: 1.5, color: const Color(0xFFFFFFFF)),
    borderRadius: BorderRadius.circular(20),
  );

  void _onChange() {
    if (controller.text.trim().isNotEmpty) {
      predictionFunction(controller.text.trim());
    }
  }

  // making the function here for the working
  void predictionFunction(String input) async {
    String baseUrl = 'https://places.googleapis.com/v1/places:autocomplete';
    // now making the working of implementation
    try {
      final structure = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': googlePlacesApi,
        },
        body: jsonEncode({'input': input, 'sessionToken': uuid}),
      );
      if (structure.statusCode == 200) {
        final response = json.decode(structure.body);
        setState(() {
          data = response['suggestions'];
        });
      } else {
        if (kDebugMode) {
          print('Unable to implement');
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  // making the function for the displaying of the data
  Future gettingLocationData(String placeId) async {
    try {
      lati = 0.0;
      longi = 0.0;
      String url = 'https://places.googleapis.com/v1/places/$placeId';
      final format = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': googlePlacesApi,
          'X-Goog-FieldMask': 'name,displayName,location',
        },
      );
      if (kDebugMode) print(format.statusCode);
      if (format.statusCode == 200) {
        final response = json.decode(format.body);
        if (kDebugMode) print(response);
        setState(() {
          lati = response['location']['latitude'];
          longi = response['location']['longitude'];
        });
      } else {
        if (kDebugMode) print('Unable to get it done');
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
