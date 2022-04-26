import 'dart:html';

import 'package:flutter/material.dart';
import 'package:minesweeper/desktop/desktop.dart';
import 'package:minesweeper/desktop/icon.dart';
import 'package:minesweeper/minesweeper/models/minesweeper_settings.dart';
import 'package:minesweeper/minesweeper/view/page.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri githubPage = Uri.parse('https://github.com/Cifruktus/FlutterMinesweeper');

void main() {
  window.document.onContextMenu.listen((evt) => evt.preventDefault());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    precacheImage(const AssetImage("assets/minesweeper/emoji/smile.png"), context);
    precacheImage(const AssetImage("assets/minesweeper/emoji/panic.png"), context);
    precacheImage(const AssetImage("assets/minesweeper/emoji/won.png"), context);
    precacheImage(const AssetImage("assets/minesweeper/emoji/lost.png"), context);
    precacheImage(const AssetImage("assets/minesweeper/emoji/what.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Desktop(
        desktop: Container(),
        onInitState: (desktop) {
          desktop.openWindow(MinesweeperWindow(key: UniqueKey()));
        },
        icons:
          [
            WinDesktopIcon(
              onPressed: (c) {
                Desktop.of(c).openWindow(MinesweeperWindow(key: UniqueKey()));
              },
              child: Image.asset(
                "assets/icons/mine_logo.png",
                fit: BoxFit.contain,
              ),
              text: "Mine - sweeper",
            ),
          WinDesktopIcon(
            onPressed: (c) {
              Desktop.of(c).openWindow(MinesweeperWindow(
                key: UniqueKey(),
                initalSettings: MinesweeperSettings.hard,
              ));
            },
            child: Image.asset(
              "assets/icons/mine_logo_2.png",
              fit: BoxFit.contain,
            ),
            text: "True mine - sweeper",
          ),
          WinDesktopIcon(
            onPressed: (c) {
              launchUrl(githubPage);
            },
            child: Image.asset(
              "assets/icons/git_logo.png",
              fit: BoxFit.contain,
            ),
            text: "Visit github page.exe",
          ),
        ],
      ),
    );
  }
}
