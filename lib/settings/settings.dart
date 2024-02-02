import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:flutter_head_unit/settings/about.dart';
import 'package:flutter_head_unit/settings/theme.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _selected = 0;
  List<Widget> pages = [
    Expanded(child: Center(child: Text("Add some settings here"))),
    ThemeSelect(),
    About(),
  ];
  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final textColor = themeModel.textColor;
    final backgroundColor = themeModel.backgroundColor;
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
                            Text("Display", style: TextStyle(color: textColor)),
                        leading: const Icon(Icons.light_mode_outlined),
                        onTap: () => setState(() {
                          _selected = 0;
                        }),
                      ),
                      CupertinoListTile.notched(
                        title:
                            Text("Theme", style: TextStyle(color: textColor)),
                        leading: const Icon(Icons.dark_mode),
                        onTap: () => setState(() {
                          _selected = 1;
                        }),
                      ),
                      CupertinoListTile.notched(
                        title:
                            Text("About", style: TextStyle(color: textColor)),
                        leading: const Icon(Icons.info_outline),
                        onTap: () => setState(() {
                          _selected = 2;
                        }),
                      ),
                    ],
                  ),
                ),
                pages[_selected],
              ]),
            )
          ]),
    );
  }
}
