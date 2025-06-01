import 'package:flutter/material.dart';

class TemperatureSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const TemperatureSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Persona Temperature: $value',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              value <= 3 ? 'Mild' :
              value <= 7 ? 'Moderate' :
              'Intense',
              style: TextStyle(
                color: value <= 3 ? Colors.green :
                value <= 7 ? Colors.orange :
                Colors.red,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            valueIndicatorColor: Theme.of(context).colorScheme.primary,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),
          child: Slider(
            min: 1,
            max: 10,
            divisions: 9,
            value: value.toDouble(),
            label: value.toString(),
            onChanged: (double newValue) {
              onChanged(newValue.round());
            },
          ),
        ),
      ],
    );
  }
}

class ResponseModeToggle extends StatelessWidget {
  final bool isShortMode;
  final ValueChanged<bool> onChanged;

  const ResponseModeToggle({
    super.key,
    required this.isShortMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Response Mode',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Switch(
            value: isShortMode,
            onChanged: onChanged,
            thumbIcon: MaterialStateProperty.resolveWith<Icon?>((states) {
              if (states.contains(MaterialState.selected)) {
                return const Icon(Icons.short_text, color: Colors.white);
              }
              return const Icon(Icons.notes, color: Colors.white);
            }),
          ),
        ],
      ),
    );
  }
}