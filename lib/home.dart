import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tiled/tiled.dart' as tiled;

import 'adventure.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Adventure adventure;
  late tiled.ImageLayer ground;
  @override
  void initState() {
    adventure = Adventure();
    // ground =

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF211F30),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameWidget(game: adventure),
              ),
            );
          },
          child: Text("Start"),
        ),
      ),
      // body: ListView(
      //   children: [
      //     //tiled.TiledMap(width: width, height: height, tileWidth: tileWidth, tileHeight: tileHeight)(),
      //     Center(
      //       child: ElevatedButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => GameWidget(game: adventure),
      //             ),
      //           );
      //         },
      //         child: Text("Start"),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
