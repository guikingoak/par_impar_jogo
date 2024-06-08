import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BetScreen extends StatefulWidget {
  final String username;

  BetScreen({required this.username});

  @override
  _BetScreenState createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  final TextEditingController _betValueController = TextEditingController();
  int _selectedParImpar = 2; // 2 para Par e 1 para Ímpar
  int _selectedNumber = 1; // Número entre 1 e 5
  List<dynamic> players = [];
  String? selectedOpponent;

  @override
  void initState() {
    super.initState();
    fetchPlayers();
    setState(() {
      players = [];
    });
  }

  Future<void> fetchPlayers() async {
    final response = await http.get(
      Uri.parse('https://par-impar.glitch.me/jogadores'),
    );

    if (response.statusCode == 200) {
      setState(() {
        players = jsonDecode(response.body)['jogadores'];
      });
    } else {
      print('Erro ao buscar jogadores');
    }
  }

  Future<void> submitBet() async {
    final response = await http.post(
      Uri.parse('https://par-impar.glitch.me/aposta'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': widget.username,
        'valor': int.parse(_betValueController.text),
        'parimpar': _selectedParImpar,
        'numero': _selectedNumber,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['msg'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer a aposta')),
      );
    }
  }

  Future<void> playGame() async {
    if (selectedOpponent == null) return;

    final response = await http.get(
      Uri.parse('https://par-impar.glitch.me/jogar/${widget.username}/$selectedOpponent'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String winner = data['vencedor']['username'];
      int winnerPoints = data['vencedor']['valor'];
      String loser = data['perdedor']['username'];
      int loserPoints = data['perdedor']['valor'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vencedor: $winner com $winnerPoints pontos. Perdedor: $loser com $loserPoints pontos.'),
        ),
      );
    } else {
      print('Erro ao jogar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fazer Aposta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jogador: ${widget.username}', style: TextStyle(fontSize: 20)),
            TextField(
              controller: _betValueController,
              decoration: InputDecoration(labelText: 'Valor da Aposta'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<int>(
              value: _selectedParImpar,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedParImpar = newValue!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: 2,
                  child: Text('Par'),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('Ímpar'),
                ),
              ],
            ),
            DropdownButton<int>(
              value: _selectedNumber,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedNumber = newValue!;
                });
              },
              items: [1, 2, 3, 4, 5].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text('Selecione o oponente'),
              value: selectedOpponent,
              items: players.map((player) {
                return DropdownMenuItem<String>(
                  value: player['username'],
                  child: Text(player['username']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedOpponent = value;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  submitBet();
                  playGame();
                },
                child: Text('Fazer Aposta e Jogar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
