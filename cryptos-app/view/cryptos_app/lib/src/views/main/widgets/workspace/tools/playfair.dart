import 'dart:io';

import 'package:cryptos_app/src/models/history_model.dart';
import 'package:cryptos_app/src/utils/screen_info.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/endecode_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for clipboard functionality
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:process_run/process_run.dart';

class PlayfairCipherToolWidget extends StatefulWidget {
  const PlayfairCipherToolWidget({super.key});

  @override
  State<PlayfairCipherToolWidget> createState() =>
      _PlayfairCipherToolWidgetState();
}

class _PlayfairCipherToolWidgetState extends State<PlayfairCipherToolWidget> {
  final TextEditingController _plainTextController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _encryptedTextController =
      TextEditingController();

  void _showDocumentationDialog() async {
    final markdownContent = await DefaultAssetBundle.of(context)
        .loadString('assets/docs/playfair.md');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
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
    String text = _plainTextController.text.toUpperCase().replaceAll(" ", "");
    String key = _keyController.text.toUpperCase().replaceAll(" ", "");
    String encrypt =
        _encryptedTextController.text.toUpperCase().replaceAll(" ", "");

    if (isEncode) {
      if (text.isEmpty || key.isEmpty) {
        _encryptedTextController.text = 'Both fields must be filled.';
        return;
      }
    } else {
      if (encrypt.isEmpty || key.isEmpty) {
        _plainTextController.text = 'Both fields must be filled.';
        return;
      }
    }

    try {
      final result = await Process.run(
        'python',
        [
          'lib/scripts/playfair.py',
          isEncode ? 'encode' : 'decode',
          isEncode ? text : encrypt,
          key
        ],
      );

      if (result.exitCode != 0) {
        final errorText = 'Error: ${result.stderr.toString().trim()}';
        if (isEncode) {
          _encryptedTextController.text = errorText;
        } else {
          _plainTextController.text = errorText;
        }
      } else {
        final output = result.stdout.toString().trim();
        if (isEncode) {
          _encryptedTextController.text = output;
        } else {
          _plainTextController.text = output;
        }

        Hive.box<HistoryModel>('history').add(HistoryModel(
          opType: 0,
          opName: isEncode
              ? "Playfair Cipher - Encryption"
              : "Playfair Cipher - Decryption",
          content: isEncode ? text : encrypt,
          timestamp: DateTime.now().toIso8601String(),
        ));
      }
    } catch (e) {
      final errorText = 'An error occurred: $e';
      if (isEncode) {
        _encryptedTextController.text = errorText;
      } else {
        _plainTextController.text = errorText;
      }
    }
  }

  Future<void> _pasteFromClipboard() async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null) {
      _plainTextController.text = clipboardData.text ?? '';
    }
  }

  Future<void> _copyToClipboard() async {
    if (_encryptedTextController.text.isNotEmpty) {
      await Clipboard.setData(
        ClipboardData(text: _encryptedTextController.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Playfair Encoder | Decoder",
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
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Plain Text",
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF8899A9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: _pasteFromClipboard,
                      child: Text(
                        "Paste from clipboard",
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: _plainTextController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 12),
                      filled: true,
                      fillColor: const Color(0xFFEBF3FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0x568899A9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0x568899A9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0x568899A9)),
                      ),
                    ),
                    style: GoogleFonts.urbanist(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EndecodeButton(isEncode: true, onTap: () => _processText(true)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Key",
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF8899A9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 360,
                      height: 36,
                      child: TextField(
                        controller: _keyController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 12),
                          filled: true,
                          fillColor: const Color(0xFFEDF5FC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                width: 1, color: Color(0x568899A9)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                width: 1, color: Color(0x568899A9)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                width: 1, color: Color(0x568899A9)),
                          ),
                        ),
                        style: GoogleFonts.urbanist(),
                      ),
                    )
                  ],
                ),
                EndecodeButton(
                    isEncode: false, onTap: () => _processText(false)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Encrypted Text",
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF8899A9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: _copyToClipboard,
                      child: Text(
                        "Copy to clipboard",
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: _encryptedTextController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 12),
                      filled: true,
                      fillColor: const Color(0xFFEBF3FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0x568899A9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0x568899A9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 1, color: Color(0x568899A9)),
                      ),
                    ),
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
}
