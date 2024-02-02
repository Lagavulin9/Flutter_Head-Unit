import 'package:flutter/cupertino.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';

class Volume extends StatelessWidget {
  const Volume({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(CupertinoIcons.volume_mute),
        SizedBox(
          width: 410,
          child: StreamBuilder(
              stream: player.stream.volume,
              builder: (context, snapshot) {
                final volume = snapshot.data ?? 50;
                return CupertinoSlider(
                    min: 0,
                    max: 100,
                    value: volume,
                    onChanged: (volume) {
                      player.setVolume(volume);
                    },
                    activeColor: Provider.of<ThemeModel>(context).sliderColor);
              }),
        ),
        const Icon(CupertinoIcons.volume_up)
      ],
    );
  }
}
