import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/car_control_provider.dart';
import 'package:provider/provider.dart';

const TextStyle selectedStyle =
    TextStyle(fontSize: 55, fontWeight: FontWeight.w900, color: Colors.black);
const TextStyle notSelectedStyle = TextStyle(
    fontSize: 55,
    fontWeight: FontWeight.w900,
    color: Color.fromRGBO(0, 0, 0, 0.2));

class GearSelection extends StatelessWidget {
  const GearSelection({super.key, required this.selected});

  final String selected;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            const BoxDecoration(color: Color.fromRGBO(0xd9, 0xd9, 0xd9, 1)),
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
