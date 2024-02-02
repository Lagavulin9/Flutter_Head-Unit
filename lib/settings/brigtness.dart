import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class BrightnessControl extends StatefulWidget {
  const BrightnessControl({super.key});

  @override
  State<BrightnessControl> createState() => _BrightnessControlState();
}

class _BrightnessControlState extends State<BrightnessControl> {
  final SETTING_FILE_DIR = "/sys/waveshare/rpi_backlight/brightness";
  double brightness = 180;

  Future<double> readBrightness() async {
    var result = await Process.run('cat', ['$SETTING_FILE_DIR']);
    if (result.exitCode != 0) {
      debugPrint("Error occured: ${result.exitCode}");
      debugPrint(result.stderr);
      return 180;
    }
    var stdout = result.stdout as String;
    return double.parse(stdout);
  }

  Future<void> wrightBrightness(double brightness) async {
    Process.run('echo', ['${brightness.toString()} > $SETTING_FILE_DIR']);
  }

  @override
  void initState() {
    super.initState();
    readBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, theme, child) => Expanded(
              child: CupertinoListSection.insetGrouped(
                header: Text(
                  "Brightness",
                  style: TextStyle(color: theme.textColor),
                ),
                children: [
                  CupertinoListTile.notched(
                      title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(CupertinoIcons.sun_min_fill, size: 30),
                      SizedBox(
                        width: 400,
                        height: 40,
                        child: CupertinoSlider(
                            min: 0,
                            max: 255,
                            value: brightness,
                            onChanged: (value) {
                              setState(() {
                                brightness = value;
                              });
                              debugPrint(value.toString());
                            }),
                      ),
                      const Icon(CupertinoIcons.brightness_solid, size: 30)
                    ],
                  ))
                ],
              ),
            ));
  }
}
