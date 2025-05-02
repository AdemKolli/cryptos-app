import 'dart:io';

import 'package:cryptos_app/src/models/history_model.dart';
import 'package:cryptos_app/src/utils/screen_info.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/endecode_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:process_run/process_run.dart';

class PolybiusToolWidget extends StatefulWidget {
  const PolybiusToolWidget({super.key});

  @override
  State<PolybiusToolWidget> createState() => _PolybiusToolWidgetState();
}

class _PolybiusToolWidgetState extends State<PolybiusToolWidget> {
  final TextEditingController _plainTextController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _omitLetterController =
      TextEditingController(text: "W");
  final TextEditingController _resultController = TextEditingController();

  Future<void> _processText(bool isEncode) async {
    final text = _plainTextController.text.trim();
    final key = _keyController.text.trim();
    final omit = _omitLetterController.text.trim().toUpperCase();

    if (text.isEmpty) {
      _resultController.text = 'Both fields must be filled.';
      return;
    }

    try {
      final result = await Process.run(
        'python',
        [
          'lib/scripts/polybius.py',
          isEncode ? 'encode' : 'decode',
          text,
          key,
          omit,
        ],
      );

      if (result.exitCode != 0) {
        _resultController.text = 'Error: ${result.stderr}'.trim();
      } else {
        final output = result.stdout.toString().trim();
        _resultController.text = output;

        Hive.box<HistoryModel>('history').add(
          HistoryModel(
            opType: 0,
            opName:
                isEncode ? "Polybius – Encode" : "Polybius – Decode",
            content: text,
            timestamp: DateTime.now().toIso8601String(),
          ),
        );
      }
    } catch (e) {
      _resultController.text = 'An error occurred: $e';
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
                  "Polybius Cipher",
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
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
              ],
            ),
          ),

          // Text input
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Text",
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
              const SizedBox(height: 8),
              TextField(
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
            ]),
          ),

          // Buttons + Key + Omit
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EndecodeButton(
                    isEncode: true, onTap: () => _processText(true)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Key (optional)",
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF8899A9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Omit Letter",
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF8899A9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 80,
                      height: 36,
                      child: TextField(
                        controller: _omitLetterController,
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
                    ),
                  ],
                ),
                EndecodeButton(
                    isEncode: false, onTap: () => _processText(false)),
              ],
            ),
          ),

          // Result output
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Result",
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
              const SizedBox(height: 8),
              TextField(
                controller: _resultController,
                maxLines: 3,
                readOnly: true,
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
            ]),
          ),
        ],
      ),
    );
  }
}
