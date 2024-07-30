import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quote_service.dart';
import 'quote.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Quote'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/my-list');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer<QuoteService>(
          builder: (context, quoteService, child) {
            final quote = quoteService.randomQuote;
            if (quote == null) {
              return CircularProgressIndicator();
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RepaintBoundary(
                      key: _globalKey,
                      child: Column(
                        children: [
                          Text(
                            '"${quote.sentence}"',
                            style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${quote.depresent} (${quote.arverb})',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        quoteService.fetchRandomQuote();
                      },
                      child: Text('New Quote'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _capturePng();
                      },
                      child: Text('Download as PNG'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        quoteService.addToMyList(quote);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to list')),
                        );
                      },
                      child: Text('Add to List'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _speakQuote(context, quote);
                      },
                      child: Text('Listen'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  

  void _speakQuote(BuildContext context, Quote quote) {
    final quoteService = Provider.of<QuoteService>(context, listen: false);
    // Use your speech synthesis logic here
    // This example assumes you have implemented speech synthesis in QuoteService
    quoteService.speak(quote.sentence);
  }
}
