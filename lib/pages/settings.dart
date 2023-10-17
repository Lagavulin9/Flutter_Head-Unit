import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(slivers: [
        const CupertinoSliverNavigationBar(
          automaticallyImplyLeading: false,
          largeTitle: Text("Settings", style: TextStyle(fontSize: 40)),
        ),
        SliverFillRemaining(
          child: Row(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: CupertinoListSection.insetGrouped(
                backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
                children: [
                  CupertinoListTile.notched(
                    title: const Text("Wifi"),
                    leading: const Icon(Icons.wifi),
                    onTap: () => debugPrint("Wifi"),
                  ),
                  CupertinoListTile.notched(
                    title: const Text("Bluetooth"),
                    leading: const Icon(Icons.bluetooth),
                    onTap: () => debugPrint("Bluetooth"),
                  ),
                  CupertinoListTile.notched(
                    title: const Text("Display"),
                    leading: const Icon(Icons.light_mode_outlined),
                    onTap: () => debugPrint("Display"),
                  ),
                  CupertinoListTile.notched(
                    title: const Text("Theme"),
                    leading: const Icon(Icons.dark_mode),
                    onTap: () => debugPrint("Theme"),
                  ),
                  CupertinoListTile.notched(
                    title: const Text("About"),
                    leading: const Icon(Icons.info_outline),
                    onTap: () => debugPrint("About"),
                  ),
                ],
              ),
            ),
            Expanded(child: Center(child: Text("Add some settings here"))),
          ]),
        )
      ]),
    );
  }
}
