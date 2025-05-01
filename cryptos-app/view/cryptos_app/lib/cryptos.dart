import 'package:cryptos_app/src/controllers/display_controller.dart';
import 'package:cryptos_app/src/controllers/workspace_controller.dart';
import 'package:cryptos_app/src/services/history_service.dart';
import 'package:cryptos_app/src/utils/screen_info.dart';
import 'package:cryptos_app/src/views/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CryptosApp extends StatelessWidget {
  const CryptosApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenInfo.height = MediaQuery.of(context).size.height;
    ScreenInfo.width = MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DisplayController(),
        ),
        ChangeNotifierProvider(
          create: (_) => WorkspaceController(),
        ),
        Provider(create: (_) => HistoryService()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}
