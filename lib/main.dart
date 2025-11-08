import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables (optional - won't crash if file doesn't exist)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env file not found or couldn't be loaded
    // App will use default values from env.dart
    debugPrint('Warning: .env file not found. Using default configuration.');
  }
  
  runApp(const App());
}
