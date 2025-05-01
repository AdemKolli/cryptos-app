import 'package:cryptos_app/src/controllers/display_controller.dart';
import 'package:cryptos_app/src/utils/screen_info.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tab_content.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/tabs_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkspaceContent extends StatelessWidget {
  const WorkspaceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DisplayController>(
      builder: (context, displayController, _) {
        return AnimatedContainer(
          padding: const EdgeInsets.all(32),
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
          child: const Column(
            children: [
              TabsBar(),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: TabContent(),
              )
            ],
          ),
        );
      }
    );
  }
}
