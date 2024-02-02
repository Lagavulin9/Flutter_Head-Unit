import 'package:flutter/cupertino.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class VideoTitle extends StatelessWidget {
  const VideoTitle({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: player.stream.playlist,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Not playing",
                style: TextStyle(
                    fontSize: 30,
                    color: Provider.of<ThemeModel>(context).textColor));
          }
          final index = snapshot.data!.index;
          final fileName = basename(player.state.playlist.medias[index].uri);
          return SizedBox(
            width: 640,
            child: Text(
              fileName,
              style: const TextStyle(fontSize: 30),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        });
  }
}
