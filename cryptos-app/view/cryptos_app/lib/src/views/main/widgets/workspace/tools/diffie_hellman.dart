import 'dart:io';
import 'package:cryptos_app/src/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:process_run/process_run.dart';

class DiffieHellmanToolWidget extends StatefulWidget {
  const DiffieHellmanToolWidget({super.key});

  @override
  State<DiffieHellmanToolWidget> createState() => _DiffieHellmanToolWidgetState();
}

class _DiffieHellmanToolWidgetState extends State<DiffieHellmanToolWidget> {
  final TextEditingController _nController = TextEditingController();
  final TextEditingController _gController = TextEditingController();
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _yController = TextEditingController();
  final TextEditingController _sharedXController = TextEditingController();
  final TextEditingController _sharedYController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  void _showDocumentationDialog() async {
    final markdownContent = await DefaultAssetBundle.of(context)
        .loadString('assets/docs/DiffieHellman.md');

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

  Future<void> _processText() async {
    final args = ['lib/scripts/diffie_hellman.py', 'key_exchange'];

    void addIfFilled(String value) {
      args.add(value.trim().isNotEmpty ? value.trim() : 'None');
    }

    addIfFilled(_nController.text);
    addIfFilled(_gController.text);
    addIfFilled(_xController.text);
    addIfFilled(_yController.text);
    addIfFilled(_sharedXController.text);
    addIfFilled(_sharedYController.text);

    try {
      final result = await Process.run('python', args);

      if (result.exitCode != 0) {
        _outputController.text = 'Error: ${result.stderr.toString().trim()}';
      } else {
        _outputController.text = result.stdout.toString().trim();
        Hive.box<HistoryModel>('history').add(HistoryModel(
          opType: 0,
          opName: "Diffie-Hellman Key Exchange Algorithm",
          content: _outputController.text,
          timestamp: DateTime.now().toIso8601String(),
        ));
      }
    } catch (e) {
      _outputController.text = 'An error occurred: $e';
    }
  }

  Widget _labeledTextField(String label, String actionLabel, TextEditingController controller,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF8899A9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
              GestureDetector(
                onTap: () async {
                  if (readOnly) {
                    // Copy to clipboard
                    await Clipboard.setData(ClipboardData(text: controller.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Copied to clipboard")),
                    );
                  } else {
                    // Paste from clipboard
                    final clipboardData = await Clipboard.getData('text/plain');
                    if (clipboardData != null) {
                      controller.text = clipboardData.text ?? '';
                    }
                  }
                },
                child: Text(actionLabel,
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
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
    );
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
                  "Diffie-Hellman Key Exchange",
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: _showDocumentationDialog,
                  child: Container(
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
                  ),
                )
              ],
            ),
          ),

          _labeledTextField("Prime N", "Paste from clipboard", _nController),
          _labeledTextField("Base G", "Paste from clipboard", _gController),
          _labeledTextField("Private x (Alice)", "Paste from clipboard", _xController),
          _labeledTextField("Private y (Bob)", "Paste from clipboard", _yController),
          _labeledTextField("Shared Key X (G^x mod N)", "Paste from clipboard", _sharedXController),
          _labeledTextField("Shared Key Y (G^y mod N)", "Paste from clipboard", _sharedYController),

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
                    "Run",
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

          // Output
          _labeledTextField("Exchange Output", "Copy to clipboard", _outputController, readOnly: true),
        ],
      ),
    );
  }
}
