import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path/path.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final Player player = Player();
  late VideoController controller = VideoController(player);

  List<String> files = [];

  Future<List<String>> loadVideos() async {
    var result =
        await Process.run('find', ['/media', '-type', 'f', '-name', '*.mkv']);
    if (result.exitCode != 0) {
      debugPrint("Error occured");
      return [];
    }
    var stdout = result.stdout as String;
    files = stdout.split('\n');
    if (files.isEmpty || files.last.isEmpty) {
      files.removeLast();
    }
    files.sort();
    return files;
  }

  Future<void> setPlaylist() async {
    await loadVideos();
    final Playlist playlist =
        Playlist(files.map((item) => Media(item)).toList());
    player.open(playlist, play: false);
  }

  @override
  void initState() {
    super.initState();
    player.setPlaylistMode(PlaylistMode.loop);
    //setPlaylist();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const CupertinoSliverNavigationBar(
        automaticallyImplyLeading: false,
        largeTitle: Text("Video"),
      ),
      SliverFillRemaining(
          child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: SizedBox(
              width: 250,
              child: FutureBuilder(
                future: setPlaylist(),
                builder: (context, snapshot) {
                  if (player.state.playlist.medias.isEmpty) {
                    return const CupertinoListSection(
                        header: Text("Error Occured"));
                  } else {
                    return CupertinoListSection.insetGrouped(
                      header: const Text("From device",
                          style: TextStyle(fontSize: 20)),
                      children: List.generate(files.length, (index) {
                        final fileName =
                            basename(player.state.playlist.medias[index].uri);
                        return CupertinoListTile.notched(
                          title: Text(fileName),
                          onTap: () {
                            player.jump(index);
                          },
                        );
                      }),
                    );
                  }
                },
              )),
        ),
        body: Expanded(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Video(width: 640, height: 360, controller: controller),
                StreamBuilder(
                    stream: player.stream.playlist,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Not playing",
                            style: TextStyle(fontSize: 30));
                      }
                      final index = snapshot.data!.index;
                      final fileName =
                          basename(player.state.playlist.medias[index].uri);
                      return SizedBox(
                        width: 640,
                        child: Text(
                          fileName,
                          style: const TextStyle(fontSize: 30),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
        floatingActionButton: CupertinoButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: const Icon(
            CupertinoIcons.list_bullet_below_rectangle,
            size: 50,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ))
    ]);
  }
}
