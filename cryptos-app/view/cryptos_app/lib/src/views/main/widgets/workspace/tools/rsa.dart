import 'dart:io';

import 'package:cryptos_app/src/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class RSAToolWidget extends StatefulWidget {
  const RSAToolWidget({super.key});

  @override
  State<RSAToolWidget> createState() => _RSAToolWidgetState();
}

class _RSAToolWidgetState extends State<RSAToolWidget> {
  final TextEditingController _plainTextController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _encryptedTextController =
      TextEditingController();

  String? _privateKey;
  bool _canDecrypt = false;

  void _showDocumentationDialog() async {
    final markdownContent =
        await DefaultAssetBundle.of(context).loadString('assets/docs/RSA.md');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        // title: const Text('Playfair Cipher Documentation'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: MarkdownBody(
              data: markdownContent,
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _processText(bool isEncode) async {
    String text = _plainTextController.text.replaceAll(" ", "");
    String encrypt = _encryptedTextController.text;

    if (isEncode) {
      if (text.isEmpty) {
        _encryptedTextController.text = 'Text must be filled.';
        return;
      }
    } else {
      if (!_canDecrypt || encrypt.isEmpty || _privateKey == null) {
        _plainTextController.text = 'Encryption must be done first.';
        return;
      }
    }

    try {
      // print("${encrypt},${_privateKey}");
      final result = await Process.run(
        'python',
        isEncode
            ? ['lib/scripts/rsa.py', 'encode', text]
            : ['lib/scripts/rsa.py', 'decode', encrypt, _privateKey!],
      );

      if (result.exitCode != 0) {
        final error = result.stderr.toString().trim();
        if (isEncode) {
          _encryptedTextController.text = 'Error: $error';
        } else {
          _plainTextController.text = 'Error: $error';
        }
      } else {
        final outputLines = result.stdout.toString().trim().split('\n');
        if (isEncode) {
          _encryptedTextController.text = outputLines[0];
          for (var line in outputLines) {
            if (line.startsWith("PRIVATE_KEY=")) {
              _privateKey = line.replaceFirst("PRIVATE_KEY=", "");
              // print(_privateKey);
              _canDecrypt = true;
            }
          }

          _keyController.text = outputLines
              .where((line) =>
                  line.startsWith("PUBLIC_KEY=") ||
                  line.startsWith("PRIVATE_KEY="))
              .map((line) => line
                  .replaceAll("PUBLIC_KEY=", "Public: ")
                  .replaceAll("PRIVATE_KEY=", "Private: "))
              .join("|| ");
          // print(_keyController.text);
          Hive.box<HistoryModel>('history').add(HistoryModel(
              opType: 0,
              opName: isEncode
                  ? "RSA Algorithm - Encryption"
                  : "RSA Algorithm - Decryption",
              content: isEncode ? text : encrypt,
              timestamp: DateTime.now().toIso8601String()));
          setState(() {}); // Refresh UI
        } else {
          _plainTextController.text = outputLines.join('\n');
          Hive.box<HistoryModel>('history').add(HistoryModel(
              opType: 0,
              opName: isEncode
                  ? "RSA Algorithm - Encryption"
                  : "RSA Algorithm - Decryption",
              content: isEncode ? text : encrypt,
              timestamp: DateTime.now().toIso8601String()));
        }
      }
    } catch (e) {
      final errorMessage = 'An error occurred: $e';
      if (isEncode) {
        _encryptedTextController.text = errorMessage;
      } else {
        _plainTextController.text = errorMessage;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "RSA Algorithm Encoder | Decoder",
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: _showDocumentationDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Check Documentation",
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          // Plain Text Input
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Plain Text", style: _labelStyle()),
                    InkWell(
                        onTap: () async {
                          final clipboardData =
                              await Clipboard.getData('text/plain');
                          if (clipboardData != null &&
                              clipboardData.text != null) {
                            setState(() {
                              _plainTextController.text = clipboardData.text!;
                            });
                          }
                        },
                        child: Text("Paste from clipboard",
                            style: _activeStyle())),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: _plainTextController,
                    maxLines: 3,
                    decoration: _fieldDecoration(),
                    style: GoogleFonts.urbanist(),
                  ),
                ),
              ],
            ),
          ),

          // Buttons & Key
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionButton(true, () => _processText(true)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Key", style: _labelStyle()),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 360,
                      height: 36,
                      child: TextField(
                        controller: _keyController,
                        readOnly: true,
                        decoration: _fieldDecoration(),
                        style: GoogleFonts.urbanist(),
                      ),
                    ),
                  ],
                ),
                _actionButton(
                    false, _canDecrypt ? () => _processText(false) : null),
              ],
            ),
          ),

          // Encrypted Text Field
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Encrypted Text", style: _labelStyle()),
                    InkWell(
                        onTap: () {
                          if (_encryptedTextController.text.isNotEmpty) {
                            Clipboard.setData(
                              ClipboardData(
                                  text: _encryptedTextController.text),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.black,
                                content: Text('Copied to clipboard',
                                    style: GoogleFonts.urbanist()),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child:
                            Text("Copy to clipboard", style: _activeStyle())),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: _encryptedTextController,
                    readOnly: !_canDecrypt,
                    maxLines: 3,
                    decoration: _fieldDecoration(),
                    style: GoogleFonts.urbanist(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // UI Style Helpers
  TextStyle _labelStyle() => GoogleFonts.urbanist(
        color: const Color(0xFF8899A9),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  TextStyle _activeStyle() => GoogleFonts.urbanist(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  InputDecoration _fieldDecoration() => InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        filled: true,
        fillColor: const Color(0xFFEDF5FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 1, color: Color(0x568899A9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 1, color: Color(0x568899A9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 1, color: Color(0x568899A9)),
        ),
      );

  Widget _actionButton(bool isEncode, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onTap != null ? Colors.black : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          isEncode ? "Encrypt" : "Decrypt",
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
