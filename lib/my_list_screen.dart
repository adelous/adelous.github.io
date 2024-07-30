import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quote_service.dart';


class MyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My List of Quotes'),
      ),
      body: Consumer<QuoteService>(
        builder: (context, quoteService, child) {
          final myList = quoteService.myList;
          if (myList.isEmpty) {
            return Center(
              child: Text('No examples in your list.'),
            );
          }
          return ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final quote = myList[index];
              return ListTile(
                title: Text('"${quote.sentence}"'),
                subtitle: Text('${quote.depresent} (${quote.arverb})'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<QuoteService>(context, listen: false).clearMyList();
        },
        child: Icon(Icons.clear),
      ),
    );
  }
}
