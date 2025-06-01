import 'package:flutter/material.dart';
import '../models/persona.dart';
import '../widgets/ai_controls.dart';

class PersonaScreen extends StatefulWidget {
  final Persona? currentPersona;
  final bool isShortMode;
  final Function(Persona?, bool) onPersonaSelected;

  const PersonaScreen({
    super.key,
    this.currentPersona,
    required this.isShortMode,
    required this.onPersonaSelected,
  });

  @override
  State<PersonaScreen> createState() => _PersonaScreenState();
}

class _PersonaScreenState extends State<PersonaScreen> {
  Persona? selectedPersona;
  int temperature = 1;
  late bool isShortMode;

  @override
  void initState() {
    super.initState();
    selectedPersona = widget.currentPersona;
    isShortMode = widget.isShortMode;
    temperature = selectedPersona?.temperatureLevel ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Persona'),
        actions: [
          TextButton(
            onPressed: () {
              if (selectedPersona != null) {
                selectedPersona!.setTemperature(temperature);
              }
              widget.onPersonaSelected(selectedPersona, isShortMode);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Default AI Option
          ListTile(
            title: const Text('Default AI'),
            subtitle: const Text('Standard AI assistant without persona'),
            selected: selectedPersona == null,
            onTap: () {
              setState(() {
                selectedPersona = null;
              });
            },
          ),
          const Divider(),

          // Response Mode Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ResponseModeToggle(
              isShortMode: isShortMode,
              onChanged: (value) {
                setState(() {
                  isShortMode = value;
                });
              },
            ),
          ),
          const Divider(),

          // Available Personas
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Available Personas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...PersonaManager.allPersonas.map((persona) => ListTile(
            title: Text(persona.name),
            selected: selectedPersona?.name == persona.name,
            onTap: () {
              setState(() {
                selectedPersona = persona;
                temperature = persona.temperatureLevel;
              });
            },
          )),

          // Temperature Slider (only shown when a persona is selected)
          if (selectedPersona != null) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TemperatureSlider(
                value: temperature,
                onChanged: (value) {
                  setState(() {
                    temperature = value;
                  });
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}