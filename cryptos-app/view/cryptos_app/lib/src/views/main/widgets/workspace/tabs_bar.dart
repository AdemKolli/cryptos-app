import 'package:cryptos_app/src/views/main/widgets/workspace/add_tab_button.dart';
import 'package:cryptos_app/src/views/main/widgets/workspace/custom_tab.dart';
import 'package:flutter/cupertino.dart';

class TabsBar extends StatelessWidget {
  const TabsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CustomTab(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: AddTabButton(),
        )
      ],
    );
  }
}