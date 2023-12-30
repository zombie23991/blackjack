import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderSection(context),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  _buildFeatureCards(context),
                  _buildPlayButton(context),
                  _buildStatisticsSection(context),

                ],
              ),
            ),
            _buildSettingsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Column(
        children: [
          Text(
            'Bienvenido a Blackjack',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'El mejor lugar para jugar y disfrutar',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            _buildFeatureCard(context, 'Únete a un Juego', Icons.group, Colors.blue),
            _buildFeatureCard(context, 'Crear Sala', Icons.create, Colors.green),
            _buildFeatureCard(context, 'Tutorial', Icons.school, Colors.orange),
            // Añadir más tarjetas según sea necesario
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.play_circle_fill, size: 30),
          label: const Text('Jugar Ahora', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          onPressed: () {
            // Navegación a la pantalla de juego
            Navigator.of(context).pushNamed('/game');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    // Asegúrate de que siempre haya un return aquí
    return const Card(
      // ... tu código para la sección de estadísticas ...
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    // Asegúrate de que siempre haya un return aquí
    return const ListTile(
      // ... tu código para la sección de configuraciones ...
    );
  }

}
