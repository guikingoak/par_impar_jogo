import 'package:flutter/material.dart';
import 'screens/players_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Par ou Ímpar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _betController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  bool _isEven = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Par ou Ímpar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nome do Jogador'),
            ),
            TextField(
              controller: _betController,
              decoration: InputDecoration(labelText: 'Valor da aposta'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _numberController,
              decoration: InputDecoration(labelText: 'Número (1-5)'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Text('Par'),
                Switch(
                  value: _isEven,
                  onChanged: (value) {
                    _isEven = value;
                  },
                ),
                Text('Ímpar'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final currentPlayer = _usernameController.text;
                final bet = int.parse(_betController.text);
                final number = int.parse(_numberController.text);

                if (currentPlayer.isNotEmpty && bet > 0 && number >= 1 && number <= 5) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayersScreen(
                        currentPlayer: currentPlayer,
                        bet: bet,
                        isEven: _isEven,
                        number: number,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Erro'),
                      content: Text('Por favor, preencha todos os campos corretamente.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Confirmar Aposta'),
            ),
          ],
        ),
      ),
    );
  }
}
