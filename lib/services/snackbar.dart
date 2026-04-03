// here making the snackbar for the data displaying
import 'package:flutter/material.dart';
import 'package:weather/services/globals.dart';

SnackBar globalBar(String type, BuildContext context) {
  return SnackBar(
    backgroundColor: const Color.fromARGB(113, 0, 0, 0),
    elevation: 0,
    content: Center(child: text(type, 12, FontWeight.w600)),
    behavior: .fixed,   
    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),    
    shape: RoundedRectangleBorder(borderRadius: .vertical(top: Radius.circular(20))),
  );
}
