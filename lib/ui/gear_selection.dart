import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/car_control_provider.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class GearSelection extends StatelessWidget {
  const GearSelection({super.key, required this.selected});

  final String selected;

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    const double fontSize = 55;
    const fontWeight = FontWeight.w900;

    TextStyle selectedStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: themeModel.textColor);
    const TextStyle notSelectedStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Color.fromRGBO(0, 0, 0, 0.2));
    return Container(
        decoration: themeModel.mode == ThemeMode.light
            ? BoxDecoration(color: Colors.grey.shade300)
            : BoxDecoration(color: Colors.grey.shade800),
        width: MediaQuery.of(context).size.width * 0.16,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CupertinoButton(
              child: Text("P",
                  style: selected == "P" ? selectedStyle : notSelectedStyle),
              onPressed: () {
                Provider.of<ControlModel>(context, listen: false).setGear("P");
              }),
          CupertinoButton(
              child: Text("R",
                  style: selected == "R" ? selectedStyle : notSelectedStyle),
              onPressed: () {
                Provider.of<ControlModel>(context, listen: false).setGear("R");
              }),
          CupertinoButton(
              child: Text("N",
                  style: selected == "N" ? selectedStyle : notSelectedStyle),
              onPressed: () {
                Provider.of<ControlModel>(context, listen: false).setGear("N");
              }),
          CupertinoButton(
              child: Text("D",
                  style: selected == "D" ? selectedStyle : notSelectedStyle),
              onPressed: () {
                Provider.of<ControlModel>(context, listen: false).setGear("D");
              }),
        ]));
  }
}
