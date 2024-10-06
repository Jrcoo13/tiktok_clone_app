import 'package:flutter/material.dart';
import 'package:tiktok_app/ui/main_page.dart';

void main() => runApp(const VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiktok Clone App',
      home: MainPage(),
    );
  }
}
