import 'package:flutter/material.dart';

void main() {
  runApp(JogoDaVelhaApp());
}

class JogoDaVelhaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JogoDaVelha(),
    );
  }
}

class JogoDaVelha extends StatefulWidget {
  @override
  _JogoDaVelhaState createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  List<String> _tabuleiro = List.filled(9, '');
  String _jogadorAtual = 'X';
  bool _jogoContraComputador = false;

  void _jogada(int index) {
    if (_tabuleiro[index] == '') {
      setState(() {
        _tabuleiro[index] = _jogadorAtual;
        if (!_verificaVencedor(_jogadorAtual)) {
          _trocaJogador();
          if (_jogoContraComputador && _jogadorAtual == 'O') {
            _jogadaComputador();
          }
        }
      });
    }
  }

  void _trocaJogador() {
    _jogadorAtual = _jogadorAtual == 'X' ? 'O' : 'X';
  }

  bool _verificaVencedor(String jogador) {
    List<List<int>> combinacoesVitoria = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combinacao in combinacoesVitoria) {
      if (combinacao.every((index) => _tabuleiro[index] == jogador)) {
        _mostrarDialogoVitoria(jogador);
        return true;
      }
    }

    if (!_tabuleiro.contains('')) {
      _mostrarDialogoEmpate();
      return true;
    }

    return false;
  }

  void _mostrarDialogoVitoria(String jogador) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Vitória!'),
        content: Text('Jogador $jogador venceu!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reiniciarJogo();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEmpate() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Empate!'),
        content: Text('Ninguém venceu!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reiniciarJogo();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _jogadaComputador() async {
    await Future.delayed(Duration(seconds: 1));
    int movimento;
    do {
      movimento = (List.generate(9, (i) => i)..shuffle()).first;
    } while (_tabuleiro[movimento] != '');
    _jogada(movimento);
  }

  void _reiniciarJogo() {
    setState(() {
      _tabuleiro = List.filled(9, '');
      _jogadorAtual = 'X';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Velha'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Modo: '),
              DropdownButton<bool>(
                value: _jogoContraComputador,
                items: [
                  DropdownMenuItem(
                    value: false,
                    child: Text('Humano'),
                  ),
                  DropdownMenuItem(
                    value: true,
                    child: Text('Computador'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _jogoContraComputador = value!;
                    _reiniciarJogo();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            width: 300,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: 9,
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => _jogada(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      _tabuleiro[index],
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _reiniciarJogo,
            child: Text('Reiniciar Jogo'),
          ),
        ],
      ),
    );
  }
}
