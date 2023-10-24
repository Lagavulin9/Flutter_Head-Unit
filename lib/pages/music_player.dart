import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/ui/music_player.dart';

class MusicInfo {
  const MusicInfo(this.title, this.url);
  final String title;
  final String url;
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void open_media(MusicInfo item) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            const CupertinoSliverNavigationBar(
              automaticallyImplyLeading: false,
              largeTitle: Text("Music", style: TextStyle(fontSize: 40)),
            ),
            SliverFillRemaining(
              child: Row(children: [AudioPlayerScreen()]),
            )
          ]),
    );
  }
}
