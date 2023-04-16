import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(children: [
        Expanded(
            child: TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'Send a message...'),
          onChanged: (value) {
            _enteredMessage = value;
          },
        )),
        IconButton(onPressed: _sendMessage, icon: Icon(Icons.send))
      ]),
    );
  }

  void _sendMessage() {
    if (!_enteredMessage.trim().isEmpty) {
      FocusScope.of(context).unfocus();
      final user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('chat').add({
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user!.uid
      });

      //_controller.text = '';
      _controller.clear();
    }
  }
}
