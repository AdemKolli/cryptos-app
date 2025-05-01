import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 10,bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(
            "Text Encryption - Vigenère Cipher",
            style: GoogleFonts.urbanist(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 20,),
          const Icon(
            Icons.close_rounded
          )
        ],
      ),
    );
  }
}
