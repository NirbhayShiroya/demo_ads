import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class demointer extends StatefulWidget {
  const demointer({Key? key}) : super(key: key);

  @override
  State<demointer> createState() => _demointerState();
}

class _demointerState extends State<demointer> {
  // request, load, show

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;

  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd(int i) {
    if (_interstitialAd == null) {
      myClick(i);
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAd();
        myClick(i);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInterstitialAd();
        myClick(i);
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  myClick(int i) {
    if (i == 0) {
      print("First Button Code");
    } else if (i == 1) {
      print("Second Button Code");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inter Ads"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                _showInterstitialAd(0);
              },
              child: Text("Show Ads")),
          ElevatedButton(
              onPressed: () {
                _showInterstitialAd(1);
              },
              child: Text("Show Ads1"))
        ],
      ),
    );
  }
}
