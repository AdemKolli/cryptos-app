import 'package:cryptos_app/src/controllers/workspace_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ToolSelector extends StatelessWidget {
  const ToolSelector({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkspaceController>(
      builder: (context,workspaceController,_) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: workspaceController.selectedTool,
              dropdownColor: Colors.black,
              iconEnabledColor: Colors.white,
              style: GoogleFonts.urbanist(color: Colors.white, fontSize: 16),
              borderRadius: BorderRadius.circular(28),
              elevation: 0,
              items: workspaceController.tools.map((String tool) {
                return DropdownMenuItem<String>(
                  value: tool,
                  child: Text(tool),
                );
              }).toList(),
              onChanged: (String? newTool) {
                workspaceController.selectTool(newTool!);
                // You can call a context-based notifier or controller here
                // For example: context.read<ToolController>().selectTool(newTool);
              },
            ),
          ),
        );
      }
    );
  }
}
