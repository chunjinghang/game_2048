import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_2048/widget/panel.dart';

import 'package:game_2048/widget/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int currentScore = 0;
  int highestScore = 0;

  static const GAME_2048_HIGHEST_SCORE = "game_2048_highest_score";

  Future<SharedPreferences> _spFuture = SharedPreferences.getInstance();

  final GlobalKey _gamePanelKey = GlobalKey<GamePanelState>();

  // final GlobalKey _gamePanelKey = GlobalKey<GamePanelState>();

  @override
  void initState() {
    super.initState();
    readHighestScoreFromSp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///设置透明应用栏：将body的高度扩展到包含应用栏的高度并对齐
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        color: ColorUtil.bgColor1,
        child: OrientationBuilder(
          ///根据设备方向重新构建布局
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Column(
                children: [
                  Flexible(child: buildHeader()),
                  Flexible(flex: 2, child: buildGamePanel()),
                ],
              );
            } else {
              return Row(
                children: [
                  Flexible(child: buildHeader()),
                  Flexible(flex: 2, child: buildGamePanel()),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "2048",
                  style: TextStyle(
                      color: ColorUtil.textColor1,
                      fontSize: 62,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Start the game by adding up the numbers to 2048",
                  style: TextStyle(fontSize: 18, color: ColorUtil.textColor1),
                ),
                const SizedBox(
                  height: 38,
                ),
                InkWell(
                  onTap: (){
                    (_gamePanelKey.currentState as GamePanelState).reStartGame();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      color: ColorUtil.gc0
                    ),
                    child: Center(
                      child: Text(
                            "New Game", style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ColorUtil.textColor1
                          ),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 120,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorUtil.bg1,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'SCORE',
                        style: TextStyle(
                          fontSize: 24,
                          color: ColorUtil.textColor4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currentScore.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          color: ColorUtil.textColor3,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 120,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorUtil.bg1,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'HIGHEST',
                        style: TextStyle(
                          fontSize: 24,
                          color: ColorUtil.textColor4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        highestScore.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          color: ColorUtil.textColor3,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGamePanel() {
    return GamePanel(
        key: _gamePanelKey,
        onScoreChanged: (score) {
          setState(() {
            currentScore = score;
            if (currentScore > highestScore) {
              highestScore = currentScore;
              storeHighestScoreToSp();
            }
          });
        });
  }

  void readHighestScoreFromSp() async {
    final SharedPreferences sp = await _spFuture;
    setState(() {
      highestScore = sp.getInt(GAME_2048_HIGHEST_SCORE) ?? 0;
    });
  }

  void storeHighestScoreToSp() async {
    final SharedPreferences sp = await _spFuture;
    await sp.setInt(GAME_2048_HIGHEST_SCORE, highestScore);
  }
}


