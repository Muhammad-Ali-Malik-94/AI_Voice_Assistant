class Persona {
  final String name;
  final List<String> temperaturePrompts;
  int _temperatureLevel = 1; // 1-10

  Persona({
    required this.name,
    required this.temperaturePrompts,
  });

  // Convert temperature level (1-10) to API temperature (0.1-1.0)
  double get apiTemperature => _temperatureLevel * 0.1;

  // Get current prompt based on temperature level
  String get currentPrompt => temperaturePrompts[_temperatureLevel - 1];

  // Update temperature level
  void setTemperature(int level) {
    if (level >= 1 && level <= 10) {
      _temperatureLevel = level;
    }
  }
}

// Predefined personas
class PersonaManager {
  static final Persona rickSanchez = Persona(
    name: 'Rick Sanchez',
    temperaturePrompts: [
      // Your 10 Rick prompts here
    ],
  );

  static final Persona shadowFiend = Persona(
    name: 'Shadow Fiend',
    temperaturePrompts: [
      // Your 10 Shadow Fiend prompts here
    ],
  );

  static List<Persona> get allPersonas => [rickSanchez, shadowFiend];
}