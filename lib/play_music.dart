// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'models/music.dart';

class PlayMusic extends StatefulWidget {
  final Music? allMusic;

  PlayMusic({this.allMusic});

  @override
  _PlayMusicState createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> {
  IconData btnIcon = Icons.play_arrow;
  var bgColor = const Color(0xFF03174C);
  var iconHoverColor = const Color(0xFF065BC3);

  BannerAd? _bannerAd;
  bool _bannerisLoaded = false;

  late AudioPlayer audioPlayer;
  late AudioCache audioCache;
  Duration duration = Duration();
  Duration position = Duration();
  bool playing = false;
  String? localPath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-2452889629536861/3021039804',
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          _bannerisLoaded = true;
        });
        print("Banner Loaded.");
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),
      request: AdRequest(),
    );
    _bannerAd!.load();
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.onDurationChanged.listen((Duration dd) {
      setState(() {
        duration = dd;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration dd) {
      setState(() {
        position = dd;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF03174C),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 10,
                  child: Container(
                    height: 500.0,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  widget.allMusic!.imgSrc.toString()),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [bgColor.withOpacity(0.4), bgColor],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 52.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (playing == true) {
                                        audioPlayer.pause();

                                        setState(() {
                                          playing = false;
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(50.0)),
                                      child: Icon(
                                        Icons.home,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Çocuk Şarkıları',
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.6)),
                                      ),
                                      Text('En Güzel Çocuk Şarkıları',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  Icon(
                                    Icons.playlist_add,
                                    color: Colors.white,
                                    size: 35,
                                  )
                                ],
                              ),
                              Spacer(),
                              Text(widget.allMusic!.name.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0)),
                              SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                widget.allMusic!.sure.toString(),
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 18.0),
                              ),
                              SizedBox(height: 16.0),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Slider.adaptive(
                      activeColor: Colors.black,
                      inactiveColor: Colors.blue,
                      min: 0.0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      onChanged: (double value) {
                        audioPlayer.seek(Duration(seconds: value.toInt()));
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.fast_rewind,
                      color: Colors.white54,
                      size: 42.0,
                    ),
                    SizedBox(width: 32.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: InkWell(
                        onTap: () async {
                          if (playing == false) {
                            await audioCache
                                .play(widget.allMusic!.soundSrc.toString());
                            setState(() {
                              playing = true;
                            });
                          } else {
                            audioPlayer.pause();
                            setState(() {
                              playing = false;
                            });
                          }
                        },
                        child: Icon(
                          playing == false ? Icons.play_arrow : Icons.pause,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 32.0),
                    Icon(
                      Icons.fast_forward,
                      color: Colors.white54,
                      size: 42.0,
                    ),
                  ],
                ),
                _bannerisLoaded
                    ? Container(
                        color: Colors.black,
                        height: 50,
                        child: AdWidget(
                          ad: _bannerAd!,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
