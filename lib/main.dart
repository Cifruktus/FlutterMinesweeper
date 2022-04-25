import 'dart:html';

import 'package:flutter/material.dart';
import 'package:minesweeper/desktop/desktop.dart';
import 'package:minesweeper/desktop/icon.dart';
import 'package:minesweeper/minesweeper/view/page.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri githubPage = Uri.parse('https://github.com/Cifruktus/FlutterMinesweeper');

void main() {
  window.document.onContextMenu.listen((evt) => evt.preventDefault());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Desktop(
        desktop: Container(),
        icons:
          [
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
            WinDesktopIcon(
              onPressed: (c) {
                Desktop.of(c).openWindow(MinesweeperWindow(key: UniqueKey()));
              },
              child: Image.asset(
                "assets/icons/mine_logo.png",
                fit: BoxFit.contain,
              ),
              text: "Mine - sweeper 1",
            ),
          ],
      ),
    );
  }
}
