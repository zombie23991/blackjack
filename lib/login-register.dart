import 'package:flutter/material.dart';

class LoginRegister extends StatefulWidget {
  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Bienvenido a Blackjack',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 1), // cambios de posición de la sombra
                  ),
                ],
              ),
              margin: const EdgeInsets.all(20.0),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                tabs: const [
                  Tab(text: 'Iniciar Sesión'),
                  Tab(text: 'Registrarse'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  LoginForm(),
                  RegisterForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Aquí implementas LoginForm y RegisterForm como en los ejemplos anteriores
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // para cerrar el teclado

    if (isValid) {
      _formKey.currentState!.save();
      // Aquí puedes usar _email y _password para iniciar sesión
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
                key: const ValueKey('email'),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Por favor, introduce un correo electrónico válido.';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                )),
            TextFormField(
              key: const ValueKey('password'),
              validator: (value) {
                if (value!.isEmpty || value.length < 7) {
                  return 'La contraseña debe tener al menos 7 caracteres.';
                }
                return null;
              },
              onSaved: (value) => _password = value!,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // color del botón
                shape: RoundedRectangleBorder(
                  // forma del botón
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _trySubmit,
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _email = '';
  String _password = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // para cerrar el teclado

    if (isValid) {
      _formKey.currentState!.save();
      // Aquí puedes usar los valores para registrar al usuario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              key: const ValueKey('username'),
              validator: (value) {
                if (value!.isEmpty || value.length < 4) {
                  return 'Por favor, introduce un nombre de usuario válido.';
                }
                return null;
              },
              onSaved: (value) => _userName = value!,
              decoration: const InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            // ... Repite los campos de correo electrónico y contraseña como en LoginForm
            // Botón de registro
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // color del botón
                shape: RoundedRectangleBorder(
                  // forma del botón
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _trySubmit,
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
