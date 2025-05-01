import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EndecodeButton extends StatelessWidget {
  final bool isEncode;
  final Function() onTap;
  const EndecodeButton({super.key, required this.isEncode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(isEncode ? "assets/Arrow 2.svg" : "assets/Arrow 3.svg"),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Center(
              child: Text(
                isEncode ? "Encode" : "Decode",
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}