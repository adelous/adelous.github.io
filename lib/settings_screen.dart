import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quote_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Dark Mode'),
              value: Provider.of<QuoteService>(context).isDarkMode,
              onChanged: (bool value) {
                Provider.of<QuoteService>(context, listen: false)
                    .toggleDarkMode(value);
              },
            ),
            SizedBox(height: 20),
            Text('Volume', style: TextStyle(fontSize: 18)),
            Slider(
              value: Provider.of<QuoteService>(context).volume,
              min: 0,
              max: 1,
              divisions: 10,
              onChanged: (double value) {
                Provider.of<QuoteService>(context, listen: false)
                    .setVolume(value);
              },
            ),
            SizedBox(height: 20),
            Text('Speed', style: TextStyle(fontSize: 18)),
            DropdownButton<double>(
              value: Provider.of<QuoteService>(context).speed,
              items: [
                DropdownMenuItem(value: 0.5, child: Text('0.5x')),
                DropdownMenuItem(value: 0.75, child: Text('0.75x')),
                DropdownMenuItem(value: 1, child: Text('1x')),
                DropdownMenuItem(value: 1.25, child: Text('1.25x')),
                DropdownMenuItem(value: 1.5, child: Text('1.5x')),
                DropdownMenuItem(value: 2, child: Text('2x')),
              ],
              onChanged: (double? value) {
                if (value != null) {
                  Provider.of<QuoteService>(context, listen: false)
                      .setSpeed(value);
                }
              },
            ),
            SizedBox(height: 20),
            Text('Repetitions', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Checkbox(
                  value: Provider.of<QuoteService>(context).isRepeat,
                  onChanged: (bool? value) {
                    if (value != null) {
                      Provider.of<QuoteService>(context, listen: false)
                          .toggleRepeat(value);
                    }
                  },
                ),
                Text('Repeat'),
              ],
            ),
            if (Provider.of<QuoteService>(context).isRepeat)
              TextField(
                decoration: InputDecoration(
                  labelText: 'Number of repetitions',
                ),
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  final int repetitions = int.tryParse(value) ?? 1;
                  Provider.of<QuoteService>(context, listen: false)
                      .setRepetitions(repetitions);
                },
              ),
          ],
        ),
      ),
    );
  }
}
