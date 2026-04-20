import 'package:flutter/material.dart';
import 'riddle_puzzle_game.dart'; // Import the Riddle Puzzle Game
import 'hangman_game.dart'; // Import the Memory Game // Import the Math Game
import 'tic_tac_toe_game.dart'; // Import the Word Search Game
import 'rock_paper_scissors.dart'; // Import the Quiz Game

class GamesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Makes the app bar background transparent
        elevation: 0, // Removes the shadow of the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back button with black color
          onPressed: () {
            Navigator.pop(context); // Pops the screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Game',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _gameButton(context, 'Riddle Puzzle', RiddlePuzzleGame()),
            SizedBox(height: 20),
            _gameButton(context, 'Hangman', HangmanGame()), // Replace with actual game widget
            SizedBox(height: 20),
            _gameButton(context, 'Tic Tac Toe', TicTacToeGame()), // Replace with actual game widget
            SizedBox(height: 20),
            _gameButton(context, 'Rock Paper Scissor', RockPaperScissorsGame()), // Replace with actual quiz game widget
          ],
        ),
      ),
    );
  }

  Widget _gameButton(BuildContext context, String gameName, Widget gameWidget) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => gameWidget),
        );
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Adjust padding
      ),
      child: Text(
        gameName,
        style: TextStyle(
          color: Colors.black, // Black color for text
          fontSize: 18,
          decoration: TextDecoration.none, // No underline
        ),
      ),
    );
  }
}
