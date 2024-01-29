import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_elinux/video_player_elinux.dart';
import 'package:provider/provider.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  State<VideoApp> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  List<String> files = [];

  Future<List<String>> loadVideos() async {
    var result = await Process.run('find', [
      '/media/jinholee/1d5e639c-41ca-4cc2-b608-c949797fd1ea/home/team2',
      '-type',
      'f',
      '-name',
      '*.mkv'
    ]);
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
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
              "Video",
              style: TextStyle(fontSize: 40, color: themeModel.textColor),
            ),
          ),
          SliverFillRemaining(
            child: Scaffold(
              body: Column(
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: 600,
                      height: 400,
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  VideoPlayer(_controller),
                                  _ControlsOverlay(controller: _controller),
                                  VideoProgressIndicator(
                                    _controller,
                                    allowScrubbing: true,
                                    padding: const EdgeInsets.only(top: 40),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 600,
                    child: Text(
                      basename(_controller.dataSource),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
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
              drawer: SizedBox(
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
                            return CupertinoListTile.notched(
                              title: Text(item),
                              onTap: () {
                                _controller.dispose();
                                _controller =
                                    VideoPlayerController.file(File(item));
                                _controller.initialize().then((_) {
                                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                  setState(() {});
                                });
                                _controller.addListener(() {
                                  setState(() {});
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
              ),
              key: _scaffoldKey,
            ),
          )
        ]);
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
