import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('created_at', descending: true).snapshots(),
      builder: (ctx, chatSnapshots) {
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found'),
          );
        }

        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            right: 13,
            left: 13,
          ),
          reverse: true,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final nextMessage = index + 1 < loadedMessages.length ? loadedMessages[index + 1].data() : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId = nextMessage != null ? nextMessage['userId'] : null;

            final nextUserIsSame = nextMessageUserId == currentMessageUserId;
          },
          itemCount: loadedMessages.length,
        );
      },
    );
  }
}
