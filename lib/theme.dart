import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFC56C35);
const Color secondaryColor = Color(0xFF8B0145);

const Color highlightColor = Color(0xDDFFFFFF);
const Color shadowColor = Color(0xDD000000);
const double borderWidth = 2;

const MaterialColor primaryColorSwatch = MaterialColor(0xFFC56C35, <int, Color>{
  50: Color(0xFFF8EDE7),
  100: Color(0xFFEED3C2),
  200: Color(0xFFE2B69A),
  300: Color(0xFFD69872),
  400: Color(0xFFCE8253),
  500: Color(0xFFC56C35),
  600: Color(0xFFBF6430),
  700: Color(0xFFB85928),
  800: Color(0xFFB04F22),
  900: Color(0xFFA33D16),
});

CustomThemeData customThemeData = CustomThemeData(
  primaryColor: primaryColor,
  secondaryColor: secondaryColor,
  windowTitleColor: Color(0xFF010183),
  fillColor: Color(0xFFc4c4c4),
  fillColorDark: Color(0xff979797),
  cardText: TextStyle(
    fontSize: 18,
  ),
  cardTextHighlighted: TextStyle(
    fontSize: 18,
    color: primaryColor,
    fontWeight: FontWeight.bold,
  ),
  homePageMainStatText: TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  homePageStatText: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  cardTitleText: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  elevatedBorder: const Border(
      left: BorderSide(
        color: highlightColor,
        width: borderWidth,
      ),
      top: BorderSide(
        color: highlightColor,
        width: borderWidth,
      ),
      right: BorderSide(
        color: shadowColor,
        width: borderWidth,
      ),
      bottom: BorderSide(
        color: shadowColor,
        width: borderWidth,
      )),
  loweredBorder: Border(
      left: BorderSide(
        color: shadowColor.withAlpha(100),
        width: borderWidth,
      ),
      top: BorderSide(
        color: shadowColor.withAlpha(100),
        width: borderWidth,
      ),
      right: BorderSide(
        color: highlightColor.withAlpha(100),
        width: borderWidth,
      ),
      bottom: BorderSide(
        color: highlightColor.withAlpha(100),
        width: borderWidth,
      )),
);

@immutable
class CustomThemeData {
  final Color primaryColor;
  final Color secondaryColor;
  final Color fillColor;
  final Color fillColorDark;
  final Color windowTitleColor;

  final TextStyle cardText;
  final TextStyle cardTextHighlighted;

  final TextStyle homePageStatText;
  final TextStyle homePageMainStatText;
  final TextStyle cardTitleText;

  final Border elevatedBorder;
  final Border loweredBorder;

  const CustomThemeData({
    required this.cardText,
    required this.cardTextHighlighted,
    required this.primaryColor,
    required this.secondaryColor,
    required this.fillColor,
    required this.fillColorDark,
    required this.windowTitleColor,
    required this.homePageStatText,
    required this.homePageMainStatText,
    required this.cardTitleText,
    required this.elevatedBorder,
    required this.loweredBorder,
  });
}
