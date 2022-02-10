import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').snapshots(),
      builder: (ctx, AsyncSnapshot<dynamic> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: chatSnapshot.data.docs.length,
          itemBuilder: (ctx, index) => Text(''),
        );
      },
    );
  }
}
