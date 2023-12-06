import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(SimonGame());

class SimonGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF011F3F),
        body: SimonGamePage(),
      ),
    );
  }
}

class SimonGamePage extends StatefulWidget {
  @override
  _SimonGamePageState createState() => _SimonGamePageState();
}

class _SimonGamePageState extends State<SimonGamePage> {
  List<String> buttonColours = ["red", "blue", "green", "yellow"];
  List<String> gamePattern = [];
  List<String> userClickedPattern = [];

  bool started = false;
  int level = 0;
  String? highlightedColor;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  void playSound(String color) {
    player.play(AssetSource('sounds/$color.mp3'));
  }

  void playGamePattern() {
    int i = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (i < gamePattern.length) {
        setState(() {
          highlightedColor = gamePattern[i];
        });
        playSound(gamePattern[i]);
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            highlightedColor = null;
          });
        });
        i++;
      } else {
        timer.cancel();
      }
    });
  }

  void nextSequence() {
    userClickedPattern = [];
    level++;

    // Reset highlightedColor to null initially
    setState(() {
      highlightedColor = null;
    });

    // Highlight the next color block if it's within the pattern length
    if (level <= gamePattern.length) {
      setState(() {
        highlightedColor = gamePattern[level - 1];
      });
      playSound(gamePattern[level - 1]);
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          highlightedColor = null;
        });
      });
    } else {
      // If the level is greater than the pattern length, add a new color block
      setState(() {
        gamePattern.add(buttonColours[Random().nextInt(4)]);
        highlightedColor = gamePattern.last;
      });
      playSound(gamePattern.last);
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          highlightedColor = null;
        });
      });
    }
  }

  void checkAnswer(int currentLevel) {
    if (gamePattern[currentLevel] == userClickedPattern[currentLevel]) {
      if (userClickedPattern.length == gamePattern.length) {
        Future.delayed(Duration(seconds: 1), () {
          nextSequence();
        });
      }
    } else {
      playSound('wrong');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('Press OK to restart the game.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  startOver();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void startOver() {
    setState(() {
      level = 0;
      gamePattern = [];
      started = false;
    });
  }

  Color getColor(String color) {
    switch (color) {
      case "red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      case "green":
        return Colors.green;
      case "yellow":
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Level $level",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Press Start 2P',
              fontSize: 30.0,
              color: Color(0xFFFEF2BF),
            ),
          ),
          SizedBox(height: 20.0),
          // Display colored buttons in rows with two buttons each
          for (int i = 0; i < buttonColours.length; i += 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = i; j < i + 2 && j < buttonColours.length; j++)
                  GestureDetector(
                    onTap: () {
                      if (started) {
                        setState(() {
                          userClickedPattern.add(buttonColours[j]);
                          playSound(buttonColours[j]);
                          checkAnswer(userClickedPattern.length - 1);
                        });
                      }
                    },
                    child: AnimatedContainer(
                      margin: EdgeInsets.all(15.0),
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        color: getColor(buttonColours[j]),
                        border: highlightedColor == buttonColours[j]
                            ? Border.all(
                          color: Colors.white, // Highlight color
                          width: 5.0,
                        )
                            : Border.all(
                          color: Colors.black,
                          width: 5.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      duration: Duration(milliseconds: 300), // Adjust duration as needed
                    ),
                  ),
              ],
            ),
          SizedBox(height: 20.0),
          GestureDetector(
            onTap: () {
              if (!started) {
                setState(() {
                  started = true;
                });
                nextSequence();
              }
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              color: started ? Colors.transparent : Colors.red,
              child: Text(
                started ? "Game in Progress" : "Start Game",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
