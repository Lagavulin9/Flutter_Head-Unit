import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:rxdart/rxdart.dart';

class MetadataWidget extends StatelessWidget {
  const MetadataWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.artist});

  final Widget image;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, offset: Offset(2, 4), blurRadius: 4)
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: image,
          ),
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          artist,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10)
      ],
    );
  }
}

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
        stream: audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;
          if (!(playing ?? false)) {
            return IconButton(
              onPressed: audioPlayer.play,
              icon: const Icon(Icons.play_arrow_rounded),
              iconSize: 60,
            );
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
              onPressed: audioPlayer.pause,
              icon: const Icon(Icons.pause_rounded),
              iconSize: 60,
            );
          }
          return const Icon(
            Icons.play_arrow_rounded,
            size: 60,
          );
        });
  }
}

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;
  bool isShuffleEnabled = false;
  LoopMode loopmode = LoopMode.all;

  Future<void> _loadAudioSources() async {
    // Load metadata and create audio sources asynchronously.
    var firstAudioMetadata = await MetadataGod.readMetadata(
        file: '/home/jinholee/media_repo/audios/happy-day.mp3');
    var secondAudioMetadata = await MetadataGod.readMetadata(
        file:
            '/home/jinholee/Downloads/TheFatRat - The Calling (feat. Laura Brehm).mp3');

    // Construct AudioSource objects after metadata is loaded.
    _playlist = ConcatenatingAudioSource(children: [
      AudioSource.file(
        '/home/jinholee/media_repo/audios/happy-day.mp3',
        tag: firstAudioMetadata, // this is now a Metadata object, not a Future
      ),
      AudioSource.file(
        '/home/jinholee/Downloads/TheFatRat - The Calling (feat. Laura Brehm).mp3',
        tag: secondAudioMetadata, // Metadata object
      ),
    ]);
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  void onShuffle() async {
    isShuffleEnabled = !isShuffleEnabled;
    await _audioPlayer.setShuffleModeEnabled(isShuffleEnabled);
    setState(() {});
  }

  void onLoop() async {
    switch (loopmode) {
      case LoopMode.all:
        loopmode = LoopMode.one;
        break;
      case LoopMode.one:
        loopmode = LoopMode.off;
        break;
      case LoopMode.off:
        loopmode = LoopMode.all;
        break;
      default:
        loopmode = LoopMode.all;
    }
    await _audioPlayer.setLoopMode(loopmode);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    await _loadAudioSources();
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playlist);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: _audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox();
              }
              final metadata = state!.currentSource!.tag as Metadata;
              Widget image = const Text("No picture");
              if (metadata.picture != null) {
                image = Image(
                  width: 250,
                  height: 250,
                  image: MemoryImage(metadata.picture!.data),
                  fit: BoxFit.cover,
                );
              }
              return MetadataWidget(
                image: image,
                title: metadata.title ?? "Unknown Soundtrack",
                artist: metadata.artist ?? "Unknown Artist",
              );
            }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 170),
          child: StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  barHeight: 10,
                  baseBarColor: Colors.grey[200],
                  bufferedBarColor: Colors.grey[200],
                  progressBarColor: Colors.grey[400],
                  thumbColor: Colors.grey,
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: _audioPlayer.seek,
                );
              }),
        ),
        SizedBox(
          width: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: onShuffle,
                icon: isShuffleEnabled
                    ? const Icon(Icons.shuffle_on_rounded)
                    : const Icon(Icons.shuffle_rounded),
                iconSize: 50,
              ),
              IconButton(
                onPressed: _audioPlayer.seekToPrevious,
                icon: const Icon(Icons.skip_previous_rounded),
                iconSize: 50,
              ),
              Controls(audioPlayer: _audioPlayer),
              IconButton(
                onPressed: _audioPlayer.seekToPrevious,
                icon: const Icon(Icons.skip_next_rounded),
                iconSize: 50,
              ),
              IconButton(
                onPressed: onLoop,
                icon: loopmode == LoopMode.all
                    ? const Icon(Icons.loop_rounded)
                    : loopmode == LoopMode.one
                        ? const Icon(Icons.looks_one_rounded)
                        : const Icon(Icons.stop_rounded),
                iconSize: 50,
              ),
            ],
          ),
        )
      ],
    )));
  }
}
