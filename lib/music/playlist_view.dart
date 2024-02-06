import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:provider/provider.dart';

class PlaylistView extends StatelessWidget {
  const PlaylistView({super.key, required this.player, required this.files});

  final Player player;
  final List<String> files;

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    // ScrollController를 생성합니다.
    final ScrollController controller = ScrollController();
    return Drawer(
      child: Container(
        color: themeModel.backgroundColor,
        width: 250,
        child: files.isEmpty
            ? const CupertinoListSection(
                header: Text(
                "No media",
                style: TextStyle(fontSize: 20),
              ))
            : GestureDetector(
                onVerticalDragUpdate: (details) {
                  controller.position
                      .jumpTo(controller.position.pixels - details.delta.dy);
                },
                child: SingleChildScrollView(
                  controller: controller,
                  child: CupertinoListSection.insetGrouped(
                    backgroundColor: themeModel.backgroundColor,
                    header: Text(
                      "From device",
                      style: TextStyle(color: themeModel.textColor),
                    ),
                    children: List.generate(files.length, (index) {
                      final item = files[index];
                      return FutureBuilder(
                          future: MetadataGod.readMetadata(file: item),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CupertinoListTile.notched(
                                  title: Text("Reading..."));
                            } else if (snapshot.hasError || !snapshot.hasData) {
                              return const CupertinoListTile.notched(
                                  title: Text("Error Occurred"));
                            } else {
                              final metadata = snapshot.data;
                              return CupertinoListTile.notched(
                                leading: metadata?.picture?.data == null
                                    ? Image.asset(
                                        'assets/images/unknown-album.png')
                                    : Image(
                                        image: MemoryImage(
                                            metadata!.picture!.data)),
                                title: Text(
                                  metadata?.title ?? "Unknown Title",
                                  style: TextStyle(color: themeModel.textColor),
                                ),
                                onTap: () {
                                  player.jump(index);
                                },
                              );
                            }
                          });
                    }).toList(),
                  ),
                ),
              ),
      ),
    );
  }
}
