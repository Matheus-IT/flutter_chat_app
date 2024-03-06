import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    // unfocus any input field, closing the keyboard
    FocusScope.of(context).unfocus();

    final enteredMessage = _messageController.text;
    if (enteredMessage.isEmpty) {
      return;
    }

    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = (await FirebaseFirestore.instance.collection('users').doc(user.uid).get()).data()!;

    await FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'created_at': Timestamp.now(),
      'user_id': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              decoration: const InputDecoration(labelText: 'Send message...'),
            ),
          ),
          IconButton(
              color: Theme.of(context).colorScheme.primary, onPressed: _submitMessage, icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
