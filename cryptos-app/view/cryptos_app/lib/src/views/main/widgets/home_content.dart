import 'package:cryptos_app/src/controllers/display_controller.dart';
import 'package:cryptos_app/src/utils/screen_info.dart';
import 'package:cryptos_app/src/views/main/widgets/history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DisplayController>(
      builder: (context,displayController,_) {
        return AnimatedContainer(
          duration: Durations.medium4,
          height: ScreenInfo.height * 0.73,
          decoration: ShapeDecoration(
            color: displayController.sidebar == SidebarStatus.collapsed
                ? const Color(0xFFEEF6FD)
                : Colors.white,
            shape: RoundedRectangleBorder(
              side: displayController.sidebar == SidebarStatus.collapsed
                  ? BorderSide.none
                  : BorderSide(color: Colors.black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(46),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextScroll(
                  '● All you need in one ● All you need in one ● All you need in one',
                  fadedBorder: true,
                  fadedBorderWidth: 0.2,
                  mode: TextScrollMode.endless,
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/logo.svg',
                        height: 55,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 528,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Discover ',
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Cryptos',
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' App, your all-in-one desktop solution for seamless cryptography! With a suite of powerful tools for encrypting text and files, it simplifies your daily security needs. Stay safe and secure with Cryptos App!',
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      AnimationLimiter(
                        child: ListView.builder(
                          itemCount: 100,
                          padding: const EdgeInsets.only(left: 20),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 900),
                              child: const SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: HistoryCard(
                                      opType: 1,
                                      opName: 'AES File Encryption',
                                      content: 'test_file.txt',
                                      timestamp: '13:46 - 16th Jun 2025',
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Left fade
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: IgnorePointer(
                          child: AnimatedContainer(
                            duration: Durations.medium4,
                            width: 30,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: displayController.sidebar ==
                                          SidebarStatus.collapsed
                                      ? [
                                          const Color(0xFFEEF6FD),
                                          const Color(0xFFEEF6FD).withOpacity(0.0),
                                        ]
                                      : [
                                          Colors.white,
                                          Colors.white.withOpacity(0)
                                        ]),
                            ),
                          ),
                        ),
                      ),
        
                      // Right fade
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: IgnorePointer(
                          child: Container(
                            width: 30,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: displayController.sidebar ==
                                          SidebarStatus.collapsed
                                      ? [
                                          const Color(0xFFEEF6FD),
                                          const Color(0xFFEEF6FD).withOpacity(0.0),
                                        ]
                                      : [
                                          Colors.white,
                                          Colors.white.withOpacity(0)
                                        ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
