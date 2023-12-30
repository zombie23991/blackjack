import 'package:blackjack/board.dart';
import 'package:blackjack/configuration.dart';
import 'package:blackjack/homepage.dart';
import 'package:blackjack/lobby.dart';
import 'package:blackjack/login-register.dart';
import 'package:blackjack/rewards.dart';
import 'package:blackjack/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Asegurarse de que Flutter esté inicializado
    WidgetsFlutterBinding.ensureInitialized();

    // Configurar orientación de pantalla
   // SystemChrome.setPreferredOrientations([
   //   DeviceOrientation.portraitUp,
   //   DeviceOrientation.portraitDown,
   // ]);

    // Configurar manejador de errores global
    //ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    //  return const ErrorScreen();
    //};

    return MaterialApp(
      title: 'BlackJack',
      theme: ThemeData(
        fontFamily: 'Inter',
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      initialRoute: '/homepage', // Ruta inicial
      routes: {
        //Menú Principal
        '/homepage': (context) => HomePage(),
        // Pantalla de Inicio / Bienvenida
        '/login-register': (context) => LoginRegister(),
        //Lobby / Sala de Espera
        '/lobby': (context) => const Lobby(),
        //Pantalla de Juego de Blackjack
        '/game': (context) => GameScreen(),
        //Pantalla de Resultados
        '/board': (context) => const Board(),
        //Pantalla de Ajustes y Ayuda
        '/configuration': (context) => const Configuration(),
        //Pantalla de Logros y Estadísticas
        '/rewards': (context) => const Rewards(),

        // Define más rutas según tus necesidades
      },
    );

  }
}
