// ignore_for_file: prefer_const_constructors, unnecessary_this, avoid_print

import 'dart:convert';

import 'package:cocuk_sarkilari_1/play_music.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'models/music.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InterstitialAd? _interstitialAd;
  bool isLoaded = false;

  List<Music>? allMusic;

  BannerAd? _bannerAd;
  bool _bannerisLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-2452889629536861/1343096246',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(
            () {
              isLoaded = true;
              this._interstitialAd = ad;
              print("Ad loaded");
            },
          );
        },
        onAdFailedToLoad: (error) {
          print("Interstitial Failed to Load");
        },
      ),
    );
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-2452889629536861/6061920519',
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
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text("Çocuk Şarkıları")),
          backgroundColor: Color(0xFF03174C),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.jpg"),
                      fit: BoxFit.cover),
                ),
                child: buildFutureBuilder(),
              ),
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
    );
  }

  FutureBuilder<List<dynamic>> buildFutureBuilder() {
    return FutureBuilder(
        future: veriKaynaginiOku(),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            allMusic = sonuc.data as List<Music>?;
            return ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {});
                    if (isLoaded == true) {
                      _interstitialAd!.show();
                    }

                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PlayMusic(
                        allMusic: allMusic![index],
                      );
                    }));
                  },
                  child: Hero(
                    tag: "${allMusic![index].imgSrc}",
                    child: GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            color: Colors.white.withOpacity(0.5),
                            shadowColor: Colors.red,
                            elevation: 12,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading:
                                  CircleAvatar(child: Icon(Icons.volume_up)),
                              title: Text(
                                "${index + 1}-" +
                                    allMusic![index].name.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text(
                                allMusic![index].sure.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_right),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: allMusic?.length,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<List> veriKaynaginiOku() async {
    var gelenJson = await DefaultAssetBundle.of(context)
        .loadString('assets/data/musics.json');

    List<Music> hayvanListesi = (json.decode(gelenJson) as List)
        .map((mapYapisi) => Music.fromJson(mapYapisi))
        .toList();

    return hayvanListesi;
  }
}
