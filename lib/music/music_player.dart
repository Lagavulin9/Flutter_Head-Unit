import 'package:flutter/cupertino.dart';
import 'package:flutter_head_unit/music/controler.dart';
import 'package:flutter_head_unit/music/progressbar.dart';
import 'package:flutter_head_unit/music/volume.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:flutter_head_unit/music/album_cover.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlbumCover(player: player),
          SizedBox(
            width: 450,
            height: 50,
            child: StreamProgressBar(player: player),
          ),
          SizedBox(
            width: 600,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  onPressed: player.previous,
                  child: Icon(CupertinoIcons.backward_fill,
                      size: 40, color: themeModel.iconColor),
                ),
                Controls(player: player),
                CupertinoButton(
                  onPressed: player.next,
                  child: Icon(CupertinoIcons.forward_fill,
                      size: 40, color: themeModel.iconColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Volume(player: player)
        ],
      ),
    );
  }
}
