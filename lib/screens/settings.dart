import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
          child: const Text('Ir a Configuraciones'),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkThemeEnabled = false;
  String _selectedLanguage = 'Español';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuraciones"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Notificaciones"),
            subtitle: const Text("Activar o desactivar notificaciones"),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Tema oscuro"),
            subtitle: const Text("Activar o desactivar tema oscuro"),
            value: _darkThemeEnabled,
            onChanged: (value) {
              setState(() {
                _darkThemeEnabled = value;
              });
            },
          ),
          ListTile(
            title: const Text("Idioma"),
            subtitle: Text("Idioma actual: $_selectedLanguage"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Cambiar contraseña"),
            trailing: const Icon(Icons.lock),
            onTap: () {
              // Navega a la pantalla de cambio de contraseña
            },
          ),
          ListTile(
            title: const Text("Cerrar sesión"),
            trailing: const Icon(Icons.logout),
            onTap: () {
              // Añadir lógica de cierre de sesión aquí
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Seleccionar idioma"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Español"),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'Español';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("Inglés"),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'Inglés';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


