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

class DesToolWidget extends StatefulWidget {
  const DesToolWidget({super.key});

  @override
  State<DesToolWidget> createState() => _DesToolWidgetState();
}

class _DesToolWidgetState extends State<DesToolWidget> {
  final TextEditingController _plainTextController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _encryptedTextController =
      TextEditingController();

  void _showDocumentationDialog() async {
    final markdownContent = await DefaultAssetBundle.of(context)
        .loadString('assets/docs/des.md');

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
    final text = isEncode
        ? _plainTextController.text
        : _encryptedTextController.text;
    final key = _keyController.text;

    if (text.isEmpty || key.isEmpty) {
      if (isEncode) {
        _encryptedTextController.text = 'Both fields must be filled.';
      } else {
        _plainTextController.text = 'Both fields must be filled.';
      }
      return;
    }

    if (key.length != 8) {
      const error = 'Key must be exactly 8 characters.';
      if (isEncode) {
        _encryptedTextController.text = error;
      } else {
        _plainTextController.text = error;
      }
      return;
    }

    try {
      final result = await Process.run(
        'python',
        [
          'lib/scripts/des.py',
          isEncode ? 'encode' : 'decode',
          text,
          key,
        ],
      );

      if (result.exitCode != 0) {
        final err = result.stderr.toString().trim();
        if (isEncode) {
          _encryptedTextController.text = 'Error: $err';
        } else {
          _plainTextController.text = 'Error: $err';
        }
      } else {
        final output = result.stdout.toString().trim();
        if (isEncode) {
          _encryptedTextController.text = output;
        } else {
          _plainTextController.text = output;
        }

        Hive.box<HistoryModel>('history').add(
          HistoryModel(
            opType: 0,
            opName: isEncode ? "DES - Encryption" : "DES - Decryption",
            content: text,
            timestamp: DateTime.now().toIso8601String(),
          ),
        );
      }
    } catch (e) {
      final err = 'An error occurred: $e';
      if (isEncode) {
        _encryptedTextController.text = err;
      } else {
        _plainTextController.text = err;
      }
    }
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      _plainTextController.text = clipboardData.text!;
    }
  }

  Future<void> _copyToClipboard() async {
    final text = _encryptedTextController.text;
    if (text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard!')),
      );
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
                  "DES Encoder | Decoder",
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

          // Plain Text
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
                  padding: const EdgeInsets.only(top: 8),
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
                        borderSide:
                            const BorderSide(width: 1, color: Color(0x568899A9)),
                      ),
                    ),
                    style: GoogleFonts.urbanist(),
                  ),
                ),
              ],
            ),
          ),

          // Buttons & Key
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EndecodeButton(isEncode: true, onTap: () => _processText(true)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Key (8 chars)",
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF8899A9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 200,
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

          // Encrypted Text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
                  padding: const EdgeInsets.only(top: 8),
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
                        borderSide:
                            const BorderSide(width: 1, color: Color(0x568899A9)),
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
