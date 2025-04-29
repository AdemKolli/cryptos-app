import 'package:cryptos_app/src/controllers/display_controller.dart';
import 'package:cryptos_app/src/utils/screen_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DisplayController>(
        builder: (context, displayController, _) {
      return AnimatedContainer(
        duration: Durations.medium4,
        curve: Easing.legacy,
        width: displayController.sidebar == SidebarStatus.open ? 175 : 72,
        height: ScreenInfo.height * 0.73,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/logo-white.svg',
                        width: 32,
                      ),
                      AnimatedSize(
                        duration: Durations.medium4,
                        curve: Curves.easeInOut,
                        child: ClipRect(
                          child: Row(
                            children: [
                              SizedBox(
                                  width: displayController.sidebar ==
                                          SidebarStatus.open
                                      ? 10
                                      : 0),
                              AnimatedOpacity(
                                duration: Durations.medium4,
                                opacity: displayController.sidebar ==
                                        SidebarStatus.open
                                    ? 1
                                    : 0,
                                child: displayController.sidebar ==
                                        SidebarStatus.open
                                    ? Text(
                                        'Menu',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.urbanist(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : const SizedBox(), // Avoid occupying space when hidden
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Opacity(
                    opacity: 0.28,
                    child: AnimatedContainer(
                      duration: Durations.medium4,
                      curve: Easing.legacy,
                      width: displayController.sidebar == SidebarStatus.open
                          ? 175
                          : 72,
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.5,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: ScreenInfo.height * 0.12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        displayController.setContent(MainScreenContent.home);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/home.svg',
                            height: 30,
                            width: 30,
                          ),
                          AnimatedSize(
                            duration: Durations.medium4,
                            curve: Curves.easeInOut,
                            child: ClipRect(
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: displayController.sidebar ==
                                              SidebarStatus.open
                                          ? 10
                                          : 0),
                                  AnimatedOpacity(
                                    duration: Durations.medium4,
                                    opacity: displayController.sidebar ==
                                            SidebarStatus.open
                                        ? 1
                                        : 0,
                                    child: displayController.sidebar ==
                                            SidebarStatus.open
                                        ? Text(
                                            'Home',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.urbanist(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : const SizedBox(), // Avoid occupying space when hidden
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        displayController.setContent(MainScreenContent.workspace);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/workspace.svg',
                          ),
                          AnimatedSize(
                            duration: Durations.medium4,
                            curve: Curves.easeInOut,
                            child: ClipRect(
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: displayController.sidebar ==
                                              SidebarStatus.open
                                          ? 10
                                          : 0),
                                  AnimatedOpacity(
                                    duration: Durations.medium4,
                                    opacity: displayController.sidebar ==
                                            SidebarStatus.open
                                        ? 1
                                        : 0,
                                    child: displayController.sidebar ==
                                            SidebarStatus.open
                                        ? Text(
                                            'Workspace',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.urbanist(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : const SizedBox(), // Avoid occupying space when hidden
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Opacity(
                    opacity: 0.28,
                    child: AnimatedContainer(
                      duration: Durations.medium4,
                      curve: Easing.legacy,
                      width: displayController.sidebar == SidebarStatus.open
                          ? 175
                          : 72,
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.5,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      displayController.toggleSidebar();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/switch.svg',
                          height: 30,
                          width: 30,
                        ),
                        AnimatedSize(
                          duration: Durations.medium4,
                          curve: Curves.easeInOut,
                          child: ClipRect(
                            child: Row(
                              children: [
                                SizedBox(
                                    width: displayController.sidebar ==
                                            SidebarStatus.open
                                        ? 10
                                        : 0),
                                AnimatedOpacity(
                                  duration: Durations.medium4,
                                  opacity: displayController.sidebar ==
                                          SidebarStatus.open
                                      ? 1
                                      : 0,
                                  child: displayController.sidebar ==
                                          SidebarStatus.open
                                      ? Text(
                                          'Collapse the bar',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : const SizedBox(), // Avoid occupying space when hidden
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
