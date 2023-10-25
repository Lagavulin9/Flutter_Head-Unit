import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/ui/music_player.dart';
import 'package:media_kit/media_kit.dart';
import 'package:metadata_god/metadata_god.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final Player player = Player();

  final List<String> files = [
    '/home/jinholee/Downloads/once-in-paris-168895.mp3',
    '/home/jinholee/Downloads/TheFatRat - The Calling (feat. Laura Brehm).mp3',
    '/home/jinholee/media_repo/audios/happy-day.mp3'
  ];

  late final playlist = Playlist(files.map((item) => Media(item)).toList());

  @override
  void initState() {
    super.initState();
    player.open(playlist, play: false);
    player.setPlaylistMode(PlaylistMode.loop);
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const CupertinoSliverNavigationBar(
        automaticallyImplyLeading: false,
        largeTitle: Text("Music"),
      ),
      SliverFillRemaining(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: SizedBox(
              width: 250,
              child: CupertinoListSection.insetGrouped(
                children: List.generate(files.length, (index) {
                  final item = files[index];
                  return FutureBuilder(
                      future: MetadataGod.readMetadata(file: item),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CupertinoListTile.notched(
                              title: Text("Reading..."));
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return const CupertinoListTile.notched(
                              title: Text("Error Occurred"));
                        } else {
                          final metadata = snapshot.data;
                          return CupertinoListTile.notched(
                            leading: metadata?.picture?.data == null
                                ? Image(
                                    image: FileImage(
                                        File('assets/unknown-album.png')))
                                : Image(
                                    image:
                                        MemoryImage(metadata!.picture!.data)),
                            title: Text(metadata?.title ?? "Unknown Title"),
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
          floatingActionButton: CupertinoButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: const Icon(CupertinoIcons.music_note_list,
                  size: 40, color: Colors.black)),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          body: AudioPlayerScreen(player: player),
        ),
      )
    ]);
  }
}
