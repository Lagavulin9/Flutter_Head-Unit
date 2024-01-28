import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    //setPlaylist();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return CustomScrollView(physics: NeverScrollableScrollPhysics(), slivers: [
      CupertinoSliverNavigationBar(
        automaticallyImplyLeading: false,
        largeTitle: Text(
          "Video",
          style: TextStyle(fontSize: 40, color: themeModel.textColor),
        ),
      ),
      SliverFillRemaining(child: Container())
    ]);
  }
}
