import 'package:flutter/material.dart';

final ThemeData CustomThemeData = new ThemeData(
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.light,
    accentColor: CustomColors.black[500],
    accentColorBrightness: Brightness.light);

class CustomColors {
  CustomColors._(); // this basically makes it so you can instantiate this class

  static const _blackPrimaryValue = 0xFF373435;

  static const MaterialColor black = const MaterialColor(
    _blackPrimaryValue,
    const <int, Color>{
      50: const Color(0xFFe0e0e0),
      100: const Color(0xFFb3b3b3),
      200: const Color(0xFF808080),
      300: const Color(0xFF4d4d4d),
      400: const Color(0xFF262626),
      500: const Color(_blackPrimaryValue),
      600: const Color(0xFF000000),
      700: const Color(0xFF000000),
      800: const Color(0xFF000000),
      900: const Color(0xFF000000),
    },

  );

  static const _appBarPrimaryValue = 0xFFFFA64D;

  static const MaterialColor appBarColor = const MaterialColor(
    _appBarPrimaryValue,
    const <int, Color>{
      12: const Color(0x1FFFA64D),
      26: const Color(0x42FFA64D),
      38: const Color(0x61FFA64D),
      45: const Color(0xFFFFA64D),
      54: const Color(0x8AFFA64D),
      87: const Color(0xDDFFA64D),
    },
  );

//  TODO BACKGROUND COLOR
  static const _backgroundPrimaryValue = 0xFFF8F8F8;

  static const MaterialColor backgroundColor = const MaterialColor(
    _backgroundPrimaryValue,
    const <int, Color>{
      12: const Color(0x1F282E3F),
      26: const Color(0x42282E3F),
      38: const Color(0x61282E3F),
      45: const Color(0xFF282E3F),
      54: const Color(0x8A282E3F),
      87: const Color(0xDD282E3F),
    },
  );

  static const _orangePrimaryValue = 0xFFFFA64D;

  static const MaterialColor orageColor = const MaterialColor(
    _orangePrimaryValue,
    const <int, Color>{
      12: const Color(0x1FFFA64D),
      26: const Color(0x42FFA64D),
      38: const Color(0x61FFA64D),
      45: const Color(0xFFFFA64D),
      54: const Color(0x8AFFA64D),
      87: const Color(0xDDFFA64D),
    },
  );

  static const _BluePrimaryValue = 0xFF69CFF3;

  static const MaterialColor blue = const MaterialColor(
    _BluePrimaryValue,
    const <int, Color>{
      12: const Color(0x1F69CFF3),
      26: const Color(0x4269CFF3),
      38: const Color(0x6169CFF3),
      45: const Color(0xFF69CFF3),
      54: const Color(0x8A69CFF3),
      87: const Color(0xDD69CFF3),
    },
  );

  static const _buttonPrimaryValue = 0xFFFFA64D;

  static const MaterialColor buttonColor = const MaterialColor(
    _buttonPrimaryValue,
    const <int, Color>{
      12: const Color(0x1FFFA64D),
      26: const Color(0x42FFA64D),
      38: const Color(0x61FFA64D),
      45: const Color(0xFFFFA64D),
      54: const Color(0x8AFFA64D),
      87: const Color(0xDDFFA64D),
    },
  );

  static const _progressbarPrimaryValue = 0xFFFFA64D;

  static const MaterialColor progressBar = const MaterialColor(
    _progressbarPrimaryValue,
    const <int, Color>{
      12: const Color(0x1FFFA64D),
      26: const Color(0x42FFA64D),
      38: const Color(0x61FFA64D),
      45: const Color(0xFFFFA64D),
      54: const Color(0x8AFFA64D),
      87: const Color(0xDDFFA64D),
    },
  );

  static const _cyanPrimaryValue = 0xFF00A794;

  static const MaterialColor cyan = const MaterialColor(
    _cyanPrimaryValue,
    const <int, Color>{
      50: const Color(0xFFe0f7fa),
      100: const Color(0xFFb2ebf2),
      200: const Color(0xFF80deea),
      300: const Color(0xFF4dd0e1),
      400: const Color(0xFF26c6da),
      500: const Color(_cyanPrimaryValue),
      600: const Color(0xFF00acc1),
      700: const Color(0xFF0097a7),
      800: const Color(0xFF00838f),
      900: const Color(0xFF006064),
    },
  );


//  TODO FLOATING BUTTON COLOR

  static const _floatingButtonPrimaryValue = 0xFFFFA64D;

  static const MaterialColor floating_button = const MaterialColor(
    _floatingButtonPrimaryValue,
    const <int, Color>{
      12: const Color(0x1FFFA64D),
      26: const Color(0x42FFA64D),
      38: const Color(0x61FFA64D),
      45: const Color(0xFFFFA64D),
      54: const Color(0x8AFFA64D),
      87: const Color(0xDDFFA64D),
    },
  );

}
