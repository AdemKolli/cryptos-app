import 'dart:io';
import 'package:cryptos_app/src/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:process_run/process_run.dart';

class SHA256ToolWidget extends StatefulWidget {
  const SHA256ToolWidget({super.key});

  @override
  State<SHA256ToolWidget> createState() => _SHA256ToolWidgetState();
}

class _SHA256ToolWidgetState extends State<SHA256ToolWidget> {
  final TextEditingController _plainTextController = TextEditingController();
  final TextEditingController _saltController = TextEditingController();
  final TextEditingController _encryptedTextController =
      TextEditingController();

  int _saltPosition = 1; // 1 for prefix, 2 for suffix

  Future<void> _processText() async {
    String text = _plainTextController.text.trim();
    String salt = _saltController.text.trim();

    if (text.isEmpty) {
      _encryptedTextController.text = 'Text field must be filled.';
      return;
    }

    final args = [
      'lib/scripts/sha256.py',
      'encode',
      text,
    ];

    if (salt.isNotEmpty) {
      args.add(salt);
      args.add(_saltPosition.toString());
    }

    try {
      final result = await Process.run('python', args);

      if (result.exitCode != 0) {
        _encryptedTextController.text =
            'Error: ${result.stderr.toString().trim()}';
      } else {
        _encryptedTextController.text = result.stdout.toString().trim();
        Hive.box<HistoryModel>('history').add(HistoryModel(
            opType: 0,
            opName: "SHA256 Hashing",
            content: text,
            timestamp: DateTime.now().toIso8601String()));
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
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "SHA-256 Hashing Tool",
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
                )
              ],
            ),
          ),

          // Plain Text Input
          _labeledTextField(
              "Plain Text", "Paste from clipboard", _plainTextController),

          // Salt Input
          _labeledTextField("Salt", "Optional input", _saltController),

          // Salt Position Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text(
                  "Salt Position:",
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF8899A9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  value: _saltPosition,
                  style:
                      GoogleFonts.urbanist(color: Colors.black, fontSize: 14),
                  borderRadius: BorderRadius.circular(8),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("Prefix")),
                    DropdownMenuItem(value: 2, child: Text("Suffix")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _saltPosition = value ?? 1;
                    });
                  },
                ),
              ],
            ),
          ),

          // Encode Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: _processText,
                child: Container(
                  width: 140,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Encode",
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Encrypted Text Output
          _labeledTextField(
              "Hash Output", "Copy to clipboard", _encryptedTextController,
              readOnly: true),
        ],
      ),
    );
  }

  Widget _labeledTextField(
      String label, String actionLabel, TextEditingController controller,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.urbanist(
                  color: const Color(0xFF8899A9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                actionLabel,
                style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              maxLines: 3,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                filled: true,
                fillColor: const Color(0xFFEBF3FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(width: 1, color: Color(0x568899A9)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(width: 1, color: Color(0x568899A9)),
                ),
                focusedBorder: OutlineInputBorder(
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
    );
  }
}
