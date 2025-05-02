import 'dart:io';
import 'package:cryptos_app/src/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:process_run/process_run.dart';

class MD5ToolWidget extends StatefulWidget {
  const MD5ToolWidget({super.key});

  @override
  State<MD5ToolWidget> createState() => _MD5ToolWidgetState();
}

class _MD5ToolWidgetState extends State<MD5ToolWidget> {
  final TextEditingController _plainTextController = TextEditingController();
  final TextEditingController _encryptedTextController = TextEditingController();

  void _showDocumentationDialog() async {
    final markdownContent = await DefaultAssetBundle.of(context)
        .loadString('assets/docs/MD5 Hashing doc.md');

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
    String text = _plainTextController.text.trim();

    if (text.isEmpty) {
      _encryptedTextController.text = 'Text field must be filled.';
      return;
    }

    final args = [
      'lib/scripts/md5.py',
      'hash',
      text,
    ];

    try {
      final result = await Process.run('python', args);

      if (result.exitCode != 0) {
        _encryptedTextController.text = 'Error: ${result.stderr.toString().trim()}';
      } else {
        _encryptedTextController.text = result.stdout.toString().trim();
        Hive.box<HistoryModel>('history').add(HistoryModel(
          opType: 0,
          opName: "MD5 Hashing Algorithm",
          content: text,
          timestamp: DateTime.now().toIso8601String(),
        ));
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

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
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
                  "MD5 Hashing Tool",
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

          // Plain Text Input
          _labeledTextField("Plain Text", "Paste from clipboard", _plainTextController,
              onActionTap: _pasteFromClipboard),

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
          _labeledTextField("Hash Output", "Copy to clipboard", _encryptedTextController,
              readOnly: true, onActionTap: () => _copyToClipboard(_encryptedTextController.text)),
        ],
      ),
    );
  }

  Widget _labeledTextField(
      String label, String actionLabel, TextEditingController controller,
      {bool readOnly = false, VoidCallback? onActionTap}) {
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
              GestureDetector(
                onTap: onActionTap,
                child: Text(
                  actionLabel,
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
}
