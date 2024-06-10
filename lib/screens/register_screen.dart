import 'package:flutter/material.dart';
import 'players_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _betController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  bool _isEven = true;

  Future<void> _submit() async {
    final String name = _nameController.text;
    final int bet = int.tryParse(_betController.text) ?? 0;
    final int number = int.tryParse(_numberController.text) ?? 1;

    if (name.isEmpty || bet <= 0 || number < 1 || number > 5) {
      print('Por favor, insira valores válidos.');
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayersScreen(
          currentPlayer: name,
          bet: bet,
          isEven: _isEven,
          number: number,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Par ou Ímpar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _betController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Valor da Aposta'),
            ),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Número (1 a 5)'),
            ),
            Row(
              children: [
                Text('Par'),
                Switch(
                  value: _isEven,
                  onChanged: (value) {
                    setState(() {
                      _isEven = value;
                    });
                  },
                ),
                Text('Ímpar'),
              ],
            ),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Confirmar Aposta'),
            ),
          ],
        ),
      ),
    );
  }
}
