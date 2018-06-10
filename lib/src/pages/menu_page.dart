import 'package:flutter/material.dart';
import 'package:migraine_killer/pages.dart';
import 'package:migraine_killer/routing_assistant.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Migraine killer'),
      ),
      body: GridView.count(
        crossAxisCount: 1,
        children: <Widget>[
          MenuTile(
            'STAI forme  Y-1',
            'assets/anxiety.jpg',
            () => Navigator.push(context, RoutingAssistant.staiPage()),
          ),
          MenuTile(
            'POMS-SF',
            'assets/sleeping.jpg',
            () => Navigator.push(context, RoutingAssistant.pomsPage()),
          ),
        ],
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  final String text;
  final String assetPath;
  final Function navigationFunction;

  MenuTile(this.text, this.assetPath, this.navigationFunction);

  @override
  Widget build(BuildContext context) => GridTile(
        footer: GestureDetector(
          onTap: navigationFunction,
          child: GridTileBar(
            backgroundColor: Colors.black54,
            title: GridTileText(text),
          ),
        ),
        child: GestureDetector(
          onTap: navigationFunction,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              MenuImage(assetPath: assetPath),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.black54, Colors.transparent],
                      begin: FractionalOffset.bottomCenter),
                ),
              ),
            ],
          ),
        ),
      );
}

class GridTileText extends StatelessWidget {
  const GridTileText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.scaleDown,
        alignment: FractionalOffset.centerLeft,
        child: Text(text),
      );
}

class MenuImage extends StatelessWidget {
  final String assetPath;
  final double height;

  const MenuImage({
    @required this.assetPath,
    this.height,
  });

  @override
  Widget build(BuildContext context) => Image(
        image: AssetImage(assetPath),
        fit: BoxFit.cover,
        height: height,
      );
}
