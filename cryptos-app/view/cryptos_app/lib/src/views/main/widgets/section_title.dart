import 'package:cryptos_app/src/controllers/display_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DisplayController>(
        builder: (context, displayController, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedSwitcher(
            duration: Durations.extralong4,
          switchInCurve: Easing.legacy,
          switchOutCurve: Easing.legacy,
            child: displayController.actualContent == MainScreenContent.home
                ? Text(
                    'Home - Welcome Back, User',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Text(
                    'Workspace Section',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          Opacity(
            opacity: 0.23,
            child: Text(
              'Today’s date - Thu 14th April 2025',
              textAlign: TextAlign.right,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      );
    });
  }
}
