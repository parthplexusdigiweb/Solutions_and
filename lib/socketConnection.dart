// socketConnection

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/io.dart';



class socketConnection extends StatefulWidget {
  @override
  _socketConnectionState createState() => _socketConnectionState();
}

class _socketConnectionState extends State<socketConnection> {
  final channel = IOWebSocketChannel.connect('ws://localhost:3000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Demo'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.hasData) {
              return Text('Received: ${snapshot.data}');
            }

            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          channel.sink.add('Hello, WebSocket Server!');
        },
        tooltip: 'Send Message',
        child: Icon(Icons.send),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

