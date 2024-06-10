import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PointsScreen extends StatefulWidget {
  final String username;

  PointsScreen({required this.username});

  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  int points = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPoints();
  }

  Future<void> fetchPoints() async {
    final response = await http.get(
      Uri.parse('https://par-impar.glitch.me/pontos/${widget.username}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        points = jsonDecode(response.body)['pontos'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Erro ao buscar pontos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pontos de ${widget.username}'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Text('Pontos: $points', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
