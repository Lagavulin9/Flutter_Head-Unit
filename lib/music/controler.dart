import 'package:flutter/cupertino.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return StreamBuilder(
        stream: player.stream.playing,
        builder: (context, snapshot) {
          final playing = snapshot.data;
          if (!(playing ?? false)) {
            return CupertinoButton(
              onPressed: player.play,
              child: Icon(CupertinoIcons.play_arrow_solid,
                  size: 50, color: themeModel.iconColor),
            );
          } else {
            return CupertinoButton(
              onPressed: player.pause,
              child: Icon(CupertinoIcons.pause_fill,
                  size: 50, color: themeModel.iconColor),
            );
          }
        });
  }
}
