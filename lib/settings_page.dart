import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Theme Color:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10.0,
              children: [
                _buildColorOption(context, Colors.blueAccent),
                _buildColorOption(context, Colors.redAccent),
                _buildColorOption(context, Colors.greenAccent),
                _buildColorOption(context, Colors.orangeAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(BuildContext context, Color color) {
    return GestureDetector(
      onTap: () {
        Provider.of<ThemeProvider>(context, listen: false).setThemeColor(color);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Provider.of<ThemeProvider>(context).themeColor == color
                ? Colors.black
                : Colors.transparent,
            width: 3.0,
          ),
        ),
      ),
    );
  }
}
