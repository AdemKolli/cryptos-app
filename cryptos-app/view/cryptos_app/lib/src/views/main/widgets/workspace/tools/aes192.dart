import 'dart:io';

import 'package:cryptos_app/src/models/history_model.dart';
import 'package:cryptos_app/src/utils/screen_info.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/endecode_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:process_run/process_run.dart';

class AES192ToolWidget extends StatefulWidget {
  const AES192ToolWidget({super.key});

  @override
  State<AES192ToolWidget> createState() => _AES192ToolWidgetState();
}

class _AES192ToolWidgetState extends State<AES192ToolWidget> {
  final TextEditingController _plainTextController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _encryptedTextController =
      TextEditingController();

  void _showDocumentationDialog() async {
    final markdownContent = await DefaultAssetBundle.of(context)
        .loadString('assets/docs/AES-192 doc.md');

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
    String text = _plainTextController.text.replaceAll(" ", "");
    String key = _keyController.text.replaceAll(" ", "");
    String encrypt =
        _encryptedTextController.text.replaceAll(" ", "");
    if (isEncode) {
      if (text.isEmpty || key.isEmpty) {
        _encryptedTextController.text = 'Both fields must be filled.';
        return;
      }
    } else {
      if (encrypt.isEmpty || key.isEmpty) {
        _plainTextController.text = 'Both fields must be filled.';
        return;
      } else if (key.length < 16) {
        _plainTextController.text.contains("other");
        _encryptedTextController.text = _encryptedTextController.text.substring(91);
        encrypt = _encryptedTextController.text;
      }
    }

    try {
      final result = await Process.run(
        'python',
        [
          'lib/scripts/aes192.py',
          isEncode ? 'encode' : 'decode',
          isEncode ? text : encrypt,
          key
        ],
      );

      if (isEncode) {
        if (result.exitCode != 0) {
          _encryptedTextController.text =
              'Error: ${result.stderr.toString().trim()}';
        } else {
          _encryptedTextController.text = result.stdout.toString().trim();
          Hive.box<HistoryModel>('history').add(HistoryModel(
              opType: 0,
              opName: isEncode
                  ? "AES 192 bit Key - Encryption"
                  : "AES 192 bit Key - Decryption",
              content: isEncode ? text : encrypt,
                timestamp: DateTime.now().toIso8601String()));
        }
      } else {
        if (result.exitCode != 0) {
          _plainTextController.text =
              'Error: ${result.stderr.toString().trim()}';
        } else {
          _plainTextController.text = result.stdout.toString().trim();
          Hive.box<HistoryModel>('history').add(HistoryModel(
              opType: 0,
              opName: isEncode
                  ? "AES 128 bit Key - Encryption"
                  : "AES 128 bit Key - Decryption",
              content: isEncode ? text : encrypt,
              timestamp: DateTime.now().toIso8601String()));
        }
      }
    } catch (e) {
      _encryptedTextController.text = 'An error occurred: $e';
    }
  }

  Future<void> _pasteFromClipboard() async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null) {
      _plainTextController.text = clipboardData.text ?? '';
    }
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _encryptedTextController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
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
                  "AES 192 bit Key Encoder | Decoder",
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: _showDocumentationDialog,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    )
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
                          width: 1,
                          color: Color(0x568899A9),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0x568899A9),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0x568899A9),
                        ),
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
                              width: 1,
                              color: Color(0x568899A9),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0x568899A9),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0x568899A9),
                            ),
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
                    )
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
                          width: 1,
                          color: Color(0x568899A9),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0x568899A9),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0x568899A9),
                        ),
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
