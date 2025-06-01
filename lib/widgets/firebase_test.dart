import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTest extends StatefulWidget {
  const FirebaseTest({Key? key}) : super(key: key);

  @override
  State<FirebaseTest> createState() => _FirebaseTestState();
}

class _FirebaseTestState extends State<FirebaseTest> {
  String _status = '';

  Future<void> _testFirestore() async {
    try {
      setState(() => _status = 'Testing connection...');

      // Try to write a test document
      final docRef = await FirebaseFirestore.instance
          .collection('messages')
          .add({
        'content': 'Test message',
        'timestamp': FieldValue.serverTimestamp(),
        'userId': 'Muhammad-Ali-Malik-94',
        'testTime': DateTime.now().toIso8601String(),
      });

      // Try to read it back
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        setState(() => _status = 'Success!\nDocument written and read with ID: ${docRef.id}');
      } else {
        setState(() => _status = 'Error: Document written but could not be read back');
      }

    } catch (e) {
      setState(() => _status = 'Error: $e');
      print('Firebase test error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _testFirestore,
          child: const Text('Test Firebase Connection'),
        ),
        if (_status.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _status.contains('Success')
                    ? Colors.green
                    : _status.contains('Error')
                    ? Colors.red
                    : Colors.blue,
              ),
            ),
          ),
      ],
    );
  }
}