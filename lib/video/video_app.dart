import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:flutter_head_unit/video/video_title.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  State<VideoApp> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
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
    final themeModel = Provider.of<ThemeModel>(context);
    final ScrollController scrollController = ScrollController();
    return CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            automaticallyImplyLeading: false,
            largeTitle: Text(
              "Video",
              style: TextStyle(fontSize: 40, color: themeModel.textColor),
            ),
          ),
          SliverFillRemaining(
              child: Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              child: Container(
                color: themeModel.backgroundColor,
                child: FutureBuilder(
                  future: setPlaylist(),
                  builder: (context, snapshot) {
                    if (player.state.playlist.medias.isEmpty) {
                      return const CupertinoListSection(
                          header: Text("Error Occured"));
                    } else {
                      return GestureDetector(
                        onVerticalDragUpdate: (details) {
                          scrollController.position.jumpTo(
                            scrollController.position.pixels -
                                details.primaryDelta!,
                          );
                        },
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: CupertinoListSection.insetGrouped(
                            backgroundColor: themeModel.backgroundColor,
                            header: Text("From device",
                                style: TextStyle(
                                    fontSize: 20, color: themeModel.textColor)),
                            children: List.generate(files.length, (index) {
                              final fileName = basename(
                                  player.state.playlist.medias[index].uri);
                              return CupertinoListTile.notched(
                                title: Text(fileName,
                                    style:
                                        TextStyle(color: themeModel.textColor)),
                                onTap: () {
                                  player.jump(index);
                                },
                              );
                            }),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            body: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  MaterialVideoControlsTheme(
                    normal: const MaterialVideoControlsThemeData(
                        volumeGesture: true,
                        bottomButtonBar: [MaterialPositionIndicator()]),
                    fullscreen: const MaterialVideoControlsThemeData(),
                    child: Video(
                      width: 640,
                      height: 360,
                      controller: controller,
                      controls: MaterialVideoControls,
                    ),
                  ),
                  VideoTitle(player: player)
                ],
              ),
            ),
            floatingActionButton: CupertinoButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Icon(
                CupertinoIcons.list_bullet_below_rectangle,
                size: 50,
                color: themeModel.iconColor,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
          ))
        ]);
  }
}
