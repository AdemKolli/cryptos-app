// src/controllers/workspace_controller.dart
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/vigenere.dart';
import 'package:flutter/material.dart';

class WorkspaceController extends ChangeNotifier {
  final List<String> tools = [
    'Vigenère Cipher', 
    'Playfair Cipher', 
    'Complex Columnar Transposition',
    "Polybius Square Transposition",
    "DES Algorithm (Data Encryption Standard)",
    "AES Algorithm (Advanced Encryption Standard)",
    "RSA Algorithm (Rivest–Shamir–Adleman)",
    "Diffie–Hellman Algorithm (Key Exchange)",
    "SHA-256 Hash Algorithm",
    "MD5 Hash Algorithm"
  ];

  final List<Widget> toolContent = [
    const VigenereToolWidget(),
  ];

  String _selectedTool = 'Vigenère Cipher';

  String get selectedTool => _selectedTool;

  void selectTool(String tool) {
    _selectedTool = tool;
    notifyListeners();
  }
}
