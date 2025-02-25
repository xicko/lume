import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'Plus Jakarta Sans',
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
        //contentPadding: EdgeInsets.all(0),
        ),
    menuStyle: MenuStyle(
      padding: WidgetStateProperty.all(
        EdgeInsets.all(0),
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.blue[100],
    thumbColor: const Color.fromARGB(255, 69, 145, 215),
    inactiveTrackColor: Colors.grey[300],
    overlayColor: const Color.fromRGBO(33, 150, 243, 0.2),
  ),
);
