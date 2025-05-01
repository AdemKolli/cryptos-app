import 'package:cryptos_app/src/views/main/widgets/sidebar.dart';
import 'package:flutter/material.dart';

enum MainScreenContent {
  home,
  workspace,
}

enum SidebarStatus {
  collapsed,
  open,
}


class DisplayController extends ChangeNotifier {
  MainScreenContent _actualSection = MainScreenContent.home;
  SidebarStatus _sidebar = SidebarStatus.collapsed; 

  MainScreenContent get actualContent => _actualSection;
  SidebarStatus get sidebar => _sidebar;

  void setContent(MainScreenContent section) {
    _actualSection = section;
    notifyListeners();
  }

  void toggleSidebar(){
    _sidebar = _sidebar == SidebarStatus.collapsed ? SidebarStatus.open : SidebarStatus.collapsed;
    notifyListeners();
  }

}