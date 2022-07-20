import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      home: HomePage(),
    );
  }
}

const lightColor = Color.fromRGBO(200, 173, 112, 1);
const text = '''
Power cut. Battery charge is empty, Welocme to Syria, You must install a solar energy system. hahaha, powered by Flutter, By Alhasan Abo Obaid.
Animations, Dart, Electricity, blablaba blabla bla bla
''';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLightOn = false;
  Offset initialPosition = const Offset(128, 61);
  Offset containerPosition = const Offset(128, 61);
  double radious = 100;

  @override
  void didChangeDependencies() {
    final size = MediaQuery.of(context).size;
    initialPosition = Offset(size.width / 2, size.height / 2);
    containerPosition = initialPosition;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Center(
            child: Stack(
              children: [
                Text(
                  text * 50,
                  style: _getTextStyle(isLightOn, radious),
                ),
                Positioned(
                  left: 25,
                  top: 25,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            radious += 50;
                          });
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.yellow,
                          size: 48,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            radious -= 50;
                            if (radious < 5) radious = 50;
                          });
                        },
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                ),
                _animatedBulb()
              ],
            ),
          ),
        ),
      ),
    );
  }

  AudioPlayer player = AudioPlayer();
  Widget bulb() {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () async {
        String audioasset = isLightOn ? 'light_off.mp3' : 'light_on.mp3';
        await player.setSource(AssetSource(audioasset));
        await player.play(AssetSource(audioasset));

        //await player.play(DeviceFileSource(audioasset));
        setState(() {
          isLightOn = !isLightOn;
        });
      },
      child: Container(
        height: 100.0,
        color: Colors.transparent,
        child: Image.asset(
          isLightOn ? 'assets/light_on.png' : 'assets/light_off.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  TextStyle _getTextStyle(bool isLightOn, double radious) {
    if (isLightOn) {
      return TextStyle(
          fontSize: 20,
          foreground: Paint()
            ..strokeWidth = 9.0
            ..shader = ui.Gradient.radial(
                containerPosition == Offset.zero
                    ? initialPosition
                    : Offset(
                        containerPosition.dx,
                        containerPosition.dy + 60,
                      ),
                radious,
                <Color>[
                  lightColor,
                  Colors.black,
                ]));
    } else {
      return const TextStyle(color: Colors.black);
    }
  }

  AnimatedPositioned _animatedBulb() {
    return AnimatedPositioned(
      left: containerPosition.dx - 30,
      top: containerPosition.dy - 85,
      curve: Curves.easeOutCirc,
      child: !isLightOn
          ? bulb()
          : Draggable(
              child: bulb(),
              onDragEnd: (x) {
                /*  setState(() {
                  containerPosition = initialPosition;
                }); */
              },
              onDragUpdate: (x) {
                if (isLightOn) containerPosition = x.localPosition;
                setState(() {});
              },
              childWhenDragging: const SizedBox(),
              feedback: Material(
                child: bulb(),
                color: Colors.transparent,
              )),
      duration: const Duration(milliseconds: 300),
    );
  }
}
