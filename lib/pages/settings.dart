import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, model, child) {
      Color textColor =
          model.mode == ThemeMode.light ? Colors.black : Colors.white;
      Color backgroundColor = model.mode == ThemeMode.light
          ? const Color.fromRGBO(245, 245, 245, 1)
          : const Color.fromRGBO(60, 60, 60, 1);
      return CupertinoPageScaffold(
        child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                automaticallyImplyLeading: false,
                largeTitle: Text("Settings",
                    style: TextStyle(fontSize: 40, color: textColor)),
              ),
              SliverFillRemaining(
                child: Row(children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: CupertinoListSection.insetGrouped(
                      backgroundColor: backgroundColor,
                      children: [
                        CupertinoListTile.notched(
                          title:
                              Text("Wifi", style: TextStyle(color: textColor)),
                          leading: const Icon(Icons.wifi),
                          onTap: () => debugPrint("Wifi"),
                        ),
                        CupertinoListTile.notched(
                          title: Text("Bluetooth",
                              style: TextStyle(color: textColor)),
                          leading: const Icon(Icons.bluetooth),
                          onTap: () => debugPrint("Bluetooth"),
                        ),
                        CupertinoListTile.notched(
                          title: Text("Display",
                              style: TextStyle(color: textColor)),
                          leading: const Icon(Icons.light_mode_outlined),
                          onTap: () => debugPrint("Display"),
                        ),
                        CupertinoListTile.notched(
                          title:
                              Text("Theme", style: TextStyle(color: textColor)),
                          leading: const Icon(Icons.dark_mode),
                          onTap: () =>
                              Provider.of<ThemeModel>(context, listen: false)
                                  .toggleTheme(),
                        ),
                        CupertinoListTile.notched(
                          title:
                              Text("About", style: TextStyle(color: textColor)),
                          leading: const Icon(Icons.info_outline),
                          onTap: () => debugPrint("About"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Center(child: Text("Add some settings here"))),
                ]),
              )
            ]),
      );
    });
  }
}
