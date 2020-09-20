import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'MessageBubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.active) {
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats/xWDqxxaJLOQ23kzjbirT/messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final docs = snapshot.data.docs;
                  return ListView.builder(
                    reverse: true,
                    itemBuilder: (ctx, index) {
                      final message = docs[index].data()['text'].toString();
                      final username =
                          docs[index].data()['username'].toString();
                      final userImage =
                          docs[index].data()['userImage'].toString();
                      final isMe = docs[index].data()['userId'].toString() ==
                          userSnapshot.data.uid;
                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: MessageBubble(
                            key: ValueKey(docs[index].reference.id),
                            message: message,
                            isMe: isMe,
                            username: username,
                            userImage: userImage),
                      );
                    },
                    itemCount: docs.length,
                  );
                }
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              });
        }
        return const Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}
