import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'play_screen.dart';

class PlayersScreen extends StatefulWidget {
  final String currentPlayer;
  final int bet;
  final bool isEven;
  final int number;

  PlayersScreen({
    required this.currentPlayer,
    required this.bet,
    required this.isEven,
    required this.number,
  });

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  List<dynamic> players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    final response = await http.get(
      Uri.parse('https://par-impar.glitch.me/jogadores'),
    );

    if (response.statusCode == 200) {
      setState(() {
        players = jsonDecode(response.body)['jogadores'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Erro ao buscar jogadores');
    }
  }

  Future<void> addPlayer(String username) async {
    final response = await http.post(
      Uri.parse('https://par-impar.glitch.me/novo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode == 200) {
      fetchPlayers(); // Atualiza a lista de jogadores
    } else {
      print('Erro ao adicionar jogador');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar Oponente'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addPlayer('JogadorTeste${players.length + 1}');
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : players.isEmpty
              ? Center(child: Text('Nenhum jogador encontrado'))
              : ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(players[index]['username']),
                      subtitle: Text('Pontos: ${players[index]['pontos']}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayScreen(
                              username: widget.currentPlayer,
                              opponentUsername: players[index]['username'],
                              aposta: widget.bet,
                              par: widget.isEven,
                              numero: widget.number,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
