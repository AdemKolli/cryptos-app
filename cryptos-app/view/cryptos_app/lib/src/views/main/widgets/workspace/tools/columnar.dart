import 'dart:io';

import 'package:cryptos_app/src/models/history_model.dart';
import 'package:cryptos_app/src/utils/screen_info.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/endecode_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:process_run/process_run.dart';

class ColumnarToolWidget extends StatefulWidget {
  const ColumnarToolWidget({super.key});

  @override
  State<ColumnarToolWidget> createState() => _ColumnarToolWidgetState();
}

class _ColumnarToolWidgetState extends State<ColumnarToolWidget> {
  final TextEditingController _plainTextController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _encryptedTextController = TextEditingController();

  Future<void> _processText(bool isEncode) async {
    String text = _plainTextController.text.toUpperCase().replaceAll(" ", "");
    String key = _keyController.text.toUpperCase().replaceAll(" ", "");
    String encrypt = _encryptedTextController.text.toUpperCase().replaceAll(" ", "");

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
          'lib/scripts/columnar.py',
          isEncode ? 'encode' : 'decode',
          isEncode ? text : encrypt,
          key
        ],
      );

      if (result.exitCode != 0) {
        final errorMsg = 'Error: ${result.stderr.toString().trim()}';
        if (isEncode) {
          _encryptedTextController.text = errorMsg;
        } else {
          _plainTextController.text = errorMsg;
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
            opName: isEncode
                ? "Columnar Cipher - Encryption"
                : "Columnar Cipher - Decryption",
            content: isEncode ? text : encrypt,
            timestamp: "timestamp",
          ),
        );
      }
    } catch (e) {
      _encryptedTextController.text = 'An error occurred: $e';
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
                  "Columnar Encoder | Decoder",
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    Text(
                      "Paste from clipboard",
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      filled: true,
                      fillColor: const Color(0xFFEBF3FA),
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
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
                        ),
                        style: GoogleFonts.urbanist(),
                      ),
                    )
                  ],
                ),
                EndecodeButton(isEncode: false, onTap: () => _processText(false)),
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
                    Text(
                      "Copy to clipboard",
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      filled: true,
                      fillColor: const Color(0xFFEBF3FA),
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
