import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> deck = [];
  List<String> playerHand = [];
  List<String> dealerHand = [];
  String result = "";
  int playerCoins = 100; // Monedas iniciales del jugador
  int currentBet = 10; // Apuesta inicial

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBetDialog();
    });
  }

  void _resetGame() {
    setState(() {
      _showBetDialog();
    });
  }

  void _initializeGame() {
    List<String> suits = ['♠', '♥', '♦', '♣'];
    List<String> ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];

    deck = [
      for (var suit in suits)
        for (var rank in ranks)
          '$rank$suit'
    ];

    playerHand = [];
    dealerHand = [];
    result = "";

    playerHand.add(_drawCard());
    playerHand.add(_drawCard());
    dealerHand.add(_drawCard());
    dealerHand.add(_drawCard());
  }

  void _doubleAndHit() {
    if (playerCoins >= currentBet * 2) {
      setState(() {
        playerCoins -= currentBet; // Duplica la apuesta
        currentBet *= 2;
        playerHand.add(_drawCard());
        if (_calculateScore(playerHand) > 21) {
          result = "Has perdido!";
        } else {
          _stand(); // El jugador se planta automáticamente después de doblar y pedir
        }
      });
    }
  }

  String _drawCard() {
    if (deck.isEmpty) {
      _reloadDeck();
    }

    final random = Random();
    int index = random.nextInt(deck.length);
    return deck[index];
  }

  void _reloadDeck() {
    List<String> suits = ['♠', '♥', '♦', '♣'];
    List<String> ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];

    deck = [
      for (var suit in suits)
        for (var rank in ranks)
          '$rank$suit'
    ];
  }

  void _hit() {
    setState(() {
      playerHand.add(_drawCard());
      if (_calculateScore(playerHand) > 21) {
        result = "Has perdido!";
      }
    });
  }

  void _stand() {
    setState(() {
      while (_calculateScore(dealerHand) < 17) {
        dealerHand.add(_drawCard());
      }

      int dealerScore = _calculateScore(dealerHand);
      int playerScore = _calculateScore(playerHand);

      if (dealerScore > 21 || playerScore > dealerScore) {
        result = "Has ganado!";
        playerCoins += currentBet * 2; // El jugador gana el doble de la apuesta
      } else if (playerScore == dealerScore) {
        result = "Empate!";
        playerCoins += currentBet; // Devuelve la apuesta al jugador
      } else {
        result = "Has perdido!";
        // No se descuentan las monedas ya que se descontaron al hacer la apuesta
      }
    });
  }


  Future<void> _showBetDialog() async {
    TextEditingController betController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados para el diálogo
          ),
          title: Text(
            'Ingresa tu apuesta',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: betController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Apuesta",
              hintStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.green[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados para el campo de texto
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirmar', style: TextStyle(color: Colors.yellowAccent)),
              onPressed: () {
                int bet = int.tryParse(betController.text) ?? 0;
                if (bet > 0 && bet <= playerCoins) {
                  setState(() {
                    currentBet = bet;
                    playerCoins -= bet; // Actualiza las monedas del jugador
                  });
                  Navigator.of(context).pop();
                  _initializeGame();
                }
              },
            ),
          ],
        );
      },
    );
  }



  int _calculateScore(List<String> hand) {
    int score = 0;
    for (String card in hand) {
      String value = card.substring(0, card.length - 1);
      score += _getCardValue(value);
    }
    return score;
  }

  int _getCardValue(String value) {
    if (value == 'A') {
      return 1;
    } else if (['J', 'Q', 'K'].contains(value)) {
      return 10;
    }
    return int.tryParse(value) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green[700]!, Colors.green[900]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildTopBar(context), // Agregar esta línea para el botón de salida
              _buildCardSection('Crupier', dealerHand),
              if (result.isNotEmpty) _buildResultSection(),
              _buildBetDisplay(),
              _buildCardSection('Jugador', playerHand),
              _buildPlayerCoins(),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red[600], // Color de fondo del botón
              borderRadius: BorderRadius.circular(30), // Bordes redondeados
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 2), // Cambios en la posición de la sombra
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Otros elementos de la barra superior, si los hay
        ],
      ),
    );
  }


  Widget _buildBetDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.casino, color: Colors.yellow),
          SizedBox(width: 8),
          Text('Apuesta: $currentBet', style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildPlayerCoins() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.monetization_on, color: Colors.yellow),
          SizedBox(width: 8),
          Text('$playerCoins Monedas', style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }



  Widget _buildCardSection(String title, List<String> hand) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text('$title: ', style: TextStyle(fontSize: 18, color: Colors.white)),
          Wrap(
            spacing: 4.0,
            children: hand.map((card) => CardView(card: card)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              _buildActionButton(
                onPressed: _calculateScore(playerHand) < 21 && result.isEmpty ? _hit : null,
                text: 'Pedir',
                color: Colors.blueAccent,
                icon: Icons.add_circle_outline,
              ),
              SizedBox(width: 20,),
              _buildActionButton(
                onPressed: result.isEmpty ? _stand : null,
                text: 'Plantarse',
                color: Colors.redAccent,
                icon: Icons.stop_circle_outlined,
              ),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              if (playerCoins >= currentBet * 2 && playerHand.length == 2 && result.isEmpty)
                _buildActionButton(
                  onPressed: _doubleAndHit,
                  text: 'Doblar y Pedir',
                  color: Colors.purpleAccent,
                  icon: Icons.double_arrow,
                ),
              if (result.isNotEmpty)
                _buildActionButton(
                  onPressed: _resetGame,
                  text: 'Jugar de Nuevo',
                  color: Colors.orangeAccent,
                  icon: Icons.refresh,
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton({required VoidCallback? onPressed, required String text, required Color color, required IconData icon}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        shadowColor: Colors.black45,
      ),
    );
  }

  Widget _buildResultSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(result, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}

class CardView extends StatelessWidget {
  final String card;
  CardView({required this.card});

  @override
  Widget build(BuildContext context) {
    String rank = card.substring(0, card.length - 1);
    String suit = card.substring(card.length - 1);
    Color color = (suit == '♥' || suit == '♦') ? Colors.red : Colors.black;

    return Container(
      width: 50,
      height: 70,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(rank, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(suit, style: TextStyle(fontSize: 18, color: color)),
        ],
      ),
    );
  }
}
