import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoInfo {
  const VideoInfo(this.title, this.url);
  final String title;
  final String url;
}

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  final List<VideoInfo> fromStorage = const [
    VideoInfo('nyancat',
        'https://github.com/Lagavulin9/media_repo/raw/main/videos/chrome_cast.mp4'),
    VideoInfo('chrome_cast',
        'https://github.com/Lagavulin9/media_repo/raw/main/videos/chrome_cast.mp4')
  ];

  final List<VideoInfo> fromServer = const [
    VideoInfo('nyancat',
        'https://github.com/Lagavulin9/media_repo/raw/main/videos/chrome_cast.mp4'),
    VideoInfo('chrome_cast',
        'https://github.com/Lagavulin9/media_repo/raw/main/videos/chrome_cast.mp4'),
    VideoInfo('what',
        'https://github.com/Lagavulin9/media_repo/raw/main/videos/chrome_cast.mp4'),
    VideoInfo('is',
        'https://github.com/Lagavulin9/media_repo/raw/main/videos/chrome_cast.mp4'),
    VideoInfo('this',
        'https://github.com/Lagavulin9/media_repo/raw/main/videos/chrome_cast.mp4'),
    VideoInfo('list',
        'https://github.com/Lagavulin9/media_repo/raw/main/videos/chrome_cast.mp4'),
    VideoInfo('going',
        'https://github.com/Lagavulin9/media_repo/raw/main/videos/chrome_cast.mp4'),
    VideoInfo('to',
        'https://github.com/Lagavulin9/media_repo/raw/main/videos/chrome_cast.mp4'),
    VideoInfo('do',
        'https://github.com/Lagavulin9/media_repo/raw/main/videos/chrome_cast.mp4')
  ];

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final Player player = Player();
  late VideoController controller = VideoController(player);
  String video_title = "";

  @override
  void initState() {
    super.initState();
    video_title = "";
    // Play a [Media] or [Playlist].);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void openVideo(VideoInfo item) {
    player.open(Media(item.url));
    controller = VideoController(player);
    video_title = item.title;
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
              largeTitle: Text("Video", style: TextStyle(fontSize: 40)),
            ),
            SliverFillRemaining(
              child: Row(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CupertinoListSection.insetGrouped(
                          header: const Text("Local Storage"),
                          //header: CupertinoSearchTextField(placeholder: "Search"),
                          children: [
                            ...widget.fromStorage.map((item) {
                              return CupertinoListTile.notched(
                                  title: Text(item.title),
                                  onTap: () {
                                    openVideo(item);
                                  });
                            })
                          ],
                        ),
                        CupertinoListSection.insetGrouped(
                          header: const Text("Media Server"),
                          children: [
                            ...widget.fromServer.map((item) {
                              return CupertinoListTile.notched(
                                  title: Text(item.title),
                                  onTap: () {
                                    openVideo(item);
                                  });
                            })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 40),
                      child: Video(
                          height: MediaQuery.sizeOf(context).height * (9 / 16),
                          controller: controller),
                    ),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            width: MediaQuery.sizeOf(context).width,
                            child: Text(
                              video_title,
                              style: TextStyle(fontSize: 35),
                            )))
                  ]),
                )
              ]),
            )
          ]),
    );
  }
}
