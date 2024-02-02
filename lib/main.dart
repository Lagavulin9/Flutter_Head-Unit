import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_head_unit/provider/app_controller.dart';
import 'package:flutter_head_unit/provider/car_control_provider.dart';
import 'package:flutter_head_unit/provider/commonAPI.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:flutter_head_unit/common/app_drawer.dart';
import 'package:flutter_head_unit/common/clock.dart';
import 'package:flutter_head_unit/common/gear_selection.dart';
import 'package:media_kit/media_kit.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:provider/provider.dart';

const double displayWidth = 1024;
const double displayHeight = 600;

void _initMetaData() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  MetadataGod.initialize();
  ByteData data = await rootBundle.load('assets/unknown-album.png');
  Uint8List bytes = data.buffer.asUint8List();
  CommonAPI bridge = CommonAPI();
  bridge.setMetaData(bytes, "Not Playing", "");
}

void main() async {
  _initMetaData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppController>(
              create: (context) => AppController()),
          ChangeNotifierProvider<ControlModel>(
              create: (context) => ControlModel()),
          ChangeNotifierProvider(create: (context) => ThemeModel())
        ],
        child: Consumer<ThemeModel>(
            builder: (context, model, child) => MaterialApp(
                  title: 'Head Unit',
                  theme: ThemeData(
                    colorScheme:
                        const ColorScheme.light(background: Colors.white),
                    textTheme: Typography.blackCupertino.copyWith(
                        labelMedium: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400)),
                    scaffoldBackgroundColor: Colors.white,
                    drawerTheme: const DrawerThemeData(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white),
                    useMaterial3: true,
                  ),
                  darkTheme: ThemeData(
                    colorScheme: const ColorScheme.dark(),
                    textTheme: Typography.whiteCupertino.copyWith(
                        labelMedium: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800)),
                    scaffoldBackgroundColor: Colors.black,
                    useMaterial3: true,
                  ),
                  themeMode: model.mode,
                  home: const MyHomePage(title: 'Head Unit'),
                  debugShowCheckedModeBanner: false,
                )));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: CupertinoButton(
        child: Icon(
          CupertinoIcons.ellipsis_vertical,
          color: Provider.of<ThemeModel>(context).iconColor,
          size: 60,
        ),
        onPressed: () {
          debugPrint("button");
          _scaffoldKey.currentState!.openEndDrawer();
        },
      ),
      endDrawer: const AppDrawer(),
      body: Row(children: [
        Consumer<ControlModel>(
          builder: (context, value, child) =>
              GearSelection(selected: value.gear),
        ),
        Expanded(
            child: Stack(
          children: [
            Center(child:
                Consumer<AppController>(builder: (context, controller, child) {
              return controller.currentPage;
            })),
            const Positioned(top: 15, right: 20, child: Clock(size: 20))
          ],
        ))
      ]),
    );
  }
}
