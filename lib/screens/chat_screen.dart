import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat...'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.amber,
              size: 36,
            ),
            onTap: () {},
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.purple,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.purple),
                    )
                  ]),
                ),
                value: 'logout',
              )
            ],
            onChanged: (value) {
              if (value == 'logout') {
                // perform logout
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.snapshotsInSync(),
              builder: (context, _) {
                return Text(
                  'Latest Snapshot: ${DateTime.now()}',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
            Expanded(

                // stream builder for messages collection
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats/YfXVvi4BWmfTpEXQP5r3/messages')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final documents = snapshot.data?.docs;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      child: Text(documents?[index]['text']),
                    );
                  },
                  itemCount: snapshot.data?.docs.length,
                );
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // fetch data from firebase
            // FirebaseFirestore.instance
            //     .collection('chats/YfXVvi4BWmfTpEXQP5r3/messages')
            //     .snapshots()
            //     .listen((event) {
            //   //print(event.docs[0]['text']);
            //   event.docs.forEach((element) {
            //     print(element['text']);
            //   });

            FirebaseFirestore.instance
                .collection('chats/YfXVvi4BWmfTpEXQP5r3/messages')
                .add({
              'text':
                  'this was added by click ${DateTime.now().toIso8601String()}'
            });
          },
          child: Icon(Icons.add)),
    );
  }
}
