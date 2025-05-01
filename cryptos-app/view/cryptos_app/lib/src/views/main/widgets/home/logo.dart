import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Cryptos ',
            style: GoogleFonts.urbanist(
              color: const Color(0xFF101010),
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: 'app',
            style: GoogleFonts.urbanist(
              color: const Color(0xFF101010),
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
