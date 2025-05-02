import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryCard extends StatelessWidget {
  final int opType;
  final String opName;
  final String content;
  final String timestamp;

  const HistoryCard({super.key, required this.opType, required this.opName, required this.content, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 211,
      height: 257,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07),)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  opType == 1 ? 'File Encryption' : 'Text Encryption',
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF8899A9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const ShapeDecoration(
                        shape: OvalBorder(
                          side: BorderSide(
                            width: 1,
                            color: Color(0x568899A9),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const ShapeDecoration(
                        color: Colors.black,
                        shape: OvalBorder(),
                      ),
                    ),
                    SvgPicture.asset(
                       opType == 1 ? 'assets/file.svg' : 'assets/text.svg',
                      width: 18,
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              width: 175,
              child: Text(
                opName,
                style: GoogleFonts.urbanist(
                  color: const Color(0xFF101010),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: 175,
                  child: Opacity(
                    opacity: 0.33,
                    child: Text(
                      opType == 1 ? 'File name' : 'Input Text',
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF101010),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.31),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      content,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF101010),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 175,
              child: Opacity(
                opacity: 0.33,
                child: Text(
                  timestamp,
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF101010),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
