import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlayScreen extends StatefulWidget {
  final String username;
  final String opponentUsername;
  final int aposta;
  final bool par;
  final int numero;

  PlayScreen({
    required this.username,
    required this.opponentUsername,
    required this.aposta,
    required this.par,
    required this.numero,
  });

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  Future<void> _makeBet() async {
    final response = await http.post(
      Uri.parse('https://par-impar.glitch.me/aposta'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': widget.username,
        'valor': widget.aposta,
        'parimpar': widget.par ? 2 : 1,
        'numero': widget.numero,
      }),
    );

    if (response.statusCode == 200) {
      print('Aposta realizada com sucesso');
    } else {
      print('Erro ao realizar aposta');
    }
  }

  Future<void> _playGame() async {
    final response = await http.get(
      Uri.parse('https://par-impar.glitch.me/jogar/${widget.username}/${widget.opponentUsername}'),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print('Resultado do jogo: ${result}');
    } else {
      print('Erro ao jogar');
    }
  }

  @override
  void initState() {
    super.initState();
    _makeBet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Jogador: ${widget.username}'),
            Text('Oponente: ${widget.opponentUsername}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playGame,
              child: Text('Jogar'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Jogar com outro oponente'),
            ),
          ],
        ),
      ),
    );
  }
}
