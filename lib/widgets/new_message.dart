import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = "";
  void _sendMessage() async {
    FocusScope.of(context).unfocus(); //klavyeyi kapat
    final user = await FirebaseAuth.instance
        .currentUser(); //kullanıcıyı belirlemek için uid fetching
    final userData =
        await Firestore.instance.collection("users").document(user.uid).get();
    Firestore.instance.collection("chat").add({
      "text": _enteredMessage,
      "createdAt": Timestamp.now(), //mesajları sıralamak için
      "userId": user.uid,
      "username": userData["username"],
      "userImage": userData["image_url"],
    });
    _controller.clear(); //mesaj alanını temizle
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Type a message..."),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
