import 'package:firebase_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = snapshot.data!.docs;
        final user = FirebaseAuth.instance.currentUser;
        return ListView.builder(
          reverse: true,
          itemBuilder: (context, index) {
            //return Text(chatDocs[index]['text']);
            return MessageBubble(
              message: chatDocs[index]['text'],
              isMe: chatDocs[index]['userId'] == user!.uid,
              userId: chatDocs[index]['userId'],
              key: ValueKey(chatDocs[index].id),
            );
          },
          itemCount: snapshot.data!.docs.length,
        );
      },
    );
  }
}
