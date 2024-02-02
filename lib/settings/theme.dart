import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, themeModel, child) {
      return Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CupertinoButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/unknown-album.png',
                    width: 200,
                    height: 300,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Light Mode",
                  style: TextStyle(fontSize: 20, color: themeModel.textColor),
                ),
                SizedBox(height: 50),
                themeModel.mode == ThemeMode.light
                    ? Icon(CupertinoIcons.check_mark_circled, size: 30)
                    : Icon(CupertinoIcons.circle, size: 30)
              ],
            ),
            onPressed: () => themeModel.setLightMode(),
          ),
          CupertinoButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/unknown-album.png',
                    width: 200,
                    height: 300,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Dark Mode",
                  style: TextStyle(fontSize: 20, color: themeModel.textColor),
                ),
                SizedBox(height: 50),
                themeModel.mode == ThemeMode.dark
                    ? Icon(CupertinoIcons.check_mark_circled, size: 30)
                    : Icon(CupertinoIcons.circle, size: 30)
              ],
            ),
            onPressed: () => themeModel.setDarkMode(),
          ),
        ],
      ));
    });
  }
}
