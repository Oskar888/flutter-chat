import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: GoogleFonts.nunitoTextTheme(),
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color.fromARGB(255, 25, 25, 25),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 41, 41, 41),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // background (button) color
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
