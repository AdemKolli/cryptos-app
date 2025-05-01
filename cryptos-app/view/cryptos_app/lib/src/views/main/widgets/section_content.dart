import 'package:cryptos_app/src/controllers/display_controller.dart';
import 'package:cryptos_app/src/utils/debug_box.dart';
import 'package:cryptos_app/src/utils/screen_info.dart';
import 'package:cryptos_app/src/views/main/widgets/home/history_card.dart';
import 'package:cryptos_app/src/views/main/widgets/home/home_content.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/workspace_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class SectionContent extends StatelessWidget {
  const SectionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DisplayController>(
        builder: (context, displayController, _) {
      return AnimatedSwitcher(
          duration: Durations.medium4,
          switchInCurve: Easing.legacy,
          switchOutCurve: Easing.legacy,
          child: displayController.actualContent == MainScreenContent.home
              ? const HomeContent()
              : const WorkspaceContent());
    });
  }
}
