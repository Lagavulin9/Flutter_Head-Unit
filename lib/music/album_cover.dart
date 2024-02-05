import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/commonAPI.dart';
import 'package:media_kit/media_kit.dart';
import 'package:metadata_god/metadata_god.dart';

class AlbumCover extends StatelessWidget {
  AlbumCover({super.key, required this.player});
  final CommonAPI bridge = CommonAPI();

  final Player player;
  final Widget default_image = DecoratedBox(
    decoration: BoxDecoration(boxShadow: const [
      BoxShadow(color: Colors.black12, offset: Offset(2, 4), blurRadius: 4)
    ], borderRadius: BorderRadius.circular(10)),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        'assets/unknown-album.png',
        width: 200,
        height: 200,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: player.stream.playlist,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Column(
              children: [
                default_image,
                const SizedBox(height: 15),
                const Text(
                  "Not Playing",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 40)
              ],
            );
          }
          final List<Media> _playlists = snapshot.data!.medias;
          final int _current_index = snapshot.data!.index;
          final String _selected_file = _playlists[_current_index].uri;
          return FutureBuilder(
              future: MetadataGod.readMetadata(file: _selected_file),
              builder: (context, snapshot) {
                final metadata = snapshot.data;
                final Uint8List rawImage =
                    metadata?.picture?.data ?? Uint8List(0);
                final String artist = metadata?.artist ?? "Unknown Artist";
                final String title = metadata?.title ?? "Unknown Title";
                bridge.setMetaData(rawImage, artist, title);
                final Widget AlbumCover = metadata?.picture == null
                    ? default_image
                    : DecoratedBox(
                        decoration: BoxDecoration(boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(2, 4),
                              blurRadius: 4)
                        ], borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: MemoryImage(metadata!.picture!.data),
                            width: 200,
                            height: 200,
                          ),
                        ),
                      );
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AlbumCover,
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
                    const SizedBox(height: 20)
                  ],
                );
              });
        });
  }
}
