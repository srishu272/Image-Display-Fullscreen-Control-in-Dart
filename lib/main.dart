import 'package:flutter/material.dart';
import 'dart:html' as html; // Importing dart:html for JS interop

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

/// [Widget] displaying the home page consisting of an image and the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  String? _imageUrl;
  bool _isMenuOpen = false;

  void _toggleFullscreen() {
    html.document.documentElement?.requestFullscreen();
  }

  void _exitFullscreen() {
    if (html.document.fullscreenElement != null) {
      html.document.exitFullscreen();
    }
  }

  void _onImageDoubleTap() {
    if (html.document.fullscreenElement != null) {
      _exitFullscreen();
    } else {
      _toggleFullscreen();
    }
  }

  void _showContextMenu() {
    setState(() {
      _isMenuOpen = true;
    });
  }

  void _hideContextMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GestureDetector(
                      onDoubleTap: _onImageDoubleTap,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _imageUrl != null
                            ? HtmlElementView(
                                viewType: 'imageView',
                              )
                            : Center(child: Text('No image loaded')),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          hintText: 'Image URL',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _imageUrl = _urlController.text;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
          if (_isMenuOpen)
            GestureDetector(
              onTap: _hideContextMenu,
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _toggleFullscreen();
                          _hideContextMenu();
                        },
                        child: Text('Enter fullscreen'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _exitFullscreen();
                          _hideContextMenu();
                        },
                        child: Text('Exit fullscreen'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showContextMenu,
        child: Icon(Icons.add),
      ),
    );
  }
}
