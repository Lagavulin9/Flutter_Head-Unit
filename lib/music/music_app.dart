import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/music/music_player.dart';
import 'package:flutter_head_unit/music/playlist_view.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final Player player = Player();

  List<String> files = [];

  Future<List<String>> loadFiles() async {
    var result = await Process.run(
        'find', ['/home/jinholee/Music', '-type', 'f', '-name', '*.mp3']);
    if (result.exitCode != 0) {
      debugPrint("Error occured: ${result.exitCode}");
      debugPrint(result.stderr);
      return [];
    }
    var stdout = result.stdout as String;
    files = stdout.split('\n');
    if (files.isNotEmpty && files.last.isEmpty) {
      files.removeLast();
    }
    files.sort();
    return files;
  }

  Future<void> setPlaylist() async {
    await loadFiles();
    final Playlist playlist =
        Playlist(files.map((item) => Media(item)).toList());
    player.open(playlist, play: false);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setPlaylist();
    player.setPlaylistMode(PlaylistMode.loop);
    player.setVolume(50);
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            automaticallyImplyLeading: false,
            largeTitle: Text(
              "Music",
              style: TextStyle(fontSize: 40, color: themeModel.textColor),
            ),
          ),
          SliverFillRemaining(
            child: Scaffold(
              key: _scaffoldKey,
              drawer: PlaylistView(player: player, files: files),
              floatingActionButton: CupertinoButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Icon(
                    CupertinoIcons.music_note_list,
                    size: 50,
                    color: themeModel.iconColor,
                  )),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startFloat,
              body: MusicPlayer(player: player),
            ),
          )
        ]);
  }
}
