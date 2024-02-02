import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/music/music_app.dart';
import 'package:flutter_head_unit/pages/car_info.dart';
import 'package:flutter_head_unit/settings/settings.dart';
import 'package:flutter_head_unit/video/video_app.dart';
import 'package:flutter_head_unit/provider/app_controller.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return Drawer(
      width: 250,
      child: Column(children: [
        Container(
            width: 250,
            height: 100,
            margin: const EdgeInsets.only(bottom: 10),
            color: themeModel.mode == ThemeMode.light
                ? const Color.fromRGBO(0xd9, 0xd9, 0xd9, 1)
                : Colors.grey.shade800,
            child: const Center(
              child: Text("SEA:ME",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
            )),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                  leading:
                      const Icon(CupertinoIcons.double_music_note, size: 30),
                  title: const Text(
                    "Music",
                    style: TextStyle(fontSize: 30),
                  ),
                  onTap: () {
                    Provider.of<AppController>(context, listen: false)
                        .updatePage(MusicApp());
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: const Icon(Icons.movie, size: 30),
                  title: const Text(
                    "Video",
                    style: TextStyle(fontSize: 30),
                  ),
                  onTap: () {
                    Provider.of<AppController>(context, listen: false)
                        .updatePage(VideoApp());
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: const Icon(CupertinoIcons.car_detailed, size: 30),
                  title: const Text(
                    "Car Info",
                    style: TextStyle(fontSize: 30),
                  ),
                  onTap: () {
                    Provider.of<AppController>(context, listen: false)
                        .updatePage(CarInfo());
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: const Icon(CupertinoIcons.gear_alt_fill, size: 30),
                  title: const Text(
                    "Settings",
                    style: TextStyle(fontSize: 30),
                  ),
                  onTap: () {
                    Provider.of<AppController>(context, listen: false)
                        .updatePage(Settings());
                    Navigator.pop(context);
                  })
            ],
          ),
        )
      ]),
    );
  }
}
