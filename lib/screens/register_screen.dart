import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Jogador'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Nome do Jogador'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  print('Botão "Fazer Aposta" pressionado');
                  Navigator.pushNamed(
                    context,
                    '/bet',
                    arguments: _controller.text, 
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, insira o nome do jogador')),
                  );
                }
              },
              child: const Text('Fazer Aposta'),
            ),
          ],
        ),
      ),
    );
  }
}
