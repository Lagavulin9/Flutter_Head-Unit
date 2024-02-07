import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSelect extends StatelessWidget {
  const ThemeSelect({super.key});

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
                    'assets/images/light_crop.png',
                    width: 280,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Light Mode",
                  style: TextStyle(fontSize: 20, color: themeModel.textColor),
                ),
                const SizedBox(height: 50),
                themeModel.mode == ThemeMode.light
                    ? const Icon(CupertinoIcons.check_mark_circled, size: 30)
                    : const Icon(CupertinoIcons.circle, size: 30)
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
                    'assets/images/dark_crop.png',
                    width: 280,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Dark Mode",
                  style: TextStyle(fontSize: 20, color: themeModel.textColor),
                ),
                const SizedBox(height: 50),
                themeModel.mode == ThemeMode.dark
                    ? const Icon(CupertinoIcons.check_mark_circled, size: 30)
                    : const Icon(CupertinoIcons.circle, size: 30)
              ],
            ),
            onPressed: () => themeModel.setDarkMode(),
          ),
        ],
      ));
    });
  }
}
