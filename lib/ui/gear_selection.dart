import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const TextStyle selectedStyle =
    TextStyle(fontSize: 65, fontWeight: FontWeight.w900, color: Colors.black);
const TextStyle notSelectedStyle = TextStyle(
    fontSize: 55,
    fontWeight: FontWeight.w900,
    color: Color.fromRGBO(0, 0, 0, 0.2));

class GearSelection extends StatefulWidget {
  const GearSelection({super.key});

  @override
  State<GearSelection> createState() => _GearSelection();
}

class _GearSelection extends State<GearSelection> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = 'P';
  }

  void onPressed(var selected_) {
    // TODO : Later add vSomeIP communication here
    setState(() {
      selected = selected_;
    });
  }

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
                onPressed("P");
              }),
          CupertinoButton(
              child: Text("D",
                  style: selected == "D" ? selectedStyle : notSelectedStyle),
              onPressed: () {
                onPressed("D");
              }),
          CupertinoButton(
              child: Text("N",
                  style: selected == "N" ? selectedStyle : notSelectedStyle),
              onPressed: () {
                onPressed("N");
              }),
          CupertinoButton(
              child: Text("R",
                  style: selected == "R" ? selectedStyle : notSelectedStyle),
              onPressed: () {
                onPressed("R");
              }),
        ]));
  }
}
