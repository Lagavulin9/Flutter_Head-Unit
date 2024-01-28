import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:flutter_head_unit/ui/music_player.dart';
import 'package:media_kit/media_kit.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:provider/provider.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final Player player = Player();

  List<String> files = [];

  Future<List<String>> loadFiles() async {
    var result = await Process.run('find', [
      '/media/jinholee/1d5e639c-41ca-4cc2-b608-c949797fd1ea/home/team2',
      '-type',
      'f',
      '-name',
      '*.mp3'
    ]);
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
              drawer: Drawer(
                child: SizedBox(
                  width: 250,
                  child: files.isEmpty
                      ? const CupertinoListSection(
                          header: Text(
                          "No media",
                          style: TextStyle(fontSize: 20),
                        ))
                      : SingleChildScrollView(
                          child: CupertinoListSection.insetGrouped(
                            header: Text(
                              "From device",
                              style: TextStyle(color: themeModel.textColor),
                            ),
                            children: List.generate(files.length, (index) {
                              final item = files[index];
                              return FutureBuilder(
                                  future: MetadataGod.readMetadata(file: item),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CupertinoListTile.notched(
                                          title: Text("Reading..."));
                                    } else if (snapshot.hasError ||
                                        !snapshot.hasData) {
                                      return const CupertinoListTile.notched(
                                          title: Text("Error Occurred"));
                                    } else {
                                      final metadata = snapshot.data;
                                      return CupertinoListTile.notched(
                                        leading: metadata?.picture?.data == null
                                            ? Image.asset(
                                                'assets/unknown-album.png')
                                            : Image(
                                                image: MemoryImage(
                                                    metadata!.picture!.data)),
                                        title: Text(
                                          metadata?.title ?? "Unknown Title",
                                          style: TextStyle(
                                              color: themeModel.textColor),
                                        ),
                                        onTap: () {
                                          player.jump(index);
                                        },
                                      );
                                    }
                                  });
                            }).toList(),
                          ),
                        ),
                ),
              ),
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
              body: AudioPlayerScreen(player: player),
            ),
          )
        ]);
  }
}
