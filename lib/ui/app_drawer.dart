import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(children: [
        Container(
            width: 250,
            height: 100,
            margin: const EdgeInsets.only(bottom: 10),
            color: const Color.fromRGBO(0xd9, 0xd9, 0xd9, 1),
            child: const Center(
              child: Text("SEA:ME", style: TextStyle(fontSize: 25)),
            )),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                  leading: const Icon(Icons.music_note, size: 30),
                  title: const Text(
                    "Music",
                    style: TextStyle(fontSize: 30),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: const Icon(Icons.movie, size: 30),
                  title: const Text(
                    "Video",
                    style: TextStyle(fontSize: 30),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: const Icon(Icons.time_to_leave, size: 30),
                  title: const Text(
                    "Car Info",
                    style: TextStyle(fontSize: 30),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: const Icon(Icons.settings, size: 30),
                  title: const Text(
                    "Settings",
                    style: TextStyle(fontSize: 30),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        )
      ]),
    );
  }
}
