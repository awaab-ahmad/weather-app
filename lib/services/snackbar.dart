// here making the snackbar for the data displaying
import 'package:flutter/material.dart';
import 'package:weather/services/styles.dart';

class GlobalBar extends StatelessWidget {
  final String type;
  const GlobalBar({super.key, required this.type});

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      backgroundColor: const Color.fromARGB(113, 0, 0, 0),
      elevation: 0,
      content: Center(child: Text(type, style: Style.standardWhite)),
      behavior: .fixed,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: Radius.circular(20)),
      ),
    );
  }
}

SnackBar globalBar(String type, BuildContext context) {
  return SnackBar(
    backgroundColor: const Color.fromARGB(113, 0, 0, 0),
    elevation: 0,
    content: Center(child: Text(type, style: Style.standardWhite)),
    behavior: .fixed,
    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: .vertical(top: Radius.circular(20)),
    ),
  );
}
