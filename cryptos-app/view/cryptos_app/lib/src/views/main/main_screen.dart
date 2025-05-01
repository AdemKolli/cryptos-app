import 'package:cryptos_app/src/utils/debug_box.dart';
import 'package:cryptos_app/src/views/main/widgets/home/logo.dart';
import 'package:cryptos_app/src/views/main/widgets/section_content.dart';
import 'package:cryptos_app/src/views/main/widgets/section_title.dart';
import 'package:cryptos_app/src/views/main/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 54),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(),
                SectionTitle()
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 60),
                  child: SideBar(),
                ),
                Expanded(
                  child: SectionContent()
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}