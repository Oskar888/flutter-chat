import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: GoogleFonts.interTextTheme(),
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple, // background (button) color
          foregroundColor: Colors.white, // foreground (text) color
        ),
      ),
    );
  }

//   static ThemeData get darkTheme {
//     return ThemeData(
//       primaryColor: Colors.green,
//       scaffoldBackgroundColor: Colors.white,
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepPurple, // background (button) color
//           foregroundColor: Colors.white, // foreground (text) color
//         ),
//       ),
//     );
//   }
// }
}
