import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final auth = context.read<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(settings.themeMode.toUpperCase()),
            leading: const Icon(Icons.palette),
            onTap: () => _showThemeDialog(context),
          ),
          SwitchListTile(
            title: const Text('Short Mode'),
            subtitle: const Text('Generate shorter responses'),
            value: settings.isShortMode,
            onChanged: settings.setShortMode,
          ),
          ListTile(
            title: const Text('Sign Out'),
            leading: const Icon(Icons.logout),
            onTap: () => auth.signOut(),
          ),
        ],
      ),
    );
  }

  Future<void> _showThemeDialog(BuildContext context) async {
    final settings = context.read<SettingsService>();
    final currentTheme = settings.themeMode;

    await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Theme'),
        children: [
          _ThemeOption(
            title: 'System',
            value: 'system',
            groupValue: currentTheme,
            onChanged: settings.setThemeMode,
          ),
          _ThemeOption(
            title: 'Light',
            value: 'light',
            groupValue: currentTheme,
            onChanged: settings.setThemeMode,
          ),
          _ThemeOption(
            title: 'Dark',
            value: 'dark',
            groupValue: currentTheme,
            onChanged: settings.setThemeMode,
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _ThemeOption({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        onChanged(value);
      },
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: (value) {
              if (value != null) {
                Navigator.pop(context);
                onChanged(value);
              }
            },
          ),
          Text(title),
        ],
      ),
    );
  }
}