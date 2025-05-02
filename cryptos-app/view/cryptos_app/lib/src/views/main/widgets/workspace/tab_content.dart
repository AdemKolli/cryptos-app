import 'package:cryptos_app/src/controllers/workspace_controller.dart';
import 'package:cryptos_app/src/utils/screen_info.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/endecode_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TabContent extends StatelessWidget {
  const TabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceController>(
        builder: (context, workspaceController, _) {
      return Container(
        height: ScreenInfo.height * 0.55,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: Builder(
            builder: (context) {
              switch (workspaceController.selectedTool) {
                case 'Vigenère Cipher':
                  return workspaceController.toolContent[0];
                case 'AES Algorithm - 128 bit key (Advanced Encryption Standard)':
                  return workspaceController.toolContent[1];
                case 'AES Algorithm - 192 bit key (Advanced Encryption Standard)':
                  return workspaceController.toolContent[2];
                case 'AES Algorithm - 256 bit key (Advanced Encryption Standard)':
                  return workspaceController.toolContent[3];
                case 'RSA Algorithm (Rivest–Shamir–Adleman)':
                  return workspaceController.toolContent[4];
                case 'SHA-256 Hash Algorithm':
                  return workspaceController.toolContent[5];
                case 'Complex Columnar Transposition':
                  return workspaceController.toolContent[6];
                case 'Playfair Cipher':
                  return workspaceController.toolContent[7];
                case 'DES Algorithm (Data Encryption Standard)':
                  return workspaceController.toolContent[8];
                case 'Polybius Square Transposition':
                  return workspaceController.toolContent[9];
                case 'MD5 Hash Algorithm':
                  return workspaceController.toolContent[10];
                case 'Diffie–Hellman Algorithm (Key Exchange)':
                  return workspaceController.toolContent[11];
                
                // Add cases for other tools as needed
                default:
                  return Center(
                    child: Text(
                      'Tool not implemented yet',
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      );
    });
  }
}

// class TabContent extends StatelessWidget {
//   const TabContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: ScreenInfo.height * 0.55,
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(8)),
//       child: SingleChildScrollView(
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Vigenère Encoder | Decoder",
//                     style: GoogleFonts.urbanist(
//                         color: Colors.black,
//                         fontSize: 24,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(8)),
//                     child: Text(
//                       "Check Documentation",
//                       style: GoogleFonts.urbanist(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Plain Text",
//                         style: GoogleFonts.urbanist(
//                             color: const Color(0xFF8899A9),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "Paste from clipboard",
//                         style: GoogleFonts.urbanist(
//                             color: Colors.black,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500),
//                       )
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: TextField(
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
//                         filled: true,
//                         fillColor: const Color(0xFFEBF3FA),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(
//                             width: 1,
//                             color: Color(0x568899A9),
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(
//                             width: 1,
//                             color: Color(0x568899A9),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(
//                             width: 1,
//                             color: Color(0x568899A9),
//                           ),
//                         ),
//                       ),
//                       style: GoogleFonts.urbanist(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   EndecodeButton(isEncode: true, onTap: () {}),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Key",
//                         style: GoogleFonts.urbanist(
//                             color: const Color(0xFF8899A9),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                         SizedBox(
//                           width: 360,
//                           height: 36,
//                           child: TextField(
//                           decoration: InputDecoration(
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 22, vertical: 12),
//                             filled: true,
//                             fillColor: const Color(0xFFEDF5FC),
//                             border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: const BorderSide(
//                               width: 1,
//                               color: Color(0x568899A9),
//                             ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: const BorderSide(
//                               width: 1,
//                               color: Color(0x568899A9),
//                             ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: const BorderSide(
//                               width: 1,
//                               color: Color(0x568899A9),
//                             ),
//                             ),
//                           ),
//                           style: GoogleFonts.urbanist(),
//                           ),
//                         )
//                     ],
//                   ),
//                   EndecodeButton(isEncode: false, onTap: () {})
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Encrypted Text",
//                         style: GoogleFonts.urbanist(
//                             color: const Color(0xFF8899A9),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "Copy to clipboard",
//                         style: GoogleFonts.urbanist(
//                             color: Colors.black,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500),
//                       )
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: TextField(
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
//                         filled: true,
//                         fillColor: const Color(0xFFEBF3FA),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(
//                             width: 1,
//                             color: Color(0x568899A9),
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(
//                             width: 1,
//                             color: Color(0x568899A9),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(
//                             width: 1,
//                             color: Color(0x568899A9),
//                           ),
//                         ),
//                       ),
//                       style: GoogleFonts.urbanist(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// A try - DONT'T UNCOMMENT PLEASE!!!


// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:process_run/process_run.dart';

// class TabContent extends StatefulWidget {
//   const TabContent({super.key});

//   @override
//   State<TabContent> createState() => _TabContentState();
// }

// class _TabContentState extends State<TabContent> {
//   final TextEditingController _plainTextController = TextEditingController();
//   final TextEditingController _keyController = TextEditingController();
//   String _resultText = '';

//   Future<void> _processText(bool isEncode) async {
//     String text = _plainTextController.text.toUpperCase().replaceAll(" ", "");
//     String key = _keyController.text.toUpperCase().replaceAll(" ", "");

//     if (text.isEmpty || key.isEmpty) {
//       setState(() {
//         _resultText = 'Both fields must be filled.';
//       });
//       return;
//     }

//     try {
//       final shell = Shell();

//       final result = await Process.run(
//         'python',
//         ['lib/scripts/columnar.py', isEncode ? 'encode' : 'decode', text, key],
//       );

//       if (result.exitCode != 0) {
//         setState(() {
//           _resultText = 'Error: ${result.stderr.toString().trim()}';
//         });
//       } else {
//         setState(() {
//           _resultText = result.stdout.toString().trim();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _resultText = 'An error occurred: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           TextField(
//             controller: _plainTextController,
//             decoration: const InputDecoration(
//               labelText: 'Plain Text',
//             ),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _keyController,
//             decoration: const InputDecoration(
//               labelText: 'Key',
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () => _processText(true),
//                 child: const Text('Encode'),
//               ),
//               ElevatedButton(
//                 onPressed: () => _processText(false),
//                 child: const Text('Decode'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           SelectableText(
//             _resultText,
//             style: const TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }

