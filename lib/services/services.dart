import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MediaApp());
}

class MediaApp extends StatelessWidget {
  const MediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShareMediaScreen(),
      debugShowCheckedModeBanner: false, // Elimina el banner de depuración
    );
  }
}

class ShareMediaScreen extends StatefulWidget {
  const ShareMediaScreen({Key? key}) : super(key: key);

  @override
  _ShareMediaScreenState createState() => _ShareMediaScreenState();
}

class _ShareMediaScreenState extends State<ShareMediaScreen> {
  final channel = IOWebSocketChannel.connect('ws://192.168.0.28:8080');
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String base64Image =
          base64Encode(File(pickedFile.path).readAsBytesSync());
      String fileName = pickedFile.path.split('/').last;
      _sendMessage({
        'type': 'image',
        'filename': fileName,
        'data': base64Image,
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      String base64Video =
          base64Encode(File(pickedFile.path).readAsBytesSync());
      String fileName = pickedFile.path.split('/').last;
      _sendMessage({
        'type': 'video',
        'filename': fileName,
        'data': base64Video,
      });
    }
  }

  void _sendMessage(dynamic data) {
    String message = json.encode(data);
    channel.sink.add(message);
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Text('Aplicación Para Compartir'),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 74, 25, 97),
              Color.fromARGB(255, 36, 21, 90)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  
                  child: const Icon(
                  Icons.document_scanner,
                  color: Color.fromARGB(255, 2, 12, 17),
                  size: 90,
                ),
                ),
                const SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Elige Un Archivo'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
