import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:media_kit/media_kit.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:rxdart/rxdart.dart';

class MetadataWidget extends StatelessWidget {
  const MetadataWidget({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: player.stream.playlist,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Text("No media");
          }
          final List<Media> _playlists = snapshot.data!.medias;
          final int _current_index = snapshot.data!.index;
          final String _selected_file = _playlists[_current_index].uri;
          return FutureBuilder(
              future: MetadataGod.readMetadata(file: _selected_file),
              builder: (context, snapshot) {
                final metadata = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    metadata?.picture == null
                        ? Text("No image")
                        : Image(
                            image: MemoryImage(metadata!.picture!.data),
                            width: 250,
                            height: 250,
                          ),
                    const SizedBox(height: 15),
                    Text(
                      "${metadata?.title ?? 'Unknown Title'}",
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${metadata?.artist ?? 'Unknown Artist'}",
                      style: const TextStyle(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              });
        });
  }
}

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class StreamProgressBar extends StatelessWidget {
  const StreamProgressBar({super.key, required this.player});

  final Player player;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.stream.position,
          player.stream.buffer,
          player.stream.duration,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
        stream: _positionDataStream,
        builder: (context, snapshot) {
          final positionData = snapshot.data;
          return ProgressBar(
            barHeight: 10,
            baseBarColor: Colors.grey[200],
            progressBarColor: Colors.grey[400],
            thumbColor: Colors.grey,
            progress: positionData?.position ?? Duration.zero,
            total: positionData?.duration ?? Duration.zero,
            onSeek: player.seek,
          );
        });
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: player.stream.playing,
        builder: (context, snapshot) {
          final playing = snapshot.data;
          if (!(playing ?? false)) {
            return CupertinoButton(
              onPressed: player.play,
              child: const Icon(
                CupertinoIcons.play_arrow_solid,
                size: 60,
              ),
            );
          } else {
            return CupertinoButton(
              onPressed: player.pause,
              child: const Icon(
                CupertinoIcons.pause_fill,
                size: 60,
              ),
            );
          }
        });
  }
}

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late final Player player = Player();

  final playlist = Playlist([
    Media(
        '/home/jinholee/Downloads/TheFatRat - The Calling (feat. Laura Brehm).mp3'),
    Media('/home/jinholee/media_repo/audios/happy-day.mp3')
  ]);

  @override
  void initState() {
    super.initState();
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
    return FutureBuilder(
        future: player.open(playlist, play: false),
        builder: (context, snapshot) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MetadataWidget(player: player),
                  SizedBox(
                      width: 600,
                      height: 40,
                      child: StreamProgressBar(
                        player: player,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        onPressed: player.previous,
                        child: const Icon(
                          CupertinoIcons.backward_fill,
                          size: 50,
                        ),
                      ),
                      Controls(player: player),
                      CupertinoButton(
                        onPressed: player.next,
                        child: const Icon(
                          CupertinoIcons.forward_fill,
                          size: 50,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
