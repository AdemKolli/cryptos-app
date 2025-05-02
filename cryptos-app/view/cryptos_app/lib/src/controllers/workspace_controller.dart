// src/controllers/workspace_controller.dart
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/DES.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/aes128.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/aes192.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/aes256.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/columnar.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/diffie_hellman.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/md5.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/playfair.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/polybius.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/rsa.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/sha256.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tools/vigenere.dart';
import 'package:flutter/material.dart';

class WorkspaceController extends ChangeNotifier {
  final List<String> tools = [
    'Vigenère Cipher', 
    'Playfair Cipher', 
    'Complex Columnar Transposition',
    "Polybius Square Transposition",
    "DES Algorithm (Data Encryption Standard)",
    "AES Algorithm - 128 bit key (Advanced Encryption Standard)",
    "AES Algorithm - 192 bit key (Advanced Encryption Standard)",
    "AES Algorithm - 256 bit key (Advanced Encryption Standard)",
    "RSA Algorithm (Rivest–Shamir–Adleman)",
    "Diffie–Hellman Algorithm (Key Exchange)",
    "SHA-256 Hash Algorithm",
    "MD5 Hash Algorithm"
  ];

  final List<Widget> toolContent = [
    const VigenereToolWidget(),
    const AES128ToolWidget(),
    const AES192ToolWidget(),
    const AES256ToolWidget(),
    const RSAToolWidget(),
    const SHA256ToolWidget(),
    const ColumnarToolWidget(),
    const PlayfairCipherToolWidget(), 
    const DesToolWidget(),
    const PolybiusToolWidget(),
    const MD5ToolWidget(),
    const DiffieHellmanToolWidget()
  ];

  String _selectedTool = 'Vigenère Cipher';

  String get selectedTool => _selectedTool;

  void selectTool(String tool) {
    _selectedTool = tool;
    notifyListeners();
  }
}
