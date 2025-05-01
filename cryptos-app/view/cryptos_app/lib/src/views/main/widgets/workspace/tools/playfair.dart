import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayfairToolWidget extends StatelessWidget {
  const PlayfairToolWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Coming Soon",
        style: GoogleFonts.urbanist(
          color: Colors.black.withOpacity(0.4),
          fontSize: 32,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}