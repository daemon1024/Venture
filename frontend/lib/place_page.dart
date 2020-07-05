import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayRoute extends StatefulWidget {
  final facts;
  final String sound;
  const PlayRoute({
    Key key,
    this.sound,
    this.facts,
  }) : super(key: key);
  @override
  _PlayRouteState createState() => _PlayRouteState();
}

class _PlayRouteState extends State<PlayRoute> {
  AudioPlayer player;
  AudioCache cache;
  bool initialPlay = true;
  bool playing;

  @override
  initState() {
    super.initState();

    player = new AudioPlayer();
    cache = new AudioCache(fixedPlayer: player);
  }

  @override
  dispose() {
    super.dispose();
    player.stop();
  }

  playPause(sound) {
    if (initialPlay) {
      print("-------------------------------------------");
      print(sound);
      print(widget.facts);
      cache.play('audio/$sound.mp3');
      playing = true;
      initialPlay = false;
    }
    return IconButton(
      color: Colors.white70,
      iconSize: 80.0,
      icon: playing ? Icon(Icons.pause_circle_filled) : Icon(Icons.play_circle_filled),
      onPressed: () {
        setState(() {
          if (playing) {
            playing = false;
            player.pause();
          } else {
            playing = true;
            player.resume();
          }
        });
      },
    );
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Stack(
        children: [
          Background(
            sound: widget.sound,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Center(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.facts[0]["place"],
                          style: TextStyle(
                              fontSize: 35.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          widget.facts[0]["country"],
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  playPause(widget.sound),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Opacity(
                        opacity: 0.75,
                        child: Card(
                          margin: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              widget.facts[0]["facts"][index],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: 3,
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height - 120,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    //  left: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return CardAttraction(img: widget.facts[0]["links"][index]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Background extends StatefulWidget {
  final String sound;
  const Background({Key key, this.sound}) : super(key: key);
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  Timer timer;
  bool _visible = false;

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  swap() {
    if (mounted) {
      setState(() {
        _visible = !_visible;
      });
    }
  }

  final img = 'assets/images/';
  @override
  build(BuildContext context) {
    timer = Timer(Duration(seconds: 6), swap);
    return Stack(
      children: [
        Container(
          padding: MediaQuery.of(context).padding,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(img + widget.sound + '_1.jpg'), fit: BoxFit.cover),
          ),
        ),
        AnimatedOpacity(
            child: Container(
              padding: MediaQuery.of(context).padding,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(img + widget.sound + '_2.jpg'), fit: BoxFit.cover),
              ),
            ),
            duration: Duration(seconds: 2),
            opacity: _visible ? 1.0 : 0.0)
      ],
    );
  }
}

class CardAttraction extends StatelessWidget {
  final String img;

  CardAttraction({this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      margin: EdgeInsets.only(right: 20.0),
      padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white),
        image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
      ),
    );
  }
}
