import 'package:flutter/material.dart';

class NewChatDialog extends StatefulWidget {
  final Function(String name) onChatCreated;

  const NewChatDialog({
    super.key,
    required this.onChatCreated,
  });

  @override
  State<NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends State<NewChatDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _isValid = _nameController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Chat'),
      content: TextField(
        controller: _nameController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter chat name',
          labelText: 'Chat Name',
        ),
        onSubmitted: _isValid ? (value) => _createChat(context) : null,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isValid ? () => _createChat(context) : null,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _createChat(BuildContext context) {
    if (_isValid) {
      widget.onChatCreated(_nameController.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}