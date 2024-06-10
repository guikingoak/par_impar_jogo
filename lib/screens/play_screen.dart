import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'points_screen.dart';

class PlayScreen extends StatefulWidget {
  final String currentPlayer;
  final String opponentUsername;
  final int bet;
  final bool isEven;
  final int number;

  PlayScreen({
    required this.currentPlayer,
    required this.opponentUsername,
    required this.bet,
    required this.isEven,
    required this.number,
  });

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  bool isLoading = false;
  String resultMessage = "";

  Future<void> playGame() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://par-impar.glitch.me/jogar/${widget.currentPlayer}/${widget.opponentUsername}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        resultMessage = data['vencedor']['username'] == widget.currentPlayer
            ? 'Você venceu!'
            : 'Você perdeu!';
        isLoading = false;
      });
    } else {
      setState(() {
        resultMessage = 'Erro ao jogar';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    playGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo: ${widget.currentPlayer} vs ${widget.opponentUsername}'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(resultMessage),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PointsScreen(username: widget.currentPlayer),
                        ),
                      );
                    },
                    child: Text('Ver Pontos'),
                  ),
                ],
              ),
      ),
    );
  }
}
