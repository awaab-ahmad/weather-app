import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/provider.dart';
import 'package:weather/services/styles.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    final p = context.read<MainProvider>();
    p.controllerAssign();
    p.searchCont!.addListener(() {
      p.onChange();
    });
  }

  @override
  void didChangeDependencies() {
    context.read<MainProvider>().disposing();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
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
                height: sz.height * 1.0,
                width: sz.width * 1.0,
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
                        const Text('Add Location', style: Style.simpleWhite),
                        const Expanded(flex: 2, child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Search Locations to Add',
                      style: Style.standardWhite,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: context.read<MainProvider>().searchCont,
                      onChanged: (value) {
                        context.read<MainProvider>().onChangingSearch();
                      },
                      cursorColor: const Color(0xFFFFFFFF),
                      style: Style.standardWhite,
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
                        hintStyle: Style.standardWhite,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: sz.height * 0.5,
                      child: Card(
                        shadowColor: const Color(0x00000000),
                        clipBehavior: .antiAlias,
                        color: const Color(0x00FFFFFF),
                        child: Selector<MainProvider, bool>(
                          selector: (_, pro) => pro.isSearching,
                          builder: (_, searching, _) {
                            if (searching) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: const Color(0xFFFFFFFF),
                                ),
                              );
                            }
                            return Selector<MainProvider, dynamic>(
                              selector: (_, pro) => pro.data,
                              builder: (_, data, _) => ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  // now making the things to go working perfectly
                                  final ind = data[index]['placePrediction'];
                                  final placeName = ind['text']['text'];
                                  final placeId = ind['placeId'];
                                  return Padding(
                                    padding: const .symmetric(vertical: 2),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: .circular(20),
                                      ),
                                      contentPadding: const .symmetric(
                                        vertical: 1,
                                        horizontal: 5,
                                      ),
                                      tileColor: const Color(0x33FFFFFF),
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
                                        await p.gettingLocationData(placeId);
                                        await p.gettingLocationData(placeId);
                                        await p.gettingDataOfSerachedPlace(
                                          p.lati,
                                          p.longi,
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
                                        style: Style.standardWhite,
                                      ),
                                    ),
                                  );
                                },
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

  final focus = OutlineInputBorder(
    borderSide: BorderSide(color: const Color(0xFFFFFFFF), width: 1.5),
    borderRadius: BorderRadius.circular(25),
  );

  final enabled = OutlineInputBorder(
    borderSide: BorderSide(width: 1.5, color: const Color(0xFFFFFFFF)),
    borderRadius: BorderRadius.circular(20),
  );
}
