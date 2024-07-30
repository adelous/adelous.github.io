import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quote_service.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomeScreen extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NightQuotes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Color(0xFF1F1F1F), // Dark gray
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Color(0xFFE0E0E0)),
            onPressed: () {
              Navigator.pushNamed(context, '/my-list');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Color(0xFFE0E0E0)),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFF121212), // Very dark gray
      body: SafeArea(
        child: Center(
          child: Consumer<QuoteService>(
            builder: (context, quoteService, child) {
              final quote = quoteService.randomQuote;
              if (quote == null) {
                return CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF6200EE)));
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Color(0xFF2C2C2C), // Dark gray
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: RepaintBoundary(
                            key: _globalKey,
                            child: Column(
                              children: [
                                Text(
                                  '"${quote.sentence}"',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE0E0E0), // Light gray
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '${quote.depresent} (${quote.arverb})',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFB0B0B0), // Medium gray
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      _buildDarkModeButton(
                        onPressed: () => quoteService.fetchRandomQuote(),
                        icon: Icons.refresh,
                        label: 'New Quote',
                      ),
                      SizedBox(height: 16),
                      _buildDarkModeButton(
                        onPressed: () {
                          _capturePng();
                        },
                        icon: Icons.download,
                        label: 'Download as PNG',
                      ),
                      SizedBox(height: 16),
                      _buildDarkModeButton(
                        onPressed: () {
                          quoteService.addToMyList(quote);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added to favorites',
                                  style: TextStyle(color: Color(0xFFE0E0E0))),
                              backgroundColor: Color(0xFF3700B3),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        icon: Icons.favorite,
                        label: 'Add to Favorites',
                      ),
                      SizedBox(height: 16),
                      _buildDarkModeButton(
                        onPressed: () => _speakQuote(context, quote),
                        icon: Icons.volume_up,
                        label: 'Listen',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDarkModeButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Color(0xFFE0E0E0)),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF3700B3), // Deep purple
        foregroundColor: Color(0xFFE0E0E0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
      ),
    );
  }

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/image.png').create();
        await file.writeAsBytes(byteData.buffer.asUint8List());

        final result = await GallerySaver.saveImage(file.path);
        print(result);

        // Clean up: delete the temp file
        await file.delete();
      } else {
        print('Failed to get byte data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _speakQuote(BuildContext context, quote) {
    final quoteService = Provider.of<QuoteService>(context, listen: false);
    quoteService.speak(quote.sentence);
  }
}
