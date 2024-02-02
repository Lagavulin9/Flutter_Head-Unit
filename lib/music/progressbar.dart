import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:rxdart/rxdart.dart';

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
